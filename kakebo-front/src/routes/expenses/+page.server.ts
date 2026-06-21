import { getExpenses, createExpense, updateExpense, deleteExpense, type Expense } from '$lib/api';
import { fail } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ url }) => {
	const now = new Date();
	const yearParam = url.searchParams.get('year');
	const monthParam = url.searchParams.get('month');
	const year = yearParam ? parseInt(yearParam) : now.getFullYear();
	const month = monthParam ? parseInt(monthParam) : now.getMonth() + 1;

	try {
		const expenses = await getExpenses(year, month);
		return { expenses, year, month };
	} catch (error) {
		const errorMessage = error instanceof Error ? error.message : 'Error loading expenses';
		return { error: errorMessage, expenses: [], year, month };
	}
};

export const actions = {
	create: async ({ request }) => {
		const formData = await request.formData();
		const expenseName = formData.get('expenseName') as string;
		const amount = parseFloat(formData.get('amount') as string);
		const expenseDate = formData.get('expenseDate') as string;

		if (!expenseName || !amount || !expenseDate) {
			return fail(400, { error: 'Missing required fields' });
		}

		try {
			const expenses = await getExpenses();
			const nextId =
				expenses.reduce((maxId, current) => {
					const currentId = current.id ?? 0;
					return currentId > maxId ? currentId : maxId;
				}, 0) + 1;

			const expense = await createExpense({
				id: nextId,
				expenseName,
				amount,
				expenseDate,
			});
			return { success: true, message: 'Gasto creado correctamente', expense };
		} catch (error) {
			const errorMessage = error instanceof Error ? error.message : 'Error creating expense';
			return fail(500, { error: errorMessage });
		}
	},

	update: async ({ request }) => {
		const formData = await request.formData();
		const id = parseInt(formData.get('id') as string);
		const expenseName = formData.get('expenseName') as string;
		const amount = formData.get('amount') as string;
		const expenseDate = formData.get('expenseDate') as string;

		if (!id) {
			return fail(400, { error: 'Missing expense ID' });
		}

		const updates: Partial<Expense> = {};
		if (expenseName) updates.expenseName = expenseName;
		if (amount) updates.amount = parseFloat(amount);
		if (expenseDate) updates.expenseDate = expenseDate;

		try {
			const expense = await updateExpense(id, updates);
			return { success: true, message: 'Gasto actualizado correctamente', expense };
		} catch (error) {
			const errorMessage = error instanceof Error ? error.message : 'Error updating expense';
			return fail(500, { error: errorMessage });
		}
	},

	delete: async ({ request }) => {
		const formData = await request.formData();
		const id = parseInt(formData.get('id') as string);

		if (!id) {
			return fail(400, { error: 'Missing expense ID' });
		}

		try {
			await deleteExpense(id);
			return { success: true, message: 'Gasto eliminado correctamente' };
		} catch (error) {
			const errorMessage = error instanceof Error ? error.message : 'Error deleting expense';
			return fail(500, { error: errorMessage });
		}
	},
};
