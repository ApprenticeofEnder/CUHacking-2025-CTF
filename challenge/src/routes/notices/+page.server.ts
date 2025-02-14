import { db } from '$lib/db/db.server';
import { notices } from '$lib/db/schema';
import type { Notice } from '$lib/types';
import type { PageServerLoad } from './$types';

export const load = (async () => {
	const result: Notice[] = await db.select().from(notices);
	return {
		result
	};
}) satisfies PageServerLoad;
