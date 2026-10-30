-- ORO · tabla de hechos: el grano es un vuelo (una fila por código de vuelo).
-- piloto, dron y encargo enlazan con sus dimensiones; minutos, batería e importe son las medidas.
-- con_incidencia: true si el piloto anotó alguna incidencia (la columna viene vacía si no hubo ninguna).
select
    vuelo,
    fecha,
    piloto,
    dron,
    encargo,
    minutos_vuelo,
    wh_bateria,
    importe_eur,
    coalesce(trim(incidencia), '') <> '' as con_incidencia
from {{ ref('stg_parte') }}
