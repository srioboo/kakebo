<script lang="ts">
	export let open: boolean = false;
	export let title: string = 'Confirmar';
	export let message: string = '¿Está seguro?';
	export let confirmText: string = 'Confirmar';
	export let cancelText: string = 'Cancelar';
	export let onConfirm: (() => void) = () => {};
	export let onCancel: (() => void) = () => {};
	export let isDangerous: boolean = false;
</script>

{#if open}
	<div class="modal modal-open">
		<div class="modal-box">
			<h3 class="font-bold text-lg">{title}</h3>
			<p class="py-4">{message}</p>
			<div class="modal-action">
				<button class="btn" on:click={() => { open = false; onCancel(); }}>
					{cancelText}
				</button>
				<button
					class="btn"
					class:btn-error={isDangerous}
					class:btn-primary={!isDangerous}
					on:click={() => {
						open = false;
						onConfirm();
					}}
				>
					{confirmText}
				</button>
			</div>
		</div>
		<form method="dialog" class="modal-backdrop" on:click={() => { open = false; onCancel(); }}>
			<button>close</button>
		</form>
	</div>
{/if}

<style>
	:global(.modal-open) {
		display: flex;
	}
</style>
