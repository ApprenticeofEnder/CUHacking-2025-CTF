<script lang="ts">
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
	const result = $derived(data.result);
	$inspect(result);
</script>

<h1>Pilots</h1>
