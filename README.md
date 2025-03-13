# Predicting Age from Drug Use Patterns: A Statistical Analysis

**Contributors**: Jade Chen, Jessica Luo, Heidi Lantz, Nazia Edroos

### Table of Contents
- [Summary of our project](#summary)
- [How to run our data analysis](#how-to-run)
- [Dependencies](#dependencies)
- [Licenses](#licenses)

## Summary:

Our dataset, obtained from [FiveThirtyEight](https://fivethirtyeight.com/features/college-students-arent-the-only-ones-abusing-adderall/), 
contains the results of a nationwide survey that collected information about drug use and health. 

We use this data to predict an individual's age group as Youth (Under 21) or Adult (21 & Over) based on their history of reported substance use.

## How To Run:

Use the following steps to reproduce the analysis in a containerized environment:

1. **From your terminal, use the following bash command to clone this repo and set it as your local working directory**

```bash
git clone https://github.com/DSCI-310-2025/dsci-310-group-7-data-dudes.git
```

```bash
cd dsci-310-group-7-data-dudes/
```

2. **Download and install Docker (if you have not already), and open the Docker application.**

- [Install Docker on Windows](https://docs.docker.com/docker-for-windows/install/)
- [Install Docker on macOS](https://docs.docker.com/docker-for-mac/install/)
- [Install Docker on Linux](https://docs.docker.com/engine/install/)

3. **Within your local computer, set up the environment using Docker image:**

- Windows users, run the following:

```bash
docker build -t data-dudes-analysis .
```

```bash
docker run -it --rm -p 8787:8787 -v /$(pwd):/home/rstudio data-dudes-analysis
```
- Mac users, run the following:

```bash
docker build --platform=linux/amd64 -t data-dudes-analysis .
```

```bash
docker run --platform=linux/amd64 -it --rm -p 8787:8787 -v /$(pwd):/home/rstudio data-dudes-analysis
```

4. **Access the analysis**

- Open a browser and go to http://localhost:8787
    - Username: **rstudio**
    - Password: from output of the previous `docker run` command
- open the file `age_predicition_analysis.qmd` in the bottom right panel
- Click the "Run" button in the top left of the RStudio panel to start running the analysis

5. **Run the analysis script**
- Click the "Render" button in the top left of the RStudio panel to render the Quarto file detailing our analysis

6. **View the results by opening the newly created age_prediction_analysis.html**


## Dependencies

**System Dependencies:**

- Docker
- Git (for cloning the repository)

**R Dependencies:**

- tidyverse
- tidymodels
- readr
- ggplot2
- dplyr
- broom
- rmarkdown

**Makefile Dependencies:**

- GNU Make
  - **macOS**: Comes pre-installed
  - **Linux**: Install via sudo apt install make
  - **Windows**: Use Git Bash or install Make for Windows


## Licenses

These are the licences contained in this repository:

- For code objects: [MIT License](LICENSE-MIT)
- For non-code objects: [Creative Commons](LICENSE-CC)

![GitHub license](https://img.shields.io/github/license/DSCI-310-2025/dsci-310-group-7-data-dudes) 
