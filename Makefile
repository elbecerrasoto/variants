ENV=bl12

.PHONY dry-run:
dry-run:
	snakemake --cores all -np

.PHONY run:
run:
	snakemake --use-conda --cores all

.PHONY dev-run:
dev-run:
	snakemake --use-conda --cores all --rerun-triggers mtime

.PHONY format:
format:
	mamba run -n $(ENV) snakefmt workflow/

.PHONY env:
env:
	mamba env create
