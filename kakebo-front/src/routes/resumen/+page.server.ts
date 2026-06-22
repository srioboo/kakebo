import { getExpenses, getIncomes } from '$lib/api';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ url }) => {
	const now = new Date();
	const yearParam = url.searchParams.get('year');
	const monthParam = url.searchParams.get('month');
	const year = yearParam ? parseInt(yearParam) : now.getFullYear();
	const month = monthParam ? parseInt(monthParam) : now.getMonth() + 1;

	try {
		const expenses = await getExpenses(year, month);
		const incomes = await getIncomes(year, month);
		return { expenses, incomes, year, month };
	} catch (error) {
		const errorMessage = error instanceof Error ? error.message : 'Error al cargar datos del resumen';
		return { error: errorMessage, expenses: [], incomes: [], year, month };
	}
};
