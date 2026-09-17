= Diodo Real de Potencia — Recuperación Inversa ($t_"rr"$)

Cuando un diodo conmuta de estado de conducción directa ($I_F$) a bloqueo inverso ($V_R$), la extracción de portadores acumulados genera una corriente inversa pico $I_"rr"$ durante un tiempo $t_"rr"$.

#align(center)[#image("images/diode2.png", width: 100%)]

*Parámetros del Datasheet*
  - $t_"rr"$: Tiempo total de recuperación inversa ($t_"rr" = t_a + t_b$).
  - $t_a$: Tiempo desde que $i_D$ cruza $0$ hasta alcanzar el pico $-I_"rr"$.
  - $t_b$: Tiempo desde $-I_"rr"$ hasta que se recupera el bloqueo.
  - $Q_"rr"$: Carga de recuperación inversa acumulada.
  - $(d i_F)/(d t)$: Pendiente de apagado impuesta por la inductancia del circuito.

  #v(6pt)
  #highlight[*Ecuaciones de Cálculo Práctico*]

  1. *Relación de Carga:*
  $ Q_"rr" approx 1/2 dot I_"rr" dot t_"rr" $

  2. *Corriente Pico Inversa:*
  $ I_"rr" = (d i_F) / (d t) dot t_a $

  3. *Aproximación para $t_a approx t_"rr"$ (Peor Caso):*
  $ I_"rr" approx sqrt(2 dot Q_"rr" dot (d i_F) / (d t)) quad "y" quad t_"rr" approx sqrt((2 dot Q_"rr")/ ((d i_F)/(d t))) $

  4. *Factor de Suavidad (Softness Factor $S$):*
  $ S = t_b / t_a $
  - $S < 1$ (Hard recovery / Snap-off): Produce picos de tensión severos $v = L dot (d i) / (d t)$.
  - $S approx 1$ (Soft recovery): Apagado suave con menor sobretensión y ruido EMI.


== Aplicación Práctica en Convertidores
- *Sobrecorriente en el MOSFET:* Al encender la llave, esta absorbe la corriente de carga $I_o$ más el pico inverso del diodo $I_"rr"$:
  $ I_"MOS,max" = I_o + I_"rr" $
- *Energía Extra por Encendido ($E_"ON,extra"$):*
  $ E_"ON,extra" approx V_R dot Q_"rr"$

#v(12pt)

#pagebreak()
= MOSFET de Potencia — Modelo Capacitivo

#align(center)[#image("images/mos.png", width: 60%)]

*Capacidades del Modelo Circuital vs Datasheet*

Las hojas de datos especifican capacidades de medición que se mapean al modelo equivalente ($C_"gs"$, $C_"gd"$, $C_"ds"$):

- *Entrada ($C_"iss"$):* $C_"iss" = C_"gs" + C_"gd"$
- *Salida ($C_"oss"$):* $C_"oss" = C_"ds" + C_"gd"$
- *Transferencia Inversa ($C_"rss"$):* $C_"rss" = C_"gd"$

#align(center)[#image("images/mos-eq.png", width: 100%)]

*Despeje para Simulación y Cálculo:*
$ C_"gd" &= C_"rss" \
C_"gs" &= C_"iss" - C_"rss" \
C_"ds" &= C_"oss" - C_"rss" $

== Variación de $C_"gd"$ (Efecto Miller)
La capacidad Gate-Drain es altamente no lineal con la tensión $V_"DS"$:
- *A $V_"DS"$ alto* ($V_"DS" approx V_"in"$): Zona de deplexión ancha, $C_"gd" = C_"gd1"$ (valor bajo).
- *A $V_"DS"$ bajo* ($V_"DS" approx 0"V"$): Zona de deplexión angosta, $C_"gd" = C_"gd2"$ (crece hasta 100 veces).

#v(12pt)

== Transitorios de Conmutación (Turn-ON y Turn-OFF)

=== Secuencia de Encendido (Turn-ON)

#align(right)[#image("images/mos-ON.png", width: 80%)]

El proceso de encendido con comando de gate ($V_"GG"$, $R_G$) se divide en 4 etapas:

