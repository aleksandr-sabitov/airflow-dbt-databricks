FROM apache/airflow:3.0.6
COPY dbt_install.sh /usr/local/bin/dbt_install.sh
USER root
RUN chmod 755 /usr/local/bin/dbt_install.sh
USER airflow
