// =====================================================================
// Resumen: Space Vector Modulation (SVM) y Transformadas (Clase 17)
// ITBA - Electrónica 4 - Dr. Pablo Cossutta
// ====================================================================

// ---------------------------------------------------------------------
// Colores y cajas
// ---------------------------------------------------------------------
#let azul = rgb("#1f5fa8")
#let verde = rgb("#2e7d32")
#let rojo = rgb("#c62828")
#let naranja = rgb("#e65100")

#let caja(titulo, color, cuerpo) = block(
  width: 100%, inset: 8pt, radius: 3pt,
  fill: color.lighten(92%),
  stroke: (left: 2.5pt + color, rest: 0.5pt + color.lighten(55%)),
)[
  #text(weight: "bold", fill: color)[#titulo] \
  #cuerpo
]

#let definicion(cuerpo) = caja("Definición", azul, cuerpo)
#let ejemplo(cuerpo) = caja("Ejemplo", verde, cuerpo)
#let importante(cuerpo) = caja("Importante", rojo, cuerpo)
#let idea(cuerpo) = caja("Idea clave", naranja, cuerpo)

// Marcador de imagen (después lo reemplazás por #image("archivo.png"))
#let imagen(desc) = figure(
  rect(
    width: 100%, height: 3cm, radius: 3pt,
    stroke: (dash: "dashed", paint: gray),
    align(center + horizon, text(fill: gray, size: 8pt)[Imagen: #desc]),
  ),
  caption: desc, kind: image, supplement: [Figura],
)



// =====================================================================
= Repaso: potencia en sistemas monofásicos
// =====================================================================

== Potencia instantánea

Un sistema monofásico queda determinado por una tensión y una corriente senoidales, con la corriente desfasada un ángulo $phi$:

$ v(t) = sqrt(2) V sin(omega t) quad quad i(t) = sqrt(2) I sin(omega t - phi) $

La potencia instantánea es el producto de ambas:

$ p(t) = v(t) i(t) = V I cos phi - V I cos(2 omega t - phi) $

Con una identidad trigonométrica se puede reescribir separando dos partes:

$ p(t) = underbrace(V I cos phi, P) [1 - cos(2 omega t)] - underbrace(V I sin phi, Q) sin(2 omega t) $

#definicion[
  - *$P$ (potencia activa):* amplitud y valor medio de la senoidal que *no se hace negativa*. Es la potencia que realmente se consume (se transforma en trabajo o calor).
  - *$Q$ (potencia reactiva):* amplitud de la senoidal de *valor medio nulo*. Va y vuelve entre fuente y carga sin consumirse.
]

#imagen[$v(t)$, $i(t)$ y $p(t)$ con sus componentes $P$ y $Q$]

#ejemplo[
  $V = 220 "V"$, $I = 10 "A"$, $phi = 30°$:
  - $P = 220 dot 10 dot cos 30° approx 1905 "W"$
  - $Q = 220 dot 10 dot sin 30° = 1100 "VAr"$
]

== Fasores y potencia aparente

Se representan tensión y corriente como números complejos (fasores) con su módulo y su fase:

$ overline(V) = V e^(j phi_V) quad quad overline(I) = I e^(j phi_I) $

La *potencia aparente* compleja reúne $P$ y $Q$ en un solo número:

$ overline(S) = V I cos(phi_V - phi_I) + j V I sin(phi_V - phi_I) = P + j Q $

#imagen[Triángulo de potencias: $P$ en el eje real, $j Q$ en el imaginario y $S$ como hipotenusa]

El *factor de potencia* mide qué fracción de la potencia aparente se aprovecha como activa:

$ "PF" = cos phi = P / S $

#ejemplo[
  Con $P = 1905 "W"$ y $Q = 1100 "VAr"$: $S = sqrt(1905^2 + 1100^2) approx 2200 "VA"$ y $"PF" = 1905 / 2200 approx 0.87$.
]

// =====================================================================
= Sistema trifásico
// =====================================================================

Tres tensiones y tres corrientes de igual amplitud, desfasadas $120°$ ($2 pi / 3$) entre sí:

$ v_a = sqrt(2) V sin(omega t) \ v_b = sqrt(2) V sin(omega t - 2 pi / 3) \ v_c = sqrt(2) V sin(omega t + 2 pi / 3) $

