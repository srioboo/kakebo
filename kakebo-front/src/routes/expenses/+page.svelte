<script lang="ts">
	import { invalidateAll } from '$app/navigation';
	import { ExpenseForm } from '$lib/components/forms';
	import { ExpensesTable } from '$lib/components/tables';
	import { Modal, ConfirmDialog, LoadingSpinner, EmptyState } from '$lib/components/common';
	import { notify } from '$lib/stores';
	import { Modal, ConfirmDialog, LoadingSpinner, EmptyState } from '$lib/components/common';
	import { YearMonthSelector } from '$lib/components/filters';
	import { notify, selectedPeriod } from '$lib/stores';
	import type { Expense } from '$lib/api';

	export let data;

	let expenses: Expense[] = data.expenses || [];
	let error = data.error || '';

	$: selectedPeriod.set({ year: data.year, month: data.month });

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

	function handlePeriodSelect(e: CustomEvent<{ year: number; month: number }>) {
		const { year, month } = e.detail;
		goto(`?year=${year}&month=${month}`);
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

<div class="mx-auto flex w-full max-w-7xl flex-col gap-6">
	<div class="kakebo-surface flex flex-col items-start justify-between gap-4 rounded-2xl p-6 md:flex-row md:items-center">
		<div>
			<h1 class="text-2xl font-semibold text-[var(--kb-accent-strong)]">Gestion de gastos</h1>
			<p class="kakebo-muted mt-1 text-sm">Administra tus gastos con una lectura clara y ordenada.</p>
		</div>
		<button class="kakebo-button" on:click={openCreateModal}>
			+ Crear Gasto
		</button>
	</div>

	{#if error}
		<div class="flex items-center gap-2 rounded-xl border border-[#d08d6d] bg-[#f8e8df] px-4 py-3 text-sm text-[#73422b]">
			<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4v2m0 0v2m0-6V9m0 0V7m0 12v-2m6-2v2m0 0v2m0-6v-2m0 0v-2m-6-2v-2m0 0V7M9 7v2m2-2V7m2 0v2" />
			</svg>
			<span>{error}</span>
		</div>
	{/if}

	<div class="kakebo-surface rounded-xl p-6">
		{#if isLoading}
			<LoadingSpinner size="md" />
		{:else if expenses.length === 0}
			<EmptyState
				title="Sin gastos"
				description="No hay gastos para el período seleccionado."
				icon="💸"
			/>
		{:else}
			<ExpensesTable
				{expenses}
				onEdit={openEditModal}
				onDelete={openDeleteConfirm}
			/>
		{/if}
	<div class="flex gap-6">
		<aside class="kakebo-surface rounded-xl p-4">
			<YearMonthSelector
				currentYear={data.year}
				currentMonth={data.month}
				on:select={handlePeriodSelect}
			/>
		</aside>

		<div class="kakebo-surface flex-1 rounded-xl p-6">
			{#if isLoading}
				<LoadingSpinner size="md" />
			{:else if expenses.length === 0}
				<EmptyState
					title="Sin gastos"
					description="No hay gastos para el período seleccionado."
					icon="💸"
				/>
			{:else}
				<ExpensesTable
					{expenses}
					onEdit={openEditModal}
					onDelete={openDeleteConfirm}
				/>
			{/if}
		</div>
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
