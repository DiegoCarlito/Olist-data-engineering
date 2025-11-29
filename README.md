# Projeto de Engenharia de Dados com Olist

## 📖 Sobre o Projeto

Projeto de engenharia de dados ponta a ponta para análise do ecossistema de e-commerce brasileiro utilizando o dataset da [Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). O pipeline implementa a **Arquitetura Medalhão (Bronze, Silver, Gold)** para processar os dados brutos, modela um **Data Warehouse em Star Schema** e culmina em dashboards analíticos para visualização de KPIs de vendas.

Este projeto foi desenvolvido para a disciplina de Sistemas de Banco de Dados 2 (2025/2).

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** Python  
- **Processamento de Dados:** PySpark  
- **Análise e Visualização:** Pandas, Matplotlib, Seaborn  
- **Banco de Dados:** PostgreSQL  
- **Infraestrutura como Código:** Docker e Docker Compose  
- **Visualização Final:** Power BI  

## 📁 Arquitetura do Repositório

O projeto é organizado em duas pastas principais, seguindo a separação de responsabilidades:

1. **`DataLayer`** — Armazena os dados e sua documentação associada em cada camada da Arquitetura Medalhão.
2. **`Transformer`** — Contém a lógica de processamento (pipelines de ETL) que move e transforma os dados entre as camadas.

### Estrutura de diretórios

```text
├── DataLayer
│   ├── raw                         # CAMADA BRONZE (Dados brutos)
│   │
│   ├── silver                      # CAMADA SILVER (Dados limpos e unificados)
│   │
│   └── gold                        # CAMADA GOLD (Data Warehouse)
│
├── Transformer
    └── ETL
        ├── etl_raw_to_silver.ipynb
        └── etl_silver_to_gold.ipynb
````

## 🚀 Configuração e Execução

Siga os passos abaixo para configurar o ambiente e executar o pipeline completo da Camada Bronze até a Gold.

### 📋 Pré-requisitos

* [Git](https://git-scm.com/)
* [Python 3.9+](https://www.python.org/downloads/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### ⚙️ Passos para Execução

1. **Clonar o Repositório**

   ```sh
   git clone https://github.com/DiegoCarlito/Olist-data-engineering.git
   cd Olist-data-engineering
   ```

2. **Criar e Ativar Ambiente Virtual**

   ```sh
   python -m venv venv
   source venv/bin/activate      # Linux/Mac
   # .\venv\Scripts\activate     # Windows
   ```

3. **Instalar Dependências**

   ```sh
   pip install -r requirements.txt
   ```

4. **Configurar o Arquivo `.env`**

   ```sh
   cp .env.example .env
   ```

   Edite o arquivo `.env` com suas informações.

5. **Subir Container PostgreSQL**

   ```sh
   docker-compose up -d
   ```

6. **Pipeline Bronze → Silver**
   Execute o notebook:

   ```
   Transformer/ETL/raw_to_silver.ipynb
   ```

7. **Pipeline Silver → Gold**
   Execute o notebook:

   ```
   Transformer/ETL/silver_to_gold.ipynb
   ```