$ i_a = sqrt(2) I sin(omega t - phi) \ i_b = sqrt(2) I sin(omega t - phi - 2 pi / 3) \ i_c = sqrt(2) I sin(omega t - phi + 2 pi / 3) $

Sumando la potencia de las tres fases, cada una tiene un término oscilante a $2 omega$, pero desfasados $4 pi / 3$ entre sí:

$ p(t) = 3 V I cos phi = 3 P $

#idea[
  En un sistema trifásico equilibrado, *las partes que dependen del tiempo se cancelan* (porque $4 pi / 3 = -2 pi / 3$ y los tres términos suman cero). La potencia instantánea total es *constante*, igual a $3 P$. Por eso las máquinas trifásicas giran sin "pulsaciones" de torque.
]

// =====================================================================
= Transformada $alpha beta 0$ (Clarke)
// =====================================================================

== Para qué sirve

Trabajar con tres variables que cumplen $x_a + x_b + x_c = 0$ es redundante: con dos alcanzan. La transformada de Clarke (o Alfa-Beta) convierte las tres magnitudes trifásicas (tensiones o corrientes, desfasadas $plus.minus 120°$) en *tres variables ortogonales*: $x_alpha$, $x_beta$ y $x_0$.

Para un vector genérico $bold(x)_(a b c)(t) = [x_a (t) quad x_b (t) quad x_c (t)]^T$ se define:

$ bold(x)_(alpha beta 0)(t) = bold(T) bold(x)_(a b c)(t) = 2/3 mat(
  1, -1/2, -1/2;
  0, sqrt(3)/2, -sqrt(3)/2;
  1/2, 1/2, 1/2;
) vec(x_a (t), x_b (t), x_c (t)) $

#idea[
  - Si $x_a + x_b + x_c = 0$ (sistema equilibrado sin componente homopolar) → $x_0 = 0$.
  - Entonces alcanza con *dos coordenadas*, que se agrupan en un número complejo:
    $ x_(alpha beta)(t) = x_alpha (t) + j x_beta (t) $
  - La transformación inversa también existe ($exists bold(T)^(-1)$), así que no se pierde información.
]

#imagen[Ejes $a$, $b$, $c$ a $120°$ y ejes ortogonales $alpha$, $beta$]

#ejemplo[
  Tensiones con pico $311 "V"$ (220 V eficaces) en el instante $omega t = 90°$:
  - $v_a = 311 "V"$, $v_b = 311 sin(-30°) = -155.5 "V"$, $v_c = 311 sin(210°) = -155.5 "V"$
  - $v_alpha = 2/3 (311 + 77.75 + 77.75) = 311 "V"$
  - $v_beta = 2/3 dot sqrt(3)/2 (-155.5 + 155.5) = 0$

  Resultado: $v_(alpha beta) = 311 "V"$, es decir, un vector de *módulo igual al pico* de la senoidal. A medida que pasa el tiempo, este vector *gira* con velocidad $omega$ describiendo un círculo.
]

// =====================================================================
= Convertidor fuente de tensión (VSI)
// =====================================================================

El VSI trifásico tiene tres ramas ($a$, $b$, $c$), cada una con un interruptor superior $g_x$ y uno inferior $overline(g_x)$ (complementario), alimentadas por $v_(d c)$. Cada $g_x$ es un IGBT con su diodo en antiparalelo. El nodo $o$ es el negativo del bus y $n$ el neutro de la carga.

#imagen[VSI trifásico con interruptores $g_1$, $g_2$, $g_3$ y sus complementarios, carga conectada en estrella]

La tensión de cada rama respecto del nodo $o$ solo puede ser *$0$ o $v_(d c)$*:

$ vec(v_(a o), v_(b o), v_(c o)) = bold(g) v_(d c) quad "con" quad bold(g) = [g_1 quad g_2 quad g_3]^T quad (g_x in {0, 1}) $

Con tres interruptores hay $2^3 = 8$ combinaciones posibles (8 estados).

#ejemplo[
  Estado $bold(g) = (1, 0, 0)$: $v_(a o) = v_(d c)$, $v_(b o) = v_(c o) = 0$.
  - Respecto del neutro de la carga (carga equilibrada): $v_(a n) = 2/3 v_(d c)$ y $v_(b n) = v_(c n) = -1/3 v_(d c)$.
  - La tensión entre el neutro de la carga y $o$ es $v_(n o) = 1/3 v_(d c)$.
]

// =====================================================================
= Modulación SPWM
// =====================================================================

