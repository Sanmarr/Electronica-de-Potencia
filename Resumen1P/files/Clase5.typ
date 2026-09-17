= Transformadores en Alta Frecuencia

== Modelo Circuital Equivalente
En alta frecuencia, el transformador real no es ideal e incluye elementos parásitos y de almacenamiento magnético que condicionan el diseño:

  #align(center)[#image("images/trafo.png", width: 80%)]

#box(
  stroke: 0.5pt,
  inset: 10pt,
  fill: rgb("#f9f9f9"),
  radius: 6pt,
  width: 100%,
)[
  *Componentes del Modelo Circuital*
  - $N_1, N_2$: Número de vueltas del devanado primario y secundario.
  - $r_1, r_2$: Resistencias del cobre de los bobinados primario y secundario.
  - $L_"l1", L_"l2"$: Inductancias de dispersión (flujo generado por un bobinado no concatenado por el otro).
  - $L_m$: Inductancia de magnetización (almacenamiento de energía magnética en el núcleo).
  - $R_m$: Resistencia de pérdidas en el núcleo (histéresis y corrientes de Foucault).

$
V_1/V_2 = N_1 / N_2
$
]

== Ciclo de Histéresis y Entrehierro (GAP)
La densidad de flujo magnético en el núcleo responde a la integral de la tensión aplicada: $B = frac(1, N A) integral V d t$.

#box(
  stroke: 0.5pt,
  inset: 10pt,
  fill: rgb("#f9f9f9"),
  radius: 6pt,
  width: 100%,
)[
*Efecto y Función del Entrehierro (GAP)*
  - La reluctancia magnética del núcleo es $R = frac(l, mu A)$, y la inductancia $L_"mag" = frac(N^2, R) = A_L dot N^2$.
  - Al introducir un *entrehierro (GAP)*, aumenta fuertemente la reluctancia $R$ del circuito magnético.
  - Esto disminuye la pendiente de la curva $B-H$, lo que permite al núcleo almacenar mayor energía magnética acumulada sin llegar a la saturación ($B_"max"$).
]

#v(10pt)

= Convertidor Flyback (Off-Line Converter)

El convertidor Flyback deriva del convertidor *Buck-Boost*, reemplazando el inductor simple por una inductancia acoplada (transformador) que provee aislación galvánica.

  #align(center)[#image("images/flyback.png", width: 50%)]


*Análisis de Funcionamiento en Modo Continuo (CCM)*

- *Estado ON* ($s = "ON"$): Durante $D T_s$, la llave conmuta aconducción. La tensión de entrada se aplica al primario ($v_"L1" =V_d$) y la corriente $i_"N1"$ crece almacenando energía en $L_m$. El diodo secundario se mantiene bloqueado en inversa.

#align(center)[#image("images/fly-ON.png", width: 60%)]

$
E_1 = 1/2 N_1^2 A_L hat(i_1)^2 =  1/2 N_2^2 A_L hat(i_2)^2
$

#align(center)[#box(stroke: 1pt,inset: 12pt, fill: rgb("#b1eeb1"))[
$ N_1 hat(i_1) = N_2 hat(i_2) $
]]

- *Estado OFF* ($s = "OFF"$): Durante $(1-D) T_s$, la llave se abre. La polaridad en los devanados se invierte, polarizando en directa al diodo secundario y transfiriendo la energía acumulada hacia la carga a través de $N_2$ con $v_"L2" = -V_o$.

#align(center)[#image("images/fly-OFF.png", width: 60%)]

*Deducción de la Tensión de Salida*

#align(center)[#image("images/fly-ded.png", width: 80%)]

Despejando la magnitud de la tensión de salida $|V_o|$:

#align(center)[#box(stroke: 1pt,inset: 12pt, fill: rgb("#b1eeb1"))[
$ |V_o| = V_d dot frac(N_2, N_1) dot frac(D, 1 - D) $
]]

#v(6pt)

== Corrientes y Capacitor de Salida

#align(center)[#image("images/fly-cap.png", width: 100%)]

- *Relación de corrientes entre primario y secundario:*
  $ I_"x2" = frac(N_1, N_2) dot I_"x1" $
- *Corriente de carga continua:* Toda la corriente enviada a la carga atraviesa el diodo secundario durante $t_"OFF"$:
  $ I_o = I_"x2" (1 - D) $
- *Dimensionamiento del capacitor ($C$):*
  - Sin triangulito de descarga extra:
    $ C = frac(I_o D T_s, Delta V_o) = frac(I_o D, f_"sw" Delta V_o) $
  - Con triangulito de descarga en $t_"OFF"$:
    $ C = frac(I_o D T_s + "triangulito", Delta V_o) $

#align(center)[#image("images/fly-curves.png", width: 70%)]

== Ventajas y Desventajas del Convertidor Flyback

#box(
  stroke: 0.5pt,
  inset: 10pt,
  fill: rgb("#f9f9f9"),
  radius: 6pt,
  width: 100%,
)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      *Ventajas:*
      - Posee aislación galvánica.
      - Circuito muy simple y económico ("anda siempre").
      - La relación $N_2 / N_1$ permite realizar grandes saltos de tensión.
      - Permite elegir $D approx 0.5$ para maximizar la eficiencia.
      - Facilita salidas múltiples con regulación cruzada.
    ],
    [
      *Desventajas:*
      - La disipación del *snubber* penaliza el rendimiento.
      - Toda la energía debe almacenarse momentáneamente en el núcleo.
      - Exige un MOSFET que soporte tensión elevada:
        $ V_"DS,max" = V_d + V_o (frac(N_1, N_2)) + V_"Ld" $
        donde $V_"Ld"$ es el sobrepico del snubber.
    ]
  )
]

= Inductancia de Dispersión y Circuito Snubber

#align(center)[#image("images/snubber.png", width: 80%)]

  *Efecto de la Inductancia de Dispersión ($L_"dispersión"$)*
  El flujo generado por el devanado primario que no se concatena con el secundario ($L_"l1"$) no puede transferir su energía al secundario durante el apagado. Esto genera sobrepicos de tensión destructivos $v = L_1 dot (d i) / (d t)$ sobre el transistor MOSFET.

  #align(center)[#image("images/nucleo.png", width: 40%)]

  #v(4pt)
  *Función del Circuito Snubber*
  Se añade un circuito de protección (red RCD o Diodo Zener) en paralelo con el primario para fijar y disipar la energía de $L_"l1"$, recortando los picos de tensión a niveles seguros.

#align(center)[#image("images/snubberRCD.png", width: 60%)]

Reduce la tension en el transistor. $R_"sn"$ disipa en forma de calor la corriente de fuga producida por el indcutor de dispersion primario y $C_"sn"$ garantiza una tension continua sin mucha oscilacion. Si el snubber no tiene los valores optimizados puede sobre-oscilar.

#align(center)[#image("images/snubberRCD2.png", width: 60%)]
