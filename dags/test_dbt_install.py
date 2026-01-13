from airflow import DAG
from airflow.operators.bash import BashOperator
import pendulum

with DAG(dag_id="dbt-installation-test", schedule=None, catchup=False, start_date=pendulum.today('UTC').add(days=-1)) as dag:
    cli_command = BashOperator(
        task_id="bash_command",
        bash_command="/opt/airflow/python3-virtualenv/dbt-env/bin/dbt --version"
    )
