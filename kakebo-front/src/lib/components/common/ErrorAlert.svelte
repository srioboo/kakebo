<script lang="ts">
	export let visible: boolean = false;
	export let type: 'success' | 'error' | 'warning' | 'info' = 'info';
	export let message: string;
	export let dismissible: boolean = true;
	export let onDismiss: (() => void) = () => {};

	function handleDismiss() {
		visible = false;
		onDismiss();
	}
</script>

{#if visible}
	<div class="alert" class:alert-success={type === 'success'} class:alert-error={type === 'error'} class:alert-warning={type === 'warning'} class:alert-info={type === 'info'}>
		<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24">
			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
		</svg>
		<span>{message}</span>
		{#if dismissible}
			<button class="btn btn-sm" on:click={handleDismiss}>Dismiss</button>
		{/if}
	</div>
{/if}

<style>
	.alert {
		animation: slideIn 0.3s ease-out;
	}

	@keyframes slideIn {
		from {
			opacity: 0;
			transform: translateY(-10px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}
</style>
