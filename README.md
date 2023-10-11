
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
snakemake --cores all --use-conda --config names=tests/input_names.txt forwards=tests/input_forwards.txt reverses=tests/input_reverses.txt
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
and be good to go.



