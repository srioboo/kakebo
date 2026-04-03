<script lang="ts">
	let { href = '#', title = '', target, rel, class: className = '' } = $props();
</script>

<a
	href={href}
	title={title}
	target={target}
	rel={rel}
	class={`flex items-center gap-2 rounded-lg px-3 py-2 text-sm text-slate-200 transition hover:bg-slate-800 ${className}`}
>
	<slot name="lead" />
	<slot />
</a>

