FORWARD_REVERSE_STEM = config["in_tsv"]

REF_DIR = config["ref"]
RESULTS_DIR = config["results"]

def parse_config(config):
    return forwards, reverses, names

rule all:
    input:
        ALL_DIR + "/all.faa.tsv",

rule download_ref:
    input:
        "input_genomes.txt",
    output:
        GENOMES_DIR + "/{sample}/{sample}.zip",
    shell:
        """
        datasets download genome accession {wildcards.sample} --filename {output} --include protein,genome,gff3
        """


rule unzip_genomes:
    input:
        rules.download_genomes.output,
    output:
        fna = REF_DIR + "/{sample}/{sample}.fna",
    shell:
        """
        unzip -o {input} -d {GENOMES_DIR}/{wildcards.genome}

        # Flatten ncbi dir structure
        mv {GENOMES_DIR}/{wildcards.sample}/ncbi_dataset/data/{wildcards.sample}/* \
           {GENOMES_DIR}/{wildcards.sample}

        # Rename fna
        mv {GENOMES_DIR}/{wildcards.genome}/*.fna {output.fna}

        # Remove crust
        rm -r {GENOMES_DIR}/{wildcards.genome}/ncbi_dataset/ \
              {GENOMES_DIR}/{wildcards.genome}/README.md
        """


rule annotate_pfams:
    input:
        rules.unzip_genomes.output.faa,
    output:
        PFAMS_DIR + "/{genome}.pfam.xml",
    threads: ISCAN_THREADS
    shell:
        """
        mkdir -p {PFAMS_DIR}
        interproscan.sh --applications Pfam \
                        --formats XML \
                        --input {input} \
                        --outfile {output} \
                        --cpu {threads} \
                        --disable-precalc
        """


rule annotate_pfams_tsv:
    input:
        rules.annotate_pfams.output,
    output:
        Path(rules.annotate_pfams.output[0]).with_suffix(".tsv"),
    shell:
        """
        interproscan.sh --mode convert \
                        --formats TSV \
                        --input {input} \
                        --outfile {output} \
        """


rule filter_genomes:
    input:
        tsv = rules.annotate_pfams_tsv.output,
        ids = IN_PFAMS,
        faa = rules.unzip_genomes.output.faa,
    output:
        FILTERED_DIR + "/{genome}.filtered.faa",
    shell:
        """
        mkdir -p {FILTERED_DIR}
        scripts/filter --tsv {input.tsv} \
                       --ids {input.ids} \
                       --out {output} \
                             {input.faa}
        """


rule gather_proteins:
    input:
        [f"{FILTERED_DIR}/{genome}.filtered.faa" for genome in GENOMES],
    output:
        ALL_DIR + "/all.redundant.faa",
    shell:
        """
        mkdir -p {ALL_DIR}
        cat {input} > {output}
        """


rule reduce_proteins:
    input:
        rules.gather_proteins.output,
    output:
        ALL_DIR + "/all.faa"
    shell:
        """
        cd-hit -i {input} -o {output}
        """


rule annotate_all:
    input:
        rules.reduce_proteins.output,
    output:
        ALL_DIR + "/all.faa.xml",
    threads: 12
    shell:
        """
        mkdir -p {PFAMS_DIR}
        interproscan.sh --formats XML \
                        --input {input} \
                        --outfile {output} \
                        --cpu {threads} \
                        --disable-precalc
        """


rule annotate_all_tsv:
    input:
        rules.annotate_all.output,
    output:
        Path(rules.annotate_all.output[0]).with_suffix(".tsv"),
    shell:
        """
        interproscan.sh --mode convert \
                        --formats TSV \
                        --input {input} \
                        --outfile {output} \
        """
