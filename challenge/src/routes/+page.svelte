<script lang="ts">
	import { Button } from '$lib/components/ui/button';
</script>

<main class="w-full">
	<h1 class="text-center">IPS-N Pilot Database</h1>

	<div class="flex justify-center gap-4">
		<Button variant="link" href="/pilots">Pilots</Button>
		<Button variant="link" href="/notices">Notices</Button>
		<Button class="hidden" variant="link" href="/new">Add Data (TODO: Test Data Upload)</Button>
	</div>
</main>
