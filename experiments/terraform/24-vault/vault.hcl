// Install vault
// brew tap hashicorp/tap
// brew install hashicorp/tap/vault

// STARTING THE SERVER
// Vault operates as a client-server application. The Vault server is the only piece of the Vault architecture that interacts with the data storage and backends. All operations done via the Vault CLI interact with the server over a TLS connection.
// vault server -help
// vault server -dev — start a Vault server in development mode (dev server). The dev server is a built-in, pre-configured server that is not very secure but useful for playing with Vault locally. The dev server stores all its data in-memory (but still encrypted), listens on localhost without TLS, and automatically unseals and shows you the unseal key and root access key.
// Copy and run the export VAULT_ADDR=... command from the terminal output. This will configure the Vault client to talk to the dev server.
// Save the unseal key somewhere
// export VAULT_TOKEN='hvs...' with the root token in the terminal output
// For dev server with TLS enabled, use run 'vault server -dev-tls' then copy and run the export VAULT_CACERT=...
// vault status — verify server is running 

// SECRETS
// Use the vault kv <subcommand> [options] [args] command to interact with K/V secrets engine.
// Subcommands:
// - delete — Delete versions of secrets stored in K/V
// - destroy — Permanently remove one or more versions of secrets
// - enable-versioning — Turns on versioning for an existing K/V v1 store
// - get — Retrieve data
// - list — List data or secrets
// - metadata — Interact with Vault's Key-Value storage
// - patch — Update secrets without overwriting existing secrets
// - put — Sets or update secrets (this replaces existing secrets)
// - rollback — Rolls back to a previous version of secrets
// - undelete — Restore the deleted version of secrets
// vault kv -help
// vault kv put -help
// vault kv put -mount=secret hello foo=world — write a key-value secret to the path hello , with a key of foo and value of world, using the vault kv put command against the mount path secret, which is where the KV v2 secrets engine is mounted. This command creates a new version of the secrets and replaces any pre-existing data at the path if any.
// vault kv put -mount=secret hello foo=world excited=yes — write multiple pieces of data
// vault kv get -mount=secret hello — get secret (equivalent to 'vault kv get secret/foo' but the -mount flag syntax is recommended wwith secrets engine v2, as it can avoid confusion later when you need to refer to the secret by its full path (secret/data/foo) when writing policies or raw API calls)
// vault kv get -mount=secret -field=excited hello — get only the value
// vault kv get -mount=secret -format=json hello | jq -r .data.data.excited — get only the value (by extracting from JSON)
// vault kv delete -mount=secret hello
// vault kv get -mount=secret hello — no values, but shows metadata
// vault kv undelete -mount=secret -versions=2 hello — we can restore since it wasn't destroyed
// vault kv get -mount=secret hello — values are back

// SECRETS ENGINES
// Some secrets engines like the key/value secrets engine simply store and read data. Other secrets engines connect to other services and generate dynamic credentials on demand. Other secrets engines provide encryption as a service.
// vault kv put foo/bar a=b — he path prefix (or alternatively the -mount flag for vault kv commands) tells Vault which secrets engine to which it should route traffic. When a request comes to Vault, it matches the initial path part using a longest prefix match and then passes the request to the corresponding secrets engine enabled at that path. Vault presents these secrets engines similar to a filesystem. There is no secrets engine mounted at foo, so the above command returned an error.
// vault secrets enable -path=kv kv — enable a new KV secrets engine at the path kv. Each path is completely isolated and cannot talk to other paths (path defaults to the secrets engine name)
// vault secrets list — -detailed for more info
// The sys/ path corresponds to the system backend. These paths interact with Vault's core system and are not required for beginners.
// vault kv put kv/hello target=world
// vault kv get kv/hello
// vault kv put kv/my-secret value="s3c(eT" — create secrets at the kv/my-secret path
// vault kv get kv/my-secret
// vault kv delete kv/my-secret
// vault kv list kv/ — list all secrets at the kv/ path
// vault secrets disable kv/ — all secrets are revoked and the corresponding Vault data and configuration is removed.

