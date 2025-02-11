<script lang="ts">
	import { PilotCard } from '$lib/components/pilot-card';

	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
	const result = $derived(data.result);
</script>

<div class="flex flex-col gap-4">
	<h1>Pilots</h1>
	{#each result as pilot}
		<PilotCard {...pilot} />
	{/each}
</div>
