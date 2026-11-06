-- HISTORIA · ¿vuela el DRN-24 con peor tiempo que el resto? Rachas del día de cada vuelo, DRN-24 frente al resto.
-- Si las rachas fueran parecidas, el viento no explica que falle más.
select
    case when p.dron = 'DRN-24' then 'DRN-24' else 'resto de la flota' end           as grupo,
    count(*)                                                                         as vuelos,
    round(avg(m.rachas_kmh), 1)                                                      as rachas_medias_kmh,
    round(100.0 * count(*) filter (where m.rachas_kmh > 50) / count(*), 1)           as pct_vuelos_rachas_50
from {{ ref('stg_parte') }} p
join {{ ref('stg_meteo_diaria') }} m using (fecha)
group by grupo
order by grupo
