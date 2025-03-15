.PHONY: all analysis report clean

all:
	make clean
	make analysis
	make report

analysis:
	Rscript scripts/01-download-dataset.R
	Rscript scripts/02-data-clean-transform.R --file_path=data/raw/drug-use-by-age.csv --output_path=data/clean/data-cleaned.csv
	Rscript scripts/03-eda.R --file_path=data/clean/data-cleaned.csv --output_path=output/eda
	Rscript scripts/04-analysis.R --data=data/clean/data-cleaned.csv --output_path=output/results

report:
	quarto render age_prediction_analysis.qmd
	mv age_prediction_analysis.html index.html

clean:
	rm -rf output/*
	rm -rf data/*
	rm -f index.html
	rm -f *.pdf
