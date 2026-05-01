<script lang="ts">
	export let open = false;
	export let title: string;
	export let onClose: (() => void) = () => {};

	function handleBackdropClick() {
		open = false;
		onClose();
	}

	function handleKeydown(e: KeyboardEvent) {
		if (e.key === 'Escape') {
			open = false;
			onClose();
		}
	}
</script>

<svelte:window on:keydown={handleKeydown} />

{#if open}
	<div class="modal modal-open">
		<div class="modal-box max-w-md">
			<h3 class="font-bold text-lg">{title}</h3>
			<div class="py-4">
				<slot />
			</div>
			<div class="modal-action">
				<button
					class="btn"
					on:click={() => {
						open = false;
						onClose();
					}}
				>
					Close
				</button>
			</div>
		</div>
		<form method="dialog" class="modal-backdrop" on:click={handleBackdropClick}>
			<button>close</button>
		</form>
	</div>
{/if}

<style>
	:global(.modal-open) {
		display: flex;
	}
</style>
