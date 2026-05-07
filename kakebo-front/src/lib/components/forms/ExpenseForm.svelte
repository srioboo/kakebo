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

<form on:submit|preventDefault={handleSubmit} class="space-y-4" aria-live="polite">
	<div class="space-y-1">
		<label class="text-sm font-semibold text-[var(--kb-text)]" for="expenseName">Concepto</label>
		<input
			id="expenseName"
			type="text"
			placeholder="Ej: Comida, Transporte..."
			class="w-full rounded-lg border bg-[var(--kb-surface)] px-3 py-2.5 text-sm text-[var(--kb-text)] placeholder:text-[var(--kb-text-muted)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)]"
			class:border-[#cf7e5c]={errors.expenseName}
			class:border-[var(--kb-border)]={!errors.expenseName}
			bind:value={formData.expenseName}
			disabled={isLoading}
		/>
		{#if errors.expenseName}
			<p class="text-xs font-medium text-[#a34f2f]">{errors.expenseName}</p>
		{/if}
	</div>

	<div class="space-y-1">
		<label class="text-sm font-semibold text-[var(--kb-text)]" for="amount">Importe (EUR)</label>
		<input
			id="amount"
			type="number"
			placeholder="0.00"
			step="0.01"
			min="0"
			class="w-full rounded-lg border bg-[var(--kb-surface)] px-3 py-2.5 text-sm text-[var(--kb-text)] placeholder:text-[var(--kb-text-muted)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)]"
			class:border-[#cf7e5c]={errors.amount}
			class:border-[var(--kb-border)]={!errors.amount}
			bind:value={formData.amount}
			disabled={isLoading}
		/>
		{#if errors.amount}
			<p class="text-xs font-medium text-[#a34f2f]">{errors.amount}</p>
		{/if}
	</div>

	<div class="space-y-1">
		<label class="text-sm font-semibold text-[var(--kb-text)]" for="expenseDate">Fecha</label>
		<input
			id="expenseDate"
			type="datetime-local"
			class="w-full rounded-lg border bg-[var(--kb-surface)] px-3 py-2.5 text-sm text-[var(--kb-text)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)]"
			class:border-[#cf7e5c]={errors.expenseDate}
			class:border-[var(--kb-border)]={!errors.expenseDate}
			bind:value={formData.expenseDate}
			disabled={isLoading}
		/>
		{#if errors.expenseDate}
			<p class="text-xs font-medium text-[#a34f2f]">{errors.expenseDate}</p>
		{/if}
	</div>

	<div class="mt-6 flex flex-row gap-2">
		<button
			type="submit"
			class="inline-flex min-h-11 flex-1 items-center justify-center rounded-lg border border-[var(--kb-accent)] bg-[var(--kb-accent)] px-4 text-sm font-semibold text-white transition hover:bg-[var(--kb-accent-strong)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)] disabled:cursor-not-allowed disabled:opacity-60"
			disabled={isLoading}
		>
			{#if isLoading}
				<span class="flex items-center gap-2">
					<LoadingSpinner size="sm" />
					Guardando...
				</span>
			{:else}
				{isEditing ? 'Actualizar' : 'Crear'} Gasto
			{/if}
		</button>
		<button
			type="button"
			class="inline-flex min-h-11 flex-1 items-center justify-center rounded-lg border border-[var(--kb-border)] bg-[var(--kb-surface)] px-4 text-sm font-semibold text-[var(--kb-text)] transition hover:bg-[var(--kb-surface-soft)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)] disabled:cursor-not-allowed disabled:opacity-60"
			on:click={handleCancel}
			disabled={isLoading}
		>
			Cancelar
		</button>
	</div>
</form>
