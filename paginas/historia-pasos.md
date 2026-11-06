# Cómo se construyó la historia

La portada cuenta el destino. Aquí queda el viaje: la decisión que hay detrás, lo que buscamos en los datos y lo que dejamos fuera.

## Paso 1 · De tema a decisión

De las cuatro preguntas del lakehouse, elegí la que tiene la consecuencia más clara: la 3, el dron que más falla. La 4 llega a la misma conclusión desde otra fuente. Las otras dos (tarifa de agricultura y consumo de LEO MOLINA) piden hablar antes de decidir; un dron que falla pide pararlo.

| Nivel | En Altura Films | Qué obliga a hacer |
|---|---|---|
| Tema | «La fiabilidad de los drones» | Nada: admite cualquier gráfico |
| Pregunta | «¿Qué dron falla más?» | Una medida justa para comparar drones que vuelan distinto: incidencias por cada 100 minutos de vuelo |
| Decisión | «¿Retira Operaciones el DRN-24 para una revisión técnica antes del 30 de noviembre de 2026?» | Quién (el responsable de Operaciones), cuándo (antes del 30 de noviembre) y qué (sacarlo de la agenda de vuelos y mandarlo al taller) |

**La prueba:** después de leer la portada, Operaciones retira o no el DRN-24 de la agenda de vuelos antes del 30 de noviembre.

## Paso 2 · Qué se mueve en los datos

### 2a · El terreno: la flota de Altura Films en siete semanas

```cifras
{{ historia_terreno.vuelos[0] }} | vuelos en el parte
{{ historia_terreno.drones[0] }} | drones
{{ historia_terreno.minutos_vuelo[0] }} | minutos de vuelo
{{ historia_terreno.incidencias[0] }} | vuelos con incidencia
```

```grafico
titular: Vuelos con incidencia por dron, marzo y abril de 2026
modelo: pregunta_3
barras: dron → incidencias
orden: desc
```

Un dron se separa a simple vista: el DRN-24 suma {{ historia_terreno.incidencias_drn24[0] }} de las {{ historia_terreno.incidencias[0] }} incidencias de toda la flota.

```grafico
tipo: linea
titular: Incidencias por cada 100 minutos de vuelo, semana a semana
modelo: historia_semana
x: semana
y: drn24, resto
leyenda: DRN-24, resto de la flota
```

Cada punto es la semana que empieza ese lunes. «Resto de la flota» no es la media de los otros ocho drones: es una tasa conjunta, todas sus incidencias entre todos sus minutos de vuelo, como si fueran un solo dron. Así cada minuto pesa lo mismo y un dron que vuela poco no deforma la cifra. La línea del DRN-24 va por encima de la del resto casi todas las semanas, no solo en una. La última semana está incompleta: el parte termina el 22 de abril.

```grafico
tipo: histograma
titular: Minutos por vuelo, marzo y abril de 2026
modelo: fact_vuelos
columna: minutos_vuelo
```

La mitad de los vuelos dura menos de {{ historia_terreno.mediana_minutos[0] }} minutos (la mediana) y la media es de {{ historia_terreno.media_minutos[0] }}. El p95 dice que el 95 % de los vuelos dura como mucho {{ historia_terreno.p95_minutos[0] }} minutos: solo 1 de cada 20 es más largo. No hay una cola rara después de la limpieza, así que contar las incidencias por minuto de vuelo es una comparación justa.

### 2b · El disparador: las incidencias, divididas por los minutos que vuela cada dron

Contar incidencias favorece al dron que vuela poco. Por eso se divide por los minutos de vuelo:

```grafico
titular: El DRN-24 falla {{ historia_terreno.veces_segundo[0] }} veces más que el segundo dron
modelo: pregunta_3
barras: dron → incidencias_100min
orden: desc
destacar: DRN-24
referencia: historia_terreno.incidencias_100min · media de la flota
```

