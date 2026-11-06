-- HISTORIA · el mapa de calor: incidencias por cada 100 minutos, una fila por dron y semana.
-- Se cruzan todos los drones con todas las semanas para que no falte ninguna celda.
with semanas as (
    select distinct date_trunc('week', fecha) as lunes, date_trunc('week', fecha)::date as semana
    from {{ ref('fact_vuelos') }}
),
celdas as (
    select
        dron,
        date_trunc('week', fecha)::date as semana,
        sum(con_incidencia::int)                         as incidencias,
        sum(minutos_vuelo)                               as minutos_vuelo
    from {{ ref('fact_vuelos') }}
    group by all
)
select
    d.dron || ' · ' || s.semana::varchar                                         as celda,
    d.dron,
    s.semana,
    coalesce(round(100.0 * c.incidencias / c.minutos_vuelo, 3), 0)       as incidencias_100min
from {{ ref('dim_dron') }} d
cross join semanas s
left join celdas c using (dron, semana)
order by d.dron, s.lunes
