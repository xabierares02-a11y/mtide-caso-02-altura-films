-- PLATA · el parte diario limpio: la limpieza que hiciste en la J3, ahora como modelo dbt.
-- Cada entrega del parte es una carpeta fecha_carga=… en bronce: aquí se leen todas juntas.
with bruto as (
    select *, parse_filename(filename) as archivo
    from {{ source('bronce', 'parte') }}
),
duracion_legible as (
    -- REMESA 2026-04-23: la app nueva de los pilotos escribe la duración «como la diría una persona».
    -- Qué venía mal: 65 de sus 108 filas traen minutos_vuelo como texto: «31 min» (60 filas) y
    -- «1h 09min» (5 filas). El cast a entero rompía stg_parte y dbt build no llegaba ni a los tests.
    -- Por qué así: se traduce cada formato a minutos aquí, en plata (bronce guarda lo que llegó, tal cual).
    -- «Nh MMmin» se convierte a N*60 + MM: quedarse con el primer número daría 1 minuto, un valor
    -- dentro del rango 1-240 que ningún test detectaría. Los enteros se dejan como venían (también los
    -- negativos y el 9999 de la J3) para que la regla de la mediana de abajo los siga corrigiendo.
    -- Un formato que no sea ninguno de estos queda en null y lo para el test minutos_vuelo_legible.
    select * replace (
        case
            when regexp_matches(trim(minutos_vuelo), '^-?[0-9]+$')
                then trim(minutos_vuelo)::integer
            when regexp_matches(trim(minutos_vuelo), '^[0-9]+ ?min$')
                then regexp_extract(minutos_vuelo, '([0-9]+)', 1)::integer
            when regexp_matches(trim(minutos_vuelo), '^[0-9]+h ?[0-9]+ ?min$')
                then regexp_extract(minutos_vuelo, '([0-9]+)h', 1)::integer * 60
                   + regexp_extract(minutos_vuelo, 'h ?([0-9]+)', 1)::integer
        end as minutos_vuelo
    )
    from bruto
),
sin_dup as (
    -- una fila por vuelo
    select * from duracion_legible
    qualify row_number() over (partition by vuelo order by fecha_carga desc) = 1
),
mediana_encargo as (
    select encargo, median(minutos_vuelo::integer) as minutos_vuelo_mediana
    from sin_dup
    where minutos_vuelo::integer between 1 and 240
    group by encargo
)
select
    s.vuelo,
    s.fecha::date                                              as fecha,
    upper(trim(s.piloto))                                         as piloto,
    s.dron,
    s.encargo,
    case when s.minutos_vuelo::integer between 1 and 240 then s.minutos_vuelo::integer
         else round(m.minutos_vuelo_mediana)::integer end               as minutos_vuelo,
    not (s.minutos_vuelo::integer between 1 and 240)                   as minutos_vuelo_corregido,
    s.wh_bateria::double                                              as wh_bateria,
    s.importe_eur::double                                      as importe_eur,
    s.incidencia,
    s.archivo,
    s.fecha_carga
from sin_dup s
join mediana_encargo m using (encargo)
