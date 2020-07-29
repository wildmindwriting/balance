<script lang="ts">
  import accounting from 'accounting';
  import { onMount } from 'svelte';
  
  let register = [];

</script>

<h1 class="uppercase font-thin text-5xl tracking-wider text-logo-red">Register</h1>
<table class="table-fixed w-full mb-5">
  <thead>
    <tr class="bg-gray-400">
      <th class="border px-4 py-2">Date</th>
      <th class="border px-4 py-2">Payee</th>
      <th class="border px-4 py-2 w-1/3">Account</th>
      <th class="border px-4 py-2">Amount</th>
      <th class="border px-4 py-2">Balance</th>
      <th class="border px-4 py-2">Notes</th>
    </tr>
  </thead>
  <tbody>
    {#each register as item, i}
      <tr>
        {#if (i === 0) }
            <td class="border px-4 py-2">{ item.date }</td>
            <td class="border px-4 py-2 font-bold">{ item.payee }</td>
        {:else}
          {#if ((item.begin - register.default[i - 1].begin) > 1) }
            <td class="border px-4 py-2">{ item.date }</td>
            <td class="border px-4 py-2 font-bold">{ item.payee }</td>
          {:else}
            <td></td>
            <td></td>
          {/if}
        {/if}
        <td class="border px-4 py-2">{ item.account }</td>
        {#if (accounting.unformat(item.amount) < 0) }
          <td class="border px-4 py-2 text-red-500">{ accounting.formatMoney(item.amount) }</td>
        {:else}
          <td class="border px-4 py-2">{ accounting.formatMoney(item.amount) }</td>
        {/if}
        {#if (accounting.unformat(item.balance) < 0) }
          <td class="border px-4 py-2 text-red-500">{ accounting.formatMoney(item.balance) }</td>
        {:else}
          <td class="border px-4 py-2">{ accounting.formatMoney(item.balance) }</td>
        {/if}
        <td class="border px-4 py-2 italic">{ item.note }</td>
      </tr>
    {/each}
  </tbody>
</table>

<style>
</style>
