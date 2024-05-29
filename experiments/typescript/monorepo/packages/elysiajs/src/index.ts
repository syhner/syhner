import { add } from 'add';
import { db, schema } from 'db';
import { Elysia, t } from 'elysia';
import { env } from 'env';

export const server = new Elysia()
	.get('/', () => 'Hi from Elysia')
	.get('/add', ({ query }) => add(query.num1, query.num2), {
		query: t.Object({
			num1: t.Numeric(),
			num2: t.Numeric(),
		}),
	})
	.get('/movies', async () => {
		const movies = await db.select().from(schema.movies);
		return movies;
	});

server.listen(env.PORT, ({ hostname, port }) => {
	const url = env.NODE_ENV === 'production' ? 'https' : 'http';
	console.log(`Elysia is running at ${url}://${hostname}:${port}`);
});
