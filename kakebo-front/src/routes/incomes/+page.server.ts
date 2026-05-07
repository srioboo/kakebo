import { getIncomes, createIncome, updateIncome, deleteIncome, type Income } from '$lib/api';
import { fail } from '@sveltejs/kit';

export async function load() {
	try {
		const incomes = await getIncomes();
		return { incomes };
	} catch (error) {
		const errorMessage = error instanceof Error ? error.message : 'Error loading incomes';
		return { error: errorMessage, incomes: [] };
	}
}

export const actions = {
	create: async ({ request }) => {
		const formData = await request.formData();
		const incomeName = formData.get('incomeName') as string;
		const amount = parseFloat(formData.get('amount') as string);
		const incomeDate = formData.get('incomeDate') as string;

		if (!incomeName || !amount || !incomeDate) {
			return fail(400, { error: 'Missing required fields' });
		}

		try {
			const incomes = await getIncomes();
			const nextId =
				incomes.reduce((maxId, current) => {
					const currentId = current.id ?? 0;
					return currentId > maxId ? currentId : maxId;
				}, 0) + 1;

			const income = await createIncome({
				id: nextId,
				incomeName,
				amount,
				incomeDate,
			});
			return { success: true, message: 'Ingreso creado correctamente', income };
		} catch (error) {
			const errorMessage = error instanceof Error ? error.message : 'Error creating income';
			return fail(500, { error: errorMessage });
		}
	},

	update: async ({ request }) => {
		const formData = await request.formData();
		const id = parseInt(formData.get('id') as string);
		const incomeName = formData.get('incomeName') as string;
		const amount = formData.get('amount') as string;
		const incomeDate = formData.get('incomeDate') as string;

		if (!id) {
			return fail(400, { error: 'Missing income ID' });
		}

		const updates: Partial<Income> = {};
		if (incomeName) updates.incomeName = incomeName;
		if (amount) updates.amount = parseFloat(amount);
		if (incomeDate) updates.incomeDate = incomeDate;

		try {
			const income = await updateIncome(id, updates);
			return { success: true, message: 'Ingreso actualizado correctamente', income };
		} catch (error) {
			const errorMessage = error instanceof Error ? error.message : 'Error updating income';
			return fail(500, { error: errorMessage });
		}
	},

	delete: async ({ request }) => {
		const formData = await request.formData();
		const id = parseInt(formData.get('id') as string);

		if (!id) {
			return fail(400, { error: 'Missing income ID' });
		}

		try {
			await deleteIncome(id);
			return { success: true, message: 'Ingreso eliminado correctamente' };
		} catch (error) {
			const errorMessage = error instanceof Error ? error.message : 'Error deleting income';
			return fail(500, { error: errorMessage });
		}
	},
};
