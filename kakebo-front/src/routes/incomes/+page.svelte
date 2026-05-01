<script lang="ts">
	import { page } from '$app/stores';
	import { goto, invalidateAll } from '$app/navigation';
	import { IncomeForm } from '$lib/components/forms';
	import { IncomesTable } from '$lib/components/tables';
	import { Modal, ConfirmDialog, LoadingSpinner } from '$lib/components/common';
	import { notify } from '$lib/stores';
	import type { Income } from '$lib/api';

	export let data;

	let incomes: Income[] = data.incomes || [];
	let error = data.error || '';

	let isModalOpen = false;
	let isConfirmOpen = false;
	let isLoading = false;
	let isEditing = false;
	let selectedIncome: Partial<Income> = {};
	let incomeToDelete: number | null = null;

	function openCreateModal() {
		isEditing = false;
		selectedIncome = {};
		isModalOpen = true;
	}

	function openEditModal(income: Income) {
		isEditing = true;
		selectedIncome = { ...income };
		isModalOpen = true;
	}

	function openDeleteConfirm(id: number) {
		incomeToDelete = id;
		isConfirmOpen = true;
	}

	async function handleFormSubmit(e: CustomEvent<Partial<Income>>) {
		const income = e.detail;
		isLoading = true;

		try {
			const formData = new FormData();
			if (isEditing) {
				formData.append('id', income.id?.toString() || '');
			}
			formData.append('incomeName', income.incomeName || '');
			formData.append('amount', income.amount?.toString() || '');
			formData.append('incomeDate', income.incomeDate || '');

			const response = await fetch(
				`?/${isEditing ? 'update' : 'create'}`,
				{ method: 'POST', body: formData },
			);

			if (response.ok) {
				await invalidateAll();
				isModalOpen = false;
				notify.success(
					isEditing
						? 'Ingreso actualizado correctamente'
						: 'Ingreso creado correctamente',
				);
			} else {
				const result = await response.json();
				notify.error(result.error || 'Error al guardar el ingreso');
			}
		} catch (err) {
			notify.error('Error al guardar el ingreso');
			console.error(err);
		} finally {
			isLoading = false;
		}
	}

	async function handleDelete() {
		if (incomeToDelete === null) return;

		isLoading = true;
		try {
			const formData = new FormData();
			formData.append('id', incomeToDelete.toString());

			const response = await fetch('?/delete', {
				method: 'POST',
				body: formData,
			});

			if (response.ok) {
				await invalidateAll();
				isConfirmOpen = false;
				incomeToDelete = null;
				notify.success('Ingreso eliminado correctamente');
			} else {
				const result = await response.json();
				notify.error(result.error || 'Error al eliminar el ingreso');
			}
		} catch (err) {
			notify.error('Error al eliminar el ingreso');
			console.error(err);
		} finally {
			isLoading = false;
		}
	}

	$: if (data.incomes) {
		incomes = data.incomes;
	}
	$: if (data.error) {
		error = data.error;
	}
</script>

<div class="container mx-auto px-4 py-8">
	<div class="flex flex-row justify-between items-center mb-6">
		<div>
			<h1 class="text-3xl font-bold">Gestión de Ingresos</h1>
			<p class="text-gray-600">Administra todos tus ingresos en un solo lugar</p>
		</div>
		<button class="btn btn-primary" on:click={openCreateModal}>
			+ Crear Ingreso
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
			<IncomesTable
				{incomes}
				onEdit={openEditModal}
				onDelete={openDeleteConfirm}
			/>
		{/if}
	</div>
</div>

<Modal bind:open={isModalOpen} title={isEditing ? 'Editar Ingreso' : 'Crear Nuevo Ingreso'}>
	<IncomeForm
		income={selectedIncome}
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
	title="Eliminar Ingreso"
	message="¿Está seguro de que desea eliminar este ingreso?"
	confirmText="Eliminar"
	cancelText="Cancelar"
	isDangerous={true}
	onConfirm={handleDelete}
	onCancel={() => {
		incomeToDelete = null;
	}}
/>
