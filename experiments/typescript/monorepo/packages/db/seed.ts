import { db } from '.';
import { movies } from './schemas/movies';

await db.insert(movies).values([
	{
		title: 'The Matrix',
		releaseYear: 1999,
	},
	{
		title: 'The Matrix Reloaded',
		releaseYear: 2003,
	},
	{
		title: 'The Matrix Revolutions',
		releaseYear: 2003,
	},
]);

console.log('Seeding complete.');
