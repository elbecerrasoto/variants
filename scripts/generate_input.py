#!/usr/bin/env python3

import os
import argparse
import subprocess as sp
from pathlib import Path

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
parser.add_argument(
    "-v", "--verbose", action="store_true", help="Debugging information"
)
args = parser.parse_args()


DATA_DIR = args.data_directory
OUT_DIR = os.getcwd() if args.out_dir is None else args.out_dir
MARK1 = "_R1" if args.mark1 is None else args.mark1
MARK2 = "_R2" if args.mark2 is None else args.mark2
DEBUG = args.verbose

FILE_FORWARDS = f"{OUT_DIR}/forwards.txt"
FILE_REVERSES = f"{OUT_DIR}/reverses.txt"
FILE_NAMES = f"{OUT_DIR}/names.txt"
FILE_INPUT = f"{OUT_DIR}/input.tsv"

if __name__ == "__main__":
    Path(OUT_DIR).mkdir(parents=True, exist_ok=True)

    CMD_FORWARDS = f"fd {MARK1} -e fastq.gz -e fastq.gz -e fq.gz -e fastq \
        {DATA_DIR} > {FILE_FORWARDS}"

    CMD_REVERSES = f"fd {MARK2} -e fastq.gz -e fastq.gz -e fq.gz -e fastq \
        {DATA_DIR} > {FILE_REVERSES}"

    CMD_NAMES = f"fd {MARK1} -e fastq.gz -e fastq.gz -e fq.gz -e fastq -e fq {DATA_DIR} | \
        perl -pe  's/^.*\\/(.*?$)/$1/' | \
        perl -pe 's/{MARK1}//' | \
        perl -pe 's/\\.(fastq|fq)(.gz)?$//' > {FILE_NAMES}"

    CMD_INPUT = f"paste {FILE_NAMES} {FILE_FORWARDS} {FILE_REVERSES} > {FILE_INPUT}"

    CMD_RM = f"rm {FILE_NAMES} {FILE_FORWARDS} {FILE_REVERSES}"

    for cmd in CMD_FORWARDS, CMD_REVERSES, CMD_NAMES, CMD_INPUT, CMD_RM:
        if DEBUG:
            print(cmd)
        sp.run(cmd, check=True, shell=True)
