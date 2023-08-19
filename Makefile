.PHONY clean:
clean:
	trash C_S3* H_S5* L_S4* WT-Neg* WT-Old* WT* *.log


input.tsv: 1_reads_forward.txt 2_reads_back.txt out_names.txt
	paste 1_reads_forward.txt 2_reads_back.txt out_names.txt > input.tsv
