import { handle } from '@hono/node-server/vercel';
import { app } from '../src/app.js';

export const config = {
  maxDuration: 30,
};

export default handle(app);
