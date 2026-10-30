-- PREGUNTA 3 · ¿Qué dron acumula más incidencias por cada 100 minutos de vuelo?
-- Se divide por minutos y no por vuelos: un dron que vuela más tiene más ocasiones de fallar.
select
    dron,
    round(100.0 * count(*) filter (where con_incidencia) / sum(minutos_vuelo), 3) as incidencias_100min,
    count(*)                                                                      as vuelos,
    count(*) filter (where con_incidencia)                                        as incidencias,
    sum(minutos_vuelo)                                                            as minutos_vuelo
from {{ ref('fact_vuelos') }}
group by dron
order by incidencias_100min desc
