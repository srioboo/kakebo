import { getExpenses, createExpense, updateExpense, deleteExpense, type Expense } from '$lib/api';
import { fail } from '@sveltejs/kit';

export async function load() {
	try {
		const expenses = await getExpenses();
		return { expenses };
	} catch (error) {
		const errorMessage = error instanceof Error ? error.message : 'Error loading expenses';
		return { error: errorMessage, expenses: [] };
	}
}

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
			const expense = await createExpense({
				expenseName,
				amount,
				expenseDate: new Date(expenseDate).toISOString(),
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
		if (expenseDate) updates.expenseDate = new Date(expenseDate).toISOString();

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
