<script lang="ts">
  import TailwindCSS from './components/TailwindCSS.svelte';
  import Header from './components/Header.svelte';
  import NetWorth from './components/NetWorth.svelte';
  import Register from './components/Register.svelte';

  let activeSegment: string;
</script>

<TailwindCSS />
<Header bind:segment={activeSegment} />

<main class="container mx-auto px-4">

  {#if (activeSegment === 'dashboard') }
    <h1 class="uppercase font-thin text-5xl tracking-wider text-logo-red">Balance</h1>
    <p><em>Balance</em> is a front-end for viewing your <a href="https://ledger-cli.org">ledger</a> files.</p>
    <NetWorth />
  {/if}

  {#if (activeSegment === 'register') }
    <Register />
  {/if}

</main>

<style>

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>
