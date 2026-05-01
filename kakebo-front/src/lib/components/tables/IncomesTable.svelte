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

	const sortedIncomes = getSortedIncomes();
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
						on:click={() => toggleSort('incomeName')}
						class="cursor-pointer hover:bg-base-200"
					>
						Concepto
						{#if sortBy === 'incomeName'}
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
						on:click={() => toggleSort('incomeDate')}
						class="cursor-pointer hover:bg-base-200"
					>
						Fecha
						{#if sortBy === 'incomeDate'}
							<span class="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>
						{/if}
					</th>
					<th>Acciones</th>
				</tr>
			</thead>
			<tbody>
				{#each sortedIncomes as income (income.id)}
					<tr class="hover:bg-base-100">
						<td>{income.id}</td>
						<td class="font-medium">{income.incomeName}</td>
						<td class="text-right font-semibold">
							{formatCurrency(income.amount || 0)}
						</td>
						<td>
							{formatDate(income.incomeDate || '', 'es-ES', {
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
								on:click={() => onEdit(income)}
								title="Editar"
							>
								✎
							</button>
							<button
								class="btn btn-xs btn-outline btn-error"
								on:click={() => onDelete(income.id || 0)}
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
