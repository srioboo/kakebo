<script lang="ts">
	import { formatCurrency, formatDate, type Expense, type Income } from '$lib/api';

	type WrappedList<T> = T[] | { data?: T[] } | undefined;

	const getList = <T>(value: WrappedList<T>): T[] => {
		if (Array.isArray(value)) return value;
		if (value && 'data' in value && Array.isArray(value.data)) return value.data;
		return [];
	};

	export let data: {
		expenses?: WrappedList<Expense>;
		incomes?: WrappedList<Income>;
		error?: string;
	};

	const incomes = getList(data?.incomes);
	const expenses = getList(data?.expenses);
	const error = data?.error;

	const monthlyIncome = incomes.reduce((total, item) => total + item.amount, 0);
	const monthlyExpenses = expenses.reduce((total, item) => total + item.amount, 0);
	const availableBudget = monthlyIncome - monthlyExpenses;

	const monthName = new Intl.DateTimeFormat('es-ES', { month: 'long' }).format(new Date());
	const currentMonth = monthName.charAt(0).toUpperCase() + monthName.slice(1);
</script>

<div class="mx-auto flex w-full max-w-7xl flex-col gap-6">
	<section class="kakebo-surface rounded-2xl p-6">
		<p class="kakebo-muted text-sm">Portada mensual</p>
		<div class="mt-2 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
			<div>
				<h1 class="text-2xl font-semibold text-[var(--kb-accent-strong)]">Kakebo · {currentMonth}</h1>
				<p class="kakebo-muted mt-1 text-sm">Escribe menos, entiende mejor en que gastas.</p>
			</div>
			<div class="kakebo-panel rounded-xl px-4 py-3 text-sm">
				<p class="kakebo-muted">Ingreso disponible este mes</p>
				<p class="text-xl font-semibold">{formatCurrency(availableBudget)}</p>
			</div>
		</div>
	</section>

	{#if error}
		<p class="rounded-xl border border-[#d08d6d] bg-[#f8e8df] px-4 py-3 text-sm text-[#73422b]">{error}</p>
	{/if}

	<section class="grid gap-4 md:grid-cols-3">
		<article class="kakebo-surface rounded-xl p-4">
			<p class="kakebo-muted text-xs uppercase tracking-wide">Ingreso mensual</p>
			<p class="mt-2 text-xl font-semibold">{formatCurrency(monthlyIncome)}</p>
		</article>
		<article class="kakebo-surface rounded-xl p-4">
			<p class="kakebo-muted text-xs uppercase tracking-wide">Gasto mensual</p>
			<p class="mt-2 text-xl font-semibold">{formatCurrency(monthlyExpenses)}</p>
		</article>
		<article class="kakebo-surface rounded-xl p-4">
			<p class="kakebo-muted text-xs uppercase tracking-wide">Balance</p>
			<p class="mt-2 text-xl font-semibold">{formatCurrency(availableBudget)}</p>
		</article>
	</section>

	<section class="grid gap-4 xl:grid-cols-2">
		<article class="kakebo-surface overflow-hidden rounded-xl">
			<header class="kakebo-panel border-b border-[var(--kb-border)] px-4 py-3">
				<h2 class="text-lg font-semibold">Ingresos del mes</h2>
			</header>
			<div class="overflow-auto">
				<table class="w-full min-w-[520px] text-sm">
					<caption class="sr-only">Listado de ingresos del mes</caption>
					<thead class="bg-[var(--kb-surface-soft)] text-left">
						<tr>
							<th scope="col" class="px-4 py-3 font-medium">Concepto</th>
							<th scope="col" class="px-4 py-3 font-medium">Fecha</th>
							<th scope="col" class="px-4 py-3 text-right font-medium">Importe</th>
						</tr>
					</thead>
					<tbody>
						{#if incomes.length > 0}
							{#each incomes as income}
								<tr class="border-t border-[var(--kb-border)]">
									<td class="px-4 py-3">{income.incomeName}</td>
									<td class="px-4 py-3 kakebo-muted">{formatDate(income.incomeDate)}</td>
									<td class="px-4 py-3 text-right font-medium">{formatCurrency(income.amount)}</td>
								</tr>
							{/each}
						{:else}
							<tr class="border-t border-[var(--kb-border)]">
								<td colspan="3" class="kakebo-muted px-4 py-4">Sin ingresos registrados por ahora.</td>
							</tr>
						{/if}
					</tbody>
					<tfoot>
						<tr class="border-t border-[var(--kb-border)] bg-[var(--kb-surface-soft)]">
							<td colspan="2" class="px-4 py-3 font-medium">Total ingresos</td>
							<td class="px-4 py-3 text-right font-semibold">{formatCurrency(monthlyIncome)}</td>
						</tr>
					</tfoot>
				</table>
			</div>
		</article>

		<article class="kakebo-surface overflow-hidden rounded-xl">
			<header class="kakebo-panel border-b border-[var(--kb-border)] px-4 py-3">
				<h2 class="text-lg font-semibold">Gastos del mes</h2>
			</header>
			<div class="overflow-auto">
				<table class="w-full min-w-[520px] text-sm">
					<caption class="sr-only">Listado de gastos del mes</caption>
					<thead class="bg-[var(--kb-surface-soft)] text-left">
						<tr>
							<th scope="col" class="px-4 py-3 font-medium">Concepto</th>
							<th scope="col" class="px-4 py-3 font-medium">Fecha</th>
							<th scope="col" class="px-4 py-3 text-right font-medium">Importe</th>
						</tr>
					</thead>
					<tbody>
						{#if expenses.length > 0}
							{#each expenses as expense}
								<tr class="border-t border-[var(--kb-border)]">
									<td class="px-4 py-3">{expense.expenseName}</td>
									<td class="px-4 py-3 kakebo-muted">{formatDate(expense.expenseDate)}</td>
									<td class="px-4 py-3 text-right font-medium">{formatCurrency(expense.amount)}</td>
								</tr>
							{/each}
						{:else}
							<tr class="border-t border-[var(--kb-border)]">
								<td colspan="3" class="kakebo-muted px-4 py-4">Sin gastos registrados por ahora.</td>
							</tr>
						{/if}
					</tbody>
					<tfoot>
						<tr class="border-t border-[var(--kb-border)] bg-[var(--kb-surface-soft)]">
							<td colspan="2" class="px-4 py-3 font-medium">Total gastos</td>
							<td class="px-4 py-3 text-right font-semibold">{formatCurrency(monthlyExpenses)}</td>
						</tr>
					</tfoot>
				</table>
			</div>
		</article>
	</section>

	<section class="grid gap-4 xl:grid-cols-2">
		<article class="kakebo-surface rounded-xl p-5">
			<h2 class="text-lg font-semibold">Resumen mensual</h2>
			<p class="kakebo-muted mt-1 text-sm">Cierre y reflexion</p>
			<ul class="mt-4 space-y-2 text-sm">
				<li><strong>¿Cuanto tienes para gastar?</strong> {formatCurrency(availableBudget)}</li>
				<li><strong>¿Que funciono este mes?</strong> Mantener visibles gastos esenciales y extras.</li>
				<li><strong>Siguiente ajuste:</strong> reducir gasto opcional un 10% la proxima semana.</li>
			</ul>
		</article>
		<article class="kakebo-surface rounded-xl p-5">
			<h2 class="text-lg font-semibold">Objetivo y promesa</h2>
			<p class="kakebo-muted mt-1 text-sm">Compromiso personal kakebo</p>
			<div class="mt-4 grid gap-3 text-sm">
				<div class="kakebo-panel rounded-lg p-3">
					<p class="font-medium">Objetivo mensual</p>
					<p class="kakebo-muted mt-1">Reservar una parte fija al ahorro antes de gastar.</p>
				</div>
				<div class="kakebo-panel rounded-lg p-3">
					<p class="font-medium">Promesa</p>
					<p class="kakebo-muted mt-1">Anotar cada gasto diario para decidir con mas calma.</p>
				</div>
			</div>
		</article>
	</section>
</div>