== Cómo funciona

Tres referencias senoidales ($v_("ref"_a)$, $v_("ref"_b)$, $v_("ref"_c)$) se *comparan con una misma triangular*. Si la referencia es mayor que la triangular, el interruptor superior de esa rama se enciende (g = 1); si no, se apaga (g = 0). Esas señales $bold(g)$ comandan al VSI.

#imagen[Diagrama de bloques VSI-SPWM: referencias, triangular, comparador y VSI]

#imagen[Forma de onda de $v_(a n)$ con SPWM en un período (50 Hz)]

Los niveles posibles son:

#table(
  columns: (auto, 1fr),
  inset: 4pt, stroke: 0.5pt + gray, align: (left, left),
  fill: (x, y) => if y == 0 { azul.lighten(80%) },
  [*Tensión*], [*Valores que puede tomar*],
  [Fase ($v_(a n)$)], [$-2/3 v_(d c)$, $-1/3 v_(d c)$, $0$, $1/3 v_(d c)$, $2/3 v_(d c)$],
  [Modo común ($v_(n o)$)], [$0$, $1/3 v_(d c)$, $2/3 v_(d c)$, $v_(d c)$],
)

== Tensión máxima en la zona lineal

#definicion[
  Con índice de modulación $m_a$ (en zona lineal, $m_a <= 1$):
  - Tensión de rama: $v_(a o, b o, o n) = 1/2 m_a v_(d c)$
  - Tensión de línea: $v_(a b, b c, c a) = sqrt(3)/2 m_a v_(d c)$

  Para generar una tensión de salida de *pico $V$* hace falta un bus de continua de al menos:
  $ v_(d c) >= 2 / m_a V $
]

#ejemplo[
  Se quiere alimentar una carga con $220 "V"$ eficaces de fase, o sea $V = 220 sqrt(2) approx 311 "V"$ de pico, con $m_a = 1$:
  $ v_(d c) >= 2 / 1 dot 311 = 622 "V" $
  Si $m_a = 0.8$, el bus debe ser de al menos $2 / 0.8 dot 311 approx 778 "V"$.
]

#importante[
  Pregunta de la clase: _¿qué sucede si rectifico la tensión de entrada y con eso vuelvo a generar la trifásica?_

  Respuesta (resolución propia, no está en las diapositivas): al rectificar una red de $380 "V"$ de línea se obtiene un bus de unos $1.35 dot 380 approx 513 "V"$, que es menor que los $622 "V"$ del ejemplo anterior. Con SPWM en zona lineal solo se llega a unos $314 "V"$ eficaces de línea. *El inversor no puede devolver la misma tensión que entró*; solo puede generar una menor (o igual con sobremodulación). Esto motiva las técnicas siguientes, que aprovechan mejor el bus.
]

// =====================================================================
= Representación de los estados en $alpha beta$
// =====================================================================

Aplicando Clarke a las tensiones de cada uno de los 8 estados se obtiene un vector en el plano $alpha beta$:

