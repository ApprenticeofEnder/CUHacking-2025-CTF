import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
  preview: {
    allowedHosts: ["cuhacking-ctf.xyz"]
  },
  plugins: [sveltekit()]
});
