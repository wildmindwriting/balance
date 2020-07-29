<script lang="ts">
  import config from '../../balance.config.js';
  export let netWorth: number = 0;
  import * as d3 from 'd3';
  import accounting from 'accounting';
  import { onMount } from 'svelte';

  onMount(() => {
    d3.csv('data/csv/exchange-ledger.csv', d => {
      if ((d.account.includes('Revalued') || d.account.includes(config.ASSETS) || d.account.includes(config.LIABILITIES))) {
        netWorth += accounting.unformat(d.quantity);
      }
    });
  });

</script>

{ accounting.formatMoney(netWorth) }

<style>
</style>
