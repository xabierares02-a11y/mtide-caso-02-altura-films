-- HISTORIA · la línea: incidencias por cada 100 minutos de vuelo, semana a semana, del DRN-24 frente al resto.
-- La semana es el lunes en que empieza (una fecha, para que los gráficos la ordenen como fecha). La última (desde el 20-04) está incompleta: el parte termina el 22 de abril.
select
    date_trunc('week', fecha)::date                                         as semana,
    round(100.0 * sum(con_incidencia::int) filter (where dron = 'DRN-24')
               / sum(minutos_vuelo)      filter (where dron = 'DRN-24'), 3)               as drn24,
    round(100.0 * sum(con_incidencia::int) filter (where dron <> 'DRN-24')
               / sum(minutos_vuelo)      filter (where dron <> 'DRN-24'), 3)              as resto
from {{ ref('fact_vuelos') }}
group by semana
order by semana
