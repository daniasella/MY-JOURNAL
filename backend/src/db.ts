import 'dotenv/config';
import { Pool } from 'pg';

const connectionString = process.env.DATABASE_URL;

const isLocalhost = !connectionString || connectionString.includes('localhost') || connectionString.includes('127.0.0.1');

export const pool = new Pool({
  connectionString: connectionString || undefined,
  max: process.env.PG_MAX_CONNECTIONS ? Number(process.env.PG_MAX_CONNECTIONS) : 5,
  idleTimeoutMillis: 30_000,
  connectionTimeoutMillis: 15_000,
  ssl: isLocalhost ? false : { rejectUnauthorized: false },
});

pool.on('error', (err) => {
  // Do not log connection details or credentials.
  console.error('An idle PostgreSQL connection error:', err?.message ?? 'unknown');
});
