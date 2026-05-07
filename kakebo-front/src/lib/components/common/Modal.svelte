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
	<div class="fixed inset-0 z-50 flex items-center justify-center p-4">
		<button
			type="button"
			aria-label="Cerrar modal"
			class="absolute inset-0 bg-[rgb(35_29_22_/_45%)] backdrop-blur-[1px]"
			on:click={handleBackdropClick}
		></button>
		<div
			role="dialog"
			aria-modal="true"
			aria-labelledby="kakebo-modal-title"
			class="kakebo-surface relative z-10 w-full max-w-xl rounded-2xl p-6"
		>
			<button
				type="button"
				class="absolute right-3 top-3 inline-flex h-9 w-9 items-center justify-center rounded-lg border border-[var(--kb-border)] bg-[var(--kb-surface)] text-[var(--kb-text-muted)] hover:bg-[var(--kb-surface-soft)] hover:text-[var(--kb-text)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)]"
				aria-label="Cerrar"
				on:click={() => {
					open = false;
					onClose();
				}}
			>
				✕
			</button>
			<h3 id="kakebo-modal-title" class="text-lg font-semibold text-[var(--kb-accent-strong)]">{title}</h3>
			<div class="pt-4">
				<slot />
			</div>
		</div>
	</div>
{/if}
