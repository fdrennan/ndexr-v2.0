FROM fdrennan/redpul:basis
WORKDIR /app
COPY .Rprofile .
COPY renv.lock .
COPY renv/activate.R renv/activate.R
COPY R R
COPY DESCRIPTION .
COPY app.R .
RUN R -e "renv::restore();devtools::document();devtools::install()"


