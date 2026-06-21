<script lang="ts">
	import { page } from '$app/state';
	import { goto } from '$app/navigation';
	import { i18n } from '$lib/i18n';
	import { AppBar, AppRail, AppRailAnchor, AppShell } from '$lib/components/layout';
	import { YearMonthSelector } from '$lib/components/filters';
	import { selectedPeriod } from '$lib/stores';
	import { ParaglideJS } from '@inlang/paraglide-sveltekit';
	import '../app.css';

	let { children } = $props();

	const isActive = (href: string) =>
		href === '/'
			? page.url.pathname === '/'
			: page.url.pathname === href || page.url.pathname.startsWith(`${href}/`);

	function getActivePeriod(): { year: number; month: number } {
		const now = new Date();
		const yearParam = page.url.searchParams.get('year');
		const monthParam = page.url.searchParams.get('month');
		return {
			year: yearParam ? parseInt(yearParam) : now.getFullYear(),
			month: monthParam ? parseInt(monthParam) : now.getMonth() + 1,
		};
	}

	function handlePeriodSelect(e: CustomEvent<{ year: number; month: number }>) {
		const { year, month } = e.detail;
		goto(`${page.url.pathname}?year=${year}&month=${month}`);
	}

	$effect(() => {
		const p = getActivePeriod();
		selectedPeriod.set({ year: p.year, month: p.month });
	});
</script>

