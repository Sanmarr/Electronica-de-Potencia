#import "@preview/charged-ieee:0.1.4": ieee

// ============================================================
// NOTA GENERAL: el informe tiene un límite de 6 carillas. Todo
// lo que exceda esa cantidad se considera NO ENTREGADO. Por eso
// esta plantilla usa el formato paper de doble columna (IEEE)
// que recomienda la cátedra. Cuidar la extensión al completar
// cada sección.
// ============================================================

#show: ieee.with(
  title: [Convertidores DC/DC y Transistores MOS — Trabajo Práctico N.°1],
  abstract: [
    // TODO: redactar el abstract al final, cuando ya estén los
    // resultados de simulación y de práctica. 3-5 líneas resumiendo:
    // qué se hizo (diseño y construcción de un convertidor Boost),
    // qué se comparó (teoría, simulación LTSpice y medición real) y
    // la conclusión más relevante (ej: diferencias de ripple, tiempos
    // de conmutación, eficiencia medida, etc.).
    Se diseñó, simuló y construyó un convertidor DC/DC Boost operando
    en el límite entre los modos de conducción continua y discontinua
    (Boundary), junto con su circuito de disparo para el transistor
    MOSFET. Se compararon los resultados teóricos, simulados en
    LTSpice y medidos experimentalmente, analizando las diferencias
    observadas en el ripple de salida, los tiempos de conmutación y el
    comportamiento del circuito en los distintos modos de operación.
  ],
  authors: (
    (
      name: "Integrante 1",
      department: [Electrónica IV],
      organization: [Instituto Tecnológico de Buenos Aires (ITBA)],
      location: [Buenos Aires, Argentina],
      email: "correo1@itba.edu.ar"
    ),
    (
      name: "Integrante 2",
      department: [Electrónica IV],
      organization: [Instituto Tecnológico de Buenos Aires (ITBA)],
      location: [Buenos Aires, Argentina],
      email: "correo2@itba.edu.ar"
    ),
    (
      name: "Integrante 2",
      department: [Electrónica IV],
      organization: [Instituto Tecnológico de Buenos Aires (ITBA)],
      location: [Buenos Aires, Argentina],
      email: "correo2@itba.edu.ar"
    ),
  ),
  index-terms: ("Convertidor Boost", "DC/DC", "MOSFET", "Electrónica de potencia", "LTSpice"),
  figure-supplement: [Fig.],
)

= Introducción
// Sección ya redactada. Ajustar nombres de grupo/materia si hace falta.

El presente informe documenta el diseño, la simulación y la
construcción de un convertidor DC/DC de topología Boost, en el marco
del Trabajo Práctico de Laboratorio N.°1 de la materia Electrónica IV
(22.14/22.28/25.28). El objetivo del trabajo es familiarizarse con el
funcionamiento de los transistores MOS de potencia —su disparo, formas
de onda y tiempos de conmutación— y con el análisis analítico y
empírico de un convertidor DC/DC básico, contemplando sus tres modos
de operación (continuo, *boundary* y discontinuo) y los factores que
afectan su eficiencia.

// TODO: agregar 1-2 oraciones mencionando los valores de diseño
// asignados al grupo (Vd, Vo, ripple, fsw, Io) tomados de la Tabla 1
// de la consigna, y aclarar que se presentan los casos A y B pedidos.

A lo largo del informe se presenta primero el diseño teórico del
convertidor (cálculo de componentes, corrientes, tensiones y modos de
operación), luego el circuito de disparo del MOSFET, la construcción
física del prototipo y, finalmente, la comparación entre los
resultados teóricos, simulados y medidos, junto con las conclusiones
del trabajo.

= Diseño del convertidor Boost <sec:diseno>

== Especificaciones de diseño
// TODO: insertar acá la tabla con los parámetros asignados al grupo
// (Vd, Vo, ΔVo/Vo, fsw, Io para los casos A y B), tal como en la
// Tabla 1 de la consigna. Usar #figure(table(...)) de Typst.
//
// #figure(
//   caption: [Especificaciones de diseño asignadas],
//   table(
//     columns: 3,
//     [Parámetro], [Valor A], [Valor B],
//     [$V_d$], [7 V], [10 V],
//     [$V_o$], [15 V], [15 V],
//     [$Delta V_o \/ V_o$], [3%], [3%],
//     [$f_"sw"$], [75 kHz], [100 kHz],
//     [$I_o$], [400 mA], [550 mA],
//   )
// ) <tab:specs>

