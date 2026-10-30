-- ORO · dimensión dron: una fila por cada dron distinto del parte.
select distinct dron
from {{ ref('stg_parte') }}
order by dron