+ #text(fill: rgb("#b67a0a"))[*Retardo de Encendido: $(t_"d")_"on"$:*]
   - $V_"GS"$ sube desde $0"V"$ hasta la tensión umbral $V_"GS(th)"$.
   - Constante de tiempo: $tau_1 = R_G dot (C_"gs" + C_"gd1")$.
   - $i_D = 0$, $v_"DS" = V_"in"$.

+ #text(fill: rgb("#1780b1"))[*Crecimiento de Corriente: $t_"ri"$* — Rise Time:]
   - $V_"GS"$ sube desde $V_"GS(th)"$ hasta la tensión de meseta $V_"GS"_"Io"$.
   - $i_D$ sube linealmente de $0$ a $I_o$.
   - Tensión de meseta según la transconductancia ($g_m$):
     $ V_"GS"_"Io" = V_"GS(th)" + I_o / g_m $

+ #text(fill: rgb("#c513bc"))[*Caída de Tensión: $t_"fv"$ — Fall Time / Meseta de Miller*]
   - $V_"GS"$ permanece constante en $V_"GS"_"Io"$. La corriente de gate descarga $C_"gd"$.
   - Corriente de gate durante la meseta:
     $ I_"G"_"meseta"  = (V_"GG" - V_"GS"_"Io") / R_G $
   - Tiempo de meseta usando capacidad $C_"gd"$:
     $ t_"fv" = (C_"gd" dot (V_"in" - V_"DS(on)")) / I_"G"_"meseta"  $
   - *Método alternativo con Carga de Gate ($Q_"GD"$ del datasheet):*
     $ t_"fv" = Q_"GD" / I_"G"_"meseta" $

+ #text(fill: rgb("#1c1fda"))[*Conducción Plena:*]
   - $V_"GS"$ sube de $V_"GS"_"Io"$ a $V_"GG"$. El MOSFET entra en zona óhmica con resistencia $r_"DS(on)"$.


#align(center)[#image("images/mos-ON2.png", width: 90%)]



=== Secuencia de Apagado (Turn-OFF)
#align(right)[#image("images/mos-OFF.png", width: 100%)]

#align(center)[#image("images/mos-OFF2.png", width: 80%)]
Es el proceso inverso al encendido:
4. #text(fill: rgb("#1c1fda"))[*Retardo de apagado $(t_"d")_"off"$:*] La corriente de Gate $i_G$ cambia de sentido y comienza a extraer carga del transistor. $V_"GS"$ cae desde $V_"GG"$ hasta la meseta $V_"GS"_"Io"$.
2. #text(fill: rgb("#1780b1"))[*Crecimiento de tensión: $t_"rv"$ — Rise Time de $v_"DS"$:*] $v_"DS"$ sube de $V_"DS(on)"$ a $V_"in"$ mientras $V_"GS"$ sigue en la meseta.
1. #text(fill: rgb("#b67a0a"))[*Caída de corriente: $t_"fi"$ — Fall Time de $i_D$ :*] $i_D$ cae de $I_o$ a $0$ mientras $V_"GS"$ cae de $V_"GS"_"Io"$ a $V_"GS(th)"$.
 

#v(12pt)

== Balance Completo de Pérdidas de Potencia

La potencia total disipada en el transistor determina el disipador térmico requerido.

  #highlight[*Formulario de Pérdidas Totales*]

  1. *Pérdidas por Conducción ($P_"cond"$):*
  $ P_"cond" = I_"D,rms"^2 dot r_"DS(on)" $

  2. *Pérdidas por Conmutación ($P_"sw"$):*
  $ P_"sw" = 1/2 dot V_"in" dot I_o dot (t_"ri" + t_"fv" + t_"rv" + t_"fi") dot f_"sw" $

  3. *Pérdidas en el Circuito de Gate ($P_"gate"$):*
  $ P_"gate" = V_"GG" dot Q_"G,total" dot f_"sw" $

  4. *Potencia Disipada Total ($P_"total"$):*
  $ P_"total" = P_"cond" + P_"sw" + P_"gate" $

