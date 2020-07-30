#!/usr/bin/python

# Run this with `ledger python gen.py`

import os
import sys
import ledger

from pprint import pprint

from dotenv import load_dotenv
load_dotenv()

from datetime import date

# https://github.com/Rudd-O/ledgerhelpers/blob/60e9efe24963fe6691d73de4204396dd883b1f29/src/ledgerhelpers/journal.py#L319
def main(argv):
    today = date.today()

    assets = os.getenv("ASSETS")
    equity = os.getenv("EQUITY")
    exchange_commodity = os.getenv("EXCHANGE_COMMODITY")
    expenses = os.getenv("EXPENSES")
    ledger_file = os.getenv("LEDGER_FILE")
    liabilities = os.getenv("LIABILITIES")

    journal = ledger.read_journal(ledger_file)

    for txn_num, xact in enumerate(journal):
        payee = xact.payee
        posting_date = xact.date
        print(xact.note)

        print(txn_num, posting_date, payee)

        for subpost in xact.posts():
            account = subpost.account
            amount = subpost.amount
            note = ""
            if subpost.note:
                note = subpost.note
            print(account, amount, note)

        print("")

    print("balance")
    for post in journal.query("bal"):
        print(post.xact.payee)
        for sub in post.xact.posts():
            account = sub.account
            amount = sub.amount
            note = ""
            if sub.note:
                note = sub.note
            print(account, amount, note)

        print("")

    ## FAILS
    print("forecast")
    for post in journal.query("--forecast 'T>{-500.00 USD}' register Assets Liabilities -X USD"):
        # print(dir(post.xact))
        # print(type(post).__name__)
        account = ""
        amount = ""
        note = ""
        payee = ""
        posting_date = post.aux_date
        state = post.state

        if (type(post).__name__ == 'JournalItem'):
            print('JOURNALITEM')
            # print(post.__getattribute__('payee'))
        else:
            account = post.account
            amount = post.amount
            if post.note:
                note = post.note

        print(posting_date, payee, account, amount, state, note)
        print("")


    # networth_history = journal.query('csv reg ^' + assets + ' ^' + liabilities + ' -X ' + exchange_commodity + ' --no-rounding -M --collapse')
    # networth_history = journal.query('csv')
    # print(networth_history)
    # networth_history = journal.query('')
    # for item in networth_history:
        # print(item)
        # pprint(dir(item))
        # print("======================================================")
        # pprint(vars(item))
        # print('Account: %s' % item.account)
        # print('Amount: %s' % item.amount)
        # print('Note: %s' % item.note)
        # print('Date:')
        # print(item.date)
        # print('')


if __name__ == "__main__":
    main(sys.argv[1:])