#table(
  columns: 9,
  inset: 3.5pt, stroke: 0.4pt + gray, align: center + horizon,
  fill: (x, y) => if y == 0 { azul.lighten(80%) },
  text(size: 8pt)[*Est.*], text(size: 8pt)[*Vector*], [$g_1$], [$g_2$], [$g_3$],
  [$v_(a b)$], [$v_(b c)$], [$v_(c a)$], [$v_(alpha beta) / v_(d c)$],
  [\#0], [$bold(v)_0$], [0], [0], [0], [0], [0], [0], [0 (cero)],
  [\#1], [$bold(v)_1$], [1], [0], [0], [$v_(d c)$], [0], [$-v_(d c)$], [$2/3$ ($0°$)],
  [\#2], [$bold(v)_2$], [1], [1], [0], [0], [$v_(d c)$], [$-v_(d c)$], [$1/3 + j sqrt(3)/3$ ($60°$)],
  [\#3], [$bold(v)_3$], [0], [1], [0], [$-v_(d c)$], [$v_(d c)$], [0], [$-1/3 + j sqrt(3)/3$ ($120°$)],
  [\#4], [$bold(v)_4$], [0], [1], [1], [$-v_(d c)$], [0], [$v_(d c)$], [$-2/3$ ($180°$)],
  [\#5], [$bold(v)_5$], [0], [0], [1], [0], [$-v_(d c)$], [$v_(d c)$], [$-1/3 - j sqrt(3)/3$ ($240°$)],
  [\#6], [$bold(v)_6$], [1], [0], [1], [$v_(d c)$], [$-v_(d c)$], [0], [$1/3 - j sqrt(3)/3$ ($300°$)],
  [\#7], [$bold(v)_7$], [1], [1], [1], [0], [0], [0], [0 (cero)],
)

#idea[
  - Los estados *\#1 a \#6* dan seis vectores *activos* de módulo $2/3 v_(d c)$, separados $60°$. Forman los vértices de un *hexágono* de radio $2/3 v_(d c)$.
  - Los estados *\#0 y \#7* dan el vector *nulo*: ambos caen en el origen (todas las ramas conectadas al mismo nodo, la tensión de línea es cero).
  - El plano se divide en *6 sectores* de $60°$: el sector $k$ está entre $bold(v)_k$ y $bold(v)_(k+1)$ (el sector 6 entre $bold(v)_6$ y $bold(v)_1$).
]

#imagen[Hexágono en $alpha beta$ con $bold(v)_1$ a $bold(v)_6$, $bold(v)_(0,7)$ en el centro y los 6 sectores]

#ejemplo[
  El estado \#1 se obtiene con $g_(1,2,3) = 100$ (arriba $a$, abajo $b$ y $c$), que también se puede escribir como $overline(g)_(1,2,3) = 011$. En el diagrama se rotula cada vértice con las dos combinaciones que lo generan (por ejemplo \#2 = 110 arriba, 001 abajo).
]

// =====================================================================
= Inyección de tercer armónico (THI)
// =====================================================================

En la zona lineal de SPWM, la referencia *no puede superar* a la triangular (pico $<=$ 1 en valores normalizados). Eso limita la fundamental.

#idea[
  Si a las *tres fases* se les suma la misma señal (un tercer armónico, de frecuencia $3 omega$), la referencia resultante queda aplastada y se puede *subir la amplitud de la fundamental* sin que el pico supere la triangular.

  Como el tercer armónico es *igual en las tres fases* (es de modo común), *se cancela en las tensiones de línea* y la carga no lo ve.
]

#imagen[Referencia con tercer armónico (azul) y fundamental aumentada (rojo punteado)]

Según la figura de la clase, la fundamental llega a aproximadamente $1.15$ veces el valor máximo de la referencia original (alrededor de un $15 %$ más de tensión con el mismo bus).

// =====================================================================
= SVM: Space Vector Modulation
// =====================================================================

== Idea

En lugar de comparar tres senoidales con una triangular, se piensa directamente en el *vector de referencia* $bold(V)_("out")$ que gira en el plano $alpha beta$. Como el inversor solo tiene 8 vectores, se *aproxima el vector deseado promediando* los vectores vecinos durante un período de conmutación $T$:

$ bold(V)_("out") = (T_1 bold(v)_1 + T_2 bold(v)_2 + T_0 bold(v)_0) / T = D_1 bold(v)_1 + D_2 bold(v)_2 + D_0 bold(v)_0 $

con $T_1 + T_2 + T_0 = T$ (los tiempos suman siempre el período) y $D_i = T_i / T$ los ciclos de trabajo.

#imagen[Descomposición de $bold(V)_("out")$ en $bold(v)_1 T_1$ y $bold(v)_3 T_3$ (o $bold(v)_2 T_2$) más el vector nulo]

#idea[
  - El vector de referencia está entre dos vectores activos *adyacentes* ($bold(v)_k$ y $bold(v)_(k+1)$), que se aplican durante $T_1$ y $T_2$.
  - El tiempo restante $T_0$ se completa con el *vector nulo* ($bold(v)_0$ o $bold(v)_7$).
]

Las preguntas abiertas de la diapositiva son: ¿qué vector nulo se usa ($bold(v)_0$ o $bold(v)_7$)? ¿En qué orden se aplican los vectores? #text(size: 9pt)[(En la práctica se suele repartir $T_0$ entre $bold(v)_0$ y $bold(v)_7$ y ordenar la secuencia para que en cada transición cambie un solo interruptor, reduciendo pérdidas de conmutación. Esto no está desarrollado en las diapositivas.)]

== Pasos para calcular los tiempos

+ Se determina *en qué sector* está la referencia.
+ Se calcula $A$, la amplitud de la referencia normalizada al radio del hexágono, y $alpha$, el ángulo de la referencia *medido desde el comienzo del sector*.
+ Se calculan los tiempos:

$ A = (|V_("ref")|) / (2/3 v_(d c)) $

$ T_1 = T A (sin(pi/3 - alpha)) / (sin(pi/3)) quad quad T_2 = T A (sin(alpha)) / (sin(pi/3)) quad quad T_0 = T - T_1 - T_2 $

#ejemplo[
  $v_(d c) = 600 "V"$, período de conmutación $T = 100 mu"s"$, referencia $|V_("ref")| = 250 "V"$ a $20°$ dentro del sector 1:
  - $A = 250 / (2/3 dot 600) = 250 / 400 = 0.625$
  - $T_1 = 100 dot 0.625 dot sin(40°) / sin(60°) approx 46.4 mu"s"$ (se aplica $bold(v)_1$)
  - $T_2 = 100 dot 0.625 dot sin(20°) / sin(60°) approx 24.7 mu"s"$ (se aplica $bold(v)_2$)
  - $T_0 = 100 - 46.4 - 24.7 approx 28.9 mu"s"$ (vector nulo)

  Verificación: $T_1 + T_2 + T_0 = 100 mu"s"$. Como $T_1 > T_2$, el vector resultante queda más cerca de $bold(v)_1$, lo cual tiene sentido porque $20° < 30°$.
]

== SVM vs. SPWM

La zona lineal de cada técnica es el *círculo máximo* que puede recorrer la referencia sin salir del hexágono:

#table(
  columns: (auto, 1fr, 1fr),
  inset: 4pt, stroke: 0.5pt + gray, align: center + horizon,
  fill: (x, y) => if y == 0 { azul.lighten(80%) },
  [], [*SPWM*], [*SVM*],
  [Radio del círculo lineal], [$1/2 v_(d c)$], [$1/sqrt(3) v_(d c)$],
  [Radio del hexágono], [$2/3 v_(d c)$], [$2/3 v_(d c)$],
)

#imagen[Hexágono con los círculos de SPWM (radio $1/2 v_(d c)$) y SVM (radio $1/sqrt(3) v_(d c)$)]

#idea[
  El círculo de SVM es *más grande* que el de SPWM: $(1/sqrt(3)) / (1/2) = 2/sqrt(3) approx 1.155$. Con el mismo bus se obtiene aproximadamente *15 % más de tensión* (el mismo beneficio que con tercer armónico) o, a igual tensión, se necesita un bus menor.
]

