
# Variants

**v0.2.0**

## Description

Variant Calling [_snakemake pipeline_](https://snakemake.github.io/) used at DeMoraes Lab.

It downloads a bacterial reference genome,
and uses bowtie2, samtools and varscan to call variants.

## Quick Usage

###  Style 1: using config/config.yaml

Edit config/config.yaml and then run.
``` sh
snakemake --use-conda --cores all
```

### Style 2: command line arguments

Specify configuration directly on the command line.
``` sh
snakemake --cores all --use-conda --config\
    reference_id=GCA_013166975.1\
    input=input.tsv\
    results=results/
```

### Generate report

``` sh
snakemake --report report.zip
```

## Inputs
The input is a tsv file with no headers and the following columns:
1. Sample name
2. Forward reads paths
3. Reverse reads paths

A script is provided to generate this file,
to run it.
``` sh
scripts/generate_input.py --mark1 _R1 --mark2 _R2 tests/data/
```

The generated file can then be manually edited,
for further customization.

## Outputs

The main output is a tsv of the variants,
one file per sample.


## Prerequisites

+ An [_Anaconda Distribution_](https://github.com/conda-forge/miniforge)
  + I recommended using [_miniforge_](https://github.com/conda-forge/miniforge)
  + This _README_ uses _mamba_, but substitute by _conda_ if appropiatly.


## Installation

``` sh
git clone 'https://github.com/elbecerrasoto/variants'
cd variants
```

``` sh
mamba env create
mamba activate variants
```

To test the installation.
``` sh
make test
```

## Usage

The pipeline uses the snakemake conventions,
so you can edit the config file at `config/config.yaml`,
and then run:

+ `snakemake --cores all --use-conda`

## TODO for v0.2.0

- [x] Use "all" for bowtie cores
- [x] Update readme
- [x] Simplify config
- [x] Simplify input files
- [x] Log generation
- [x] Script for suggesting input

## TODO for future releases

- [ ] Workflow catalog standards


## Issues

_bowtie2_ uses `libcrypt.so.1`
you can install it on _manjaro_ like this:

+ `sudo pacman -S core/libxcrypt-compat`

