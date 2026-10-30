# 1 · La remesa nueva

**Qué llegó.** Una entrega nueva del parte de vuelos, con fecha de carga 2026-04-23: 108 vuelos del 13 al 22 de abril. Los pilotos habían estrenado una app que escribe la duración del vuelo «como la diría una persona». En la columna `minutos_vuelo`, **65 de las 108 filas** ya no traían un número: 60 venían como `31 min` y 5 como `1h 09min`. El problema empieza justo con esta entrega: en la anterior (2026-04-13) todas las duraciones eran números.

**Cómo lo descubrí.** No se puso rojo ningún test: `dbt build` ni siquiera llegó a ejecutarlos. Falló al construir `stg_parte`, con el error `Could not convert string '31 min' to INT32 ... minutos_vuelo`, y los siete tests quedaron en SKIP. Después le pregunté directamente a bronce con `dbt show --inline`: cuántas filas no eran numéricas en cada `fecha_carga` y con qué formatos. Eso me dio las dos variantes y me confirmó que todas eran de la entrega nueva.

**Cómo lo arreglé.** En plata, en `stg_parte.sql`, añadí un paso que traduce cada formato a minutos: `31 min` → 31 y `1h 09min` → 60 + 9 = 69. Este último era la trampa: si me hubiera quedado con el primer número, habría salido **1 minuto**, un valor dentro del rango válido (1–240) que ningún test habría detectado. Los números que ya venían bien se dejan como estaban, así que la regla de la J3 (sustituir por la mediana del encargo las duraciones imposibles, como -23 o 9999) sigue funcionando igual. Además escribí un test nuevo, `minutos_vuelo_legible`, que se pone rojo si la app empieza a mandar un formato que plata todavía no sabe leer.

**Por qué en plata y no en bronce.** Bronce es la prueba de lo que la empresa nos mandó. Si lo corrigiera a mano, perdería esa prueba y tendría que repetir el arreglo con cada entrega nueva. En plata, el arreglo es código: queda documentado, se aplica solo a cada remesa y lo comprueban los tests.

Resultado: plata tiene ahora **{{ stg_parte.filas }} vuelos**, sin perder ninguno (el test `filas_conservadas` está en verde), y la duración media de la remesa nueva es prácticamente igual a la de la anterior (unos 39 minutos), lo que confirma que la traducción es correcta.
