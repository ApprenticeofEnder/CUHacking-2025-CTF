<script lang="ts">
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
	const result = $derived(data.result);
</script>

<h1>Notices</h1>
{#each result as notice }
	<div class="p-4 border-2 border-primary">
		<h2 class="flex justify-between">{notice.title} {notice.author}</h2>
        <p>{notice.note}</p>
	</div>
{/each}