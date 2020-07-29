#!/usr/bin/python

# Run this with `ledger python gen.py`

import os
import sys
import ledger

from pprint import pprint

from dotenv import load_dotenv
load_dotenv()

from datetime import date

def main(argv):
    today = date.today()
    ledger_file = os.getenv("LEDGER_FILE")
    assets = os.getenv("ASSETS")
    liabilities = os.getenv("LIABILITIES")
    journal = ledger.read_journal(ledger_file)
    networth_history = journal.query('')
    # networth_history = journal.query('')
    for item in networth_history:
        # pprint(dir(item))
        # print("======================================================")
        # pprint(vars(item))
        print('Date: %s' % item.date)
        print('Account: %s' % item.account)
        print('Amount: %s' % item.amount)
        print('Note: %s' % item.note)
        print('')


if __name__ == "__main__":
    main(sys.argv[1:])
