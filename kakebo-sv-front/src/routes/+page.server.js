import { fetchPosts, fetchExpenses, fetchIncomes } from '$lib/api';

export async function load() {
	try {
		// const posts = await fetchPosts();
		const expenses = await fetchExpenses();
		const incomes = await fetchIncomes();
		// return { posts, expenses };
		return { expenses, incomes };
	} catch (error) {
		return { error: error.message };
	}
}
