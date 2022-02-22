FROM r-base:latest

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev

RUN install2.r rsconnect

COPY deploy.R /deploy.R

CMD ["Rscript", "--no-init-file", "/deploy.R"]