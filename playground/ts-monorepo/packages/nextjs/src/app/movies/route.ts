import { db, schema } from 'db';

export const GET = async () => {
	const movies = await db.select().from(schema.movies);
	return Response.json(movies);
};
