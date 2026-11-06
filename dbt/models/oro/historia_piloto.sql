-- HISTORIA · ¿es el dron o es el piloto? Incidencias por cada 100 minutos de vuelo, por piloto:
-- los vuelos de ese piloto con el DRN-24 frente a los suyos con el resto de la flota.
-- Si el DRN-24 sale por encima con cada piloto, el problema no es el piloto.
select
    piloto,
    count(*) filter (where dron = 'DRN-24')                                              as vuelos_drn24,
    round(100.0 * sum(con_incidencia::int) filter (where dron = 'DRN-24')
               / sum(minutos_vuelo)      filter (where dron = 'DRN-24'), 3)            as drn24,
    round(100.0 * sum(con_incidencia::int) filter (where dron <> 'DRN-24')
               / sum(minutos_vuelo)      filter (where dron <> 'DRN-24'), 3)           as resto,
    -- con cuántos pilotos (de todos) el DRN-24 sale por encima del resto
    count(*) over ()                                                                     as total_pilotos,
    sum((drn24 > resto)::int) over ()::integer                                           as pilotos_drn24_peor
from {{ ref('fact_vuelos') }}
group by piloto
order by drn24 desc
