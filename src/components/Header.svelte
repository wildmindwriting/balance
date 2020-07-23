<script lang="ts">
  export let segment: string = 'dashboard';
  const select = val => () => segment = val;
</script>

<nav class="flex items-center justify-between flex-wrap p-6">
  <div class="flex items-center flex-shrink-0 text-logo-red mr-6">
    <span class="uppercase font-thin text-3xl tracking-wider">Balance</span>
  </div>
  <div class="w-full block flex-grow lg:flex lg:items-center lg:w-auto">
    <div class="text-sm lg:flex-grow">
      <a on:click={select('dashboard')} class:underline="{segment === 'dashboard'}" class="block mt-4 lg:inline-block lg:mt-0 hover:text-red-400 mr-4">
        Dashboard
      </a>
      <a on:click={select('register')} class:underline="{segment === 'register'}" class="block mt-4 lg:inline-block lg:mt-0 hover:text-red-400 mr-4">
        Register
      </a>
      <a on:click={select('forecast')} class:underline="{segment === 'forecast'}" class="block mt-4 lg:inline-block lg:mt-0 hover:text-red-400 mr-4">
        Forecast
      </a>
    </div>
    <div>
      <a href="#" class="inline-block text-sm px-4 py-2 leading-none border rounded text-red border-white hover:border-transparent hover:text-red-500 mt-4 lg:mt-0">What is this?</a>
    </div>
  </div>
</nav>

<style>
  a {
    cursor: pointer;
  }
</style>
