<script lang="ts">
	import { Card, CardContent, CardHeader, CardFooter } from '$lib/components/ui/card';
	import type { Pilot } from '$lib/types';
	import { cn } from '$lib/utils';
	import CardTitle from '../ui/card/card-title.svelte';

	let { id, name, callsign, biography, notes, classified }: Pilot = $props();

	const visibilityStatus = $derived(classified ? 'CLASSIFIED' : 'PUBLIC');
</script>

<Card>
	<CardHeader>
		<CardTitle>{name}</CardTitle>
		<h3>Callsign: {callsign}</h3>
	</CardHeader>
	<CardContent class="flex flex-col gap-4">
		<div class="flex flex-col gap-2">
			<h3 class="text-lg">Biography</h3>
			<pre class="entry">{biography}</pre>
		</div>
		<div class="flex flex-col gap-2">
			<h3 class="text-lg">Notes</h3>
			<pre class="entry">{notes}</pre>
		</div>
	</CardContent>
	<CardFooter class={cn(classified ? 'text-destructive' : '')}>
		{visibilityStatus}
	</CardFooter>
</Card>
