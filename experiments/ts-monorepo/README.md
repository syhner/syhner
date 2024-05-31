# ts-kickstart

## Getting started

Install dependencies with [Bun](https://bun.sh), then run the `dev` script in all packages (where a `dev` script exists)

```sh
bun install
bun run all:dev
```

## Default packages

```
.
└── packages/     - Any new projects belong here
    ├── add/      - Package configured to be published to npm
    ├── db/       - Database schemas and scripts
    ├── elysiajs/ - Backend with ElysiaJS (web framework)
    ├── env/      - Type-safe environment variables
    └── nextjs/   - Frontend with Next.js (web framework)
```

## Deployment

- To Railway - deploy [`packages/elysiajs`](packages/elysiajs) (using Docker)

  [![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/SthLV_?referralCode=Q9UMnd)

- To Vercel - deploy [`packages/nextjs`](packages/nextjs) - see the [Railway template](https://railway.app/template/SthLV_?referralCode=Q9UMnd) for required environment variables (including NODE_ENV=production)

  [![Vercel](https://vercel.com/button)](https://vercel.com/new/clone?s=https%3A%2F%2Fgithub.com%2FSyhner%2Fts-kickstart)

## Environment variables

Any environment variables in `packages/<package>/.env` are available to the package (thanks to Bun)

### Type-safe environment variables

If not already present in the package, add the [workspace env package](packages/env) and install the new dependency

```diff
  "dependencies": {
+   "env": "workspace:*"
  }
```

```sh
bun install
```

Import environment variables (schema defined in [packages/env/index.ts](packages/env/index.ts))

```ts
import { env } from 'env';
const PORT = env.PORT; // PORT: number
```