```grafico
tipo: calor
titular: ¿Es una mala semana o es el dron? Incidencias por cada 100 minutos, por dron y semana (día/mes del lunes)
modelo: historia_dron_semana
filas: dron
columnas: semana
valor: incidencias_100min
orden: desc
destacar: DRN-24
```

El mapa de calor no se normaliza por fila a propósito: lo que interesa es comparar drones entre sí, y el DRN-61 no tiene ninguna incidencia, de modo que su media es 0. Se ve que la fila del DRN-24 se enciende en casi todas las semanas, y la del resto apenas.

**El hallazgo:** el DRN-24 tiene {{ historia_terreno.incidencias_100min_drn24[0] }} incidencias por cada 100 minutos de vuelo, {{ historia_terreno.veces_resto[0] }} veces más que el resto de la flota ({{ historia_terreno.incidencias_100min_resto[0] }}). Vuela el {{ historia_terreno.pct_vuelos_drn24[0] }} % de los vuelos y acumula el {{ historia_terreno.pct_incidencias_drn24[0] }} % de las incidencias. Le pasa casi todas las semanas y con pilotos y encargos distintos, así que el motivo más probable es el propio aparato. Es una hipótesis: el parte no dice qué pieza falla.

### 2c · Qué lo puede explicar

- **Anomalía:** sí. Un dron de nueve concentra más de la mitad de las incidencias.
- **Cambio significativo:** no. El DRN-24 está por encima del resto desde la primera semana de marzo; no hay un antes y un después.
- **Fuerzas del mercado:** el tiempo es lo que la empresa no controla, y se puede comprobar con la meteo. El DRN-24 no vuela con peor tiempo que los demás (gráfico de abajo), así que el viento no lo explica.
- **Iniciativas propias:** lo que la empresa decide es a quién y a qué encargo manda cada dron. Si el DRN-24 lo volara un piloto torpe, o solo hiciera encargos difíciles, el problema sería ese y no el dron. Se comprueba en los dos gráficos de abajo. No sabemos si tuvo una revisión, un cambio de batería o una actualización: el parte no lo registra.

```grafico
titular: El DRN-24 vuela con el mismo viento que el resto de la flota
modelo: historia_viento
barras: grupo → rachas_medias_kmh
```

En sus días de vuelo, el DRN-24 tuvo rachas medias de {{ historia_viento.rachas_medias_kmh[0] }} km/h, frente a {{ historia_viento.rachas_medias_kmh[1] }} km/h del resto. El {{ historia_viento.pct_vuelos_rachas_50[0] }} % de sus vuelos fue en días con rachas de más de 50 km/h, frente al {{ historia_viento.pct_vuelos_rachas_50[1] }} % del resto.

```grafico
titular: Con cada uno de los {{ historia_piloto.total_pilotos[0] }} pilotos, el DRN-24 falla más que el resto de la flota
modelo: historia_piloto
barras: piloto → drn24, resto
leyenda: con el DRN-24, con el resto de la flota
```

```grafico
titular: En cada uno de los {{ historia_encargo.total_encargos[0] }} tipos de encargo, el DRN-24 falla más que el resto de la flota
modelo: historia_encargo
barras: encargo → drn24, resto
leyenda: con el DRN-24, con el resto de la flota
```

Cada par de barras compara a un mismo piloto (o un mismo encargo) consigo mismo: sus vuelos con el DRN-24 frente a sus vuelos con los otros drones. El DRN-24 sale por encima con {{ historia_piloto.pilotos_drn24_peor[0] }} de {{ historia_piloto.total_pilotos[0] }} pilotos y en {{ historia_encargo.encargos_drn24_peor[0] }} de {{ historia_encargo.total_encargos[0] }} encargos. No es el piloto ni el encargo: lo que tienen en común es el dron. Una cautela: cada piloto hizo pocos vuelos con el DRN-24 (entre 4 y 12), así que cada barra por separado es frágil. Lo que pesa es que la diferencia se repite en todas.

## Paso 3 · Qué datos entran y cuáles se quedan fuera

