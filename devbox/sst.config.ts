/// <reference path="./.sst/platform/config.d.ts" />

import fs from "fs";

export default $config({
  app(input) {
    return {
      name: "devbox",
      removal: input?.stage === "production" ? "retain" : "remove",
      home: "aws",
      providers: { aws: { profile: "syhner-dev" } },
    };
  },
  async run() {
    const keyPair = new aws.ec2.KeyPair("my-keypair", {
      keyName: "my-keypair",
      publicKey: fs.readFileSync("../dotfiles/home/ssh/.ssh/id_ed25519.pub", "utf8"),
    });

    const securityGroup = new aws.ec2.SecurityGroup("web-secgrp", {
      ingress: [
        {
          protocol: "tcp",
          fromPort: 22,
          toPort: 22,
          cidrBlocks: ["0.0.0.0/0"], // Allow SSH from anywhere
        },
      ],
    });

    const ubuntu = aws.ec2.getAmi({
      mostRecent: true,
      filters: [
        {
          name: "name",
          values: ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"],
        },
        {
          name: "virtualization-type",
          values: ["hvm"],
        },
      ],
      owners: ["099720109477"],
    });

    const web = new aws.ec2.Instance("web", {
      ami: ubuntu.then((ubuntu) => ubuntu.id),
      instanceType: aws.ec2.InstanceType.T2_Micro,
      keyName: keyPair.keyName,
      securityGroups: [securityGroup.name],
      metadataOptions: {
        httpTokens: "required", // Require IMDSv2
      },
      tags: { Name: "devbox" },
    });

    return {
      web: web.publicIp,
    };
  },
});
