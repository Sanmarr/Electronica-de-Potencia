
= Límite entre CCM y DCM (Boundary Condition)

Un convertidor opera en el límite (*Boundary*) entre Modo de Conducción Continuo (CCM) y Discontinuo (DCM) cuando el valor mínimo de la corriente del inductor toca exactamente cero ($I_"L,min" = 0$) al final del intervalo de apagado.

#align(center)[#image("images/buckBound.png", width: 60%)]

*Corriente Límite de Carga ($I_"oB"$)*

Dado que en el límite la corriente es un triángulo perfecto con mínimo en $0$:
$ I_"oB" = 1/2 dot Delta i_L $

- *Convertidor Buck (Boundary):*
  $ I_"oB" = (V_d - V_o) / (2 L) dot D T_s = (V_d dot D dot (1 - D)) / (2 dot L dot f_"sw")  $

#align(center)[
#box(stroke: 1pt,inset: 12pt, fill: rgb("#b1eeb1"))[
  $ I_"oB" = 1/2 dot (V_d dot D dot (1 - D)) / (L dot f_"sw")  $
]]

- *Convertidor Boost (Boundary):*
#align(center)[
#box(stroke: 1pt,inset: 12pt, fill: rgb("#b1eeb1"))[
  $ I_"oB" = 1/2 dot (V_d dot D dot (1 - D)^2) / (L dot f_"sw")  $
]]
- *Criterio de Operación:*
  - Si $I_o > I_"oB"$: Modo Continuo (*CCM*).
  - Si $I_o < I_"oB"$: Modo Discontinuo (*DCM*).


== Convertidor Buck en Modo Discontinuo (DCM)

En DCM, la corriente del inductor se anula antes de completar el período $T_s$. El período se divide en 3 tramos:

#align(center)[#image("images/buck-disc.png", width: 60%)]

1. *Tramo ON ($D T_s$):* La llave conduce. $v_L = V_d - V_o$. La corriente sube hasta $I_"L,max" = ((V_d - V_o) / L) D T_s$.

2. *Tramo OFF con corriente ($Delta_1 T_s$):* La llave se abre y el diodo conduce. $v_L = -V_o$. La corriente cae a $0$ en un tiempo $Delta_1 T_s$.

3. *Tramo nulo ($T_s (1 - D - Delta_1)$):* La corriente permanece en $0$. $v_L = 0$ y la carga es sostenida únicamente por el capacitor.

*Deducción de la Tensión de Salida en DCM*

$
  I_o &= 1/2 Delta I_L (D + Delta_1 ) dot T_s \
  Delta I_L &= (v_d - v_o)/(L) dot D T_s = v_o / L dot Delta_1 T_s
$
#align(center)[#box(stroke: 1pt,inset: 12pt, fill: rgb("#b1eeb1"))[
$ v_o / v_d = (D^2) / (D^2 + (2 dot I_o dot L) / (V_d dot T_s)) $
]]

*Propiedad clave:* En DCM, la tensión de salida $V_o$ ya no depende solo del ciclo de trabajo $D$, sino que **aumenta al disminuir la corriente de carga $I_o$**.


#v(10pt)

== Convertidor Boost en Modo Discontinuo (DCM)

#align(center)[#image("images/boost-disc.png", width: 60%)]

De forma análoga al Buck, en el Boost en DCM la inductancia entrega toda su energía acumulada a la salida antes de que termine el ciclo.

*Ecuaciones del Boost en DCM*

$ V_o = V_d dot (1 + (V_d D^2 T_s) / (2 I_o L)) $

*Ciclo de Trabajo Requerido ($D$):*
#align(center)[#box(stroke: 1pt,inset: 12pt, fill: rgb("#b1eeb1"))[
$ D = sqrt((2 I_o L) / (V_d T_s) dot (V_o - V_d) / V_d) $
]]

#v(10pt)

== Causas de Entrada en Modo Discontinuo

Un convertidor diseñado para operar en CCM puede pasar a trabajar en DCM si ocurren los siguientes cambios en el circuito:

