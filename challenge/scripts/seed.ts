import * as dotenv from 'dotenv';
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from '../src/lib/db/schema';
import pilotData from './pilots.json';

dotenv.config();
const { DATABASE_URL } = process.env;
if (!DATABASE_URL) {
	throw new Error('No url');
}

const client = postgres(DATABASE_URL);
const db = drizzle(client, { schema });

const { pilots, notices } = schema;

async function main() {
	await db.delete(pilots);
	await db.delete(notices);
	console.log('Initializing insertion...');
	await db.insert(pilots).values(pilotData);
	console.log('Insertion complete.');
}

main().then(() => {
	console.log('Seed complete.');
	process.exit(0);
});
