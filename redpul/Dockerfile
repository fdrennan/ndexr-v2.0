FROM fdrennan/redpul:basis
WORKDIR /backend
COPY .Rprofile .
COPY renv.lock .
COPY renv/activate.R renv/activate.R
COPY DESCRIPTION DESCRIPTION
COPY R R
COPY src/ src
COPY .config/Makevars src/Makevars
COPY NAMESPACE .
COPY Makefile .
COPY main.R .
RUN R -e "renv::restore();rextendr::document();devtools::document();devtools::install()"

#CMD ["R", "-e", "source('main.R')"]
