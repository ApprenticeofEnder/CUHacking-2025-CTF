<script lang="ts">
	import { Navbar } from '$lib/components/navbar';
	import '../app.css';
	let { children } = $props();
</script>

<div class="flex justify-center">
	<div class="flex h-full w-full max-w-screen-lg flex-col gap-4 overflow-x-clip">
		<Navbar></Navbar>
		<div class="container">
			{@render children()}
		</div>
	</div>
</div>
