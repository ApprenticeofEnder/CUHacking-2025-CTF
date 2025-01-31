import { boolean, pgTable, serial, text } from 'drizzle-orm/pg-core';

export const pilots = pgTable('pilots', {
	id: serial('id').primaryKey(),
	name: text('name').notNull(),
	callsign: text('callsign').notNull(),
	biography: text('biography').notNull(),
	notes: text('notes').notNull(),
	classified: boolean('classified').notNull().default(false)
});

export const notices = pgTable('notices', {
	id: serial('id').primaryKey(),
	title: text('title').notNull(),
	note: text('note').notNull(),
	author: text('author').notNull()
})
