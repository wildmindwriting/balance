import config from '../balance.config.js';
import * as d3 from 'd3';
import accounting from 'accounting';
import App from './App.svelte';

const accounts = [];
const accountData = [];
const commodities = [];
const commodityData = [];
d3.csv('data/csv/ledger.csv', d => {
  // Get all commodities
  if (!commodities.includes(d.commodity) && (d.account.includes('Equity') || d.account.includes('Assets') || d.account.includes('Liabilities'))) {
    commodityData[d.commodity] = {
      balance: accounting.unformat(d.quantity),
      lastTransaction: d.date,
      name: d.commodity
    };
    commodities.push(d.commodity);
  } else if (d.account.includes('Equity') || d.account.includes('Assets') || d.account.includes('Liabilities')) {
    commodityData[d.commodity].balance += accounting.unformat(d.quantity);
    commodityData[d.commodity].lastTransaction = d.date;
  }
  // Get all accounts
  if (!accounts.includes(d.account)) {
    accountData[d.account] = {
      balance: accounting.unformat(d.quantity),
      commodity: d.commodity,
      lastTransaction: d.date,
      name: d.account,
    };
    accounts.push(d.account);
  } else {
    accountData[d.account].balance += accounting.unformat(d.quantity);
    accountData[d.account].lastTransaction = d.date;
  }
});
console.log(commodityData);
console.log(accountData);

const app = new App({
	target: document.body
});

export default app;
