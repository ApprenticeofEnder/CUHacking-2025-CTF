<script lang="ts">
	import { PilotDetail } from '$lib/components/pilot-detail';

	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
	const result = $derived(data.result);
</script>

{#each result as pilot}
	<PilotDetail {...pilot} />
{/each}
