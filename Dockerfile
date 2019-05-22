FROM postgres:11.0

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive

# ---------------------------------------------------------------------------
# PipelineDB
# ---------------------------------------------------------------------------
RUN apt-get -y update \
    && apt-get install -y curl \
    && curl -s http://download.pipelinedb.com/apt.sh | bash \
    && apt-get -y install pipelinedb-postgresql-11 \
    && apt-get -y install postgresql-server-dev-11 \
    && apt-get -y install git \
    && apt-get -y install cmake \
    && apt-get purge -y --auto-remove curl

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
COPY create-extensions.sql /docker-entrypoint-initdb.d/
COPY configure.sh /docker-entrypoint-initdb.d/

# remove the apt cache:
RUN apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

