= Convertidores Simples

== Convertidor Buck (Step-Down)

#align(center)[#image("images/buck.png", width: 60%)]

El convertidor Buck es una topología *reductora* de tensión que entrega una tensión media de salida $v_o$ menor o igual a la tensión de entrada $v_d$.

#highlight[*Análisis de Funcionamiento en Modo Continuo (CCM)*]

Durante un período de conmutación $T_s$, la llave conmuta con un ciclo de trabajo $D = t_"on" / T_s$:
  
- *Estado ON ($s$ = ON*): Durante $D dot T_s$, la llave está cerrada. La tensión en el inductor es $v_L = v_d - v_o$.
#align(center)[#image("images/buckON.png", width: 40%)]
- *Estado OFF ($s$ = OFF*): Durante $(1-D) dot T_s$, la llave está abierta y el diodo de libre circulación conduce. La tensión en el inductor es $v_L = -v_o$.
#align(center)[#image("images/buckOFF.png", width: 40%)]

#v(4pt)
#highlight[*Deducción de la Tensión de Salida*]

Aplicando el *balance de volt-segundo* en la inductancia en estado estacionario:
$ (v_d - v_o) D T_s + (-v_o) (1 - D) T_s = 0 $

Despejando $v_o$:
$ 
(v_d - v_o) D &= v_o (1 - D) \
  v_d D - v_o D &= v_o - v_o D \
$

#align(center)[
#box(stroke: 1pt,inset: 10pt, fill: rgb("#b1eeb1"))[
$v_o = v_d dot D $]
]


#v(6pt)

=== Rizado de Corriente e Inductancia
El rizado pico a pico de corriente en el inductor ($Delta i_L$) se obtiene evaluando el intervalo ON:
$ v_L = L dot frac(d i_L, d t) => (v_d - v_o) = L dot frac(Delta i_L, D dot T_s) $
$ Delta i_L = frac((v_d - v_o) dot D dot T_s, L) = frac(v_d dot D dot (1 - D), L dot f_"sw") $

#align(center)[#image("images/buckComp.png", width: 100%)]

=== Cálculo del Capacitor de Salida ($C$)
La corriente en el capacitor es $i_C = i_L - I_o$. La corriente del inductor $i_L(t)$ es una onda triangular que oscila simétricamente entre un valor mínimo y maximo. Al restarle el valor medio $I_o$, la corriente del capacitor $i_C(t)$ queda centrada en $0 "A"$.

La carga $Delta Q$ retenida equivale al área del triángulo de corriente sobre el valor medio $I_o$:
$ Delta Q = 1/2 dot (frac(T_s, 2)) dot (frac(Delta i_L, 2)) = frac(T_s Delta i_L, 8) $

Como $Delta Q = C dot Delta v_o$, sustituyendo $T_s = 1 / f_"sw"$:
$ C = frac(Delta i_L, 8 dot f_"sw" dot Delta v_o) $

#box(stroke: 0.5pt, inset: 10pt, fill: rgb("#f9f9f9"), radius: 6pt, width: 100%)[
  *Ejemplo práctico:* \
  Para $f_"sw" = 100 "kHz"$, $I_o = 10 "A"$, rizado $Delta i_L = 10% dot I_o = 1 "A"$, $V_o = 5 "V"$ y $Delta V_o = 5% dot V_o = 0.25 "V"$:
  $ C = frac(1 "A", 8 dot 100000 "Hz" dot 0.25 "V") = 50 "µF" $
]

#v(10pt)

== Convertidor Boost (Step-Up)

#align(center)[#image("images/boost.png", width: 60%)]

El convertidor Boost es una topología *elevadora* de tensión, donde $v_o > v_d$.

  #highlight[*Análisis de Funcionamiento (CCM)*]

  - *Estado ON ($s$ = ON*): La llave se cierra durante $D T_s$. La inductancia se conecta a la entrada acumulando energía con $v_L = v_d$. El capacitor alimenta solo la carga.
  #align(center)[#image("images/boostON.png", width: 40%)]
  - *Estado OFF ($s$ = OFF*): La llave se abre durante $(1-D) T_s$. La inductancia se descarga hacia la salida a través del diodo con $v_L = v_d - v_o$.
  #align(center)[#image("images/boostOFF.png", width: 40%)]

  #v(4pt)
  #highlight[*Deducción de la Tensión de Salida*]

  Por balance de volt-segundo en la inductancia:
  $ v_d D T_s + (v_d - v_o) (1 - D) T_s = 0 $
  $ v_d D + v_d - v_d D - v_o (1 - D) &= 0  $

#align(center)[
#box(stroke: 1pt,inset: 15pt, fill: rgb("#b1eeb1"))[
$v_o = v_d dot frac(1, 1 - D) $
]]

