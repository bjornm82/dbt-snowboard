ARG DBT_VERSION
FROM ghcr.io/dbt-labs/dbt-core:${DBT_VERSION}

RUN apt-get update
RUN apt-get install unixodbc-dev -y \
    python3-dev -y \
    curl -y \
    gcc libsasl2-dev libsasl2-modules -y

RUN pip install dbt-snowflake
RUN pip install dbt-trino

RUN dbt --version

ARG PROJECT_NAME

COPY ${PROJECT_NAME}/dbt_project.yml /usr/app/${PROJECT_NAME}/dbt_project.yml
COPY ${PROJECT_NAME}/packages.yml /usr/app/${PROJECT_NAME}/packages.yml
COPY ${PROJECT_NAME}/dbt_packages /usr/app/${PROJECT_NAME}/dbt_packages

WORKDIR /usr/app/${PROJECT_NAME}

# ENTRYPOINT [ "/bin/bash" ]