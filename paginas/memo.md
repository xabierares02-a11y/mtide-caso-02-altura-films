# Memo para la dirección de Altura Films

**Para:** Dirección de Altura Films · **Sobre:** {{ fact_vuelos.filas }} vuelos del parte (2 de marzo a 22 de abril de 2026), la meteo diaria y el registro de vuelos del 25 de abril.

## Qué hemos visto

1. **El encargo que menos rinde es {{ pregunta_1.encargo[0] }}**: deja {{ pregunta_1.ingreso_min[0] }} € por minuto de vuelo, menos de la mitad que el siguiente ({{ pregunta_1.encargo[1] }}, {{ pregunta_1.ingreso_min[1] }} €/min) y casi un tercio de lo que deja {{ pregunta_1.encargo[7] }} ({{ pregunta_1.ingreso_min[7] }} €/min).
2. **{{ pregunta_2.piloto[0] }} es quien más batería gasta**: {{ pregunta_2.wh_min[0] }} Wh por minuto, frente a {{ pregunta_2.wh_min[1] }} del siguiente. El resto de pilotos están todos cerca de 2.
3. **El dron {{ pregunta_3.dron[0] }} es el que más falla**: {{ pregunta_3.incidencias_100min[0] }} incidencias por cada 100 minutos ({{ pregunta_3.incidencias[0] }} en {{ pregunta_3.vuelos[0] }} vuelos), casi cuatro veces más que el segundo ({{ pregunta_3.dron[1] }}, {{ pregunta_3.incidencias_100min[1] }}).
4. **El mismo {{ pregunta_4.dron[0] }} es el que más vuelos pierde**: {{ pregunta_4.sin_aterrizaje[0] }} de sus {{ pregunta_4.vuelos_registro[0] }} vuelos del 25 de abril ({{ pregunta_4.pct_sin_aterrizaje[0] }} %) despegaron y no registraron el aterrizaje. Lo dicen dos fuentes que no dependen la una de la otra: el parte que escriben los pilotos y el registro automático del propio dron.
5. **Se ha volado con viento prohibido.** Hubo 53 vuelos en 5 días con rachas de más de 50 km/h, el límite que marca la normativa. Solo uno de ellos tiene anotado «viento fuerte» en el parte.

Las tres primeras respuestas son las mismas que obtuvimos en la J3 con los datos de entonces: la remesa nueva (un 25 % más de vuelos) no cambia ninguna.

## Qué recomendamos

- **Retirar el {{ pregunta_3.dron[0] }} para una revisión técnica**, antes de que una pérdida acabe en accidente. Es el dron con más incidencias ({{ pregunta_3.incidencias_100min[0] }} por 100 min) y con más vuelos sin aterrizaje ({{ pregunta_4.pct_sin_aterrizaje[0] }} %).
- **Prohibir de verdad los vuelos con rachas de más de 50 km/h**: consultar la previsión antes de cada salida y anotarla en el parte. Los 53 vuelos de días prohibidos son un riesgo con la aseguradora, que pide justo esta prueba.
- **Revisar la tarifa de {{ pregunta_1.encargo[0] }}**: a {{ pregunta_1.ingreso_min[0] }} €/min, cada minuto de dron en el aire rinde menos de la mitad que en cualquier otro encargo. Conviene cobrar por tiempo de vuelo o subir el precio mínimo.
- **Hablar con {{ pregunta_2.piloto[0] }} antes de sacar conclusiones**: su consumo ({{ pregunta_2.wh_min[0] }} Wh/min) destaca, pero puede deberse a los drones o los encargos que le tocan, y no a su forma de pilotar.

## Qué no sabemos todavía

- **El registro de vuelos es de un solo día.** Además, dos de los vuelos «perdidos» del {{ pregunta_4.dron[0] }} despegaron poco antes de que se exportara el fichero y podrían seguir en el aire. Si no se cuentan, se queda en {{ pregunta_4.sin_aterrizaje_seguro[0] }} vuelo perdido ({{ pregunta_4.pct_sin_aterrizaje_seguro[0] }} %) y dejaría de ser el primero. Para estar seguros, necesitamos varias semanas de registro completo.
- **La meteo es diaria, no por hora.** Sabemos que esos días hubo rachas de más de 50 km/h, pero no si coincidieron con la hora exacta de cada vuelo. Con la meteo por horas sabríamos cuántos vuelos se hicieron realmente con viento prohibido.
- **El ingreso por minuto no incluye costes** (batería, desplazamiento, horas de edición). Un encargo barato por minuto podría ser rentable si sus costes son bajos.
- **Hemos corregido datos.** 5 vuelos traían duraciones imposibles (negativas o de 9.999 minutos) y se les asignó la duración típica de su tipo de encargo. Y 65 duraciones de la última entrega venían escritas como texto («31 min», «1h 09min») y se tradujeron a minutos.
- **Hemos hecho dos supuestos.** Que una incidencia es cualquier anotación en esa columna del parte, y que un vuelo sin aterrizaje que despegó menos de 75 minutos (el vuelo más largo del parte) antes del final del registro podría no estar perdido.

## Cómo se ha hecho

Los datos viven en un *lakehouse* de tres capas. En **bronce** se guarda cada entrega tal como llegó y no se toca nunca. En **plata** se limpian (`stg_parte`, `stg_meteo_diaria`, `stg_eventos`). En **oro** se organizan en una estrella (`fact_vuelos` con `dim_piloto`, `dim_dron` y `dim_encargo`) y en las cuatro respuestas (`pregunta_1` a `pregunta_4`). Todo se construye y se comprueba con dbt en cada cambio, y este portal se vuelve a publicar solo.

- **El problema de calidad:** la remesa del 23 de abril traía la duración del vuelo escrita como texto por la app nueva de los pilotos, y el proceso se paraba. Se arregló en plata, sin tocar lo recibido. Desde ahora lo vigila el test `minutos_vuelo_legible`, que salta si llega un formato que todavía no sabemos leer.
- **El test protagonista:** `vuelos_con_rachas_fuertes` cruza el parte con la meteo y señala cada vuelo hecho con rachas de más de 50 km/h. Está configurado como **aviso** y no como error a propósito: el dato es correcto, lo que incumple la norma es la operación. Así aparece en cada actualización sin parar el resto del portal, y la dirección lo ve hasta que deje de ocurrir.