Se considera inicialmente un convertidor Boost ideal (sin pérdidas en
el MOSFET, el diodo, el inductor ni el capacitor), con el fin de
obtener los valores teóricos de partida que luego se contrastarán con
la simulación y la medición.

== Relación de conversión y ciclo de trabajo

Para un convertidor Boost ideal operando en conducción continua (CCM),
la relación entre la tensión de entrada y de salida es

$ V_o = V_d / (1 - D) => D = 1 - V_d / V_o $

Reemplazando los valores de diseño:

// TODO: si se corrige el valor de D por caída real del diodo (ítem 2
// de la consigna), agregar esa corrección como subsección aparte más
// abajo (ver "Corrección de D por caída de tensión del diodo").

$ D_a approx 0.54 quad quad D_b approx 0.34 $

Este valor corresponde al caso ideal; en la implementación real será
necesario un ciclo de trabajo levemente mayor para compensar las
caídas de tensión y pérdidas del circuito (ver
#link(<sec:diodo-real>)[sección de corrección por diodo real]).

== Corriente de salida y potencia

La corriente de salida requerida es $I_o$ (dato de diseño). La
potencia entregada a la carga resulta

$ P_o = V_o dot I_o = 15 dot 0.4 = 6 "W" $

y la resistencia equivalente de carga

$ R_o = V_o / I_o $

que para la simulación puede tomarse inicialmente como

$ R_o^a = 37.5 space Omega quad quad R_o^b = 27.3 space Omega $

== Corriente de entrada

Suponiendo un convertidor ideal, la potencia de entrada es igual a la
de salida ($P_d = P_o$), de donde

$ I_d = P_o / V_d = I_o / (1-D) $

$ I_d^a approx 0.857 "A" quad quad I_d^b approx 1.5 "A" $

La corriente promedio del inductor coincide con $I_d$ (toda la
corriente de entrada circula por el inductor):

$ I_L^a approx 0.857 "A" quad quad I_L^b approx 0.825 "A" $

// NOTA: revisar la diferencia entre I_d^b (1.5 A) e I_L^b (0.825 A)
// calculados en las cuentas — deberían coincidir en un Boost ideal.
// Verificar con qué valores de Vd/Vo se calculó cada uno antes de
// pasarlo en limpio al informe final.

== Condición de Boundary

La condición de Boundary ocurre cuando la corriente del inductor llega
exactamente a cero al final de la descarga ($I_(L,"min") = 0$). Con
forma de onda triangular,

$ I_L = I_(L,"pk") / 2 => I_(L,"pk") = 2 I_L $

$ I_(L,"pk")^a approx 1.714 "A" quad quad I_(L,"pk")^b approx 1.65 "A" $

$ Delta I_L^a approx 1.714 "A" quad quad Delta I_L^b approx 1.65 "A" $

// TODO: acá conviene agregar la forma de onda teórica de i_L(t) en
// modo Boundary (gráfico triangular con I_min=0), como pide el punto
// 1 de la consigna. También agregar las formas de onda para CCM y
// DCM (con la carga máxima que permitan los componentes).

== Cálculo del inductor

A partir de $V_L = L dot (Delta I_L)/(Delta t)$, en Boundary
($Delta I_L = 2 I_L$):

$ L = (V_d dot D) / (f_"sw" dot Delta I_L) $

$ L^a approx (7 dot 0.54)/(75"kHz" dot 1.714"A") approx 29.1 mu"H" approx 30 mu"H" $

$ L^b approx (10 dot 0.34)/(100"kHz" dot 1.65"A") approx 20.6 mu"H" approx 20 mu"H" $

// NOTA (restricción de la consigna): el inductor debe bobinarse sobre
// un núcleo RM8 N87 (TDK B65811J0000R087) y carrete B65812N1008D002,
// usando solo una de las dos secciones disponibles. Agregar acá el
// cálculo de vueltas / entrehierro / verificación de saturación una
// vez definido el diseño físico del inductor (con o sin ayuda de la
// asesoría del 28/8).

Si se utiliza exactamente $30 mu"H"$ o $20 mu"H"$, la condición de
Boundary se desplazará levemente respecto del cálculo ideal, por lo
que debe verificarse mediante simulación.

== Ripple de tensión de salida y cálculo del capacitor

El ripple máximo especificado es $Delta V_o \/ V_o = 3%$, es decir

$ Delta V_o = 0.03 dot 15 = 0.45 "V" $

Despreciando el ESR del capacitor,

$ Delta V_o approx (I_o D)/(f_"sw" C) => C >= (I_o D)/(f_"sw" Delta V_o) $

$ C^a >= (0.4 dot 0.54)/(75"kHz" dot 0.45"V") approx 6.32 mu"F" $

$ C^b >= (0.55 dot 0.34)/(100"kHz" dot 0.45"V") approx 4.16 mu"F" $

Para la simulación se selecciona inicialmente $C^a = C^b = 10 mu"F"$,
lo que da margen respecto del mínimo calculado.

// TODO: en el informe final, agregar acá el análisis del ESR real
// del capacitor elegido y cómo modifica el ripple esperado (la
// cátedra insiste en este punto explícitamente).

== Corrección de $D$ por caída de tensión real del diodo <sec:diodo-real>
// TODO (ítem 2 de la consigna, pendiente de cálculo):
// - Elegir el diodo real (ver comentario sobre MUR460 vs MUR160 más
//   abajo) y su V_F típica a la corriente de trabajo.
// - Recalcular D para CCM considerando V_o = (V_d - V_F)/(1-D) + ... 
//   (ajustar según el modelo de diodo con caída V_F usado en la cursada).
// - Explicar qué modifica este nuevo D en las formas de onda (ancho
//   de pulso de disparo, tensión de drain, etc.)

== Rangos de operación y corriente máxima de salida
// TODO (pendiente, pedido por la consigna):
// - Rango de operación del circuito en cada modo (CCM/Boundary/DCM).
// - Corriente de salida en modo Boundary (ya calculada arriba) y
//   corriente máxima de salida que soportan los componentes elegidos.
// - Calcular la/las resistencias de carga (R_o) necesarias para
//   barrer todo el rango de operación pedido, incluyendo el punto de
//   máxima potencia en CCM.

== Valores máximos, mínimos, medios y RMS
// TODO: tabla resumen con V e I (pico, mínimo, medio, RMS) en cada
// componente (inductor, diodo, MOSFET, capacitor) y en cada modo de
// operación (CCM, Boundary, DCM). Es uno de los puntos que la cátedra
// remarca como más importante ("mostrar las corrientes y tensiones en
// todos los componentes en todos los estados del circuito").

== Simulación en LTSpice
// TODO (ítem 3 de la consigna):
// - Armar el modelo en LTSpice con TODOS los valores reales de
//   componentes (no ideales).
// - Insertar figura del esquemático simulado.
// - Insertar formas de onda simuladas (i_L, V_out, V_drain, V_gate)
//   en CCM, Boundary y DCM.
// - Comparar contra las curvas teóricas de las secciones anteriores
//   y explicar las diferencias (empezar con componentes ideales y
//   luego ir incorporando detalles, como recomienda la cátedra).

= Disparo del transistor MOSFET

// TODO: breve introducción (1-2 líneas) explicando que se diseña el
// circuito de disparo (BJT push-pull, según el esquemático de
// referencia) para minimizar los tiempos de conmutación del MOS.

== Diseño del circuito de disparo
// TODO:
// - Justificar la topología de disparo elegida (referencia: par
//   BJT complementario Q1/Q2/Q3 + R1/R5/R6/R3 del esquemático dado).
// - Calcular R_base y R_colector de los BJT de disparo, verificando
//   que soportan la corriente de gate necesaria.
// - Verificar dimensionamiento de R_GATE (ni sobre ni sub-dimensionada
//   — la cátedra penaliza especialmente el sobredimensionamiento).

== Tiempos de conmutación
// TODO (ítem 2.a y 2.b de la consigna):
// - Calcular t_on y t_off teóricos del MOS a máxima carga con los
//   valores reales del circuito propio (no los del esquemático de
//   referencia).
// - Insertar curvas de conmutación teóricas vs. simuladas.
// - Explicar diferencias, distinguiendo cuáles se deben al circuito
//   de disparo, cuáles a los valores de componentes reales y cuáles a
//   otros factores (capacidades parásitas, layout, etc.).

== Potencia disipada y disipador
// TODO (ítem 2.c de la consigna):
// - Calcular potencia disipada en el MOSFET (conducción + conmutación)
//   y en el diodo.
// - Evaluar si se necesita disipador; si es necesario, calcular la
//   resistencia térmica requerida.
// NOTA de la consigna: comparar MUR460 vs MUR160 — usar MUR160 si la
// corriente no supera 1 A (revisar si aplica al caso propio).

= Construcción del prototipo

== Layout y análisis de lazos de corriente
// TODO (ítem 3.a):
// - Insertar el layout físico de componentes (placa universal o PCB).
// - Mostrar los lazos de corriente teóricos en cada etapa de
//   conmutación (ON, OFF, transiciones) y contrastarlos con las
//   simulaciones.
// - Recordar: cables/pistas cortos, evitar lazos entrelazados
//   (acoplamiento magnético).

== Armado físico
// TODO (ítem 3.b): foto de la placa armada (objetivo ~5x5 cm),
// mención de los componentes reales utilizados (disponibles en el
// pañol) y justificación de que no están sobre/sub-dimensionados.

== Mediciones con osciloscopio
// TODO (ítem 3.c). Incluir como mínimo, según las recomendaciones de
// la cátedra (cada imagen con leyenda de qué, dónde y cómo se midió):
// - Tensión y corriente de entrada.
// - Corriente en el inductor.
// - Duty cycle en CCM y en DCM.
// - Tensión de colector/drain al finalizar Ton (comparar caso DCM).
// - Tensión de salida vs. disparo del transistor (V_max/V_min,
//   considerando la carga del capacitor durante Toff y su ESR).
// - Formas de onda combinadas: V_gate + V_drain + V_L, o V_out (AC) +
//   V_gate con escala para ver el ripple.
// - Usar siempre una señal de referencia común (p. ej. V_gate) para
//   poder comparar gráficos entre sí.
// - Barrer la carga entre los extremos de operación para verificar
//   funcionamiento correcto en todos los puntos intermedios.

= Comparación entre teoría, simulación y práctica
// TODO — sección central del informe, no debe faltar:
// - Duty cycle: teórico vs. medido; si difieren, justificar usando la
//   simulación de componentes ideales, modificándola hasta igualar la
//   práctica.
// - Ripple de salida: valor calculado vs. medido; si el real es mayor,
//   proponer y ejecutar un experimento que lo explique (p. ej. cambiar
//   la tecnología del capacitor) — la cátedra valora esto por sobre
//   simplemente “mostrar un osciloscopio sin ripple”.
// - Tiempos de conmutación: teórico vs. simulado vs. medido.
// - Comportamiento en vacío (circuito sin carga): ¿qué se predice y
//   qué se observa?
// - Cualquier otra hipótesis analizada y verificada experimentalmente.

= Conclusiones
// TODO: SOLO observaciones prácticas, no repetir teoría (explícito en
// la consigna). Responder, por ejemplo:
// - ¿Qué pasó / qué no funcionó como se esperaba?
// - ¿Qué fue difícil de medir o construir?
// - ¿Qué se debería cambiar para mejorar el circuito?
// - Aporte extra sugerido por la cátedra: medir eficiencia P_out/P_in.
// Todas las afirmaciones deben estar justificadas (con datos o
// experimentos propios), no solo enunciadas.

// TODO opcional: si se quiere responder el bonus de la consigna
// ("¿Qué hace CTRL+* en MS-Word?"), agregar una línea al final o en
// una nota al pie — no consume espacio relevante de las 6 carillas.

// Si no se usan citas bibliográficas, se puede quitar el parámetro
// "bibliography" del #show: ieee.with(...) de arriba y este bloque.
// #bibliography("refs.bib")
