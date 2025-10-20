# RStudio Server with R preinstalled (multi-arch; good on Apple Silicon + Intel)
FROM ghcr.io/rocker-org/rstudio:4.4.1

# System libs for tidyverse, rstan/brms, fonts/graphics, XML/cURL/SSL, and R Markdown
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gfortran pkg-config zlib1g-dev libbz2-dev libgit2-dev \
    libssl-dev libxml2-dev libcurl4-openssl-dev \
    libfontconfig1-dev libfreetype6-dev libharfbuzz-dev libfribidi-dev \
    libpng-dev libjpeg-dev libtiff5-dev libx11-dev libwebp-dev \
    pandoc \
 && rm -rf /var/lib/apt/lists/*

# (Optional) Faster C/C++ builds (use cores available in container)
ENV MAKEFLAGS="-j4"
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Work in the project directory under the pre-created 'rstudio' user
WORKDIR /home/rstudio/project

# Install renv (and pak for convenience), consent to renv
RUN R -q -e 'install.packages(c("renv","pak"), repos="https://cloud.r-project.org"); renv::consent(provided=TRUE)'

# Copy lockfile & renv bootstrap early for better layer caching
# (copy only if present to keep builds flexible)
COPY renv.lock* ./
COPY .Rprofile ./.Rprofile
COPY renv/activate.R ./renv/activate.R

# Restore packages from renv.lock inside the image (fully reproducible build)
RUN if [ -f "renv.lock" ]; then \
      R -q -e 'renv::restore(prompt = FALSE)'; \
    fi

# Now copy the rest of your project (respects your .dockerignore)
COPY . .

# Make sure the 'rstudio' user owns the home dir (useful when mounting volumes)
RUN chown -R rstudio:rstudio /home/rstudio

# Expose the RStudio Server port (use at run time with -p 8787:8787)
EXPOSE 8787

# Base image already provides the entrypoint / s6 + rserver, so no CMD needed.
# At runtime, set a password, e.g.:
#   docker run --rm -p 8787:8787 -e PASSWORD=pass123 \
#     -v "$(pwd)":/home/rstudio/project ghcr.io/<you>/fischdetektionen:latest