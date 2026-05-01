<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import type { Income } from '$lib/api';
	import { formatDateForInput } from '$lib/api';
	import LoadingSpinner from '../common/LoadingSpinner.svelte';

	export let income: Partial<Income> = {};
	export let isLoading: boolean = false;
	export let isEditing: boolean = false;

	const dispatch = createEventDispatcher();

	let errors: Record<string, string> = {};
	let formData = {
		incomeName: income.incomeName || '',
		amount: income.amount || 0,
		incomeDate: income.incomeDate ? formatDateForInput(income.incomeDate) : formatDateForInput(new Date()),
	};

	function validateForm() {
		errors = {};

		if (!formData.incomeName.trim()) {
			errors.incomeName = 'El concepto es requerido';
		}

		if (formData.amount <= 0) {
			errors.amount = 'El importe debe ser mayor a 0';
		}

		if (!formData.incomeDate) {
			errors.incomeDate = 'La fecha es requerida';
		}

		return Object.keys(errors).length === 0;
	}

	function handleSubmit() {
		if (!validateForm()) return;

		const payload: Partial<Income> = {
			incomeName: formData.incomeName.trim(),
			amount: parseFloat(formData.amount.toString()),
			incomeDate: new Date(formData.incomeDate).toISOString(),
		};

		if (isEditing && income.id) {
			payload.id = income.id;
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
		<label class="label" for="incomeName">
			<span class="label-text">Concepto</span>
		</label>
		<input
			id="incomeName"
			type="text"
			placeholder="Ej: Salario, Freelance..."
			class="input input-bordered w-full"
			class:input-error={errors.incomeName}
			bind:value={formData.incomeName}
			disabled={isLoading}
		/>
		{#if errors.incomeName}
			<label class="label" for="incomeName">
				<span class="label-text-alt text-error">{errors.incomeName}</span>
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
		<label class="label" for="incomeDate">
			<span class="label-text">Fecha</span>
		</label>
		<input
			id="incomeDate"
			type="datetime-local"
			class="input input-bordered w-full"
			class:input-error={errors.incomeDate}
			bind:value={formData.incomeDate}
			disabled={isLoading}
		/>
		{#if errors.incomeDate}
			<label class="label" for="incomeDate">
				<span class="label-text-alt text-error">{errors.incomeDate}</span>
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
				{isEditing ? 'Actualizar' : 'Crear'} Ingreso
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
