import { createClient } from '@libsql/client';
import { drizzle } from 'drizzle-orm/libsql';
import { env } from 'env';
import { z } from 'zod';
import * as moviesSchemas from './schemas/movies';

export const schema = { ...moviesSchemas };

export const db = drizzle(
	createClient(
		env.NODE_ENV === 'production' || env.NEXT_RUNTIME === 'edge'
			? {
					url: z.string().parse(env.DB_URL),
					authToken: env.DB_TOKEN,
			  }
			: {
					url: 'file:../../sqlite.db',
			  },
	),
	{ schema },
);
