import { db } from '$lib/db/db.server';
import { pilots } from '$lib/db/schema';
import type { PageServerLoad } from './$types';

export const load = (async () => {
    const result = await db.select().from(pilots)
    return {
        result
    };
}) satisfies PageServerLoad;