<script lang="ts">
  import * as d3 from 'd3';
  import accounting from 'accounting';
  import moment from 'moment';
  import { onMount } from 'svelte';
  import netWorthHistory from '../../../public/data/json/networth-history.json';
  console.log(netWorthHistory);

  netWorthHistory.forEach(item => {
    item.date = moment(item.date);
  });
  netWorthHistory.sort((a, b) => {
    return new Date(b.date) - new Date(a.date);
  });

  const margin = {
    top: 100,
    right: 100,
    bottom: 100,
    left: 100
  };

  const container = document.querySelector('body');
  const width = container.offsetWidth - margin.left - margin.right;
  const height = 500 - margin.top - margin.bottom;
  const minAmount = parseFloat(d3.min(netWorthHistory, d => d.amount)) - 10000;
  const maxAmount = parseFloat(d3.max(netWorthHistory, d => d.amount)) + 10000;
  const minDate = d3.min(netWorthHistory, d => new Date(d.date));
  // minDate.setDate(minDate.getDate() - 30);
  const maxDate = d3.max(netWorthHistory, d => new Date(d.date));
  // maxDate.setDate(maxDate.getDate() + 30);

  const xScale = d3.scaleTime()
    .domain([minDate, maxDate])
    .range([0, width]);

  const yScale = d3.scaleLinear()
    .domain([minAmount, maxAmount])
    .range([height, 0]);

  const line = d3.line()
    .x(d => xScale(d.date))
    .y(d => yScale(d.amount))
    .curve(d3.curveMonotoneX);

  const svg = d3.select('body').append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g')
    .attr('transform', `translate(${margin.left}, ${margin.top})`);

  svg.append('g')
    .attr('class', 'x axis')
    .attr('transform', `translate(0, ${height})`)
    .call(d3.axisBottom(xScale));

  svg.append('g')
    .attr('class', 'y axis')
    .call(d3.axisLeft(yScale).tickFormat(d3.format('$,.0f')));

  svg.append('path')
    .datum(netWorthHistory)
    .attr('class', 'line')
    .attr('fill', 'none')
    .attr('stroke', 'steelblue')
    .attr('stroke-width', 1.5)
    .attr('d', line);

    svg.selectAll('.dot')
      .data(netWorthHistory)
      .enter()
      .append('circle')
      .attr('class', 'dot')
      .attr('cx', d => xScale(d.date))
      .attr('cy', d => yScale(d.amount))
      .attr('r', 5)
      .on('mouseover', e => {
        const nw = document.querySelector('#networth-tooltip');
        const line1 = `<strong class="font-bold">${moment(e.date).format('MMMM YYYY')}</strong>`;
        const line2 = `${accounting.formatMoney(e.amount)}`;

        let classes = ['border', 'px-4', 'py-3', 'rounded'];
        if (accounting.unformat(e.amount) < 0) {
          classes.push('bg-red-100');
          classes.push('border-red-400');
          classes.push('text-red-700');
        } else {
          classes.push('bg-green-100');
          classes.push('border-green-400');
          classes.push('text-green-700');
        }
        nw.classList.add(...classes);

        nw.innerHTML = `${line1}<br />${line2}`;
        d3.select('#networth-tooltip').transition().duration(200).style('opacity', 1);
      })
      .on('mouseout', e => {
        d3.select('#networth-tooltip').style('opacity', 0);
      })
      .on('mousemove', e => {
        d3.select('#networth-tooltip')
          .style('left', `${d3.event.pageX}px`)
          .style('top', `${d3.event.pageY}px`);
      });

  d3.select('body')
    .append('div')
    .attr('id', 'networth-tooltip')
    .attr('class', 'bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded')
    .attr('style', 'position: absolute; opacity: 0;');

</script>

<style>
</style>
