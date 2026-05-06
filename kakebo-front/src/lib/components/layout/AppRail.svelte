<nav aria-label="Navegacion principal" class="kakebo-surface flex h-full min-h-96 flex-col rounded-xl p-2">
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
