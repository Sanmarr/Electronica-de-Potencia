#set page(
  paper: "a4",
  margin: (x: 1.8cm, y: 2cm),
  numbering: "1",
)
#set text(
  lang: "es",
  size: 11pt,
)
#set heading(numbering: "1.1 -")

#align(center)[
  #text(size: 20pt, weight: "bold")[Resumen de Electrónica de Potencia]
  #v(2pt)
  #text(size: 13pt, style: "italic")[Clase 1: Convertidores CC-CC Básicos (Modo Continuo — CCM)]
]

#v(10pt)

= Convertidor Buck (Step-Down)

El convertidor Buck es una topología *reductora* de tensión que entrega una tensión media de salida $v_o$ menor o igual a la tensión de entrada $v_d$.

#box(stroke: 1pt, inset: 12pt, radius: 8pt, width: 100%)[
  #highlight[*Análisis de Funcionamiento en Modo Continuo (CCM)*]

  Durante un período de conmutación $T_s$, la llave conmuta con un ciclo de trabajo $D = t_"on" / T_s$:
  
  - *Estado ON ($s$ = "ON"*): Durante $D T_s$, la llave está cerrada. La tensión en el inductor es $v_L = v_d - v_o$.
  - *Estado OFF ($s$ = "OFF"*): Durante $(1-D) T_s$, la llave está abierta y el diodo de libre circulación conduce. La tensión en el inductor es $v_L = -v_o$.

  #v(4pt)
  #highlight[*Deducción de la Tensión de Salida*]

  Aplicando el *balance de volt-segundo* en la inductancia en estado estacionario:
  $ (v_d - v_o) D T_s + (-v_o) (1 - D) T_s = 0 $

  Despejando $v_o$:
  $ (v_d - v_o) D &= v_o (1 - D) \
    v_d D - v_o D &= v_o - v_o D \
    v_o &= v_d dot D $
]

#v(6pt)

== Rizado de Corriente e Inductancia
El rizado pico a pico de corriente en el inductor ($Delta i_L$) se obtiene evaluando el intervalo ON:
$ v_L = L frac(d i_L, d t) => v_d - v_o = L frac(Delta i_L, D T_s) $
$ Delta i_L = frac((v_d - v_o) D T_s, L) = frac(v_d D (1 - D), L f_"sw") $

== Cálculo del Capacitor de Salida ($C$)
La corriente en el capacitor es $i_C = i_L - I_o$. La carga $Delta Q$ retenida equivale al área del triángulo de corriente sobre el valor medio $I_o$:
$ Delta Q = 1/2 dot frac(T_s, 2) dot frac(Delta i_L, 2) = frac(T_s Delta i_L, 8) $

Como $Delta Q = C dot Delta v_o$, sustituyendo $T_s = 1 / f_"sw"$:
$ C = frac(Delta i_L, 8 dot f_"sw" dot Delta v_o) $

#box(stroke: 0.5pt, inset: 10pt, fill: rgb("#f9f9f9"), radius: 6pt, width: 100%)[
  *Ejemplo práctico:* \
  Para $f_"sw" = 100 "kHz"$, $I_o = 10 "A"$, rizado $Delta i_L = 10% dot I_o = 1 "A"$, $V_o = 5 "V"$ y $Delta V_o = 5% dot V_o = 0.25 "V"$:
  $ C = frac(1 "A", 8 dot 100000 "Hz" dot 0.25 "V") = 50 "µF" $
]

#v(10pt)

= Convertidor Boost (Step-Up)

El convertidor Boost es una topología *elevadora* de tensión, donde $v_o > v_d$.

#box(stroke: 1pt, inset: 12pt, radius: 8pt, width: 100%)[
  #highlight[*Análisis de Funcionamiento (CCM)*]

  - *Estado ON ($s$ = "ON"*): La llave se cierra durante $D T_s$. La inductancia se conecta a la entrada acumulando energía con $v_L = v_d$. El capacitor alimenta solo la carga.
  - *Estado OFF ($s$ = "OFF"*): La llave se abre durante $(1-D) T_s$. La inductancia se descarga hacia la salida a través del diodo con $v_L = v_d - v_o$.

  #v(4pt)
  #highlight[*Deducción de la Tensión de Salida*]

  Por balance de volt-segundo en la inductancia:
  $ v_d D T_s + (v_d - v_o) (1 - D) T_s = 0 $
  $ v_d D + v_d - v_d D - v_o (1 - D) &= 0 \
    v_o &= frac(v_d, 1 - D) $
]

#v(6pt)

== Relaciones de Corriente y Capacitor
- *Corriente media en la inductancia ($I_L$):*
  $ I_L = frac(I_o, 1 - D) $
- *Rizado de corriente en el inductor ($Delta i_L$):*
  $ Delta i_L = frac(v_d D, L f_"sw") $
- *Capacidad de salida ($C$):* Durante $D T_s$, la carga es sostenida unicamente por el capacitor ($Delta Q = I_o D T_s$):
  $ C = frac(I_o D, f_"sw" Delta v_o) $

#v(10pt)

= Convertidor Buck-Boost

El convertidor Buck-Boost entrega una tensión de salida cuya magnitud puede ser *mayor o menor* a $v_d$, invirtiendo la polaridad de salida respecto de la entrada.

#box(stroke: 1pt, inset: 12pt, radius: 8pt, width: 100%)[
  #highlight[*Análisis de Funcionamiento (CCM)*]

  - *Estado ON ($s$ = "ON"*): Durante $D T_s$, la inductancia almacena energía de la fuente con $v_L = v_d$.
  - *Estado OFF ($s$ = "OFF"*): Durante $(1-D) T_s$, la inductancia transfiere energía a la carga invirtiendo polaridad, con $v_L = -v_o$.

  #v(4pt)
  #highlight[*Deducción de la Tensión de Salida*]

  Por balance de volt-segundo en la inductancia:
  $ v_d D T_s + (-v_o) (1 - D) T_s = 0 $
  $ v_o = v_d dot frac(D, 1 - D) $
]

#v(6pt)

== Modos de Operación según el Ciclo de Trabajo ($D$)
- *Si $D < 0.5$:* $v_o < v_d$ (modo reductor).
- *Si $D > 0.5$:* $v_o > v_d$ (modo elevador).
- *Si $D = 0.5$:* $v_o = v_d$.

== Corrientes y Dimensionamiento
- *Corriente media en la inductancia:*
  $ I_L = frac(I_o, 1 - D) = frac(I_d, D) $
- *Capacidad de salida ($C$):*
  $ C = frac(I_o D, f_"sw" Delta v_o) $