#ejemplo[
  Con $v_(d c) = 600 "V"$: SPWM llega a $1/2 dot 600 = 300 "V"$ de pico de fase y SVM a $600 / sqrt(3) approx 346 "V"$.
]

// =====================================================================
= Resumen de fórmulas
// =====================================================================

#table(
  columns: (1fr, auto),
  inset: 5pt, stroke: 0.5pt + gray, align: (left, center),
  fill: (x, y) => if y == 0 { azul.lighten(80%) },
  [*Concepto*], [*Fórmula*],
  [Potencia activa y reactiva], [$P = V I cos phi$, #h(4pt) $Q = V I sin phi$],
  [Potencia aparente y PF], [$overline(S) = P + j Q$, #h(4pt) $"PF" = P / S$],
  [Potencia trifásica instantánea], [$p(t) = 3 P$],
  [Transformada de Clarke], [$bold(x)_(alpha beta 0) = bold(T) bold(x)_(a b c)$, #h(4pt) $x_(alpha beta) = x_alpha + j x_beta$],
  [Salida del VSI], [$[v_(a o) quad v_(b o) quad v_(c o)]^T = bold(g) v_(d c)$],
  [Tensión de rama SPWM], [$1/2 m_a v_(d c)$],
  [Tensión de línea SPWM], [$sqrt(3)/2 m_a v_(d c)$],
  [Bus mínimo], [$v_(d c) >= 2 V / m_a$],
  [Radio del hexágono], [$2/3 v_(d c)$],
  [Referencia SVM], [$bold(V)_("out") = D_1 bold(v)_1 + D_2 bold(v)_2 + D_0 bold(v)_0$],
  [Tiempos SVM], [$T_1 = T A sin(pi/3 - alpha) / sin(pi/3)$, #h(4pt) $T_2 = T A sin(alpha) / sin(pi/3)$],
  [Amplitud normalizada], [$A = |V_("ref")| / (2/3 v_(d c))$],
)