// DYNAMIC SECRETS
// Unlike the kv secrets where you had to put data into the store yourself, dynamic secrets are generated when they are accessed. Dynamic secrets do not exist until they are read, so there is no risk of someone stealing them or another client using the same secrets. Because Vault has built-in revocation mechanisms, dynamic secrets can be revoked immediately after use, minimizing the amount of time the secret existed.
// vault secrets enable -path=aws aws
// export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
// export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
// vault write aws/config/root access_key=$AWS_ACCESS_KEY_ID secret_key=$AWS_SECRET_ACCESS_KEY region=us-east-1
// IAM policy that enables all actions on EC2, but not IAM or other AWS services. This map the policy document to a named role (my-role)
/*
vault write aws/roles/my-role \
        credential_type=iam_user \
        policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
*/
// We just told Vault: When I ask for a credential for "my-role", create it and attach the IAM policy { "Version": "2012..." }.
// Now that the AWS secrets engine is enabled and configured with a role, you can ask Vault to generate an access key pair for that role by reading from aws/creds/:name, where :name corresponds to the name of an existing role:
// vault read aws/creds/my-role — generate an access key pair for my-role. lease_id is used for renewal, revocation, and inspection. lease_duration defaults to 32 days
// vault lease revoke <lease id>
// vault read aws/creds/my-role — keys listed but will not work, and no created IAM users remain

// BUILT-IN HELP
// vault path-help aws — Get help on a path (request, patching route, description, paramaters). Command takes a path. By specifying a root path, it will give us the overview of that secrets engine. Notice how the help not only contains a description, but also the exact regular expressions used to match routes for this backend along with a brief description of what the route is for.
// vault path-help aws/roles/my-role — vault path-help with a regular expression for a path (path doesn't need to actually exist)

// AUTHENTICATION
// Token authentication is automatically enabled. When you started the dev server, the output displayed a root token. The Vault CLI read the root token from the $VAULT_TOKEN environment variable. This root token can perform any operation within Vault because it is assigned the root policy. One capability is to create new tokens.
// vault token create — This token is a child of the root token, and by default, it inherits the policies from its parent.
// vault login — use the token from the previous command
// vault token revoke <token> — now a 'vault login' will fail
// Vault supports authentication methods for human operators. GitHub authentication enables a user to authenticate with Vault by providing their GitHub credentials and receive a Vault token.
// vault auth enable github — auth method is enabled and available at the path auth/github/
// This auth method requires that you set a GitHub organization in the configuration. A GitHub organization maintains a list of users which you are allowing to authenticate with Vault.
// vault write auth/github/config organization=hashicorp — now all users within the hashicorp GitHub organization are able to authenticate 
// GitHub organizations can define teams. Each team may have access to different actions across all the repositories that the organization maintains. These teams may also need access to specific secrets within Vault.
// vault write auth/github/map/teams/engineering value=default,applications — Configure the GitHub engineering team authentication to be granted the default and applications policies.
// vault auth list
// vault auth help github
// unset VAULT_TOKEN — Since you will attempt to login with an auth method, you should ensure that the VAULT_TOKEN environment variable is not set for this shell session since its value will take precedence over any token you obtain from Vault.
// vault login -method=github

