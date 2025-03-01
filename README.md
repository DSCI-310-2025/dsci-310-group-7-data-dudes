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

- Windows users, run the following:
```
docker build -t data-dudes-analysis .
```
```
docker run -it --rm -p 8787:8787 -v /$(pwd):/home/rstudio data-dudes-analysis
```
- Mac users, run the following:
```
docker build --platform=linux/amd64 -t data-dudes-analysis .
```
```
docker run --platform=linux/amd64 -it --rm -p 8787:8787 -v /$(pwd):/home/rstudio data-dudes-analysis
```

**4. Access the analysis**

- Open a browser and go to http://localhost:8787
    - Username: **rstudio**
    - Password: from output of the previous `docker run` command
- open the file `age_predicition_analysis.qmd` in the bottom right panel
- Click the "Run" button in the top left of the RStudio panel to start running the analysis

**5. Run the analysis script**
- Inside RStudio, go to the terminal or the script pane and run the following command to start the analysis:
```
rmarkdown::render("age_prediction_analysis.qmd")
```

**6. View the results by opening the newly created age_prediction_analysis.html**


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
