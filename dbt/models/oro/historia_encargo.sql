-- HISTORIA · ¿es el dron o es el encargo? Incidencias por cada 100 minutos de vuelo, por encargo:
-- los vuelos de ese encargo con el DRN-24 frente a los suyos con el resto de la flota.
-- Si el DRN-24 sale por encima con cada encargo, el problema no es el encargo.
select
    encargo,
    count(*) filter (where dron = 'DRN-24')                                              as vuelos_drn24,
    round(100.0 * sum(con_incidencia::int) filter (where dron = 'DRN-24')
               / sum(minutos_vuelo)      filter (where dron = 'DRN-24'), 3)            as drn24,
    round(100.0 * sum(con_incidencia::int) filter (where dron <> 'DRN-24')
               / sum(minutos_vuelo)      filter (where dron <> 'DRN-24'), 3)           as resto,
    -- con cuántos encargos (de todos) el DRN-24 sale por encima del resto
    count(*) over ()                                                                     as total_encargos,
    sum((drn24 > resto)::int) over ()::integer                                           as encargos_drn24_peor
from {{ ref('fact_vuelos') }}
group by encargo
order by drn24 desc
