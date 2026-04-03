<div class="min-h-screen bg-slate-950 text-slate-100">
	<header class="border-b border-slate-800 px-4 py-3">
		<slot name="header" />
	</header>

	<div class="mx-auto flex w-full max-w-7xl gap-4 p-4">
		<aside class="hidden w-56 shrink-0 md:block">
			<slot name="sidebarLeft" />
		</aside>
		<main class="min-w-0 flex-1">
			<slot />
		</main>
	</div>
</div>

