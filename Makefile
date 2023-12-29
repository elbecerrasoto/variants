ENV=variants

.PHONY dry-test:
dry-test:
	snakemake --cores all -np --configfile config/test1.yaml

.PHONY test:
test:
	snakemake --use-conda --cores all --configfile config/test1.yaml

.PHONY clean:
clean:
	rm -r results_test

.PHONY format:
format:
	mamba run -n $(ENV) snakefmt workflow/

.PHONY env:
env:
	mamba env create

.PHONY rm-env:
rm-env:
	mamba env remove --name $(ENV)
