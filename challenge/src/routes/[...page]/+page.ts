import { error } from '@sveltejs/kit';
import type { PageLoad } from './$types';

export const load = (async ({ params }: { params: { page: string } }) => {
	if (params.page !== '0Jl9N6lfWs6XogjuudXNGw') {
		error(404);
	}
	return {
		flag: 'FLAG{9defe3d40faee6ef341bc0b4075c1dc2}'
	};
}) satisfies PageLoad;
