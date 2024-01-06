ENV=variants

.PHONY dry-test:
dry-test:
	mamba run -n $(ENV) snakemake --cores all -np --configfile tests/config.yaml

./tests/input.tsv:
	mamba run -n $(ENV) scripts/generate_input.py -o tests/ -m1 _R1 -m2 _R2 tests/data/

.PHONY test:
test: tests/input.tsv
	mamba run -n $(ENV) snakemake --use-conda --cores all --configfile tests/config.yaml
	diff -s tests/results/sampleA.variants.tsv tests/results/sampleB.variants.tsv

.PHONY clean:
clean:
	rm -rf tests/results/
	rm -f tests/input.tsv
	rm -rf .snakemake/

.PHONY style:
style:
	mamba run -n $(ENV) snakefmt .
	mamba run -n $(ENV) black .

.PHONY env:
env:
	mamba env create

.PHONY rm-env:
rm-env:
	mamba env remove --name $(ENV)
