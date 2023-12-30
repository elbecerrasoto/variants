#!/usr/bin/env python3

import os
import argparse
import subprocess as sp

DESCRIPTION = """
    Generate input files for a variant calling Snakemake pipeline
"""

parser = argparse.ArgumentParser(
    description=DESCRIPTION, formatter_class=argparse.RawDescriptionHelpFormatter
)
parser.add_argument("data_directory", help="Directory of fastq files")
parser.add_argument("-o", "--out-dir", help="Where to generate input files")
parser.add_argument("-m1", "--mark1", help="Which string use to parse forward reads")
parser.add_argument("-m2", "--mark2", help="Which string use to parse reverse reads")
args = parser.parse_args()


DATA_DIR = args.data_directory
OUT_DIR = os.getcwd() if args.out_dir is None else args.out_dir
MARK1 = "_R1" if args.mark1 is None else args.mark1
MARK2 = "_R2" if args.mark2 is None else args.mark2

FILE_FORWARDS = f"{OUT_DIR}/forwards.txt"
FILE_REVERSES = f"{OUT_DIR}/reverses.txt"
FILE_NAMES = f"{OUT_DIR}/names.txt"

if __name__ == "__main__":
    CMD_FORWARDS = f"fd {MARK1} -e fastq.gz -e fastq.gz -e fq.gz -e fastq \
        {DATA_DIR} > {FILE_FORWARDS}"

    CMD_REVERSES = f"fd {MARK2} -e fastq.gz -e fastq.gz -e fq.gz -e fastq \
        {DATA_DIR} > {FILE_REVERSES}"

    CMD_NAMES = f"fd {MARK1} -e fastq.gz -e fastq.gz -e fq.gz -e fastq -e fq {DATA_DIR} | \
        perl -pe  's/^.*\/(.*?$)/$1/' | \
        perl -pe 's/{MARK1}//' | \
        perl -pe 's/\.(fastq|fq)(.gz)?$//' > {FILE_NAMES}"

    for cmd in CMD_FORWARDS, CMD_REVERSES, CMD_NAMES:
        print(cmd)
        sp.run(cmd, check=True, shell=True)
