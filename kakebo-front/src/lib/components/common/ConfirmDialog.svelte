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
	<div class="fixed inset-0 z-50 flex items-center justify-center p-4">
		<button
			type="button"
			aria-label="Cerrar confirmacion"
			class="absolute inset-0 bg-[rgb(35_29_22_/_45%)] backdrop-blur-[1px]"
			on:click={() => {
				open = false;
				onCancel();
			}}
		></button>
		<div
			role="dialog"
			aria-modal="true"
			aria-labelledby="kakebo-confirm-title"
			class="kakebo-surface relative z-10 w-full max-w-lg rounded-2xl p-6"
		>
			<h3 id="kakebo-confirm-title" class="text-lg font-semibold text-[var(--kb-accent-strong)]">{title}</h3>
			<p class="kakebo-muted py-4">{message}</p>
			<div class="flex justify-end gap-2">
				<button type="button" class="kakebo-button" on:click={() => { open = false; onCancel(); }}>
					{cancelText}
				</button>
				<button
					type="button"
					class="inline-flex min-h-11 items-center justify-center rounded-lg border px-4 text-sm font-semibold transition focus-visible:outline-2 focus-visible:outline-offset-2"
					class:border-[#d08d6d]={isDangerous}
					class:bg-[#fbf0ea]={isDangerous}
					class:text-[#8a4a2c]={isDangerous}
					class:hover:bg-[#f7e2d7]={isDangerous}
					class:focus-visible:outline-[#a15d3e]={isDangerous}
					class:border-[var(--kb-border)]={!isDangerous}
					class:bg-[var(--kb-surface)]={!isDangerous}
					class:text-[var(--kb-text)]={!isDangerous}
					class:hover:bg-[var(--kb-surface-soft)]={!isDangerous}
					class:focus-visible:outline-[var(--kb-focus)]={!isDangerous}
					on:click={() => {
						open = false;
						onConfirm();
					}}
				>
					{confirmText}
				</button>
			</div>
		</div>
	</div>
{/if}