| Dato candidato | ¿Pasa el filtro? | Dónde se usa |
|---|---|---|
| Incidencias por cada 100 minutos de cada dron (P3) | Sí: es la cifra de la decisión | Portada, titular y gráfico-mensaje |
| Vuelos sin aterrizaje registrado de cada dron (P4) | Sí: es una segunda fuente, la del propio dron, que apunta a lo mismo | Portada, segunda prueba |
| Incidencias semana a semana | Sí: demuestra que no es una mala racha | Portada, tercera prueba |
| Rachas de viento de los días de vuelo | Sí, para descartar: si el DRN-24 volara con más viento, la decisión sería otra | Aquí, en el 2c |
| DRN-24 frente al resto, por piloto y por encargo | Sí, para descartar: si fuera un piloto o un encargo, habría que actuar sobre ellos y no sobre el dron | Aquí, en el 2c, y citado en la portada |
| Ingreso por minuto de cada encargo (P1) | No: no cambia si se retira el dron | Fuera |
| Consumo de batería por piloto (P2) | No: el DRN-24 lo vuelan todos los pilotos | Fuera |
| Vuelos con rachas de más de 50 km/h (test protagonista) | No para esta decisión: es otra historia, para la aseguradora | Fuera, en el memo |

**El contraste sin limpiar frente a limpio.** Al limpiar el parte se quitaron 10 vuelos repetidos entre entregas, se leyeron las duraciones escritas como texto y se corrigieron 5 duraciones imposibles (dos negativas y tres de 9.999 minutos):

```grafico
titular: Con o sin limpieza, el DRN-24 es el que más falla
modelo: historia_contraste
barras: dron → sin_limpiar, limpio
leyenda: tal como llegan, limpios
```

La conclusión aguanta: con los datos tal como llegan, el DRN-24 sale con {{ historia_contraste.sin_limpiar[0] }} y, limpio, con {{ historia_contraste.limpio[0] }}. Lo que cambia es el resto. Los drones con un vuelo de 9.999 minutos (como el {{ historia_contraste.dron[2] }}) parecían casi perfectos, porque un vuelo imposible inflaba sus minutos.

```grafico
tipo: eje
titular: Mismos datos, dos lecturas: el eje manda
modelo: pregunta_3
barras: dron → minutos_vuelo
corte: 1800
```

Con el eje cortado, parece que unos drones vuelan muchísimo más que otros. Con el eje honesto se ve que todos vuelan parecido, y por eso es justo compararlos por minuto. Por eso todos los gráficos de barras de la portada empiezan en cero.

> **Alcance.** Parte de vuelos de Altura Films, dos entregas (13 y 23 de abril de 2026) con vuelos del 2 de marzo al 22 de abril: {{ fact_vuelos.filas }} vuelos tras quitar los repetidos, con las duraciones en texto traducidas a minutos y las imposibles corregidas con la mediana de su encargo. Registro de eventos de los drones del 25 de abril: {{ stg_eventos.filas }} eventos. Meteo diaria de {{ stg_meteo_diaria.filas }} días. Una incidencia es cualquier anotación en esa columna del parte.

## Las cinco comprobaciones

- **Hay una decisión detrás:** sí. Operaciones retira o no el DRN-24 antes del 30 de noviembre de 2026.
- **El titular afirma:** sí. Leído sin gráficos, dice cuánto falla el DRN-24 y que hay que retirarlo.
- **Cada cifra tiene fuente:** sí. Todas son marcas del lakehouse, y cada gráfico lleva su modelo al pie. El periodo está en el alcance.
- **La evidencia es diversa:** sí. Hay dos fuentes independientes (el parte de los pilotos y el registro automático del dron), una serie en el tiempo y tres descartes: el viento, los pilotos y los encargos.
- **Lo que no cuadra se dice:** sí. El registro de eventos es de un solo día, dos de los vuelos perdidos podrían seguir en el aire, el parte no dice qué pieza falla y se corrigieron datos.
