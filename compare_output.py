from collections import defaultdict
from operator import itemgetter
import csv
import sys
import argparse


def main():

    pkeys = sys.argv[4:]#['Position', 'Ref_Base', 'Var_Base']
    pkeygetter = itemgetter(*pkeys)
    with open(sys.argv[1]) as f1, open(sys.argv[2]) as f2:
        reader1 = csv.DictReader(f1, delimiter='\t')
        reader2 = csv.DictReader(f2, delimiter='\t')
        h1, h2 = set(reader1.fieldnames), set(reader2.fieldnames)

        # headers in common
        incommon = h1 & h2
        print 'incommon:', incommon
        # in h1 but not h2
        print 'new:', h1 - h2
        print 'old:', h2 - h1
        comparekeys = incommon - set(pkeys)
        d1 = {pkeygetter(row): {k: row[k] for k in comparekeys} for row in reader1}
        d2 = {pkeygetter(row): {k: row[k] for k in comparekeys} for row in reader2}

    headers = list(pkeys) + list(comparekeys)

    writer = csv.DictWriter(open(sys.argv[3], 'w'), headers, delimiter='\t')
    writer.writeheader()
    for key in sorted(set(d1.keys()) | set(d2.keys())):
        from1, from2 = d1.get(key, {}), d2.get(key, {})
        if from1 == from2:
            continue

        row = {k: v for k, v in zip(pkeys, key)}
        for k in comparekeys:
            f1, f2 = from1.get(k), from2.get(k)
            if f1 != f2:
                row[k] = ('%s <-> %s' % (f1, f2))

        writer.writerow(row)

main()
