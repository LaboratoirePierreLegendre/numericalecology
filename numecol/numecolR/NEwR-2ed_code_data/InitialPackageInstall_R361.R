# ============================================================
# Script for first-time users of "Numerical Ecology with R"  #
# by Daniel Borcard, Francois Gillet and Pierre Legendre     #
# Adapted to R 3.6.1 on 2019-09-21                           #
# ============================================================

# This script installs or provides guidelines to install all
# the packages necessary to run the code provided in the book,
# but that do not belong to the standard R distribution (steps 2-3).

# Steps 1 to 2 must be run only once when installing or upgrading R.
# Step 3 is not mandatory.


# 1. Update installed packages
#    -------------------------
update.packages(checkBuilt = TRUE, ask = FALSE)


# 2. Install packages from the main CRAN site
#    ----------------------------------------

install.packages(
  c(
    "ade4",
    "adegraphics",
    "adespatial",
    "agricolae",
    "ape",
    "cluster",
    "cocorresp",
    "colorspace",
    "dendextend",
    "ellipse",
    "FactoMineR",
    "FD",
    "gclus",
    "ggplot2",
    "googleVis",
    "igraph",
    "indicspecies",
    "labdsv",
    "MASS",
    "missMDA",
    "picante",
    "pvclust",
    "RColorBrewer",
    "rgexf",
    "RgoogleMaps",
    "rioja",
    "rrcov",
    "SoDA",
    "spdep",
    "taxize",
    "vegan",
    "vegan3d",
    "vegclust",
    "vegetarian"
  ),
  dependencies = TRUE,
  type = "both"
)


# Install mvpart and MVPARTwrap that are not available from CRAN anymore:
# On Windows machines, Rtools (3.4 and above) must be installed first. Go to:
# https://cran.r-project.org/bin/windows/Rtools/
# After that:
install.packages("devtools")
library(devtools)
assignInNamespace("version_info", c(devtools:::version_info, list("3.5" = list(version_min = "3.3.0", version_max = "99.99.99", path = "bin"))), "devtools")
install_github("cran/mvpart", force = TRUE)
install_github("cran/MVPARTwrap", force = TRUE)


# 3. OPTIONAL (for power users): Install all R packages from
#    Environmetrics, a CRAN Task View for the Analysis of Ecological
#    and Environmental Data
#    See http://cran.r-project.org/web/views/Environmetrics.html
#    --------------------------------------------------------------------

install.packages("ctv")
library(ctv)
update.views("Environmetrics")

# Other potentially useful CRAN Task Views...
update.views("Cluster")
update.views("Multivariate")
update.views("Spatial")
update.views("MachineLearning")