// POLICIES
// Policies in Vault control what a user can access. This section is about authorization. 
// For authentication Vault has multiple options or methods that can be enabled and used. Vault always uses the same format for both authorization and policies. All auth methods map identities back to the core policies that are configured with Vault.
// Policies are authored in HCL, but are JSON compatible e.g. (grants capabilities for a KV v2 secrets engine) e.g.
/*
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "secret/data/foo" {
  capabilities = ["read"]
}
*/
// With this policy, a user could write any secret to secret/data/, except to secret/data/foo, where only read access is allowed. Policies default to deny, so any access to an unspecified path is not allowed.
// The policy format uses a prefix matching system on the API path to determine access control. The most specific defined policy is used, either an exact match or the longest-prefix glob match. Since everything in Vault must be accessed via the API, this gives strict control over every aspect of Vault, including enabling secrets engines, enabling auth methods, authenticating, as well as secret access.
// There are some built-in policies that cannot be removed. For example, the root and default policies are required policies and cannot be deleted. The default policy provides a common set of permissions and is included on all tokens by default. The root policy gives a token super admin permissions, similar to a root user on a Linux machine.
// vault policy read default — view the default policy
// vault policy write -h
/*
vault policy write my-policy - << EOF
// Dev servers have version 2 of KV secrets engine mounted by default, so will
// need these paths to grant permissions:
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "secret/data/foo" {
  capabilities = ["read"]
}
EOF
*/
// this policy provides limited management of secrets defined for the KV-V2 secrets engine (enables the create and update capabilities for every path within the secret/ engine except one.)
// vault policy list
// vault policy read my-policy
// export VAULT_TOKEN="$(vault token create -field token -policy=my-policy)" — create a token, add the my-policy policy, and set the token ID
// vault token lookup | grep policies — validate that the token ID was exported properly, and has the correct policies attached
// vault kv put -mount=secret creds password="my-long-password" — write a secret to the secret/data/creds path
// If you use the KV v1-like path prefix syntax (e.g. vault kv get secret/foo), /data will be automatically appended to the secret path, which may cause confusion.
// vault kv put -mount=secret foo robot=beepboop – permission denied error
// This policy defines a limited set of paths and capabilities. Without access to sys, commands like vault policy list or vault secrets list will not work.
// ---
// Vault itself is the single policy authority, unlike authentication where you can enable multiple auth methods.
// You can configure auth methods to automatically assign a set of policies to tokens created by authenticating with certain auth methods. The way this is done differs depending on the related auth method, but typically involves mapping a role to policies or mapping identities or groups to policies.
// or a dev mode server you can specify the token ID that is output when you start the server or the one that you set with the -dev-root-token-id= flag. For example, if -dev-root-token-id=root, the following exports the correct root token ID.
// vault auth list | grep 'approle/' — verify that approle auth method has not been enabled at the path approle/
// if that produces no output (i.e. appRole is not listed) then enable the approle auth method
// vault auth enable approle — Enable an AppRole role named "my-role", to configure some basic token options and to attach the previously defined "my-policy" policy to all tokens that it creates when applications authenticate with the role.
/*
vault write auth/approle/role/my-role \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=my-policy
*/
// export ROLE_ID="$(vault read -field=role_id auth/approle/role/my-role/role-id)" — To authenticate with AppRole, first fetch the role ID, and capture its value in a ROLE_ID environment variable.
// export SECRET_ID="$(vault write -f -field=secret_id auth/approle/role/my-role/secret-id)" — Next, get a secret ID (which is similar to a password for applications to use for AppRole authentication), and capture its value in the SECRET_ID environment variable.
// vault write auth/approle/login role_id="$ROLE_ID" secret_id="$SECRET_ID" — Finally, authenticate to AppRole with vault write by specifying the role path and passing the role ID and secret ID values with the respective options.
// The token has three similarly named fields, policies, identity_policies, and token_policies. The difference in these fields is that token_policies represent all policies attached to the token by auth methods, and identity_policies represents all policies attached to the token by the Identity secrets engine. The policies field is a correlation of identity_policies and token_policies to show you all available policies for a given token

// DEPLOY
// Vault is configured using HCL files
// usually config.hcl
// storage "raft" {
//   path    = "./vault/data"
//   node_id = "node1"
// }

// listener "tcp" {
//   address     = "127.0.0.1:8200"
//   tls_disable = "true"
// }

