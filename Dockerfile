# based on https://github.com/nownabe/metabase-gae
# Java 11 required to fix https://github.com/metabase/metabase/issues/12549
FROM openjdk:19-buster
ADD https://downloads.metabase.com/v0.50.33/metabase.jar /metabase.jar

# Add cloud sql proxy to connect to the database
ADD https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 ./cloud_sql_proxy
RUN mv cloud_sql_proxy /bin/cloud_sql_proxy \
    && chmod +x /bin/cloud_sql_proxy

# Add Tini as init process via ENTRYPOINT - https://github.com/krallin/tini
ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini-static ./tini-static
RUN mv tini-static /bin/tini \
    && chmod +x /bin/tini
ENTRYPOINT ["tini", "--"]

# TODO: Load secrets at runtime instead of build time
COPY .env .

# https://github.com/metabase/metabase/issues/3734
EXPOSE 8080

# https://github.com/metabase/metabase/issues/3983#issuecomment-268068993
COPY docker-cmd.sh /usr/local/bin
CMD ["docker-cmd.sh"]
