#!/bin/bash

if [[ "${MWAA_AIRFLOW_COMPONENT}" != "worker" ]]
then
    exit 0
fi

echo "------------------------------"
echo "Installing virtual Python env"
echo "------------------------------"

pip3 install --upgrade pip

echo "Current Python version:"
python3 --version
echo "..."

pip3 install virtualenv
mkdir -p python3-virtualenv
cd python3-virtualenv
python3 -m venv dbt-env
chmod -R 777 *

echo "------------------------------"
echo "Activating venv in"
echo $DBT_ENV_PATH
echo "------------------------------"

source dbt-env/bin/activate
pip3 list

echo "------------------------------"
echo "Installing libraries..."
echo "------------------------------"

# do not use sudo, as it will install outside the venv
# Python 3.12 requires Pandas >= 2.1.0.
# Older versions of databricks-sql-connector required Pandas < 2.0.0.
# We must explicitly install a newer databricks-sql-connector (>=3.0.0) that supports Pandas 2.x.
# We also install a compatible dbt-databricks version.
pip3 install "databricks-sql-connector>=3.0.0" "dbt-databricks>=1.8.0"

echo "------------------------------"
echo "Venv libraries..."
echo "------------------------------"

pip3 list
dbt --version

echo "------------------------------"
echo "Deactivating venv..."
echo "------------------------------"

deactivate
