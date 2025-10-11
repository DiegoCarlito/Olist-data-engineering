import os
from dotenv import load_dotenv
import psycopg2
from pyspark.sql import SparkSession

def carregar_variaveis_ambiente():
    load_dotenv()
    print("Variáveis de ambiente carregadas.")
    return {
        "db_user": os.getenv("DB_USER"),
        "db_password": os.getenv("DB_PASSWORD"),
        "db_host": os.getenv("DB_HOST"),
        "db_port": os.getenv("DB_PORT"),
        "db_name": os.getenv("DB_NAME")
    }

def executar_script_ddl(env_vars):
    ddl_script_path = "sql/create_silver_table.sql"
    try:
        with psycopg2.connect(
            user=env_vars["db_user"],
            password=env_vars["db_password"],
            host=env_vars["db_host"],
            port=env_vars["db_port"],
            dbname=env_vars["db_name"]
        ) as conn:
            with conn.cursor() as cur:
                with open(ddl_script_path, "r") as f:
                    ddl_script = f.read()
                    cur.execute(ddl_script)
                print(f"Script DDL '{ddl_script_path}' executado com sucesso.")
    except Exception as e:
        print(f"Erro ao executar o script DDL: {e}")
        raise

def carregar_dados_no_postgres(spark, env_vars):
    caminho_parquet = "data/silver/pedidos"
    
    print(f"Lendo dados Parquet de: {caminho_parquet}")
    df_prata = spark.read.parquet(caminho_parquet)

    jdbc_url = f"jdbc:postgresql://{env_vars['db_host']}:{env_vars['db_port']}/{env_vars['db_name']}"
    jdbc_properties = {
        "user": env_vars["db_user"],
        "password": env_vars["db_password"],
        "driver": "org.postgresql.Driver"
    }
    
    print("Iniciando a carga de dados no PostgreSQL...")
    df_prata.write.jdbc(
        url=jdbc_url,
        table="pedidos",
        mode="overwrite", # "overwrite" apaga a tabela e a recria com os novos dados
        properties=jdbc_properties
    )
    print("Carga de dados no PostgreSQL concluída com sucesso.")

def main():
    env_vars = carregar_variaveis_ambiente()
    
    # O Spark precisa do driver JDBC do PostgreSQL para se conectar.
    # Esta configuração baixa o driver automaticamente se não estiver presente.
    spark = SparkSession.builder \
        .appName("CargaPrataParaPostgreSQL") \
        .config("spark.jars.packages", "org.postgresql:postgresql:42.5.0") \
        .getOrCreate()
        
    try:
        # Nota: O write.jdbc com modo "overwrite" já pode criar a tabela.
        # Executar o DDL manualmente garante que os tipos de dados e comentários
        # do nosso script SQL sejam respeitados.
        executar_script_ddl(env_vars)
        carregar_dados_no_postgres(spark, env_vars)
    finally:
        spark.stop()
        print("Sessão Spark finalizada.")

if __name__ == "__main__":
    main()