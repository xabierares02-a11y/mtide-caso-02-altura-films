-- PREGUNTA 4 · ¿Qué dron tiene más vuelos sin aterrizaje registrado (en proporción)? ¿Coincide con la pregunta 3?
-- Nivel de la respuesta: una fila por dron. Cada parte se lleva a ese nivel por separado y luego se unen,
-- para que ningún join multiplique filas:
--   1. eventos → una fila por vuelo (¿tiene despegue? ¿tiene aterrizaje?)
--   2. vuelos  → una fila por dron (cuántos, cuántos cojos)
--   3. dim_dron + lo anterior + pregunta_3 (incidencias por 100 min, ya a nivel dron)
-- sin_aterrizaje_seguro: solo cuenta el vuelo cojo si despegó más de 75 min (el vuelo más largo del parte)
-- antes del final del registro; los más recientes podrían seguir en el aire cuando se exportó el fichero.
with vuelos as (
    select
        vuelo_id,
        any_value(dron)                               as dron,
        min(ts) filter (where tipo = 'despegue')      as despegue,
        count(*) filter (where tipo = 'aterrizaje') > 0 as aterrizo
    from {{ ref('stg_eventos') }}
    group by vuelo_id
),
fin_registro as (
    select max(ts) as fin from {{ ref('stg_eventos') }}
),
por_dron as (
    select
        dron,
        count(*)                                                    as vuelos_registro,
        count(*) filter (where not aterrizo)                        as sin_aterrizaje,
        count(*) filter (where not aterrizo
                           and despegue < fin - interval 75 minute) as sin_aterrizaje_seguro
    from vuelos, fin_registro
    where despegue is not null
    group by dron
)
select
    d.dron,
    round(100.0 * coalesce(p.sin_aterrizaje, 0) / nullif(p.vuelos_registro, 0), 1)        as pct_sin_aterrizaje,
    coalesce(p.vuelos_registro, 0)                                                       as vuelos_registro,
    coalesce(p.sin_aterrizaje, 0)                                                        as sin_aterrizaje,
    coalesce(p.sin_aterrizaje_seguro, 0)                                                 as sin_aterrizaje_seguro,
    round(100.0 * coalesce(p.sin_aterrizaje_seguro, 0) / nullif(p.vuelos_registro, 0), 1) as pct_sin_aterrizaje_seguro,
    q3.incidencias_100min
from {{ ref('dim_dron') }} d
left join por_dron p using (dron)
left join {{ ref('pregunta_3') }} q3 using (dron)
order by pct_sin_aterrizaje desc nulls last, sin_aterrizaje desc, d.dron
