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

<form on:submit|preventDefault={handleSubmit} class="space-y-4" aria-live="polite">
	<div class="space-y-1">
		<label class="text-sm font-semibold text-[var(--kb-text)]" for="incomeName">Concepto</label>
		<input
			id="incomeName"
			type="text"
			placeholder="Ej: Salario, Freelance..."
			class="w-full rounded-lg border bg-[var(--kb-surface)] px-3 py-2.5 text-sm text-[var(--kb-text)] placeholder:text-[var(--kb-text-muted)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)]"
			class:border-[#cf7e5c]={errors.incomeName}
			class:border-[var(--kb-border)]={!errors.incomeName}
			bind:value={formData.incomeName}
			disabled={isLoading}
		/>
		{#if errors.incomeName}
			<p class="text-xs font-medium text-[#a34f2f]">{errors.incomeName}</p>
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
		<label class="text-sm font-semibold text-[var(--kb-text)]" for="incomeDate">Fecha</label>
		<input
			id="incomeDate"
			type="datetime-local"
			class="w-full rounded-lg border bg-[var(--kb-surface)] px-3 py-2.5 text-sm text-[var(--kb-text)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)]"
			class:border-[#cf7e5c]={errors.incomeDate}
			class:border-[var(--kb-border)]={!errors.incomeDate}
			bind:value={formData.incomeDate}
			disabled={isLoading}
		/>
		{#if errors.incomeDate}
			<p class="text-xs font-medium text-[#a34f2f]">{errors.incomeDate}</p>
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
				{isEditing ? 'Actualizar' : 'Crear'} Ingreso
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
