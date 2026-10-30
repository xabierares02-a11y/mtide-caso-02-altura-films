{{ config(severity = 'warn') }}
-- TEST PROTAGONISTA · la normativa no permite volar con rachas de más de 50 km/h.
-- Devuelve los vuelos del parte hechos en días con rachas por encima de ese límite.
-- Es warn y no error: el dato está bien (los vuelos ocurrieron y el viento se midió bien);
-- lo que incumple la norma es la operación. Es un hallazgo para la dirección y la aseguradora,
-- y el build tiene que enseñarlo sin parar el resto del lakehouse.
select
    p.vuelo,
    p.fecha,
    p.piloto,
    p.dron,
    p.encargo,
    p.incidencia,
    m.rachas_kmh
from {{ ref('stg_parte') }} p
join {{ ref('stg_meteo_diaria') }} m using (fecha)
where m.rachas_kmh > 50
