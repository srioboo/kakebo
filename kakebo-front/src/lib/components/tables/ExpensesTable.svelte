<script lang="ts">
	import type { Expense } from '$lib/api';
	import { formatCurrency, formatDate } from '$lib/api';
	import EmptyState from '../common/EmptyState.svelte';

	export let expenses: Expense[] = [];
	export let onEdit: (expense: Expense) => void = () => {};
	export let onDelete: (id: number) => void = () => {};
	export let sortBy: string = 'expenseDate';
	export let sortOrder: 'asc' | 'desc' = 'desc';

	function getSortedExpenses() {
		const sorted = [...expenses];
		sorted.sort((a, b) => {
			let aVal = a[sortBy as keyof Expense];
			let bVal = b[sortBy as keyof Expense];

			if (aVal === null || aVal === undefined) return 1;
			if (bVal === null || bVal === undefined) return -1;

			const comparison = aVal < bVal ? -1 : aVal > bVal ? 1 : 0;
			return sortOrder === 'asc' ? comparison : -comparison;
		});
		return sorted;
	}

	function toggleSort(field: string) {
		if (sortBy === field) {
			sortOrder = sortOrder === 'asc' ? 'desc' : 'asc';
		} else {
			sortBy = field;
			sortOrder = 'desc';
		}
	}

	function getTotalAmount() {
		return expenses.reduce((sum, exp) => sum + (exp.amount || 0), 0);
	}

	$: sortedExpenses = getSortedExpenses();
</script>

<div class="overflow-x-auto">
	{#if expenses.length === 0}
		<EmptyState
			title="Sin gastos"
			description="No hay gastos registrados"
			icon="💸"
			actionText="Crear gasto"
			onAction={() => {}}
		/>
	{:else}
		<table class="w-full min-w-[760px] border-separate border-spacing-0 text-sm">
			<caption class="sr-only">Listado de gastos con ordenacion y acciones</caption>
			<thead class="bg-[var(--kb-surface-soft)]">
				<tr>
					<th
						on:click={() => toggleSort('id')}
						scope="col"
						class="sticky top-0 z-10 cursor-pointer border-b border-[var(--kb-border)] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-[var(--kb-text-muted)] hover:bg-[var(--kb-row-alt)]"
					>
						ID
						{#if sortBy === 'id'}
							<span class="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>
						{/if}
					</th>
					<th
						on:click={() => toggleSort('expenseName')}
						scope="col"
						class="sticky top-0 z-10 cursor-pointer border-b border-[var(--kb-border)] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-[var(--kb-text-muted)] hover:bg-[var(--kb-row-alt)]"
					>
						Concepto
						{#if sortBy === 'expenseName'}
							<span class="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>
						{/if}
					</th>
					<th
						on:click={() => toggleSort('amount')}
						scope="col"
						class="sticky top-0 z-10 cursor-pointer border-b border-[var(--kb-border)] px-4 py-3 text-right text-xs font-semibold uppercase tracking-wide text-[var(--kb-text-muted)] hover:bg-[var(--kb-row-alt)]"
					>
						Importe
						{#if sortBy === 'amount'}
							<span class="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>
						{/if}
					</th>
					<th
						on:click={() => toggleSort('expenseDate')}
						scope="col"
						class="sticky top-0 z-10 cursor-pointer border-b border-[var(--kb-border)] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-[var(--kb-text-muted)] hover:bg-[var(--kb-row-alt)]"
					>
						Fecha
						{#if sortBy === 'expenseDate'}
							<span class="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>
						{/if}
					</th>
					<th
						scope="col"
						class="sticky top-0 z-10 border-b border-[var(--kb-border)] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-[var(--kb-text-muted)]"
					>
						Acciones
					</th>
				</tr>
			</thead>
			<tbody>
				{#each sortedExpenses as expense (expense.id)}
					<tr
						class="odd:bg-[var(--kb-surface)] even:bg-[var(--kb-row-alt)] hover:bg-[var(--kb-surface-soft)]"
					>
						<td class="border-b border-[var(--kb-border)] px-4 py-3 text-[var(--kb-text-muted)]">{expense.id}</td>
						<td class="border-b border-[var(--kb-border)] px-4 py-3 font-medium">{expense.expenseName}</td>
						<td
							class="border-b border-[var(--kb-border)] px-4 py-3 text-right font-semibold tabular-nums text-[var(--kb-accent-strong)]"
						>
							{formatCurrency(expense.amount || 0)}
						</td>
						<td class="kakebo-muted whitespace-nowrap border-b border-[var(--kb-border)] px-4 py-3">
							{formatDate(expense.expenseDate || '', 'es-ES', {
								year: 'numeric',
								month: 'short',
								day: 'numeric',
								hour: '2-digit',
								minute: '2-digit',
							})}
						</td>
						<td class="border-b border-[var(--kb-border)] px-4 py-3">
							<div class="flex gap-2">
							<button
								class="inline-flex min-h-8 items-center justify-center rounded-md border border-[var(--kb-border)] bg-[var(--kb-surface)] px-2.5 text-xs font-medium hover:bg-[var(--kb-surface-soft)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)]"
								on:click={() => onEdit(expense)}
								title="Editar"
								aria-label={`Editar gasto ${expense.expenseName}`}
							>
								✎
							</button>
							<button
								class="inline-flex min-h-8 items-center justify-center rounded-md border border-[#d08d6d] bg-[#fbf0ea] px-2.5 text-xs font-medium text-[#8a4a2c] hover:bg-[#f7e2d7] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#a15d3e]"
								on:click={() => onDelete(expense.id || 0)}
								title="Eliminar"
								aria-label={`Eliminar gasto ${expense.expenseName}`}
							>
								🗑
							</button>
							</div>
						</td>
					</tr>
				{/each}
			</tbody>
			<tfoot>
				<tr class="bg-[var(--kb-surface-soft)]">
					<td colspan="2" class="px-4 py-3 text-sm font-semibold text-[var(--kb-accent-strong)]">Total</td>
					<td class="px-4 py-3 text-right text-base font-bold tabular-nums text-[var(--kb-accent-strong)]">
						{formatCurrency(getTotalAmount())}
					</td>
					<td colspan="2"></td>
				</tr>
			</tfoot>
		</table>
	{/if}
</div>

<style>
	th {
		user-select: none;
	}
</style>
