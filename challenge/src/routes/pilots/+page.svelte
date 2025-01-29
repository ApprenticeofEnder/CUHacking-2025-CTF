<script lang="ts">
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
	const result = $derived(data.result);
	$inspect(result);
</script>

<h1>Pilots</h1>
{#each result as pilot }
	<div class="p-4 border-2 border-primary">
		<h2>{pilot.name} ({pilot.callsign})</h2>
	</div>
{/each}