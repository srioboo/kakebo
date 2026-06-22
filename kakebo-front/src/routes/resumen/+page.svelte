<script lang="ts">
	import { formatCurrency, type Expense, type Income } from '$lib/api';

	export let data: {
		expenses?: Expense[];
		incomes?: Income[];
		year: number;
		month: number;
		error?: string;
	};

	const periodDate = new Date(data.year, data.month - 1);
	const monthName = new Intl.DateTimeFormat('es-ES', { month: 'long' }).format(periodDate);
	const currentMonth = `${monthName.charAt(0).toUpperCase()}${monthName.slice(1)} ${data.year}`;

	const incomes = data.incomes ?? [];
	const expenses = data.expenses ?? [];

	const totalIncome = incomes.reduce((sum, item) => sum + item.amount, 0);
	const totalExpenses = expenses.reduce((sum, item) => sum + item.amount, 0);
	const savings = totalIncome - totalExpenses;
	const savingsRate = totalIncome === 0 ? 0 : Math.round((savings / totalIncome) * 1000) / 10;
</script>

<div class="mx-auto flex w-full max-w-7xl flex-col gap-6">
	<section class="kakebo-surface rounded-2xl p-6">
		<h1 class="text-2xl font-semibold text-[var(--kb-accent-strong)]">Resumen mensual · {currentMonth}</h1>
		<p class="kakebo-muted mt-2 text-sm">
			Espacio para cerrar el mes: comparar plan vs. realidad y preparar el siguiente ciclo.
		</p>
	</section>

	{#if data.error}
		<div class="flex items-center gap-2 rounded-xl border border-[#d08d6d] bg-[#f8e8df] px-4 py-3 text-sm text-[#73422b]">
			<span>{data.error}</span>
		</div>
	{/if}

	<section class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
		<article class="kakebo-surface rounded-xl p-4">
			<p class="kakebo-muted text-xs uppercase tracking-wide">Ingresos</p>
			<p class="mt-2 text-lg font-semibold">{formatCurrency(totalIncome)}</p>
		</article>
		<article class="kakebo-surface rounded-xl p-4">
			<p class="kakebo-muted text-xs uppercase tracking-wide">Gastos</p>
			<p class="mt-2 text-lg font-semibold">{formatCurrency(totalExpenses)}</p>
		</article>
		<article class="kakebo-surface rounded-xl p-4">
			<p class="kakebo-muted text-xs uppercase tracking-wide">Ahorro</p>
			<p class="mt-2 text-lg font-semibold">{formatCurrency(savings)}</p>
		</article>
		<article class="kakebo-surface rounded-xl p-4">
			<p class="kakebo-muted text-xs uppercase tracking-wide">Tasa de ahorro</p>
			<p class="mt-2 text-lg font-semibold">{savingsRate.toFixed(1)}%</p>
		</article>
	</section>

	<section class="grid gap-4 xl:grid-cols-2">
		<article class="kakebo-surface rounded-xl p-5">
			<h2 class="text-lg font-semibold">Preguntas de cierre kakebo</h2>
			<ul class="mt-3 space-y-2 text-sm">
				<li>¿En que categoria se fue mas dinero de lo previsto?</li>
				<li>¿Que gasto dio mas valor real y cual menos?</li>
				<li>¿Que pequeno ajuste hara mas facil ahorrar el mes que viene?</li>
			</ul>
		</article>
		<article class="kakebo-surface rounded-xl p-5">
			<h2 class="text-lg font-semibold">Plan de ajuste</h2>
			<div class="mt-3 space-y-3 text-sm">
				<div class="kakebo-panel rounded-lg p-3">
					<p class="font-medium">Reducir gastos opcionales</p>
					<p class="kakebo-muted mt-1">Limitar compras impulsivas a una vez por semana.</p>
				</div>
				<div class="kakebo-panel rounded-lg p-3">
					<p class="font-medium">Ahorro automatizado</p>
					<p class="kakebo-muted mt-1">Separar ahorro al inicio del mes, no al final.</p>
				</div>
			</div>
		</article>
	</section>
</div>
