import { z } from 'zod';

const envSchema = z.object({
	PORT: z.coerce.number().default(3001), // used by packages/elysiajs
});

export const env = {
	...process.env,
	...envSchema.parse(process.env),
} as NodeJS.ProcessEnv & z.infer<typeof envSchema>;
