
# Variants

Variant Calling _snakemake pipeline_ used at DeMoraes Lab.

It downloads a reference genome (default _BL12 e. coli_),
and uses bowtie2, samtools and varscan to call variants.

## Quick Usage

###  Style 1: using config/config.yaml

``` sh
snakemake --cores all --use-conda
```

### Style 2: command line arguments

``` sh
snakemake --cores all --use-conda --config reference_id=GCF_000699465.1\
                                                  names=20231011_variants/samples.txt\
                                                forwards=20231011_variants/forwards.txt\
                                                reverses=20231011_variants/reverses.txt
```

## Inputs
The inputs are 3 text files:
1. Forward reads paths, 1 per line
2. Reverse reads paths, 1 per line
3. Names of the samples, 1 per line

## Outputs
The main output is a tsv of the variants.


## Prerequisites

+ An _Anaconda Distribution_
  + I recommended using _miniforge_
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


## Usage

The pipeline uses the snakemake conventions,
so you can edit the config file at `config/config.yaml`,
and then run ~snakemake --cores all --use-conda~


## Issues

bowtie2 uses ~libcrypt.so.1~
you can install it on _manjaro_ like this: `sudo pacman -S core/libxcrypt-compat`
~
