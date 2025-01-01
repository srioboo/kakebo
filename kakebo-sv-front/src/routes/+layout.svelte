<script lang="ts">
	import '../app.postcss';
	import { AppShell, AppBar } from '@skeletonlabs/skeleton';
	import { AppRail, AppRailTile, AppRailAnchor } from '@skeletonlabs/skeleton';

	// Floating UI for Popups
	import { computePosition, autoUpdate, flip, shift, offset, arrow } from '@floating-ui/dom';
	import { storePopup } from '@skeletonlabs/skeleton';

	// Font Awesome
	import '@fortawesome/fontawesome-free/css/fontawesome.css';
	import '@fortawesome/fontawesome-free/css/brands.css';
	import '@fortawesome/fontawesome-free/css/solid.css';

	storePopup.set({ computePosition, autoUpdate, flip, shift, offset, arrow });

	let currentTile: number = 0;
</script>

<!-- App Shell -->
<AppShell>
	<svelte:fragment slot="header">
		<!-- App Bar -->
		<AppBar gridColumns="grid-cols-3" slotDefault="place-self-center" slotTrail="place-content-end">
			<svelte:fragment slot="lead">
				<i class="fa-solid fa-bars text-2xl"></i>
			</svelte:fragment>
			<strong class="text-xl uppercase">Kakebo</strong>
			<svelte:fragment slot="trail">
				<!-- <a
					class="btn btn-sm variant-ghost-surface"
					href="https://discord.gg/EXqV7W8MtY"
					target="_blank"
					rel="noreferrer"
				>
					Discord
				</a>
				<a
					class="btn btn-sm variant-ghost-surface"
					href="https://twitter.com/SkeletonUI"
					target="_blank"
					rel="noreferrer"
				>
					Twitter
				</a>
				<a
					class="btn btn-sm variant-ghost-surface"
					href="https://github.com/skeletonlabs/skeleton"
					target="_blank"
					rel="noreferrer"
				>
					GitHub
				</a> -->
				<a class="btn btn-sm variant-ghost-surface" href="ayuda" rel="noreferrer"> Ayuda </a>
			</svelte:fragment>
		</AppBar>
	</svelte:fragment>

	<!-- App Rail -->
	<svelte:fragment slot="sidebarLeft">
		<AppRail>
			<svelte:fragment slot="lead">
				<AppRailAnchor href="/">(icon)</AppRailAnchor>
			</svelte:fragment>
			<!-- --- -->
			<AppRailAnchor href="/" title="tile-1">
				<svelte:fragment slot="lead">(icon)</svelte:fragment>
				<span>General</span>
			</AppRailAnchor>
			<AppRailAnchor href="/diario" title="tile-2">
				<svelte:fragment slot="lead">(icon)</svelte:fragment>
				<span>Diario</span>
			</AppRailAnchor>
			<AppRailAnchor href="/resumen" title="tile-3">
				<svelte:fragment slot="lead">(icon)</svelte:fragment>
				<span>Resumen</span>
			</AppRailAnchor>
			<!-- --- -->
			<svelte:fragment slot="trail">
				<AppRailAnchor href="/" target="_blank" title="Account">(icon)</AppRailAnchor>
			</svelte:fragment>
		</AppRail>
	</svelte:fragment>

	<!-- Page Route Content -->
	<slot />
</AppShell>
