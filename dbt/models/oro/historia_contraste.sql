-- HISTORIA · el contraste: incidencias por cada 100 minutos con el parte tal como llega a bronce y limpio en plata.
-- Tal como llega: con los vuelos repetidos entre entregas, las duraciones en texto sin leer y los 9.999 minutos.
with sin_limpiar as (
    select
        dron,
        round(100.0 * count(*) filter (where coalesce(trim(incidencia), '') <> '')
                    / sum(try_cast(minutos_vuelo as integer)), 3) as valor
    from {{ source('bronce', 'parte') }}
    group by all
),
limpio as (
    select dron, incidencias_100min as valor
    from {{ ref('pregunta_3') }}
)
select dron, s.valor as sin_limpiar, l.valor as limpio
from sin_limpiar s
join limpio l using (dron)
order by limpio desc