<ParaglideJS {i18n}>
	<AppShell>
		<a
			href="#main-content"
			class="sr-only left-2 top-2 z-50 rounded-lg border border-[var(--kb-border)] bg-[var(--kb-surface)] px-3 py-2 text-sm focus:not-sr-only focus:absolute focus:outline-2 focus:outline-offset-2 focus:outline-[var(--kb-focus)]"
		>
			Saltar al contenido
		</a>
		<svelte:fragment slot="header">
			<AppBar
				gridColumns="grid-cols-[auto_1fr_auto]"
				slotDefault="justify-self-start text-left"
				slotTrail="place-content-end"
			>
				<svelte:fragment slot="lead">
					<div
						class="flex h-10 w-10 items-center justify-center rounded-lg border border-[var(--kb-border)] bg-[var(--kb-surface-soft)] text-[var(--kb-accent-strong)]"
					>
						<svg
							aria-hidden="true"
							viewBox="0 0 24 24"
							class="h-5 w-5"
							fill="none"
							stroke="currentColor"
							stroke-width="1.8"
						>
							<path d="M4 19.5h16M6.5 18V7a2 2 0 0 1 2-2h7l2 2v11" />
							<path d="M9 9.5h6M9 13h6" />
						</svg>
					</div>
				</svelte:fragment>
				<div>
					<strong class="text-lg uppercase tracking-wide text-[var(--kb-accent-strong)]">Kakebo</strong>
					<p class="kakebo-muted text-xs">Control mensual con metodo japones</p>
				</div>
			<svelte:fragment slot="trail">
				<a class="kakebo-button gap-2" href="/ayuda" rel="noreferrer">
					<svg
						aria-hidden="true"
						viewBox="0 0 24 24"
						class="h-4 w-4"
						fill="none"
						stroke="currentColor"
						stroke-width="1.8"
					>
						<path d="M12 17v.01M9.1 9a3 3 0 1 1 5.8 1c-.6 1.2-1.8 1.6-2.5 2.5-.2.3-.4.7-.4 1" />
						<circle cx="12" cy="12" r="9" />
					</svg>
					<span>Ayuda</span>
				</a>
			</svelte:fragment>
			</AppBar>
		</svelte:fragment>

		<svelte:fragment slot="sidebarLeft">
			<AppRail>
				<svelte:fragment slot="lead">
					<p class="px-3 py-2 text-xs font-semibold uppercase tracking-wide kakebo-muted">Libro kakebo</p>
				</svelte:fragment>
				<AppRailAnchor href="/" title="General" active={isActive('/')}>
					<svelte:fragment slot="lead">
						<svg
							aria-hidden="true"
							viewBox="0 0 24 24"
							class="h-4 w-4"
							fill="none"
							stroke="currentColor"
							stroke-width="1.8"
						>
							<path d="M3 11.5 12 4l9 7.5" />
							<path d="M5.5 10.5v9h13v-9" />
						</svg>
					</svelte:fragment>
					<span>General</span>
				</AppRailAnchor>
				<AppRailAnchor href="/diario" title="Diario" active={isActive('/diario')}>
					<svelte:fragment slot="lead">
						<svg
							aria-hidden="true"
							viewBox="0 0 24 24"
							class="h-4 w-4"
							fill="none"
							stroke="currentColor"
							stroke-width="1.8"
						>
							<path d="M7 4.5h10a2 2 0 0 1 2 2v13H7a2 2 0 0 0-2 2V6.5a2 2 0 0 1 2-2Z" />
							<path d="M9 9h7M9 12.5h7M9 16h5" />
						</svg>
					</svelte:fragment>
					<span>Diario</span>
				</AppRailAnchor>
				<AppRailAnchor href="/expenses" title="Gastos" active={isActive('/expenses')}>
					<svelte:fragment slot="lead">
						<svg
							aria-hidden="true"
							viewBox="0 0 24 24"
							class="h-4 w-4"
							fill="none"
							stroke="currentColor"
							stroke-width="1.8"
						>
							<path d="M4.5 7h15v10h-15z" />
							<path d="M4.5 10.5h15M9 14h3" />
						</svg>
					</svelte:fragment>
					<span>Gastos</span>
				</AppRailAnchor>
				<AppRailAnchor href="/incomes" title="Ingresos" active={isActive('/incomes')}>
					<svelte:fragment slot="lead">
						<svg
							aria-hidden="true"
							viewBox="0 0 24 24"
							class="h-4 w-4"
							fill="none"
							stroke="currentColor"
							stroke-width="1.8"
						>
							<path d="M12 19V5M7.5 9.5 12 5l4.5 4.5" />
							<path d="M5 19h14" />
						</svg>
					</svelte:fragment>
					<span>Ingresos</span>
				</AppRailAnchor>
				<AppRailAnchor href="/resumen" title="Resumen" active={isActive('/resumen')}>
					<svelte:fragment slot="lead">
						<svg viewBox="0 0 24 24" class="h-4 w-4" fill="none" stroke="currentColor" stroke-width="1.8">
							<path d="M5 5.5v13h14" />
							<path d="M8.5 15.5V12M12 15.5V9M15.5 15.5V7" />
						</svg>
					</svelte:fragment>
					<span>Resumen</span>
				</AppRailAnchor>

				<div class="mt-3 border-t border-[var(--kb-border)] px-1 pt-3">
					<p class="mb-2 px-1 text-xs font-semibold uppercase tracking-wide kakebo-muted">Período</p>
					<YearMonthSelector
						currentYear={getActivePeriod().year}
						currentMonth={getActivePeriod().month}
						on:select={handlePeriodSelect}
					/>
				</div>

				<svelte:fragment slot="trail">
					<AppRailAnchor href="/ayuda" title="Ayuda" active={isActive('/ayuda')}>
						<svelte:fragment slot="lead">
							<svg
								aria-hidden="true"
								viewBox="0 0 24 24"
								class="h-4 w-4"
								fill="none"
								stroke="currentColor"
								stroke-width="1.8"
							>
								<path d="M12 17v.01M9.1 9a3 3 0 1 1 5.8 1c-.6 1.2-1.8 1.6-2.5 2.5-.2.3-.4.7-.4 1" />
								<circle cx="12" cy="12" r="9" />
							</svg>
						</svelte:fragment>
						<span>Ayuda</span>
					</AppRailAnchor>
				</svelte:fragment>
			</AppRail>
		</svelte:fragment>

		{@render children()}
	</AppShell>
</ParaglideJS>
