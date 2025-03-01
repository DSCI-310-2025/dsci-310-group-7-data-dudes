# Project Title: Early Substance Use and Hard Drug Behaviors: A Predictive Analysis
Contributors: Jade Chen, Jessica Luo, Heidi Lantz, Nazia Edroos
<br><br>

## Summary:
Our dataset, obtained from [FiveThirtyEight](https://fivethirtyeight.com/features/college-students-arent-the-only-ones-abusing-adderall/), contains the results of a nationwide survey that collected information about drug use and health. We will use this data to categorize an individual's age group as Youth (Under 21) or Adult (21 & Over) based on their history of reported substance use.

## How to run our Data Analysis:
Use the following steps to reproduce the analysis in a containerized environment:

**1. From your terminal, use the following bash command to clone this repo and set it as your local working directory**
```
git clone https://github.com/DSCI-310-2025/dsci-310-group-7-data-dudes.git
```
```
cd dsci-310-group-7-data-dudes
```

**2. Download and install Docker (if you have not already), and open the Docker application.**

- [Install Docker on Windows](https://docs.docker.com/docker-for-windows/install/)
- [Install Docker on macOS](https://docs.docker.com/docker-for-mac/install/)
- [Install Docker on Linux](https://docs.docker.com/engine/install/)

**3. Within your local computer, set up the environment using Docker image:**
```
docker build -t data-dudes-analysis .
```
- Windows users should run:
```
docker run -it --rm -v "$(pwd)":/project data-dudes-analysis
```
- Mac users should run:
```
docker run --platform=linux/amd64 -it --rm -v "$(pwd)":/project data-dudes-analysis
```

**4. Excecute the analysis**
Inside the Docker container, run
```
Rscript scripts/run_analysis.R
```

**5. Access the results in the `output` directory of the project folder**

## Dependencies:

**System Dependencies**

1. Docker
2. Git (for cloning the repository)

**R Dependencies**

- tidyverse
- tidymodels
- readr
- ggplot2
- dplyr
- broom
- rmarkdown

**Makefile Dependencies**
If your analysis uses a Makefile, you also need:

GNU Make

- macOS: Comes pre-installed
- Linux: Install via sudo apt install make
- Windows: Use Git Bash or install Make for Windows


## Licenses contained in LICENSE.md:
- MIT License
