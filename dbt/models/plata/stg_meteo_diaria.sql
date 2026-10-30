-- PLATA · meteo diaria: una fila por día con el viento medio y las rachas máximas (km/h).
-- Llega limpia (52 días, del 2 de marzo al 22 de abril, sin vacíos): solo se fijan los tipos.
select
    fecha::date              as fecha,
    viento_medio_kmh::double as viento_medio_kmh,
    rachas_kmh::double       as rachas_kmh
from {{ source('bronce', 'meteo_diaria') }}
