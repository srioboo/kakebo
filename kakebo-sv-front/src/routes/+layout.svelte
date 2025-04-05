<script lang="ts">
	import '../app.css';
	import { AppBar, Navigation } from '@skeletonlabs/skeleton-svelte';
	// delete Floating UI for Popups
	// import { computePosition, autoUpdate, flip, shift, offset, arrow } from '@floating-ui/dom';
	// Font Awesome
	import '@fortawesome/fontawesome-free/css/fontawesome.css';
	import '@fortawesome/fontawesome-free/css/brands.css';
	import '@fortawesome/fontawesome-free/css/solid.css';
	// import IconFolder from '@lucide/svelte/icons/folder';
	import { Menu, Folder, CircleHelp } from '@lucide/svelte';
	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();

	// storePopup.set({ computePosition, autoUpdate, flip, shift, offset, arrow });

	let currentTile: number = 0;
</script>

<!-- App Shell -->
<div class="w-full flex flex-col bg-surface-100-900 space-y-4 p-4">
	<!-- {#snippet header()} -->
	
			<!-- App Bar -->
			<AppBar headlineClasses="sm:hidden flex-auto place-self-center" 
				leadClasses="app-bar-slot-lead flex-none flex justify-between items-center " 
				centerClasses="hidden sm:block"
				trailClasses="app-bar-slot-trail flex-none flex items-center space-x-4 place-content-end">

				
				{#snippet lead()}
						<Menu size={26} font-weight={900}/>
				{/snippet}
				{#snippet headline()}
				<h1 class="h1">Kakebo</h1>
				{/snippet}
				<span class="h4">Kakebo</span>
				{#snippet trail()}
					
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
						<a href="ayuda" rel="noreferrer">
							<CircleHelp href="ayuda" />
						</a>
						
					
				{/snippet}
			</AppBar>
		
	<!-- {/snippet} -->

	<!-- App Rail -->
	<!-- {#snippet sidebarLeft()} -->
	<div class="grid grid-cols-1 md:grid-cols-[auto_1fr]">
		<Navigation.Rail>
			{#snippet header()}
				<Navigation.Tile label="Inicio" href="/">
					<Folder />
				</Navigation.Tile>
			{/snippet}
			<!-- --- -->
			{#snippet tiles()}
			<Navigation.Tile label="General" href="/" title="tile-1">
				<Folder />
			</Navigation.Tile>
			<Navigation.Tile label="Diario" href="/diario" title="tile-2">
				<Folder />
			</Navigation.Tile>
			<Navigation.Tile label="Resumen" href="/resumen" title="tile-3">
				<Folder />
			</Navigation.Tile>
			{/snippet}
			<!-- --- -->
			{#snippet footer()}
				<Navigation.Tile href="/ayuda" target="_blank" title="Account">
					<Folder />
				</Navigation.Tile>
			{/snippet}
		</Navigation.Rail>
	
		<!-- Page Route Content -->
		{@render children?.()}
	</div>
	<!-- {/snippet} -->
</div>
