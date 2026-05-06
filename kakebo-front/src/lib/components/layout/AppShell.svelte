<script lang="ts">
	let { mainId = 'main-content' } = $props();
</script>

<div class="min-h-screen bg-[var(--kb-bg)] text-[var(--kb-text)]">
	<header class="border-b border-[var(--kb-border)] bg-[var(--kb-surface)] px-4 py-3">
		<slot name="header" />
	</header>

	<div class="mx-auto flex w-full max-w-7xl gap-4 p-4">
		<aside class="hidden w-56 shrink-0 md:block">
			<slot name="sidebarLeft" />
		</aside>
		<main id={mainId} class="min-w-0 flex-1 rounded-xl focus:outline-none">
			<slot />
		</main>
	</div>
</div>
