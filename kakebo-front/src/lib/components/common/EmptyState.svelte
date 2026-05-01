<script lang="ts">
	export let title: string = 'Sin datos';
	export let description: string = 'No hay elementos para mostrar';
	export let icon: string = '📭';
	export let actionText: string | undefined = undefined;
	export let onAction: (() => void) | undefined = undefined;
</script>

<div class="empty-state">
	<div class="empty-state-icon">{icon}</div>
	<h3 class="empty-state-title">{title}</h3>
	<p class="empty-state-description">{description}</p>
	{#if actionText && onAction}
		<button class="btn btn-primary mt-4" on:click={onAction}>
			{actionText}
		</button>
	{/if}
</div>

<style>
	.empty-state {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		padding: 3rem 1rem;
		text-align: center;
		gap: 1rem;
	}

	.empty-state-icon {
		font-size: 4rem;
		line-height: 1;
	}

	.empty-state-title {
		font-weight: 700;
		font-size: 1.25rem;
		margin: 0;
	}

	.empty-state-description {
		color: rgba(0, 0, 0, 0.6);
		margin: 0;
	}
</style>
