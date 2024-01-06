ENV=variants

.PHONY dry-test:
dry-test:
	mamba run -n $(ENV) snakemake --cores all -np --configfile ./tests/config.yaml

./tests/input.tsv:
	mamba run -n $(ENV) ./scripts/generate_input.py -o ./tests/ -m1 _R1 -m2 _R2 ./tests/data/

.PHONY test:
test: ./tests/input.tsv
	mamba run -n $(ENV) snakemake --use-conda --cores all --configfile tests/config.yaml
	diff -s tests/results/sample1.variants.tsv tests/results/sample2.variants.tsv

.PHONY clean-test:
clean-test:
	rm -rf ./tests/results/
	rm -f ./tests/input.tsv

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
