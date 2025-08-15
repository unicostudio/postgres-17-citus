FROM ghcr.io/cloudnative-pg/postgresql:17.2
USER root

# Install build dependencies, Citus, and build pg_partman from source
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg git build-essential \
    postgresql-server-dev-17 libpq-dev && \
    # Install Citus
    curl -s https://packagecloud.io/install/repositories/citusdata/community/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y --no-install-recommends postgresql-17-citus-13.0 && \
    # Install pg_partman from source
    git clone https://github.com/pgpartman/pg_partman.git /tmp/pg_partman && \
    cd /tmp/pg_partman && \
    make install && \
    cd / && rm -rf /tmp/pg_partman && \
    # Clean up build dependencies but keep runtime dependencies
    apt-get remove -y git build-essential postgresql-server-dev-17 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER 26
