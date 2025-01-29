CREATE TABLE "pilots" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"callsign" text NOT NULL,
	"biography" text NOT NULL,
	"notes" text NOT NULL
);
