-- PREGUNTA 2 · ¿Qué piloto gasta más batería por minuto de vuelo?
-- wh_min = Wh totales / minutos totales del piloto.
select
    piloto,
    round(sum(wh_bateria) / sum(minutos_vuelo), 3) as wh_min,
    count(*)                                       as vuelos,
    sum(minutos_vuelo)                             as minutos_vuelo,
    round(sum(wh_bateria), 1)                      as wh_bateria
from {{ ref('fact_vuelos') }}
group by piloto
order by wh_min desc
