# vercel-edge-imports

https://github.com/orgs/vercel/discussions/4116

## Summary

In a repo that is used to deploy to Vercel Edge Functions:

- Relative imports work

  ```ts
  // api/index.ts
  import { RESPONSE_STRING } from "../src/responses";
  ```

- but absolute imports do not (path alias `"~/*": ["./src/*"]` is registered in `tsconfig.json`)

  ```ts
  // api/index.ts
  import { RESPONSE_STRING } from "~/responses";
  ```

Are absolute imports supported? Or is there a codegen step that needs to be ran beforehand to transform the imports to relative ones?

## Example

https://github.com/syhner/vercel-edge-imports

## Steps to Reproduce

1. Clone the [minimal reproduction](https://github.com/syhner/vercel-edge-imports/)

2. Checkout the `relative` branch, and deploy with `vercel deploy`. Observe that it is working.

```sh
git checkout relative
vercel deploy
```

> Vercel CLI 30.2.3
> 🔍 Inspect: https://vercel.com/syhner/vercel-edge-imports/2KLSAVb7ZvK3MXzUqdJAu4gBFjiG [2s]
> ✅ Preview: https://vercel-edge-imports-syhner.vercel.app [11s]

(https://vercel-edge-imports-syhner.vercel.app - returns 'Hello World')

3. Checkout the `absolute` branch, and deploy with `vercel deploy`. Observe that it is not working.

```sh
git checkout absolute
vercel deploy
```

> Vercel CLI 30.2.3
> 🔍 Inspect: https://vercel.com/syhner/vercel-edge-imports/DiGJaezrrQq17HhQdtNQXPpyh7cX [1s]
> Error: The Edge Function "api/index" is referencing unsupported modules:

        - api/index.js: ~/responses

(https://vercel-edge-imports-qlpvl0nhh-syhner.vercel.app - shows deployment failed)
