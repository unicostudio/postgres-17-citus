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
    # Install pg_partman from source
    cd /tmp && \
    git clone https://github.com/pgpartman/pg_partman.git && \
    cd pg_partman && \
    export PG_CONFIG=/usr/bin/pg_config && \
    make clean && \
    make && \
    make install && \
    # Verify files were installed BEFORE cleanup
    echo "=== Checking installed files ===" && \
    ls -la /usr/lib/postgresql/17/lib/pg_partman_bgw.so && \
    ls -la /usr/share/postgresql/17/extension/pg_partman.control && \
    # Clean up but be more careful about what we remove
    cd / && rm -rf /tmp/pg_partman && \
    apt-get remove -y git build-essential make && \
    # Keep postgresql-server-dev-17 and libpq-dev as they might be needed at runtime
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Final verification
    echo "=== Final verification ===" && \
    ls -la /usr/lib/postgresql/17/lib/pg_partman_bgw.so

USER 26
