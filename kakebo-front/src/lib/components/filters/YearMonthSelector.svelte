<script lang="ts">
	export let currentYear: number;
	export let currentMonth: number;
	export let onselect: ((data: { year: number; month: number }) => void) | undefined = undefined;

	const START_YEAR = 2023;
	const THIS_YEAR = new Date().getFullYear();

	const years: number[] = Array.from(
		{ length: THIS_YEAR - START_YEAR + 1 },
		(_, i) => THIS_YEAR - i,
	);

	const MONTHS: number[] = Array.from({ length: 12 }, (_, i) => i + 1);

	let expandedYear: number | null = currentYear;

	function getMonthName(month: number): string {
		return new Intl.DateTimeFormat('es-ES', { month: 'long' }).format(new Date(2000, month - 1));
	}

	function toggleYear(year: number) {
		expandedYear = expandedYear === year ? null : year;
	}

	function selectMonth(year: number, month: number) {
		onselect?.({ year, month });
	}
</script>

<nav class="year-month-selector" aria-label="Seleccionar período">
	{#each years as year (year)}
		<div class="ym-year-block">
			<button
				class="ym-year-btn"
				class:ym-year-btn--active={year === currentYear}
				on:click={() => toggleYear(year)}
				aria-expanded={expandedYear === year}
			>
				<span>{year}</span>
				<svg
					class="ym-chevron"
					class:ym-chevron--open={expandedYear === year}
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 20 20"
					fill="currentColor"
					aria-hidden="true"
				>
					<path
						fill-rule="evenodd"
						d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z"
						clip-rule="evenodd"
					/>
				</svg>
			</button>

			{#if expandedYear === year}
				<ul class="ym-month-list">
					{#each MONTHS as month (month)}
						<li>
							<button
								class="ym-month-btn"
								class:ym-month-btn--active={year === currentYear && month === currentMonth}
								on:click={() => selectMonth(year, month)}
							>
								{getMonthName(month)}
							</button>
						</li>
					{/each}
				</ul>
			{/if}
		</div>
	{/each}
</nav>

<style>
	.year-month-selector {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		min-width: 160px;
	}

	.ym-year-block {
		display: flex;
		flex-direction: column;
	}

	.ym-year-btn {
		display: flex;
		align-items: center;
		justify-content: space-between;
		width: 100%;
		padding: 0.5rem 0.75rem;
		border: none;
		border-radius: 0.5rem;
		background: transparent;
		cursor: pointer;
		font-weight: 600;
		font-size: 0.875rem;
		color: var(--kb-accent-strong, #2d4a3e);
		transition: background 0.15s;
	}

	.ym-year-btn:hover {
		background: var(--kb-surface-hover, rgba(0, 0, 0, 0.05));
	}

	.ym-year-btn--active {
		background: var(--kb-accent-soft, rgba(45, 74, 62, 0.1));
	}

	.ym-chevron {
		width: 1rem;
		height: 1rem;
		transition: transform 0.2s;
		flex-shrink: 0;
	}

	.ym-chevron--open {
		transform: rotate(180deg);
	}

	.ym-month-list {
		list-style: none;
		margin: 0;
		padding: 0 0 0.25rem 0.5rem;
		display: flex;
		flex-direction: column;
		gap: 0.125rem;
	}

	.ym-month-btn {
		display: block;
		width: 100%;
		padding: 0.375rem 0.75rem;
		border: none;
		border-radius: 0.375rem;
		background: transparent;
		cursor: pointer;
		font-size: 0.8125rem;
		text-align: left;
		text-transform: capitalize;
		color: var(--kb-text, inherit);
		transition: background 0.15s;
	}

	.ym-month-btn:hover {
		background: var(--kb-surface-hover, rgba(0, 0, 0, 0.05));
	}

	.ym-month-btn--active {
		background: var(--kb-accent-strong, #2d4a3e);
		color: white;
		font-weight: 600;
	}
</style>
