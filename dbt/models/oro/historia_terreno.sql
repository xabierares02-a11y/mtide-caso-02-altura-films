-- HISTORIA · el terreno: una fila con las cifras de contexto de la flota y del DRN-24.
with flota as (
    select
        count(*)                                  as vuelos,
        count(distinct dron)                      as drones,
        count(distinct piloto)                    as pilotos,
        sum(minutos_vuelo)                        as minutos_vuelo,
        round(sum(importe_eur), 0)                as importe_eur,
        sum(con_incidencia::int)                  as incidencias,
        round(100.0 * sum(con_incidencia::int) / sum(minutos_vuelo), 3) as incidencias_100min,
        round(median(minutos_vuelo), 0)           as mediana_minutos,
        round(avg(minutos_vuelo), 1)              as media_minutos,
        quantile_cont(minutos_vuelo, 0.95)        as p95_minutos
    from {{ ref('fact_vuelos') }}
),
drn24 as (
    select
        count(*)                                  as vuelos_drn24,
        sum(con_incidencia::int)                  as incidencias_drn24,
        round(100.0 * sum(con_incidencia::int) / sum(minutos_vuelo), 3) as incidencias_100min_drn24
    from {{ ref('fact_vuelos') }}
    where dron = 'DRN-24'
),
resto as (
    select round(100.0 * sum(con_incidencia::int) / sum(minutos_vuelo), 3) as incidencias_100min_resto
    from {{ ref('fact_vuelos') }}
    where dron <> 'DRN-24'
),
segundo as (
    -- el segundo dron de la pregunta 3 (la fila 1, porque está ordenada de mayor a menor)
    select dron as segundo_dron, incidencias_100min as incidencias_100min_segundo
    from {{ ref('pregunta_3') }}
    order by incidencias_100min desc
    limit 1 offset 1
)
select
    'flota' as ambito,
    flota.*,
    drn24.*,
    resto.*,
    segundo.*,
    round(100.0 * incidencias_drn24 / incidencias, 1)              as pct_incidencias_drn24,
    round(100.0 * vuelos_drn24 / vuelos, 1)                        as pct_vuelos_drn24,
    round(incidencias_100min_drn24 / incidencias_100min_resto, 1)  as veces_resto,
    round(incidencias_100min_drn24 / incidencias_100min_segundo, 1) as veces_segundo
from flota, drn24, resto, segundo
