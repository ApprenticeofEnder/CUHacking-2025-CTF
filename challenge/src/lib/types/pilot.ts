export interface PilotCreate {
	name: string;
	callsign: string;
	biography: string;
	notes: string;
	classified: boolean;
}

export interface Pilot extends PilotCreate {
	id: number;
}
