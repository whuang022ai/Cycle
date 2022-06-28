#!/bin/bash

sra_ids="SRR650259 SRR650290 SRR651263 SRR651328 SRR651357 "

for sra_id in ${sra_ids}; do
    fastq-dump ${sra_id} -T
done
