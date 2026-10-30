-- ORO · dimensión encargo: una fila por cada tipo de encargo distinto del parte.
select distinct encargo
from {{ ref('stg_parte') }}
order by encargo