// api_addr = "http://127.0.0.1:8200"
// cluster_addr = "https://127.0.0.1:8201"
// ui = true
// Within the configuration file, there are two primary configurations:
// 1. storage - This is the physical backend that Vault uses for storage. Up to this point the dev server has used "inmem" (in memory), but the example above uses Integrated Storage (raft), a much more production-ready backend.
// 2. listener - One or more listeners determine how Vault listens for API requests. The example above listens on localhost port 8200 without TLS. In your environment set VAULT_ADDR=http://127.0.0.1:8200 so the Vault client will connect without TLS.
// The listener stanza disables TLS (tls_disable = "true"). In production, Vault should always use TLS to provide secure communication between clients and the Vault server. It requires a certificate file and key file on each Vault host.
// api_addr - Specifies the address to advertise to route client requests.
// cluster_addr - Indicates the address and port to be used for communication between the Vault nodes in a cluster.
// mkdir -p ./vault/data — The ./vault/data directory that raft storage backend uses must exist.
// vault server -config=vault.hcl — Set the -config flag to point to the proper path where you saved the configuration above.
// Initialization is the process of configuring Vault. This only happens once when the server is started against a new backend that has never been used with Vault before. When running in HA mode, this happens once per cluster, not per server. During initialization, the encryption keys are generated, unseal keys are created, and the initial root token is created.
// export VAULT_ADDR='http://127.0.0.1:8200'
// vault operator init — initialise vault. This is an unauthenticated request, but it only works on brand new Vaults without existing data:
// Initialization outputs two incredibly important pieces of information: the unseal keys and the initial root token. This is the only time ever that all of this data is known by Vault, and also the only time that the unseal keys should ever be so close together. You would likely use Vault's PGP and Keybase.io support to encrypt each of these keys with the users' PGP keys. This prevents one single person from having all the unseal keys.
// Every initialized Vault server starts in the sealed state. From the configuration, Vault can access the physical storage, but it can't read any of it because it doesn't know how to decrypt it. The process of teaching Vault how to decrypt the data is known as unsealing the Vault.
// Unsealing has to happen every time Vault starts. It can be done via the API and via the command line. To unseal the Vault, you must have the threshold number of unseal keys. In the output above, notice that the "key threshold" is 3.
// the unseal process is stateful. You can go to another computer, use vault operator unseal, and as long as it's pointing to the same server, that other computer can continue the unseal process. 
// vault operator unseal — 2/3
// vault operator unseal — 3/3
// vault login — success
// vault operator seal — As a root user, you can reseal the Vault with vault operator seal. A single operator is allowed to do this. This lets a single operator lock down the Vault in an emergency without consulting other operators. When the Vault is sealed again, it clears all of its state (including the encryption key) from memory. The Vault is secure and locked down from access.
// pgrep -f vault | xargs kill — kill vault
// rm -r ./vault/data — delete the /vault/data directory which stores the encrypted Vault data.

// HTTP APIs
// All of Vault's capabilities are accessible via the HTTP API in addition to the CLI. In fact, most calls from the CLI actually invoke the HTTP API. In some cases, Vault features are not available via the CLI and can only be accessed via the HTTP API.
// storage "file" {
//   path = "vault-data"
// }

// listener "tcp" {
//   tls_disable = "true"
// }
// vault server -config=vault.hcl — Start a new Vault instance using the newly created configuration
// curl --request POST --data '{"secret_shares": 1, "secret_threshold": 1}' http://127.0.0.1:8200/v1/sys/init | jq — This response contains your initial root token. It also includes the unseal key. You can use the unseal key to unseal the Vault and use the root token perform other requests in Vault that require authentication.
// To make this tutorial easy to copy-and-paste, you will be using the environment variable $VAULT_TOKEN to store the root token.
// export VAULT_TOKEN=... — set the root token from the previous output
// curl --request POST --data '{"key": "<unseal key from first curl output (keys_base64)>="}' http://127.0.0.1:8200/v1/sys/unseal | jq — Using the unseal key (not the root token) from above, you can unseal the Vault via the HTTP API.
// curl http://127.0.0.1:8200/v1/sys/init — invoke the Vault API to validate the initialization status.
// Now any of the available auth methods can be enabled and configured. For the purposes of this tutorial lets enable AppRole authentication.
// vault auth enable -output-curl-string approle — output cURL equivalent
// curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data '{"type": "approle"}' http://127.0.0.1:8200/v1/sys/auth/approle — enable the AppRole auth method by invoking the Vault API
// stop server, unset VAULT_TOKEN && rm -r vault-data

// WEB UI
// When you start the Vault server in dev mode, Vault UI is automatically enabled and ready to use.
// To activate the UI, set the ui configuration option in the Vault server configuration. 
ui = true
disable_mlock = true

storage "raft" {
  path    = "./vault/data"
  node_id = "node1"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  // The UI runs on the same port as the Vault listener. As such, you must configure at least one listener stanza in order to access the UI. In this case, the UI is accessible at the following URL from any machine on the subnet (provided no network firewalls are in place): https://0.0.0.0:8200/ui. It is also accessible at any DNS entry that resolves to that IP address. If bound to localhost, the Vault UI is only accessible from the local machine! address = "127.0.0.1:8200"
  tls_disable = "true"
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
// mkdir -p vault/data — Create the vault/data directory for the storage backend (The raft storage backend requires the filesystem path ./vault/data)
// vault server -config=vault.hcl — start the Vault server
// Visit http://127.0.0.1:8200/ui — The Vault server is uninitialized and sealed
// Select Create a new Raft cluster and click Next > 3 of 5 > download keys > continue to unseal > copy+paste key portions (not base64) > unseal > copy+paste root key > sign in
