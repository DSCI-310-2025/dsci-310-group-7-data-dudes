.PHONY: all analysis

all:
	make clean
	make analysis

analysis:
	Rscript scripts/01-download-dataset.R
	Rscript scripts/02-data-clean-transform.R
	Rscript scripts/03-eda.R
	Rscript scripts/04-analysis.R

clean:
	rm -f output/*
	rm -f data/*
	rm -f index.html
	rm -f *.pdf
