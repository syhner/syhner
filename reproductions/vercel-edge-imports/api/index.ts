import { RESPONSE_STRING } from '../src/responses';

export const config = { runtime: 'edge' };

export default function (request: Request) {
  return new Response(RESPONSE_STRING);
}
