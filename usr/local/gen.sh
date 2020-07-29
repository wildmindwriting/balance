#!/bin/sh
# Output the various reports from ledger into CSVs for D3
if ! test -f balance.config.js ; then
  echo "ERROR"
  echo "You do not have a .env file"
  echo "Please copy env.example to .configrc"
  exit
fi

if ! command -v ledger &> /dev/null
then
  echo "ERROR"
  echo "ledger does not seem to be installed on your system"
  echo "Please install ledger to continue"
  exit
fi

mkdir -p public/data/csv
mkdir -p public/data/json

ASSETS="$(sed -n 's/\s*\"ASSETS\": \"\(.*\)\",/\1/gp' balance.config.js)"
EXCHANGE_COMMODITY="$(sed -n 's/\s*\"EXCHANGE_COMMODITY\": \"\(.*\)\",/\1/gp' balance.config.js)"
LEDGER_FILE="$(sed -n 's/\s*\"LEDGER_FILE\": \"\(.*\)\"/\1/gp' balance.config.js)"
LIABILITIES="$(sed -n 's/\s*\"LIABILITIES\": \"\(.*\)\",/\1/gp' balance.config.js)"

# Straight up register, no commodity conversion
echo "date,code,payee,account,commodity,quantity,status,note" > $PWD/public/data/csv/ledger.csv
ledger -f $LEDGER_FILE csv --sort date >> $PWD/public/data/csv/ledger.csv

# Straight up register, commodity conversion
echo "date,code,payee,account,commodity,quantity,status,note" > $PWD/public/data/csv/exchange-ledger.csv
ledger -f $LEDGER_FILE csv --sort date -X $EXCHANGE_COMMODITY >> $PWD/public/data/csv/exchange-ledger.csv

# Net worth report
echo "[" > $PWD/public/data/json/networth-history.json
ledger -f $LEDGER_FILE -J reg ^$ASSETS ^$LIABILITIES -X $EXCHANGE_COMMODITY --no-rounding -M --collapse --plot-total-format="{ \"date\": \"%(format_date(date, \"%Y-%m-%d\"))\", \"amount\": \"%(abs(quantity(display_total)))\" }," >> $PWD/public/data/json/networth-history.json
sed -i 's/,$//' $PWD/public/data/json/networth-history.json
echo "]" >> $PWD/public/data/json/networth-history.json
