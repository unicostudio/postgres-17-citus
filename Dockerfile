FROM ghcr.io/cloudnative-pg/postgresql:17.2
USER root

# Install build dependencies, Citus, and build pg_partman from source
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg git build-essential \
    postgresql-server-dev-17 libpq-dev make && \
    # Install Citus first
    curl -s https://packagecloud.io/install/repositories/citusdata/community/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y --no-install-recommends postgresql-17-citus-13.0 && \
    # Install pg_partman from source with proper compilation
    cd /tmp && \
    git clone https://github.com/pgpartman/pg_partman.git && \
    cd pg_partman && \
    # Ensure we're using the right PostgreSQL version
    export PG_CONFIG=/usr/bin/pg_config && \
    make clean && \
    make && \
    make install && \
    # Verify the bgw library was installed
    ls -la /usr/lib/postgresql/17/lib/pg_partman_bgw.so && \
    cd / && rm -rf /tmp/pg_partman && \
    # Clean up build dependencies
    apt-get remove -y git build-essential postgresql-server-dev-17 make && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER 26
