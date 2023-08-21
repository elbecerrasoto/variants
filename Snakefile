FORWARD = "forward.fastq.gz"
REVERSE = "reverse.fastq.gz"
REFERENCE = "GCA_013166975.1" # BL12 e. coli


RESULTS_DIR = "results"
RESULTS_DIR_OTHER = "results/other"
REFERENCE_DIR = "reference"


# sample_name, forward, reverse,
rule all:
    input:
        f"{REFERENCE_DIR}/{REFERENCE}.fna"


rule download_ref:
    output:
        f"{REFERENCE_DIR}/{REFERENCE}.zip",
    shell:
        """
        datasets download genome accession {REFERENCE} --filename {output} --include genome
        """


rule unzip_genomes:
    input:
        rules.download_ref.output,
    output:
        f"{REFERENCE_DIR}/{REFERENCE}.fna",
    shell:
        """
        unzip -o {input} -d {REFERENCE_DIR}

        # Flatten ncbi dir structure
        mv {REFERENCE_DIR}/ncbi_dataset/data/{REFERENCE}/* \
           {REFERENCE_DIR}

        # Rename fna
        mv {REFERENCE_DIR}/*.fna {output}

        # Remove crust
        rm -r {REFERENCE_DIR}/ncbi_dataset/ \
              {REFERENCE_DIR}/README.md
        """

