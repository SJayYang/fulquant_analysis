#!/usr/bin/env python3
# filename: aaa.py
# python3

import os
import sys
import gzip

gtf_file = sys.argv[1]

d = {}
with open(gtf_file, 'rt') as r:
    for line in r:
        if line.startswith('#'):
            continue
        fields = line.strip().split('\t')
        if not fields[2] == 'transcript':
            continue
        gene = tx = ''
        for spec in fields[8].split(';'):
            if spec.startswith('gene_id'):
                gene = spec.replace('gene_id ', '')
            elif spec.startswith('transcript_id'):
                tx = spec.replace('transcript_id ', '')
            else:
                continue
        d[gene] = d.get(gene, 0) + 1

for k, v in d.items():
   print(k, v)
