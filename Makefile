ENV=bl12


.PHONY run:
run:
	mamba run -n $(ENV) snakemake --cores all

.PHONY format:
format:
	mamba run -n $(ENV) snakefmt workflow

