import { serve } from '@hono/node-server';
import { app } from './app.js';

const port = Number(process.env.PORT ?? 8787);
const hostname = process.env.HOST ?? '127.0.0.1';

serve({ fetch: app.fetch, port, hostname }, () => {
  console.log(`My Journal API listening at http://${hostname}:${port}`);
});
