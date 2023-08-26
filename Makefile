ENV=bl12

.PHONY dry:
dry:
	mamba run -n $(ENV) snakemake --cores all -np

.PHONY run:
run:
	mamba run -n $(ENV) snakemake --cores all

.PHONY format:
format:
	mamba run -n $(ENV) snakefmt workflow/

