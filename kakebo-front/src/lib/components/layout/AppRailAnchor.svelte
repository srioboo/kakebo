<script lang="ts">
	let {
		href = '#',
		title = '',
		target = undefined,
		rel = undefined,
		active = false,
		class: className = '',
	} = $props();
</script>

<a
	href={href}
	title={title}
	aria-label={title || undefined}
	target={target}
	rel={rel}
	aria-current={active ? 'page' : undefined}
	class={`flex min-h-11 items-center gap-2 rounded-lg border px-3 py-2 text-sm transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--kb-focus)] ${
		active
			? 'border-[var(--kb-accent)] bg-[var(--kb-surface-soft)] font-semibold text-[var(--kb-accent-strong)]'
			: 'border-transparent text-[var(--kb-text)] hover:bg-[var(--kb-surface-soft)]'
	} ${className}`}
>
	<slot name="lead" />
	<slot />
</a>
