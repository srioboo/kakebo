import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ url }) => {
	const now = new Date();
	const yearParam = url.searchParams.get('year');
	const monthParam = url.searchParams.get('month');
	return {
		year: yearParam ? parseInt(yearParam) : now.getFullYear(),
		month: monthParam ? parseInt(monthParam) : now.getMonth() + 1,
	};
};
