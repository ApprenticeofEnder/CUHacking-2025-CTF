<script lang="ts">
	import { goto } from '$app/navigation';
	import { Card, CardContent, CardHeader, CardFooter, CardTitle } from '$lib/components/ui/card';
	import type { Pilot } from '$lib/types';

	let { id, name, callsign, biography, notes, classified }: Pilot = $props();

	const visibilityStatus = $derived(classified ? 'CLASSIFIED' : 'PUBLIC');
</script>

<Card onclick={() => {goto(`/pilots/${id}`)}} class="hover:cursor-pointer">
	<CardHeader>
        <CardTitle>{name}</CardTitle>
		<h3>Callsign: {callsign}</h3>
	</CardHeader>
	<CardContent>
		{visibilityStatus}
	</CardContent>
</Card>
