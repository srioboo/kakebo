<script lang="ts">
	import type { Income } from '$lib/api';
	import { formatCurrency, formatDate } from '$lib/api';
	import EmptyState from '../common/EmptyState.svelte';

	export let incomes: Income[] = [];
	export let onEdit: (income: Income) => void = () => {};
	export let onDelete: (id: number) => void = () => {};
	export let sortBy: string = 'incomeDate';
	export let sortOrder: 'asc' | 'desc' = 'desc';

	function getSortedIncomes() {
		const sorted = [...incomes];
		sorted.sort((a, b) => {
			let aVal = a[sortBy as keyof Income];
			let bVal = b[sortBy as keyof Income];

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
		return incomes.reduce((sum, inc) => sum + (inc.amount || 0), 0);
	}

	$: sortedIncomes = getSortedIncomes();
</script>

<div class="overflow-x-auto">
	{#if incomes.length === 0}
		<EmptyState
			title="Sin ingresos"
			description="No hay ingresos registrados"
			icon="💰"
			actionText="Crear ingreso"
			onAction={() => {}}
		/>
	{:else}
		<table class="w-full min-w-[760px] border-separate border-spacing-0 text-sm">
			<caption class="sr-only">Listado de ingresos con ordenacion y acciones</caption>
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
						on:click={() => toggleSort('incomeName')}
						scope="col"
						class="sticky top-0 z-10 cursor-pointer border-b border-[var(--kb-border)] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-[var(--kb-text-muted)] hover:bg-[var(--kb-row-alt)]"
					>
						Concepto
						{#if sortBy === 'incomeName'}
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
						on:click={() => toggleSort('incomeDate')}
						scope="col"
						class="sticky top-0 z-10 cursor-pointer border-b border-[var(--kb-border)] px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-[var(--kb-text-muted)] hover:bg-[var(--kb-row-alt)]"
					>
						Fecha
						{#if sortBy === 'incomeDate'}
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
				{#each sortedIncomes as income (income.id)}
					<tr
						class="odd:bg-[var(--kb-surface)] even:bg-[var(--kb-row-alt)] hover:bg-[var(--kb-surface-soft)]"
					>
						<td class="border-b border-[var(--kb-border)] px-4 py-3 text-[var(--kb-text-muted)]">{income.id}</td>
						<td class="border-b border-[var(--kb-border)] px-4 py-3 font-medium">{income.incomeName}</td>
						<td
							class="border-b border-[var(--kb-border)] px-4 py-3 text-right font-semibold tabular-nums text-[var(--kb-accent-strong)]"
						>
							{formatCurrency(income.amount || 0)}
						</td>
						<td class="kakebo-muted whitespace-nowrap border-b border-[var(--kb-border)] px-4 py-3">
							{formatDate(income.incomeDate || '', 'es-ES', {
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
								on:click={() => onEdit(income)}
								title="Editar"
								aria-label={`Editar ingreso ${income.incomeName}`}
							>
								✎
							</button>
							<button
								class="inline-flex min-h-8 items-center justify-center rounded-md border border-[#d08d6d] bg-[#fbf0ea] px-2.5 text-xs font-medium text-[#8a4a2c] hover:bg-[#f7e2d7] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#a15d3e]"
								on:click={() => onDelete(income.id || 0)}
								title="Eliminar"
								aria-label={`Eliminar ingreso ${income.incomeName}`}
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