#box(
  stroke: 0.5pt,
  inset: 10pt,
  fill: rgb("#f9f9f9"),
  radius: 6pt,
  width: 100%,
)[
  - *Disminución de la corriente de carga ($I_o < I_"oB"$):* Ocurre al aumentar la resistencia de carga $R$.
  - *Disminución de la frecuencia de conmutación ($f_"sw"$):* Aumenta el período $T_s$, incrementando el rizado $Delta i_L$.
  - *Disminución de la inductancia ($L$):* Almacena menos energía y se descarga más rápido.
]




== Consecuencias del modo Discontinuo
#align(center)[#image("images/LC.png", width: 70%)]


*1. Extinción de Corriente y Estado Flotante*

Cuando la corriente del inductor $i_L (t)$ se anula por completo al final del intervalo de descarga, el diodo se apaga de forma natural al no poder conducir en sentido inverso. 

- *En convertidor Buck:* $v_"sw" -> v_o$
- *En convertidor Boost / Flyback:* $v_"sw" -> v_d$





*2. Dinámica del Ringing Parasítico (Oscilación LC) *

  La caída abrupta de corriente al llegar a cero interrumpe el bucle de energía y desencadena un transitorio resonante entre los elementos reactivos del circuito:
  
  - *Capacidad parasitaria total en el nodo ($C_"sw"$):* Corresponde a la suma de la capacidad de salida del MOSFET ($C_"oss"$), la capacidad de juntura del diodo ($C_j$) y las capacidades parásitas de la inductancia y de la pista del PCB ($C_"PCB"$).
  - *Intercambio de energía:* La energía retenida en la capacidad $C_"sw"$ al momento del bloqueo interactúa con la inductancia $L$, formando un *circuito resonante $L C$ amortiguado*.

  #v(4pt)
  #highlight[*Frecuencia de Resonancia y Amortiguamiento*]

  La tensión en el nodo de conmutación $v_"sw"(t)$ oscila amortiguadamente alrededor del nivel de reposo con una frecuencia característica $f_r$:
  $ f_r = 1 / (2 pi sqrt(L dot C_"sw")) $

  Esta oscilación se atenuará paulatinamente antes del inicio del siguiente ciclo debido a la disipación en las resistencias parásitas serie del circuito (ESR de la inductancia y pérdidas en el semiconductor).
#box(
  stroke: 0.5pt,
  inset: 10pt,
  fill: rgb("#f9f9f9"),
  radius: 6pt,
  width: 100%,
)[
*Emisión de Ruido e Interferencia Electromagnética (EMI):* 
El alto $(d v) / (d t)$ de las oscilaciones resonantes en el nodo de conmutación actúa como una antena que radiará y acoplará ruido de alta frecuencia a las pistas vecinas.
]


== Cero en el Semiplano Derecho (RHPZ — Right Half Plane Zero)

#align(center)[#image("images/RPZpng.png", width: 70%)]

En topologías indirectas (Boost, Buck-Boost, Flyback) operando en *CCM*, aparece un cero en el semiplano derecho ($s > 0$) en la función de transferencia del control a la salida.

  #highlight[*Explicación Física del RHPZ*]

  Ante un escalón de carga que requiere subir $V_o$, el lazo de control incrementa el ciclo de trabajo ($D -> D'$):

  1. *Respuesta transitoria inmediata:*
     - Al aumentar $D$, el transistor pasa más tiempo cerrado ($D' T_s$).
     - El tiempo de transferencia de energía hacia la salida se reduce: $(1 - D') T_s < (1 - D) T_s$.
     - La corriente media transferida al capacitor y la carga **cae temporalmente**.
     - Como consecuencia, la tensión de salida $V_o$ **cae inicialmente** antes de empezar a subir.

  2. *Respuesta permanente:*
     - La corriente del inductor sube hasta su nuevo valor de régimen y $V_o$ alcanza el nivel deseado.

  #v(4pt)

  #highlight[*Efecto en la Estabilidad del Control*]
  - *En CCM:* El RHPZ agrega un desfase de $180$ sin atenuar la ganancia (fase no mínima), lo que exige diseñar un controlador PI **lento** para evitar inestabilidad.
  - *En DCM:* La energía del inductor se vacía completamente en cada período, **eliminando el efecto RHPZ a bajas frecuencias** y permitiendo un control de tensión mucho más rápido y estable.

