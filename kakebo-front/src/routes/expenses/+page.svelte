<script lang="ts">
	import { page } from '$app/stores';
	import { goto, invalidateAll } from '$app/navigation';
	import { ExpenseForm } from '$lib/components/forms';
	import { ExpensesTable } from '$lib/components/tables';
	import { Modal, ConfirmDialog, LoadingSpinner } from '$lib/components/common';
	import { notify } from '$lib/stores';
	import type { Expense } from '$lib/api';

	export let data;

	let expenses: Expense[] = data.expenses || [];
	let error = data.error || '';

	let isModalOpen = false;
	let isConfirmOpen = false;
	let isLoading = false;
	let isEditing = false;
	let selectedExpense: Partial<Expense> = {};
	let expenseToDelete: number | null = null;

	function openCreateModal() {
		isEditing = false;
		selectedExpense = {};
		isModalOpen = true;
	}

	function openEditModal(expense: Expense) {
		isEditing = true;
		selectedExpense = { ...expense };
		isModalOpen = true;
	}

	function openDeleteConfirm(id: number) {
		expenseToDelete = id;
		isConfirmOpen = true;
	}

	async function handleFormSubmit(e: CustomEvent<Partial<Expense>>) {
		const expense = e.detail;
		isLoading = true;

		try {
			const formData = new FormData();
			if (isEditing) {
				formData.append('id', expense.id?.toString() || '');
			}
			formData.append('expenseName', expense.expenseName || '');
			formData.append('amount', expense.amount?.toString() || '');
			formData.append('expenseDate', expense.expenseDate || '');

			const response = await fetch(
				`?/${isEditing ? 'update' : 'create'}`,
				{ method: 'POST', body: formData },
			);

			if (response.ok) {
				await invalidateAll();
				isModalOpen = false;
				notify.success(
					isEditing
						? 'Gasto actualizado correctamente'
						: 'Gasto creado correctamente',
				);
			} else {
				const result = await response.json();
				notify.error(result.error || 'Error al guardar el gasto');
			}
		} catch (err) {
			notify.error('Error al guardar el gasto');
			console.error(err);
		} finally {
			isLoading = false;
		}
	}

	async function handleDelete() {
		if (expenseToDelete === null) return;

		isLoading = true;
		try {
			const formData = new FormData();
			formData.append('id', expenseToDelete.toString());

			const response = await fetch('?/delete', {
				method: 'POST',
				body: formData,
			});

			if (response.ok) {
				await invalidateAll();
				isConfirmOpen = false;
				expenseToDelete = null;
				notify.success('Gasto eliminado correctamente');
			} else {
				const result = await response.json();
				notify.error(result.error || 'Error al eliminar el gasto');
			}
		} catch (err) {
			notify.error('Error al eliminar el gasto');
			console.error(err);
		} finally {
			isLoading = false;
		}
	}

	$: if (data.expenses) {
		expenses = data.expenses;
	}
	$: if (data.error) {
		error = data.error;
	}
</script>

<div class="container mx-auto px-4 py-8">
	<div class="flex flex-row justify-between items-center mb-6">
		<div>
			<h1 class="text-3xl font-bold">Gestión de Gastos</h1>
			<p class="text-gray-600">Administra todos tus gastos en un solo lugar</p>
		</div>
		<button class="btn btn-primary" on:click={openCreateModal}>
			+ Crear Gasto
		</button>
	</div>

	{#if error}
		<div class="alert alert-error mb-4">
			<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4v2m0 0v2m0-6V9m0 0V7m0 12v-2m6-2v2m0 0v2m0-6v-2m0 0v-2m-6-2v-2m0 0V7M9 7v2m2-2V7m2 0v2" />
			</svg>
			<span>{error}</span>
		</div>
	{/if}

	<div class="bg-white rounded-lg shadow-md p-6">
		{#if isLoading}
			<LoadingSpinner size="md" />
		{:else}
			<ExpensesTable
				{expenses}
				onEdit={openEditModal}
				onDelete={openDeleteConfirm}
			/>
		{/if}
	</div>
</div>

<Modal bind:open={isModalOpen} title={isEditing ? 'Editar Gasto' : 'Crear Nuevo Gasto'}>
	<ExpenseForm
		expense={selectedExpense}
		isLoading={isLoading}
		isEditing={isEditing}
		on:submit={handleFormSubmit}
		on:cancel={() => {
			isModalOpen = false;
		}}
	/>
</Modal>

<ConfirmDialog
	bind:open={isConfirmOpen}
	title="Eliminar Gasto"
	message="¿Está seguro de que desea eliminar este gasto?"
	confirmText="Eliminar"
	cancelText="Cancelar"
	isDangerous={true}
	onConfirm={handleDelete}
	onCancel={() => {
		expenseToDelete = null;
	}}
/>
