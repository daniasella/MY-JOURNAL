import 'dotenv/config';
import { Pool } from 'pg';

const connectionString = process.env.DATABASE_URL;
if (!connectionString) {
  throw new Error('DATABASE_URL is required in the backend runtime environment.');
}

const isLocalhost = connectionString.includes('localhost') || connectionString.includes('127.0.0.1');

export const pool = new Pool({
  connectionString,
  max: process.env.PG_MAX_CONNECTIONS ? Number(process.env.PG_MAX_CONNECTIONS) : 5,
  idleTimeoutMillis: 30_000,
  connectionTimeoutMillis: 15_000,
  ssl: isLocalhost ? false : { rejectUnauthorized: false },
});

pool.on('error', () => {
  // Do not log connection details or credentials.
  console.error('An idle PostgreSQL connection failed.');
});
