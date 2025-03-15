.PHONY: all analysis report clean

all:
	make clean
	make analysis
	make report

analysis:
	Rscript scripts/01-download-dataset.R
	Rscript scripts/02-data-clean-transform.R --file_path=data/raw/drug-use-by-age.csv --output_path=data/clean/data-cleaned.csv
	Rscript scripts/03-eda.R --file_path_drug=data/data_cleaned.csv --file_path_age=data/data_cleaned_transformed.csv --output_path=output/eda
	Rscript scripts/04-analysis.R --data=data/data-cleaned.csv --output_prefix=output/results

report:
	quarto render age_prediction_analysis.qmd
	mv age_prediction_analysis.html index.html

clean:
	rm -f output/*
	rm -f data/*
	rm -f index.html
	rm -f *.pdf
