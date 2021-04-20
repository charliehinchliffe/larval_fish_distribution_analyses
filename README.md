# Larval fish seasonality in a changing western boundary current

This repository contains all the data and code used in the manuscript:

* Title: "Modelling the distribution of larval fish in a western
boundary current using a multi-voyage database"
* Authors: Charles Hinchliffe, James A. Smith, Jason D. Everett, Daniel S. Falster, Ana Lara-Lopez,
 Anthony G. Miskiewicz, Anthony J. Richardson, Hayden T. Schilling, Iain M. Suthers
* Year of publication: 2021
* Journal: Reviews in Fish Biology and Fisheries
* doi: https://doi.org/10.1007/s11160-021-09647-x


The main script, `analyses_and_figures.rmd` contains code to reproduce the all but one analysis, and all figures (excluding the site map), from the paper. The other script `manyglm_uni_test.R` contains code for running univariate tests on the larval fish community with SST using a multivariate genralized linear model (MGLM) which were originally run on the University of New South Wales computational cluster 'Katana' supported by Research Technology Services. The output from this is saved in the repository as `outputs/Uni_test_manyglm_output.rds` and can be imported and observed directly whe running `analyses_and_figures.Rmd`.

There are 3 major analyses within the manuscript. The first two involve analysis of the seasonal and latitudinal variation in larval fish abundance and taxa richness using generalised additive mixed-models (GAMMs) and can be found in section 2) and 3) in the main script. The third major analyses involves investigation of the community composition of larval fish across the study area, first in relation to Sea Surface Temperature (SST), followed by Latitude (which appears in the supplementary material of the manuscript), and can be found in section 4) of the script. The figures associated with each analysis are at the end of each section, with there figure number as they appear in the manuscript and figure caption.

## Running the code

All analyses were done in `R`. All data and code needed to reproduce the submitted products is included in this repository. 

The paper was written in 2019-2020 using a version of R available at the time. You can try running it on your current version and it may work. 

To ensure [computational reproducibility](https://www.britishecologicalsociety.org/wp-content/uploads/2017/12/guide-to-reproducible-code.pdf) into the future, we have also generated [Docker](http://dockerhub.com) and [Binder](https://mybinder.org) containers, enabling you to launch a compute environment built off R 3.6.1 with all the dependencies included.

### Running locally

If reproducing these results on your own machine, first download the code and then install the required packages, listed under `Depends` in the `DESCRIPTION` file. This can be achieved by opening the Rstudio project and running:

```{r}
#install.packages("devtools")
devtools::install_deps()
```

### Running on Binder 

You can launch the analysis on the web in an interactive RStudio session with the required software pre-installed. This session is hosted by binder and can be accessed by clicking on the following:

[![Launch Rstudio Binder](http://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/traitecoevo/hinchliffe_larval_fish_distribution/master?urlpath=rstudio)

### Running via Docker

If you have Docker installed, you can recreate the compute environment as follows. 

First fetch the container:

```
docker pull traitecoevo/hinchliffe_larval_fish_distribution
```

Then launch it via:

```
docker run --user root -v $(pwd):/home/rstudio/ -p 8787:8787 -e DISABLE_AUTH=true traitecoevo/hinchliffe_larval_fish_distribution
```

The code above initialises a docker container, which runs an rstudio session, which is accessed by pointing your browser to [localhost:8787](http://localhost:8787). For more instructions on running docker, see the info from [rocker](https://hub.docker.com/r/rocker/rstudio).

Note, this container does not contain the actual github repo, only the software environment. If you run the above command from within your downloaded repo, it will map the working directory as the current working directory inside the docker container.

Also, note you may need to increase the memory accessible to dockerto get all coponnets to run.

### Building the docker images (optional)

For posterity, the docker image was built off [`rocker/verse:3.6.1` container](https://hub.docker.com/r/rocker/verse) via the following command, in a terminal contained within the downloaded repo:

```
docker build -t traitecoevo/hinchliffe_larval_fish_distribution .
```

and was then pushed to dockerhub ([here](https://cloud.docker.com/u/traitecoevo/repository/docker/traitecoevo/hinchliffe_larval_fish_distribution). The image used by binder builds off this container, adding extra features needed bi binder, as described in [rocker/binder](https://hub.docker.com/r/rocker/binder/dockerfile).


Contributors
------------------------
Charlie Hinchliffe
Daniel Falster

