#!/bin/sh
# Output the various reports from ledger into CSVs for D3
if test -f .configrc ; then
  . ./.configrc
else
  echo "ERROR"
  echo "You do not have a .configrc file"
  echo "Please copy configrc.example to .configrc"
  exit
fi

if ! command -v ledger &> /dev/null
then
  echo "ERROR"
  echo "ledger does not seem to be installed on your system"
  echo "Please install ledger to continue"
  exit
fi

mkdir -p src/json

# Generate Net Worth report
echo "[" > $PWD/src/json/networth-history.json
ledger -f $LEDGER_FILE -J reg ^$ASSETS ^$LIABILITIES -X $ --no-rounding -M --collapse --plot-total-format="  { \"date\": \"%(format_date(date, \"%Y-%m-%d\"))\", \"amount\": \"%(abs(quantity(display_total)))\" },\n" >> $PWD/src/json/networth-history.json
sed -i '$ s/.$//' $PWD/src/json/networth-history.json
echo "]" >> $PWD/src/json/networth-history.json

# echo "ledger -f $LEDGER_FILE --monthly --collapse -X $ bal $ASSETS $LIABILITIES -J"
# Generate account balances
echo "[" > $PWD/src/json/balances.json
ledger -f $LEDGER_FILE bal ^$ASSETS ^$LIABILITIES -X $ --no-total --balance-format "  { \"account\": \"%A\", \"partial_account\": \"%(partial_account)\", \"amount\": \"%T\", \"depth\": %(depth) },\n" >> $PWD/src/json/balances.json
sed -i '$ s/.$//' $PWD/src/json/balances.json
echo "]" >> $PWD/src/json/balances.json

echo "[" > $PWD/src/json/register.json
ledger -f $LEDGER_FILE reg -E -X $ --no-revalued --format="  { \"begin\": \"%b\", \"end\": \"%e\", \"payee\": \"%P\", \"date\": \"%D\", \"formatted_date\": \"%(format_date(date, \"%Y-%m-%d\"))\", \"account\": \"%A\", \"amount\": \"%t\", \"balance\": \"%T\", \"state\": %(quoted(cleared ? \"*\" : (pending ? \"!\" : \"\"))), \"note\": %(quoted(join(note | xact.note))) },\n" >> $PWD/src/json/register.json
sed -i '$ s/.$//' $PWD/src/json/register.json
echo "]" >> $PWD/src/json/register.json


