# RStudio Server with R preinstalled (multi-arch: works on Apple Silicon & Intel)
FROM rocker/rstudio:latest

# (Optional) system libs you might need for packages like brms/Stan, xml2, etc.
# Add/remove as your project needs evolve.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl-dev libxml2-dev libcurl4-openssl-dev libglpk-dev \
    libgit2-dev zlib1g-dev build-essential gfortran \
 && rm -rf /var/lib/apt/lists/*

# Set a working directory inside the container
WORKDIR /home/rstudio/project

# Preinstall renv (and pak for fast installs)
RUN R -q -e 'install.packages(c("renv","pak"), repos="https://cloud.r-project.org")'

# Leverage Docker layer caching:
# copy lockfile first (if present) to cache package install layers
COPY renv.lock* ./

# (Optional) Pre-restore packages at build time if you have a lockfile.
# If you prefer restoring interactively inside RStudio, comment this out.
RUN if [ -f "renv.lock" ]; then \
      R -q -e 'renv::restore(prompt = FALSE)'; \
    fi

# Copy the rest of your project (but see .dockerignore below)
COPY . .

# Expose RStudio Server
EXPOSE 8787

# RStudio image uses user/password: rstudio / $PASSWORD (set via docker run)
# Nothing else to CMD—Rocker sets this up for you.