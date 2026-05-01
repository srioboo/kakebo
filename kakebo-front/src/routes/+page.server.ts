import { getExpenses, getIncomes } from '$lib/api';

export async function load() {
	try {
		const expenses = await getExpenses();
		const incomes = await getIncomes();
		return { expenses, incomes };
	} catch (error) {
		const errorMessage = error instanceof Error ? error.message : 'Error loading data';
		return { error: errorMessage, expenses: [], incomes: [] };
	}
}
