# Dicionário de Dados - Camada Bronze (Olist)

Este documento serve como um dicionário de dados para todos os arquivos `.csv` que compõem a camada Bronze do dataset Olist.

---

### 1. `olist_customers_dataset.csv`
Armazena informações sobre os clientes.

| Coluna | Tipo Inferido (PySpark) | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `customer_id` | `string` | ID único do cliente por pedido. | Um mesmo cliente pode ter múltiplos `customer_id` se fizer múltiplos pedidos. |
| `customer_unique_id` | `string` | ID que identifica unicamente um cliente. | Usado para agrupar todos os pedidos de um mesmo indivíduo. Chave real do cliente. |
| `customer_zip_code_prefix`| `integer` | Os 5 primeiros dígitos do CEP do cliente. | Permite a localização geográfica. |
| `customer_city` | `string` | A cidade do cliente. | |
| `customer_state` | `string` | O estado do cliente (sigla de 2 letras). | |

---

### 2. `olist_orders_dataset.csv`
Contém os dados centrais de cada pedido realizado.

| Coluna | Tipo Inferido (PySpark) | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `order_id` | `string` | ID único de cada pedido. | Chave primária desta tabela e principal chave de ligação do dataset. |
| `customer_id` | `string` | Chave estrangeira que liga ao `olist_customers_dataset`. | |
| `order_status` | `string` | Status atual do pedido. | Categórico (ex: `delivered`, `shipped`, `canceled`). |
| `order_purchase_timestamp` | `timestamp` | Data e hora em que a compra foi realizada. | |
| `order_approved_at` | `timestamp` | Data e hora da aprovação do pagamento. | Contém valores nulos. |
| `order_delivered_carrier_date`| `timestamp` | Data e hora em que o pedido foi postado na transportadora. | Contém valores nulos. |
| `order_delivered_customer_date`|`timestamp` | Data da entrega real do pedido ao cliente. | Contém valores nulos. |
| `order_estimated_delivery_date`|`timestamp` | Data estimada de entrega informada ao cliente. | |

---

### 3. `olist_order_items_dataset.csv`
Tabela associativa que detalha os produtos contidos em cada pedido.

| Coluna | Tipo Inferido (PySpark) | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `order_id` | `string` | Chave estrangeira que liga ao `olist_orders_dataset`. | |
| `order_item_id` | `integer` | ID sequencial que identifica os itens dentro de um mesmo pedido. | Se um pedido tem 3 itens, haverá registros com `order_item_id` 1, 2 e 3. |
| `product_id` | `string` | Chave estrangeira que liga ao `olist_products_dataset`. | |
| `seller_id` | `string` | Chave estrangeira que liga ao `olist_sellers_dataset`. | |
| `shipping_limit_date` | `timestamp` | Data limite para o vendedor enviar o produto. | |
| `price` | `double` | O preço do produto (valor unitário). | |
| `freight_value` | `double` | O valor do frete do item. | Se um pedido tem múltiplos itens, o frete total é a soma dos `freight_value`. |

---

### 4. `olist_order_payments_dataset.csv`
Registra as informações de pagamento de cada pedido.

| Coluna | Tipo Inferido (PySpark) | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `order_id` | `string` | Chave estrangeira que liga ao `olist_orders_dataset`. | |
| `payment_sequential` | `integer` | Sequencial para pagamentos múltiplos em um mesmo pedido. | |
| `payment_type` | `string` | Método de pagamento utilizado. | Categórico (ex: `credit_card`, `boleto`). |
| `payment_installments` | `integer` | Número de parcelas no cartão de crédito. | |
| `payment_value` | `double` | O valor total do pagamento. | |

---

### 5. `olist_order_reviews_dataset.csv`
Armazena as avaliações (reviews) feitas pelos clientes para cada pedido.

| Coluna | Tipo Inferido (PySpark) | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `review_id` | `string` | ID único da avaliação. | |
| `order_id` | `string` | Chave estrangeira que liga ao `olist_orders_dataset`. | |
| `review_score` | `string` | Nota da avaliação (de 1 a 5). | **Atenção:** Coluna "suja", contém textos e lixo. Lida como `string`. |
| `review_comment_title` | `string` | Título do comentário da avaliação (opcional). | |
| `review_comment_message` | `string` | Corpo do comentário da avaliação (opcional). | |
| `review_creation_date` | `timestamp`| Data em que a pesquisa de satisfação foi enviada ao cliente. | |
| `review_answer_timestamp`| `timestamp`| Data em que o cliente respondeu à pesquisa. | |

---

### 6. `olist_products_dataset.csv`
Contém os dados do catálogo de produtos vendidos.

| Coluna | Tipo Inferido (PySpark) | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `product_id` | `string` | ID único do produto. | Chave primária desta tabela. |
| `product_category_name` | `string` | Nome da categoria do produto, em português. | Contém valores nulos. |
| `product_name_lenght` | `integer` | Número de caracteres no nome do produto. | Contém valores nulos. |
| `product_description_lenght`| `integer` | Número de caracteres na descrição do produto. | Contém valores nulos. |
| `product_photos_qty` | `integer` | Quantidade de fotos publicadas do produto. | Contém valores nulos. |
| `product_weight_g` | `integer` | Peso do produto em gramas. | Contém valores nulos. |
| `product_length_cm` | `integer` | Comprimento do produto em centímetros. | Contém valores nulos. |
| `product_height_cm` | `integer` | Altura do produto em centímetros. | Contém valores nulos. |
| `product_width_cm` | `integer` | Largura do produto em centímetros. | Contém valores nulos. |

---

### 7. `olist_sellers_dataset.csv`
Armazena informações sobre os vendedores que utilizam a plataforma Olist.

| Coluna | Tipo Inferido (PySpark) | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `seller_id` | `string` | ID único do vendedor. | Chave primária desta tabela. |
| `seller_zip_code_prefix` | `integer` | Os 5 primeiros dígitos do CEP do vendedor. | |
| `seller_city` | `string` | A cidade do vendedor. | |
| `seller_state` | `string` | O estado do vendedor (sigla de 2 letras). | |

---

### 8. `product_category_name_translation.csv`
Tabela "de-para" para traduzir os nomes das categorias de produtos para o inglês.

| Coluna | Tipo Inferido (PySpark) | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `product_category_name` | `string` | Nome da categoria em português. | Chave de ligação com `olist_products_dataset`. |
| `product_category_name_english` | `string`| Nome da categoria em inglês. | |

---

### 9. `olist_geolocation_dataset.csv`
Contém informações de geolocalização (latitude e longitude) para cada CEP.

| Coluna | Tipo Inferido (PySpark) | Descrição | Observações |
| :--- | :--- | :--- | :--- |
| `geolocation_zip_code_prefix`| `integer` | Os 5 primeiros dígitos do CEP. | Pode ter múltiplas entradas para o mesmo CEP. |
| `geolocation_lat` | `double` | Latitude. | |
| `geolocation_lng` | `double` | Longitude. | |
| `geolocation_city` | `string` | Nome da cidade. | Pode ter variações de acentuação e escrita. |
| `geolocation_state` | `string` | Estado (sigla de 2 letras). | |