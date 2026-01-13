from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
import pendulum
import os
import requests

# Define default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

def dummy_task(task_name):
    print(f"Executing {task_name}")

def stop_sql_warehouse(**context):
    from airflow.providers.databricks.hooks.databricks import DatabricksHook

    hook = DatabricksHook(databricks_conn_id='databricks_default')

    http_path = os.environ.get('DBT_DATABRICKS_HTTP_PATH')
    if not http_path:
        print("DBT_DATABRICKS_HTTP_PATH not found, cannot determine Warehouse ID to stop.")
        return

    warehouse_id = http_path.split('/')[-1]
    print(f"Stopping Warehouse ID: {warehouse_id}")

    conn = hook.databricks_conn
    host = conn.host
    # For Databricks connections, the token is stored in the 'password' field
    token = conn.password

    endpoint = f"api/2.0/sql/warehouses/{warehouse_id}/stop"
    url = f"https://{host}/{endpoint}"
    headers = {"Authorization": f"Bearer {token}"}

    try:
        response = requests.post(url, headers=headers)
        response.raise_for_status()  # Will raise an HTTPError for bad responses (4xx or 5xx)
        print(f"Successfully requested stop for warehouse {warehouse_id}. Status: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"Error stopping warehouse: {e}")
        if e.response:
            print(f"Response body: {e.response.text}")
        raise e

with DAG(
        dag_id="Wonderbricks_booking",
        default_args=default_args,
        description="DAG to run DBT models for Wonderbricks and stop SQL Warehouse",
        schedule=None,
        start_date=pendulum.today('UTC').add(days=-1),
        catchup=False,
        tags=['dbt', 'databricks', 'wonderbricks'],
) as dag:

    dag_start = PythonOperator(
        task_id='dag_start',
        python_callable=dummy_task,
        op_kwargs={'task_name': 'dag_start'},
    )

    dbt_run_datamarts = BashOperator(
        task_id='dbt_run_datamarts',
        bash_command="cd /opt/airflow/dbt && /opt/airflow/python3-virtualenv/dbt-env/bin/dbt run --select +dm_monthly_bookings",
        env=os.environ.copy()
    )

    stop_warehouse = PythonOperator(
        task_id='stop_warehouse',
        python_callable=stop_sql_warehouse,
    )

    dag_end = PythonOperator(
        task_id='dag_end',
        python_callable=dummy_task,
        op_kwargs={'task_name': 'dag_end'},
    )

    dag_start >> dbt_run_datamarts >> stop_warehouse >> dag_end