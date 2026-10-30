-- ORO · dimensión piloto: una fila por cada piloto distinto del parte (ya normalizado en plata).
select distinct piloto
from {{ ref('stg_parte') }}
order by piloto
