FROM rust:1.58-buster
RUN echo "deb https://cloud.r-project.org/bin/linux/debian buster-cran40/" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN rustup update
RUN cargo install diesel_cli

RUN apt update -qq -y

RUN apt install -y software-properties-common dirmngr libcurl4-openssl-dev \
    libssl-dev libssh2-1-dev libxml2-dev zlib1g-dev make git-core \
    libcurl4-openssl-dev libxml2-dev libpq-dev cmake \
    r-base r-base-dev libsodium-dev libsasl2-dev librabbitmq-dev

RUN add-apt-repository ppa:maxmind/ppa

RUN apt install -y \
    libmaxminddb0 libmaxminddb-dev mmdb-bin

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

RUN R -e "install.packages(c('renv','rextendr', 'devtools', 'shiny', 'roxygen2', 'usethis', 'testthat', 'tidyverse'))"
RUN R -e "install.packages('reticulate')"
RUN R -e "reticulate::install_miniconda()"
RUN R -e "install.packages('spacyr')"
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
RUN R -e "spacyr::spacy_install(prompt=FALSE)"

COPY ./srcpkgs/rredis_1.7.0.tar.gz .
RUN R -e "install.packages('rredis_1.7.0.tar.gz', repo=NULL)"
RUN R -e "devtools::install_github('atheriel/longears')"
RUN R -e "devtools::install_github('hadley/emo')"

WORKDIR /redpul/stripeR
COPY ./stripeR/DESCRIPTION .
COPY ./stripeR/NAMESPACE .
COPY ./stripeR/R R

WORKDIR /redpul
RUN R -e "devtools::install_deps('./stripeR')"
RUN R -e "devtools::document('./stripeR')"
RUN R -e "devtools::install('./stripeR')"

WORKDIR /redpul/state
COPY ./state/DESCRIPTION .
COPY ./state/NAMESPACE .
COPY ./state/R R

WORKDIR /redpul
RUN R -e "devtools::install_deps('./state')"
RUN R -e "devtools::document('./state')"
RUN R -e "devtools::install('./state')"

WORKDIR /redpul/redpul
COPY redpul/DESCRIPTION .
COPY redpul/NAMESPACE .
COPY redpul/R R
COPY redpul/src src
COPY redpul/.config/Makevars ./src/Makevars


WORKDIR /redpul
RUN R -e "devtools::install_deps('./redpul')"
RUN R -e "rextendr::document('./redpul')"
RUN R -e "devtools::document('./redpul')"
RUN R -e "devtools::install('./redpul')"

WORKDIR /redpul/frontend
COPY ./frontend/DESCRIPTION .
COPY ./frontend/NAMESPACE .
COPY ./frontend/R R

WORKDIR /redpul
RUN R -e "devtools::install_deps('./frontend')"
RUN R -e "devtools::document('./frontend')"
RUN R -e "devtools::install('./frontend')"

COPY ./gmail_creds /redpul/gmail_creds

COPY ./frontend/app.R .
COPY ./frontend/www www
COPY ./frontend/node_modules node_modules
COPY ./sql sql
COPY redpul/main.R .
COPY redpul/plumber.R .
COPY redpul/pulse.R .

