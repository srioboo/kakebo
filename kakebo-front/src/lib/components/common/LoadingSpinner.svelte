<script lang="ts">
	export let loading: boolean = false;
	export let size: 'sm' | 'md' | 'lg' = 'md';
</script>

<div class="loading-container" class:loading-sm={size === 'sm'} class:loading-md={size === 'md'} class:loading-lg={size === 'lg'}>
	<span class="loading loading-spinner" />
</div>

<style>
	.loading-container {
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 2rem;
	}

	.loading-sm :global(.loading-spinner) {
		width: 1.5rem;
		height: 1.5rem;
	}

	.loading-md :global(.loading-spinner) {
		width: 2.5rem;
		height: 2.5rem;
	}

	.loading-lg :global(.loading-spinner) {
		width: 4rem;
		height: 4rem;
	}
</style>
