<nav class="flex h-full min-h-96 flex-col rounded-xl border border-slate-800 bg-slate-900/60 p-2">
	<div class="mb-2">
		<slot name="lead" />
	</div>

	<div class="flex flex-1 flex-col gap-1">
		<slot />
	</div>

	<div class="mt-2">
		<slot name="trail" />
	</div>
</nav>

