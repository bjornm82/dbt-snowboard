FROM python:3.11.2-slim-bullseye

ARG DBT_VERSION
RUN pip install dbt-core==${DBT_VERSION}
RUN pip install dbt-postgres

RUN mkdir -p /usr/app/my_project/

# Git is required to run dbt deps.
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean

WORKDIR /usr/app/my_project/

CMD [ "dbt", "--version" ]
