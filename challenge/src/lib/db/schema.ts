import { pgTable,serial,text } from "drizzle-orm/pg-core";

export const pilots = pgTable("pilots",{
    id:serial("id").primaryKey(),
    name:text("name").notNull(),
    callsign:text("callsign").notNull(),
    biography:text("biography").notNull(),
    notes:text("notes").notNull()
});