-- Toda duración que llega a bronce tiene un formato que plata sabe leer: un entero («38»),
-- minutos («31 min») u horas y minutos («1h 09min»). Si la app de los pilotos estrena otro,
-- este test lo para aquí en vez de dejar que la mediana lo tape en silencio.
select vuelo, fecha_carga, minutos_vuelo
from {{ source('bronce', 'parte') }}
where not regexp_matches(trim(minutos_vuelo), '^-?[0-9]+$')
  and not regexp_matches(trim(minutos_vuelo), '^[0-9]+ ?min$')
  and not regexp_matches(trim(minutos_vuelo), '^[0-9]+h ?[0-9]+ ?min$')
