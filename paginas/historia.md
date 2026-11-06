# El DRN-24 falla {{ historia_terreno.veces_resto[0] }} veces más que el resto de la flota: hay que retirarlo a revisión antes del 30 de noviembre

Uno de nuestros nueve drones, el DRN-24, hace el {{ historia_terreno.pct_vuelos_drn24[0] }} % de los vuelos, pero acumula el {{ historia_terreno.pct_incidencias_drn24[0] }} % de las incidencias: {{ historia_terreno.incidencias_100min_drn24[0] }} por cada 100 minutos de vuelo, frente a {{ historia_terreno.incidencias_100min_resto[0] }} del resto. Le pasa con los {{ historia_piloto.total_pilotos[0] }} pilotos, en los {{ historia_encargo.total_encargos[0] }} tipos de encargo y con el mismo viento que a los demás: el problema es el dron. El registro automático del propio dron dice lo mismo: es el que más vuelos pierde sin registrar el aterrizaje. Proponemos que Operaciones lo saque de la agenda y lo mande a una revisión técnica antes del 30 de noviembre de 2026.

```grafico
titular: El DRN-24 tiene {{ historia_terreno.veces_segundo[0] }} veces más incidencias por minuto de vuelo que el segundo dron
modelo: pregunta_3
barras: dron → incidencias_100min
orden: desc
destacar: DRN-24
referencia: historia_terreno.incidencias_100min · media de la flota
```

```grafico
titular: El registro del propio dron apunta al mismo aparato: el DRN-24 es el que más vuelos pierde sin aterrizaje
modelo: pregunta_4
barras: dron → pct_sin_aterrizaje
orden: desc
destacar: DRN-24
```

```grafico
tipo: linea
titular: No es una mala racha: el DRN-24 falla más que el resto casi todas las semanas
modelo: historia_semana
x: semana
y: drn24, resto
leyenda: DRN-24, resto de la flota
```

## Qué proponemos

1. **Retirar el DRN-24 de la agenda de vuelos y mandarlo a una revisión técnica** de batería, estabilidad con viento y aterrizaje, que son sus incidencias más repetidas. Lo hace Operaciones antes del 30 de noviembre de 2026.
2. **Anotar en el parte cada revisión y cada cambio de pieza de los drones**, para poder comparar el antes y el después. Lo hacen los pilotos, con el parte de la próxima entrega.

## Qué no sabemos todavía

- **Qué pieza falla.** El parte dice qué pasó (batería baja, viento fuerte, aterrizaje forzoso…), no por qué. Que sea el aparato y no otra cosa es una hipótesis: no es cosa del viento, de un piloto ni de un encargo, pero solo el taller lo puede confirmar.
- **El registro de eventos es de un solo día** (25 de abril). Además, dos de los vuelos «perdidos» del DRN-24 despegaron poco antes del final del registro y podrían seguir en el aire. Sin ellos, se queda en {{ pregunta_4.pct_sin_aterrizaje_seguro[0] }} %, y la segunda prueba es todavía débil.
- **Son siete semanas** de parte, del 2 de marzo al 22 de abril de 2026, con {{ fact_vuelos.filas }} vuelos. Para medir si la revisión funciona harán falta las semanas siguientes.

## La misma historia para cada audiencia

- **Comité de dirección (5 segundos):** «Un dron, el DRN-24, concentra el {{ historia_terreno.pct_incidencias_drn24[0] }} % de las incidencias: hay que retirarlo».
- **Operaciones (1 minuto):** «El DRN-24 tiene {{ historia_terreno.incidencias_100min_drn24[0] }} incidencias por cada 100 minutos, {{ historia_terreno.veces_resto[0] }} veces más que el resto, casi todas las semanas y con todos los pilotos». Acción 1: retirarlo a revisión antes del 30 de noviembre. Acción 2: anotar las revisiones en el parte.
- **Equipo de datos (5 minutos):** «Incidencias por cada 100 minutos de vuelo, por dron, 2 de marzo a 22 de abril de 2026». Salen de `fact_vuelos` ({{ fact_vuelos.filas }} vuelos, sin repetidos, con las duraciones en texto traducidas y las imposibles corregidas con la mediana). Una incidencia es cualquier anotación en el parte. Se contrastan con el registro de eventos del 25 de abril (`pregunta_4`) y con la meteo diaria.
