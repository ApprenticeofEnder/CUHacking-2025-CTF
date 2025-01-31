import { eq } from 'drizzle-orm';

import { db } from '$lib/db/db.server';
import { pilots } from '$lib/db/schema';
import type { Pilot } from '$lib/types/pilot';
import type { PageServerLoad } from './$types';

export const load = (async () => {
	const result: Pilot[] = await db.select().from(pilots).where(eq(pilots.classified, false));
	return {
		result
	};
}) satisfies PageServerLoad;
