# Predicting Age from Drug Use Patterns: A Statistical Analysis

**Contributors**: Jade Chen, Jessica Luo, Heidi Lantz, Nazia Edroos

### Table of Contents
- [Summary of Project](#summary)
- [How to Run the Analysis](#how-to-run)
- [Dependencies](#dependencies)
- [Licenses](#licenses)

## Summary:

Our dataset, obtained from [FiveThirtyEight](https://fivethirtyeight.com/features/college-students-arent-the-only-ones-abusing-adderall/), 
contains the results of a nationwide survey that collected information about drug use and health.

We use this data to predict an individual's age group as Youth (Under 21) or Adult (21 & Over) based on their history of reported substance use.

We created and ran three different models using a train/test split on our data. All three models were unable to completely correctly classify youth vs. adult due to some limitations with our dataset, mostly a limited sample size and imbalance in how data was categorized.

## How to Run the Analysis:

Use the following steps to reproduce the analysis in a containerized environment:

1. **In terminal, use the following bash command to clone this repository from GitHub to your local machine.**

    ```bash
    git clone https://github.com/DSCI-310-2025/dsci-310-group-7-data-dudes.git
    ```
2. **Set it this newly cloned repository as your local working directory.**

    ```bash
    cd dsci-310-group-7-data-dudes/
    ```

3. **Open the Docker application.**
    
    1. Download and install Docker:
        - [Install Docker on Windows](https://docs.docker.com/docker-for-windows/install/)
        - [Install Docker on macOS](https://docs.docker.com/docker-for-mac/install/)
        - [Install Docker on Linux](https://docs.docker.com/engine/install/)
    2. Open the Docker app by clicking on its icon (from Finder, Applications or Launchpad).
    3. To test if Docker is working, type the following in the terminal:
        ```bash
       docker run hello-world
        ```
        You should see something like this if you were successful:
        ```bash
        Unable to find image 'hello-world:latest' locally
        latest: Pulling from library/hello-world
        1b930d010525: Pull complete
        Digest: sha256:451ce787d12369c5df2a32c85e5a03d52cbcef6eb3586dd03075f3034f10adcd
        Status: Downloaded newer image for hello-world:latest

        Hello from Docker!
        This message shows that your installation appears to be working correctly.

        To generate this message, Docker took the following steps:
        1. The Docker client contacted the Docker daemon.
        2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
            (amd64)
        3. The Docker daemon created a new container from that image which runs the
            executable that produces the output you are currently reading.
        4. The Docker daemon streamed that output to the Docker client, which sent it
            to your terminal.

        To try something more ambitious, you can run an Ubuntu container with:
        $ docker run -it ubuntu bash

        Share images, automate workflows, and more with a free Docker ID:
        https://hub.docker.com/

        For more examples and ideas, visit:
        https://docs.docker.com/get-started/
        ```

4. **Within your local computer, set up the environment using Docker image:**

    - Windows users, run the following:

        ```bash
        docker build -t data-dudes-analysis .
        ```

        ```bash
        docker run -it --rm -p 8787:8787 -e PASSWORD="sushi" data-dudes-analysis
        ```

    - Mac users, run the following:

        ```bash
        docker build --platform=linux/amd64 -t data-dudes-analysis .
        ```

        ```bash
        docker run --platform=linux/amd64 -it --rm -p 8787:8787 -e PASSWORD="sushi" data-dudes-analysis
        ```

5. **Access the analysis**

    - Open a browser and go to http://localhost:8787.
        - Username: **rstudio**
        - Password: **sushi**
    - Navigate to the file `project` folder in the bottom right panel to view all files.

6. **Run the analysis script**
    - In the terminal, type `make all`
        - Cleans any older renders of our analyss file, cleans data/ and output/ directories
        - Runs the analysis scripts
        - Renders the Quarto document

7. **View the results by**
    - In the terminal, type `make view`; this will open the rendered Quarto document in your browser.


## Dependencies

**System Dependencies**

- Docker
- Git (for cloning the repository)
- GNU Make
  - **macOS**: Comes pre-installed
  - **Linux**: Install via sudo apt install make
  - **Windows**: Use Git Bash or install Make for Windows

**R Dependencies**

- `tidyverse`# TO DO - add version
- `tidymodels`# TO DO - add version
- `readr`# TO DO - add version
- `ggplot2`# TO DO - add version
- `dplyr`# TO DO - add version
- `broom`# TO DO - add version
- `rmarkdown`# TO DO - add version
  - **Windows**: Use Git Bash or install Make for Windows


## Licenses

These are the licences contained in this repository:

- For code objects: [MIT License](LICENSE-MIT)
- For non-code objects: [Creative Commons](LICENSE-CC)

![GitHub license](https://img.shields.io/github/license/DSCI-310-2025/dsci-310-group-7-data-dudes) 
