<script lang="ts">
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
	const result = $derived(data.result);
</script>

<h1>Notices</h1>
{#each result as notice}
	<div class="border-2 border-primary p-4">
		<h2 class="flex justify-between">{notice.title} {notice.author}</h2>
		<p>{notice.note}</p>
	</div>
{/each}
