FROM ghcr.io/cloudnative-pg/postgresql:17.2
USER root

# Add Citus Data package repository and install extensions
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg && \
    curl -s https://packagecloud.io/install/repositories/citusdata/community/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-17-citus-13.0 \
    postgresql-17-pg-partman && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER 26
