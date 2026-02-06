import json
import os

import boto3
import psycopg
from dotenv import load_dotenv

load_dotenv(".env")

SCHEMA_FILE = "./schema/schema.sql"

DB_NAME = os.environ["DB_NAME"]
DB_HOST = os.environ["DB_HOST"]
DB_PORT = os.environ["DB_PORT"]
DB_SECRET_ARN = os.environ["DB_SECRET_ARN"]

def get_db_secret(secret_arn: str) -> dict:
    client = boto3.client("secretsmanager")
    response = client.get_secret_value(SecretId=secret_arn)
    return json.loads(response["SecretString"])

def main():
    secret = get_db_secret(DB_SECRET_ARN)
    print(secret)

    dbname = DB_NAME
    host = DB_HOST
    port = DB_PORT
    user = secret["username"]
    password = secret["password"]

    print(f"Connecting to {host}:{port}/{dbname} as {user}")

    conninfo = (
        f"host={host} port={port} dbname={dbname} "
        f"user={user} password={password} sslmode=require"
    )

    with psycopg.connect(conninfo) as conn:
        with conn.cursor() as cur:
            sql = open(SCHEMA_FILE, "r", encoding="utf-8").read()
            cur.execute(sql)
        conn.commit()

    print("Schema applied.")

if __name__ == "__main__":
    main()
