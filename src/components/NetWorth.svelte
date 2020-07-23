<script lang="ts">
  export let netWorth: number = 0;
  import accounting from 'accounting';
  import { onMount } from 'svelte';
  
  import * as nwHistory from '../json/networth-history.json';

  $: {
    nwHistory.default.sort((a, b) => {
      return new Date(a.date) - new Date(b.date);
    });

    console.log(nwHistory.default);

    nwHistory.default.forEach(item => {
      netWorth = item.amount;
    });
  }

</script>

{ accounting.formatMoney(netWorth) }

<style>
</style>
