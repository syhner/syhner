import { describe, expect, it } from 'bun:test';
import { server } from '.';

describe('Elysia', () => {
	it('return a response', async () => {
		const response = await server.handle(new Request('http://localhost'));
		const text = await response.text();

		expect(text).toBe('Hi from Elysia');
	});
});
