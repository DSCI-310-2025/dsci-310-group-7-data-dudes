analysis:
	Rscript scripts/01-download-dataset.R
	Rscript scripts/02-data-clean-transform.R
	Rscript scripts/03-eda.R
	Rscript scripts/04-analysis.R

download:
	Rscript 01-download-dataset.R
