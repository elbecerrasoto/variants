ENV=variants

.PHONY dry-test:
dry-test:
	mamba run -n $(ENV) snakemake --cores all -np --configfile config/test1.yaml

.PHONY test:
test:
	mamba run -n $(ENV) snakemake --use-conda --cores all --configfile config/test/config.yaml
	# diff -s test/results/sample1.variants.tsv test/results/sample2.variants.tsv

.PHONY clean-test:
clean-test:
	# rm -r test/results/

.PHONY style:
style:
	mamba run -n $(ENV) snakefmt ./
	mamba run -n $(ENV) black ./

.PHONY env:
env:
	mamba env create

.PHONY rm-env:
rm-env:
	mamba env remove --name $(ENV)
