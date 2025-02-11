<script lang="ts">
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
</script>

<div class="flex flex-col gap-4">
	<h1>{data.flag}</h1>

	<p>If you're reading this, congrats, you're not the first one here!</p>

	<p>
		I have no idea how I snuck this past IPS-N's CI/CD pipeline, but it's not like the jarheads give
		much of a crap about security.
	</p>

	<p>
		Here's the sitch: Corp has been planning a new AI slop feature for months. Even got a testbed
		for it. I've been able to find a way to get past it and into the server itself, but I can't
		actually make any backdoors lest I get caught.
	</p>

	<p>Here's the code for the endpoint, they're using SvelteKit under the hood:</p>
	<pre class="entry">
        //src/routes/api/noah/+server.ts
        
    </pre>
</div>
