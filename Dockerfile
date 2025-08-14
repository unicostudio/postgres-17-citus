FROM ghcr.io/cloudnative-pg/postgresql:17.2
USER root
# Add Citus Data package repository
# Install Citus extension
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg && \
    curl -s https://packagecloud.io/install/repositories/citusdata/community/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y --no-install-recommends postgresql-17-citus-13.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Append the Citus configuration to the actual postgresql.conf file
RUN echo "shared_preload_libraries = 'citus'" >> /var/lib/postgresql/data/postgresql.conf
USER 26
