<script lang="ts">
	let { gridColumns = 'grid-cols-3', slotDefault = '', slotTrail = '' } = $props();
</script>

<div class={`grid items-center gap-3 ${gridColumns}`}>
	<div class="flex items-center gap-2">
		<slot name="lead" />
	</div>
	<div class={`text-center ${slotDefault}`}>
		<slot />
	</div>
	<div class={`flex items-center justify-end gap-2 ${slotTrail}`}>
		<slot name="trail" />
	</div>
</div>

