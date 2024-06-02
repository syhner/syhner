import { defineConfig } from 'drizzle-kit';
import { env } from 'env';
import { z } from 'zod';

export default defineConfig({
	schema: './schemas/*.ts',
	out: './migrations',
	driver: env.NODE_ENV === 'production' ? 'turso' : 'better-sqlite',
	dbCredentials:
		env.NODE_ENV === 'production'
			? {
					url: z.string().parse(env.DB_URL),
					authToken: z.string().parse(env.DB_TOKEN),
			  }
			: {
					url: `${__dirname}/../../sqlite.db`,
			  },
	strict: true,
});
