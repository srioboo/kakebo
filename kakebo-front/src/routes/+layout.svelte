<script lang="ts">
	import { i18n } from '$lib/i18n';
	import { ParaglideJS } from '@inlang/paraglide-sveltekit';
	import '../app.css';
	let { children } = $props();
</script>

<ParaglideJS {i18n}>
	{@render children()}
</ParaglideJS>
<!-- App Shell -- TODO create component  -->
<AppShell>
	<svelte:fragment slot="header">
		<!-- App Bar -- TODO create component  -->
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

	<!-- App Rail -- TODO create component -->
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
