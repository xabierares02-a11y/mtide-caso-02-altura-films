-- PREGUNTA 1 · ¿Qué tipo de encargo deja menos ingreso por minuto de vuelo?
-- ingreso_min = ingreso total / minutos totales del encargo (no la media de cada vuelo:
-- así pesa más un vuelo largo que uno corto, que es lo que de verdad cuesta tiempo de dron).
select
    encargo,
    round(sum(importe_eur) / sum(minutos_vuelo), 2) as ingreso_min,
    count(*)                                       as vuelos,
    sum(minutos_vuelo)                             as minutos_vuelo,
    round(sum(importe_eur), 2)                     as importe_eur
from {{ ref('fact_vuelos') }}
group by encargo
order by ingreso_min asc
