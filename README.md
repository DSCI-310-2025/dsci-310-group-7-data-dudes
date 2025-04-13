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

- We assume you have set up your machine
using the [DSCI 310 Computer Setup Instructions](https://ubc-dsci.github.io/dsci-310-student/computer-setup.html)

### Option 1

1. **In your terminal, use the following bash command to clone this repository from GitHub to your local machine.**

    ```bash
    git clone https://github.com/DSCI-310-2025/dsci-310-group-7-data-dudes.git
    ```
2. **Set this newly cloned repository as your local working directory.**

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

    - **Windows** users, run the following:

        ```bash
        docker build -t data-dudes-analysis .
        ```

        ```bash
        docker run -it --rm -p 8787:8787 -e PASSWORD="sushi" data-dudes-analysis
        ```

    - **Mac** users, run the following:

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
    
    - In the RStudio terminal, type `cd project` to set the correct working directory
    - In the RStudio terminal, type `make all`, which:
        - Cleans any older renders of our analyss file, cleans data/ and output/ directories
        - Runs the analysis scripts
        - Renders the Quarto document

7. **View the results**
    
    - In the Files panel on the bottom right, click the newly created `index.html` file
    - Select **View in Web Browser** to view the results

### Option 2
1. Pull the latest pre-built Docker image from Docker Hub:
    ```bash
    docker pull jadeeechen/dsci-310-group-7-data-dudes:latest
    ```
    - This will pull the container onto your local computer.

2. Use the provided `docker-compose.yaml` file in this repository to start the container:
    - Clone this repository by running the following in your terminal
        ```bash
        git clone https://github.com/DSCI-310-2025/dsci-310-group-7-data-dudes.git
        ```
    - In the directory containing the downloaded/pulled compose file, run `docker-compose up`
        ```bash
        cd dsci-310-group-7-data-dudes
        docker-compose up
        ```
    - Navigate to http://localhost:8787/ in your browser which will open an rstudio window in your browser, no login needed!

3. Create and view the report:
    - Navigate to the rstudio terminal window
    - use the following commands
        ```
        cd project
        make all
        ```
    - This will run all the scripts to clean the data, create EDA figures and tables, and create the model and visualizations
    - It will also create an index.html file in the docs folder to allow you to easily view the full report.

Attribution: [DSCI310 Group 02 instructions](https://github.com/DSCI-310-2025/dsci-310-group-02/blob/main/README.md)


## Dependencies

**System Dependencies**

- Docker
- Git (for cloning the repository)
- GNU Make
  - **macOS**: Comes pre-installed
  - **Linux**: Install via sudo apt install make
  - **Windows**: Use Git Bash or install Make for Windows

**R Dependencies**

- `pkg.drugage`: 1.0.0 (Instructions to install at [DSCI-310-2025/pkg.drugage](https://github.com/DSCI-310-2025/pkg.drugage))
- `docopt`: 0.7.1
- `dplyr`: 1.1.4
- `parsnip`: 1.3.1
- `pointblank`: 0.12.2
- `readr`: 2.1.5
- `recipes`: 1.1.1
- `rsample`: 1.2.1
- `tidyr`: 1.3.1
- `workflows`: 1.2.0

## Licenses

These are the licences contained in this repository:

- For code objects: [MIT License](LICENSE-MIT)
- For non-code objects: [Creative Commons](LICENSE-CC)

![GitHub license](https://img.shields.io/github/license/DSCI-310-2025/dsci-310-group-7-data-dudes) 
