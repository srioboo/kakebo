<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import type { Expense } from '$lib/api';
	import { formatDateForInput } from '$lib/api';
	import LoadingSpinner from '../common/LoadingSpinner.svelte';

	export let expense: Partial<Expense> = {};
	export let isLoading: boolean = false;
	export let isEditing: boolean = false;

	const dispatch = createEventDispatcher();

	let errors: Record<string, string> = {};
	let formData = {
		expenseName: expense.expenseName || '',
		amount: expense.amount || 0,
		expenseDate: expense.expenseDate ? formatDateForInput(expense.expenseDate) : formatDateForInput(new Date()),
	};

	function validateForm() {
		errors = {};

		if (!formData.expenseName.trim()) {
			errors.expenseName = 'El concepto es requerido';
		}

		if (formData.amount <= 0) {
			errors.amount = 'El importe debe ser mayor a 0';
		}

		if (!formData.expenseDate) {
			errors.expenseDate = 'La fecha es requerida';
		}

		return Object.keys(errors).length === 0;
	}

	function handleSubmit() {
		if (!validateForm()) return;

		const payload: Partial<Expense> = {
			expenseName: formData.expenseName.trim(),
			amount: parseFloat(formData.amount.toString()),
			expenseDate: new Date(formData.expenseDate).toISOString(),
		};

		if (isEditing && expense.id) {
			payload.id = expense.id;
		}

		dispatch('submit', payload);
	}

	function handleCancel() {
		dispatch('cancel');
	}
</script>

<form on:submit|preventDefault={handleSubmit} class="space-y-4">
	<!-- Concepto/Descripción -->
	<div class="form-control w-full">
		<label class="label" for="expenseName">
			<span class="label-text">Concepto</span>
		</label>
		<input
			id="expenseName"
			type="text"
			placeholder="Ej: Comida, Transporte..."
			class="input input-bordered w-full"
			class:input-error={errors.expenseName}
			bind:value={formData.expenseName}
			disabled={isLoading}
		/>
		{#if errors.expenseName}
			<label class="label" for="expenseName">
				<span class="label-text-alt text-error">{errors.expenseName}</span>
			</label>
		{/if}
	</div>

	<!-- Importe -->
	<div class="form-control w-full">
		<label class="label" for="amount">
			<span class="label-text">Importe (€)</span>
		</label>
		<input
			id="amount"
			type="number"
			placeholder="0.00"
			step="0.01"
			min="0"
			class="input input-bordered w-full"
			class:input-error={errors.amount}
			bind:value={formData.amount}
			disabled={isLoading}
		/>
		{#if errors.amount}
			<label class="label" for="amount">
				<span class="label-text-alt text-error">{errors.amount}</span>
			</label>
		{/if}
	</div>

	<!-- Fecha -->
	<div class="form-control w-full">
		<label class="label" for="expenseDate">
			<span class="label-text">Fecha</span>
		</label>
		<input
			id="expenseDate"
			type="datetime-local"
			class="input input-bordered w-full"
			class:input-error={errors.expenseDate}
			bind:value={formData.expenseDate}
			disabled={isLoading}
		/>
		{#if errors.expenseDate}
			<label class="label" for="expenseDate">
				<span class="label-text-alt text-error">{errors.expenseDate}</span>
			</label>
		{/if}
	</div>

	<!-- Acciones -->
	<div class="form-control mt-6 flex flex-row gap-2">
		<button
			type="submit"
			class="btn btn-primary flex-1"
			disabled={isLoading}
		>
			{#if isLoading}
				<LoadingSpinner size="sm" />
				Guardando...
			{:else}
				{isEditing ? 'Actualizar' : 'Crear'} Gasto
			{/if}
		</button>
		<button
			type="button"
			class="btn btn-ghost flex-1"
			on:click={handleCancel}
			disabled={isLoading}
		>
			Cancelar
		</button>
	</div>
</form>
