# see https://rocker-project.org/images/versioned/rstudio.html

FROM rocker/verse:4.4.3

RUN Rscript -e "install.packages('renv', repos = 'https://cloud.r-project.org')"

COPY . /home/rstudio/project

WORKDIR /home/rstudio/project

RUN chown -R rstudio:rstudio /home/rstudio/project

EXPOSE 8787

RUN Rscript -e "if (file.exists('renv.lock')) renv::restore(prompt = FALSE) else print('No renv.lock found, skipping restore.')"