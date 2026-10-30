-- PLATA · registro de eventos de los drones: una fila por evento (despegue o aterrizaje).
-- Un vuelo ocupa dos filas, unidas por vuelo_id. El giro de este caso: hay vuelos que despegan
-- y nunca registran el aterrizaje (batería agotada, señal perdida…). Aquí no se rellenan ni se
-- borran: un vuelo cojo es justo el dato que interesa, y se detecta en pregunta_4 agrupando por vuelo.
-- Por si el sistema reenvía un evento (entrega «al menos una vez»), se deja uno por evento_id;
-- en el registro del 25-04 no había ninguno repetido, pero el siguiente puede traerlos.
-- El orden que vale es el de la hora del evento (ts), no el de llegada al fichero.
select
    evento_id,
    vuelo_id,
    dron,
    lower(trim(tipo)) as tipo,
    ts::timestamp     as ts
from {{ source('bronce', 'eventos') }}
qualify row_number() over (partition by evento_id order by ts) = 1
