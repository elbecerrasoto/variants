ENV=variants

.PHONY dry-test:
dry-test: tests/input.tsv
	mamba run -n $(ENV) snakemake --cores all -np --configfile tests/config.yaml

.PHONY test:
test: tests/input.tsv
	rm -rf tests/results
	mamba run -n $(ENV) snakemake --use-conda --cores all --configfile tests/config.yaml
	diff -s tests/results/sampleA.varscan.tsv tests/results/sampleB.varscan.tsv

tests/input.tsv:
	mamba run -n $(ENV) scripts/generate_input.py -o tests/ -m1 _R1 -m2 _R2 tests/data/

.PHONY clean:
clean:
	rm -rf tests/results/
	rm -f tests/input.tsv
	rm -rf .snakemake/

.PHONY style:
style:
	mamba run -n $(ENV) snakefmt . # buggy {{name}} -> {name}
	sed -i 's/{name}/{{name}}/' workflow/Snakefile # hack
	mamba run -n $(ENV) black .

.PHONY env:
env:
	mamba env create

.PHONY rm-env:
rm-env:
	mamba env remove --name $(ENV)