#v(6pt)

=== Relaciones de Corriente y Capacitor
- *Corriente media en la inductancia ($I_L$):*
Por conservacion de la potencia podemos plantear: $P_"in" = P_"out"$ que es lo mismo que decir $V_"d" dot I_"d" = V_"o" dot I_"o"$. Despejando y reemplando obtenemos:

  $ I_L = frac(I_o, 1 - D) $


#align(center)[#image("images/boostComp.png", width: 100%)]

Durante $t_"OFF"$, la corriente del inductor $i_"L(t)"$ va bajando linealmente desde su valor pico $I_"Lmax"$ hasta su valor mínimo $I_"Lmin"$:
 - *Al inicio de $t_"OFF"$*: Como $i_"L"(t) > I_o$, la corriente $i_"C"(t) = i_L"(t)" - I_o$ es positiva y el capacitor se recarga.
 - *Al final de $t_"OFF"$*: Dependiendo del rizado $Delta i_L$ y de la corriente de carga $I_o$, puede ocurrir que el valor mínimo de la rampa $I_"Lmin"$ caiga por debajo de la corriente de carga $I_o$

Si $i_"L" (t)$ cae por debajo de $I_o$ antes de que finalice $t_"OFF"$, la corriente $i_"C" (t) = i_"L" (t) - I_o$ se vuelve negativa en ese último tramo1. Gráficamente, la curva de $i_"C" (t)$ cruza el eje de cero hacia abajo antes de que conmute la llave, formando una pequeña área triangular negativa sombreada debajo del eje cero: ese es el *'triangulito de descarga'*

#align(center)[#image("images/boost2.png", width: 60%)]

- *Rizado de corriente en el inductor ($Delta i_L$):*

Planteamos $v_L = L dot frac(Delta i_L,Delta t)$, despejando obtenemos:

  $ Delta i_L = frac(v_d dot D, L dot f_"sw") $
- *Capacidad de salida ($C$):* Durante $D dot T_s$, la carga es sostenida unicamente por el capacitor ($Delta Q = I_o dot D dot T_s$):
  $ C = frac(I_o dot  D, f_"sw" dot Delta v_o) $

#v(10pt)

== Convertidor Buck-Boost

#align(center)[#image("images/buckBoost.png", width: 60%)]

El convertidor Buck-Boost entrega una tensión de salida cuya magnitud puede ser *mayor o menor* a $v_d$, invirtiendo la polaridad de salida respecto de la entrada.


  #highlight[*Análisis de Funcionamiento (CCM)*]

  - *Estado ON ($s$ = ON*): Durante $D T_s$, la inductancia almacena energía de la fuente con $v_L = v_d$.
  #align(center)[#image("images/buckBoostON.png", width: 40%)]
  - *Estado OFF ($s$ = OFF*): Durante $(1-D) T_s$, la inductancia transfiere energía a la carga invirtiendo polaridad, con $v_L = -v_o$.
#align(center)[#image("images/buckBoostOFF.png", width: 40%)]

  #v(4pt)
  #highlight[*Deducción de la Tensión de Salida*]

  Por balance de volt-segundo en la inductancia:
  $ v_d D T_s + (-v_o) (1 - D) T_s = 0 $

#align(center)[
#box(stroke: 1pt,inset: 12pt, fill: rgb("#b1eeb1"))[
  $ v_o = v_d dot frac(D, 1 - D) $
]]

#v(6pt)

=== Modos de Operación según el Ciclo de Trabajo ($D$)
- *Si $D < 1/2 $ :* $v_o < v_d$ (modo reductor).
- *Si $D > 1/2 $ :* $v_o > v_d$ (modo elevador).
- *Si $D = 1/2 $ :* $v_o = v_d$.

=== Corrientes y Dimensionamiento
- *Corriente media en la inductancia:*
  $ I_L = frac(I_o, 1 - D) = frac(I_d, D) $
- *Capacidad de salida ($C$):*
  $ C = frac(I_o dot D, f_"sw" dot Delta v_o) $

== Perdidas de Conmutacion

#align(center)[#image("images/perdidas.png", width: 100%)]


 - $t_"ri"$ *(rise time de corriente)*: Tiempo que tarda la corriente en subir hasta alcanzar la corriente de carga $I_o$.
 - $t_"fv"$ *(fall time de tensión)*: Tiempo que tarda la tensión en caer desde $V_d$ hasta la tensión de conducción en ON.
 - $t_"rv"$ *(rise time de tensión)*: Tiempo que tarda la tensión en subir de cero a $V_d$ al apagarse la llave.
 - $t_"fi"$ *(fall time de corriente)*: Tiempo que tarda la corriente en caer a cero durante el apagado.

