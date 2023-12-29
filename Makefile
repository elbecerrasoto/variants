ENV=variants

.PHONY dry-test:
dry-test:
	mamba run -n $(ENV) snakemake --cores all -np --configfile config/test1.yaml

.PHONY test:
test:
	mamba run -n $(ENV) snakemake --use-conda --cores all --configfile config/test1.yaml
	diff -s results_test/test1/sample1.variants.tsv results_test/test1/sample2.variants.tsv

.PHONY clean:
clean:
	rm -r results_test

.PHONY style:
style:
	mamba run -n $(ENV) snakefmt workflow/

.PHONY env:
env:
	mamba env create

.PHONY rm-env:
rm-env:
	mamba env remove --name $(ENV)
