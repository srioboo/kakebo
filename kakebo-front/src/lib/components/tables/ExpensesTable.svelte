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

	const sortedExpenses = getSortedExpenses();
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
		<table class="table w-full">
			<thead>
				<tr>
					<th
						on:click={() => toggleSort('id')}
						class="cursor-pointer hover:bg-base-200"
					>
						ID
						{#if sortBy === 'id'}
							<span class="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>
						{/if}
					</th>
					<th
						on:click={() => toggleSort('expenseName')}
						class="cursor-pointer hover:bg-base-200"
					>
						Concepto
						{#if sortBy === 'expenseName'}
							<span class="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>
						{/if}
					</th>
					<th
						on:click={() => toggleSort('amount')}
						class="cursor-pointer hover:bg-base-200"
					>
						Importe
						{#if sortBy === 'amount'}
							<span class="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>
						{/if}
					</th>
					<th
						on:click={() => toggleSort('expenseDate')}
						class="cursor-pointer hover:bg-base-200"
					>
						Fecha
						{#if sortBy === 'expenseDate'}
							<span class="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>
						{/if}
					</th>
					<th>Acciones</th>
				</tr>
			</thead>
			<tbody>
				{#each sortedExpenses as expense (expense.id)}
					<tr class="hover:bg-base-100">
						<td>{expense.id}</td>
						<td class="font-medium">{expense.expenseName}</td>
						<td class="text-right font-semibold">
							{formatCurrency(expense.amount || 0)}
						</td>
						<td>
							{formatDate(expense.expenseDate || '', 'es-ES', {
								year: 'numeric',
								month: 'short',
								day: 'numeric',
								hour: '2-digit',
								minute: '2-digit',
							})}
						</td>
						<td class="flex gap-2">
							<button
								class="btn btn-xs btn-outline"
								on:click={() => onEdit(expense)}
								title="Editar"
							>
								✎
							</button>
							<button
								class="btn btn-xs btn-outline btn-error"
								on:click={() => onDelete(expense.id || 0)}
								title="Eliminar"
							>
								🗑
							</button>
						</td>
					</tr>
				{/each}
			</tbody>
			<tfoot>
				<tr class="font-bold">
					<td colspan="2">Total</td>
					<td class="text-right">{formatCurrency(getTotalAmount())}</td>
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
