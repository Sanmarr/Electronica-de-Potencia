// =====================================================================
// Resumen: Inverters y Convertidores Directos (Clases 14, 15 y 16)
// ITBA - 22.14 Electrónica IV / 22.28 Electrónica de Potencia
// Fuente: "Power Electronics" - Mohan, Undeland & Robbins
// =====================================================================

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


// (Clase 14)
// =====================================================================
= Inversores DC-AC
// =====================================================================

== La rama de inversor 

=== De dos convertidores a una sola rama

Un *Buck* baja tensión llevando energía de $V_d$ a $V_o$ (con $V_d > V_o$) usando un transistor $Q_1$ y un diodo. Un *Boost* hace el camino contrario, de $V_o$ a $V_d$, usando un transistor $Q_2$ y su diodo.

Si juntamos los dos circuitos compartiendo el mismo inductor, obtenemos una *rama* (half-bridge leg): dos transistores en serie, cada uno con su diodo en antiparalelo, y el punto medio $v_a$ conectado al inductor.

//#imagen[Buck + Boost combinados en una rama con $Q_1$ y $Q_2$]

#figure(
  image("images/BuckBoostBaked.pdf", width: 100%)
) <fig:BuckBoost>

#idea[
  - Conmutando $Q_1$ → la energía va de $V_d$ a $V_o$ (efecto Buck).
  - Conmutando $Q_2$ → la energía va de $V_o$ a $V_d$ (efecto Boost).
  - Es una rama *bidireccional*: la corriente del inductor puede ser positiva o negativa.
]

=== Estados de conducción y conmutación

La clave es que *el inductor fuerza la corriente*: cuando se apaga un transistor, la corriente del inductor no puede cortarse y enciende el diodo del otro transistor. Eso fija la tensión $v_a$.

#table(
  columns: (auto, auto, auto, 1fr),
  inset: 8pt, stroke: 0.5pt + gray, align: center + horizon,
  fill: (x, y) => if y == 0 { azul.lighten(80%) },
  [*Estado*], [*$v_a$*], [*$V_L (t) = V_a - V_o$*], [*Qué ocurre*],
  [$(Q_1)$ ON], [$V_d$], [$V_d - V_o$], [Efecto Buck: el inductor se carga desde $V_d$.],
  [$Q_1$ OFF], [$0$], [$-V_o$], [El inductor enciende el diodo de $Q_2$: $v_a = 0$.],
  [$Q_2$ ON], [$0$], [$V_o$], [Efecto Boost: el inductor se carga desde $V_o$.],
  [$Q_2$ OFF], [$V_d$], [$V_o - V_d$], [El inductor enciende el diodo de $Q_1$: $v_a = V_d$.],
)

#figure(
  image("images/formas.png", width: 100%)
) <fig:formas>



=== Blanking-time y prevención de shoot-through

Si $Q_1 = Q_2 = "OFF"$, la tensión $v_a$ depende del *sentido de la corriente* del inductor, que enciende un diodo o el otro y clava $v_a$ en $0$ o en $V_d$.

#importante[
  Esta situación debe evitarse, pero se produce a propósito durante un tiempo corto (*blanking-time* o tiempo muerto) como margen de seguridad para evitar el *shoot-through* (cortocircuito de la rama si $Q_1$ y $Q_2$ conducen a la vez). Genera una distorsión no lineal llamada *efecto del blanking-time*.
]

=== Ciclo de trabajo y corriente del inductor

El valor medio de $v_a$ es $D_(Q_1) dot V_d$. Si ese valor es mayor que $V_o$, el inductor ve tensión media positiva y su corriente $i_L$ *sube*; si es menor, *baja*.



// =====================================================================
== PWM sinusoidal (SPWM)
// =====================================================================

=== Principio de modulación y armónico fundamental

Para fabricar una tensión alterna con una rama, se *compara* una señal de control sinusoidal con una portadora triangular:

- Si $v_"control" > v_"tri"$ → se enciende el transistor de arriba y $v_(A o) = +V_d / 2$.
- Si $v_"control" < v_"tri"$ → se enciende el de abajo y $v_(A o) = -V_d / 2$.

Dentro de un período de conmutación la señal de control se puede considerar *constante*, y entonces el valor medio de la salida en ese período es:

$ v_(A o) = v_"control" / hat(V)_"tri" dot V_d / 2 $

donde al ser $v_"control"$ una senoidal, esos promedios van dibujando otra senoidal, de la misma frecuencia. Esa es la fundamental:

$ 
  v_(A o,"fundamental") = v_(A o 1) =
    (hat(v)_"control" dot sin(2 pi f_1)) / hat(V)_"tri" dot V_d / 2 
$

//#imagen[PWM sinusoidal: $v_"tri"$ vs. $v_"control"$ y salida $v_(A o)$]

#figure(
  image("images/vcontrol.png", width: 70%)
) <fig:vcontrol>

#definicion[
  - *Índice de modulación de amplitud:* 
     $m_a = hat(V)_"control"  / hat(V)_"tri"$

  - *Índice de modulación de frecuencia:* $m_f = f_"tri" / f_"1"$

  El armónico fundamental de la salida vale $(hat(V)_(A o))_1 = m_a dot V_d / 2$ (para $m_a <= 1$).
]

#ejemplo[
  $V_d = 400 "V"$, $m_a = 0.8$, $f_"senoidal" = 50 "Hz"$, $m_f = 15$.
  - Frecuencia de la portadora: $f_"tri" = 15 dot 50 = 750 "Hz"$.
  - Pico de la fundamental en una rama: $0.8 dot 400/2 = 160 "V"$.
  Si subís $m_a$ a $1.0$, el pico sube a $200 "V"$.
]

=== Armónicos de la salida

El PWM no genera una senoidal perfecta: aparecen armónicos *alrededor de $m_f$, $2 m_f$, $3 m_f$...* (múltiplos de la frecuencia de la portadora). Por eso se filtra con inductores o un filtro LC.

En teoría, las frecuencias en las que ocurren armónicos de frecuencia se indican como

$
  f_h = (j dot m_f plus.minus k) dot f_1
$

es decir, el orden armónico h corresponde a la banda lateral número $k$ de $j$ veces la relación de modulación 
de frecuencia $m_f$:

$
  h = j dot (m_f) plus.minus k
$

#figure(
  image("images/armonicos.png", width: 80%)
) <fig:armonicos>






== Inversor trifásico

=== Estructura y tensiones de línea

Son *tres ramas* (A, B y C) conectadas al mismo bus de continua $V_d$. El punto medio del capacitor $N$ es *ficticio*: no se conecta a nada, solo sirve como referencia para analizar.

#figure(
  image("images/trifasico.png", width: 50%)
) <fig:trifasico>

Cada rama se modula con su propia senoidal, desfasadas $120°$ entre sí, pero con *la misma portadora triangular*. La tensión de línea es la diferencia entre dos tensiones de rama:

$ v_(A B) = v_(A N) - v_(B N) $

#figure(
  image("images/trifasico2.png", width: 90%),
  caption:[$V_(o,A)("deseado")=V dot sin(ω t)   
  quad quad 
  V_(o,A\/B)("deseado") = V dot sin(ω t plus.minus 120°)$]
) <fig:trifasico2>

#figure(
  image("images/trifasico3.png", width: 70%)
) <fig:trifasico3>

//#imagen[Señales de control trifásicas y tensiones $v_(A N)$, $v_(B N)$, $v_(A B)$]

=== Selección inteligente de $m_f$

#idea[
  - Si $m_f$ es *entero e impar* → desaparecen los armónicos *pares*.
  - Si $m_f$ es *múltiplo de 3* → desaparecen en la tensión de línea todos los armónicos múltiplos de 3.
]



=== Rango lineal y sobremodulación

El valor rms del voltaje de línea a línea de frecuencia fundamental $V_"LL1"$ se traza como función de $m_a$. 
De modo semejante al PWM monofásico, para valores lo bastante grandes de $m_a$, el PWM degenera a una 
forma de onda de un inversor de ondas cuadradas. 

$
 V_("LL"_1, "rms") = sqrt(6)/2 dot m_a V_d
$

#figure(
  image("images/lineal.png", width: 30%)
) <fig:lineal>

- *Lineal* ($m_a <= 1$): la fundamental crece proporcional a $m_a$:
  $ V_("LL1,rms") = sqrt(3) / (2 sqrt(2)) dot m_a dot V_d $
- *Sobremodulación* ($m_a > 1$): la fundamental crece menos que proporcional y aparecen más armónicos.
- *Onda cuadrada* ($m_a$ muy grande, 3.24 para $m_f = 15$): se llega al máximo posible:
  $ V_("LL1,rms") = sqrt(6) / pi dot V_d $



//#imagen[$V_("LL1")$(rms)$ \/V_d$ en función de $m_a$: lineal, sobremodulación y onda cuadrada]

#ejemplo[
  $V_d = 400 "V"$ y $m_a = 0.8$: $V_("LL1,rms") = 0.612 dot 0.8 dot 400 approx 196 "V"$ de línea. El máximo teórico (onda cuadrada) sería $0.78 dot 400 = 312 "V"$.
]

== Disparo de transistores flotantes

=== El problema del transistor flotante

En una rama, el transistor de arriba ($Q_1$) tiene su source en $v_a$, que *oscila entre $0$ y $V_d$*. Pero el gate se puede polarizar solo con unos $20 "V"$ respecto del source ($B V_(G S) approx 20 "V"$), mientras que $V_d approx 300$ a $400 "V"$. Por lo tanto, la tensión de gate de $Q_1$ debe *"flotar"* acompañando a $v_a$.

//#imagen[Rama con $V_(G S)$ en $Q_1$ y $Q_2$]

#figure(
  image("images/problem.png", width: 50%)
) <fig:problem>

=== Circuito Bootstrap

Es la solución más simple y barata.

#figure(
  image("images/bootstrap.png", width: 50%)
) <fig:bootstrap>

+ Cuando $Q_2$ está *ON*, $v_a approx 0 "V"$. Una fuente $V_(G G)$ carga el capacitor $C_B$ a través de un diodo.
+ Cuando $Q_2$ pasa a *OFF*, $v_a$ sube hasta $approx V_d$. El diodo se polariza en inversa y $C_B$ queda "flotando" cargado, con su borde negativo conectado a $v_a$.
+ Ese capacitor entrega la tensión de gate de $Q_1$ referida a $v_a$.

#figure(
  image("images/bootstrap2.png", width: 70%)
) <fig:bootstrap>

//#imagen[Bootstrap: $Q_2$ ON carga $C_B$; $Q_2$ OFF alimenta el gate de $Q_1$]

#importante[
  Limitación: el capacitor solo se recarga cuando $Q_2$ conduce. Si $Q_2$ nunca se enciende, $C_B$ se descarga.
]

=== Otros métodos de disparo

- *Alimentación aislada + optoacoplador:* cada transistor tiene su propia fuente aislada y el comando llega por un optoacoplador.

#figure(
  image("images/alt.png", width: 40%)
) <fig:alt>

- *Disparo "magnético":* un transformador con aislación tipo flyback lleva la energía al gate.

#importante[
  Para el optoacoplador *no usar un 4N35 o similar* (muy lento). Usar uno pensado para gate-drive, como el FOD3180 o el HCPL314.
]

== Conexión del inversor con la red

=== Circuito y diagrama fasorial

El inversor se conecta a la red (a través de un transformador) con un inductor $L$ por fase. A frecuencia fundamental se analiza con fasores:

$ bold(V)_(A n) = bold(E)_A + j omega_1 L bold(I)_A $

donde $bold(E)_A$ es la tensión de la red (fija) y $bold(V)_(A n)$ es la que el inversor sintetiza. La diferencia es la caída en el inductor, $V_L = j omega_1 L bold(I)_A$, que *siempre está a $90°$ de la corriente*.

//#imagen[Inversor trifásico y diagrama fasorial (Fig. 8-25 y 8-37)]

#figure(
  image("images/diagrma-fasorial.png", width: 70%)
) <fig:diagrma-fasorial>

#figure(
  image("images/diagrma-fasorial2.png", width: 50%)
) <fig:diagrma-fasorial2>

#idea[
  Cambiando *amplitud y fase* de $bold(V)_(A n)$ (el inversor lo controla con $m_a$ y la fase de la senoidal de control), se cambia $bold(I)_A$ y con ella el flujo de potencia. El ángulo $delta$ entre $bold(V)_(A n)$ y $bold(E)_A$ es el que mueve la potencia activa $P$.
]

=== Los cuatro casos de flujo de potencia

#table(
  columns: (auto, 1fr),
  inset: 4pt, stroke: 0.5pt + gray, align: (left, left),
  fill: (x, y) => if y == 0 { azul.lighten(80%) },
  [*Situación*], [*Posición de $bold(I)_A$ respecto de $bold(E)_A$*],
  [Entrega $P$ a la red], [En fase con $bold(E)_A$.],
  [Consume $P$ de la red], [En contrafase ($180°$) con $bold(E)_A$.],
  [Entrega $P$ y $-Q$ a la red], [Adelantada respecto de $bold(E)_A$.],
  [Consume $P$ y entrega $Q$ a la red], [En contrafase, con componente reactiva.],
)

#imagen[Los cuatro diagramas fasoriales (entrega / consume $P$ y $Q$)]

#ejemplo[
  Un inversor solar conectado a la red quiere inyectar solo potencia activa: se controla para que $bold(I)_A$ quede *en fase* con $bold(E)_A$. Para eso hay que generar $bold(V)_(A n)$ adelantada un ángulo $delta$ chico respecto de $bold(E)_A$.
  Si el mismo equipo pasa a ser un rectificador activo (carga de baterías), $bold(I)_A$ se invierte y pasa a estar en contrafase.
]

// (Clase 15)
// =====================================================================
// 
#pagebreak()
= Convertidores directos y aislados
// =====================================================================

== Circuitos básicos (Half-Bridge, Full-Bridge y Push-Pull)

Son convertidores DC-DC con *transformador* de aislación, relación $N_1 : N_2$, y una *Buck a la salida* (rectificador + filtro LC). Los tres circuitos básicos de entrada son:

- *Half Bridge:* dos transistores y dos capacitores en serie; el primario ve $plus.minus V_d / 2$.
- *Full Bridge:* cuatro transistores; el primario ve $plus.minus V_d$.
- *Push-Pull:* dos transistores con primario de punto medio.


//#imagen[Half Bridge, Full Bridge y Push-Pull]

#figure(
  image("images/basic.png", width: 100%)
) <fig:basic>

Para analizar cualquiera de ellos, se reemplaza la etapa de entrada por una fuente $plus.minus V_d$ con una llave en serie con el primario, un puente de diodos y un filtro LC. Se debe cumplir $I_o > I_("o,min")$ (veremos por qué).

#figure(
  image("images/basic2.png", width: 50%)
) <fig:basic2>

== Rectificador de salida: conducción con primario abierto

Con el primario *apagado* ($V_(N_1) = 0$), la corriente del inductor $i_L$ debe seguir circulando (no puede cortarse). Con el puente de diodos, la corriente se *reparte en los 4 diodos*: $i_L / 2$ por cada rama.

Como los cuatro diodos conducen, aplicando Kirchhoff en el secundario:

$ V_(N_2) = v_D - v_D = -v_D + v_D = 0 arrow.r.double V_(N_1) = 0 $

#idea[
  Mientras todos los diodos conduzcan, el secundario queda *cortocircuitado* y la tensión en el transformador es cero. Así el convertidor "se comporta bien" en el tiempo muerto.
]


#figure(
  image("images/oaa.png", width: 85%)
) <fig:oaa>
//#imagen[Puente rectificador con $i_L / 2$ por cada rama]

== Transformador real y corriente de magnetización

Un transformador real tiene inductancia de magnetización $L_m$ y por ella circula $i_(L_m)$ aunque el primario esté abierto. Vista desde el secundario se llama $i_(L_(m 2))$.

Esta corriente se suma o se resta a la que lleva cada diodo, según su sentido:

#table(
  columns: (auto, 1fr),
  inset: 8pt, stroke: 0.5pt + gray, align: (center, left),
  fill: (x, y) => if y == 0 { azul.lighten(80%) },
  [*Sentido de $i_(L_m)$*], [*Corriente en los diodos*],
  [Sale por el punto], [Dos diodos con $i_L / 2 + i_(L_(m 2)) / 2$ y los otros dos con $i_L / 2 - i_(L_(m 2)) / 2$.],
  [Entra por el punto], [Lo mismo pero con los roles invertidos.],
)

#figure(
  image("images/real.png", width: 60%)
) <fig:real>

#importante[
  Para que $V_(N_2) = 0$ cuando el primario está abierto, *todos* los diodos tienen que seguir conduciendo, es decir que ninguna corriente debe ser negativa:
  $ i_("Lmin") / 2 - i_(L_(m 2)) / 2 > 0 $
  Como la salida es una Buck: $i_("Lmin") = I_o - (Delta i_L) / 2$. Por eso *la corriente de salida no puede caer por debajo de un mínimo*, o el convertidor deja de regular.
]

#ejemplo[
  Si $I_o = 10 "A"$ y el ripple del inductor es $Delta i_L = 2 "A"$: $i_("Lmin") = 10 - 1 = 9 "A"$. Entonces la condición $i_("Lmin") / 2 - i_(L_(m 2)) / 2 > 0$ exige $i_(L_(m 2)) < 9 "A"$ para que los cuatro diodos sigan conduciendo.
]

== Convertidor Full Bridge

#figure(
  image("images/fullbridge.png", width: 60%)
) <fig:fullbridge>

=== Etapas de funcionamiento

Se prenden las llaves *en diagonal*: primero el par $Q_1$ y luego, en el semiciclo siguiente, el par $Q_2$. Etapas:

#figure(
  image("images/diag.png", width: 60%)
) <fig:diag>

- *Durante $t_2$* (par $Q_1$ ON): $V_(N_1) = V_d$, $V_(N_2) = (N_2/N_1) V_d$, y el inductor de filtro $L_F$ ve $V_(L_F) = (N_2/N_1) V_d - V_o$, por lo que su corriente *sube*.
- *Durante $t_(3,4,1,6)$* (todo apagado): $V_(N_1) = 0$, $V_(L_F) = -V_o$ y $i_(L_F)$ *baja*.
- *Durante $t_5$* (par $Q_2$ ON): $V_(N_1) = -V_d$, el secundario invierte su polaridad, y el puente rectifica: $L_F$ vuelve a ver $(N_2/N_1) V_d - V_o$.

//#imagen[Full Bridge: formas de onda de $V_(N_1)$, $V_(N_2)$, $V_(L_F)$, $i_(L_F)$ e $i_(L_"mag")$]

#figure(
  image("images/graf.png", width: 50%)
) <fig:graf>

La corriente de magnetización *sube* con el primario en $+V_d$, se queda *constante* con el primario apagado y *baja* con el primario en $-V_d$: el transformador no se satura porque la tensión media es cero (alterna).

=== Ganancia de tensión y balance de volt-segundo

Aplicando balance de volts-segundo al inductor de filtro $L_F$ (el valor medio de la tensión en un inductor es cero), con $D$ definido por el criterio de la inductancia de filtro:

$ ((N_2) / (N_1) V_d - V_o) D T_"sw" = V_o (1 - D) T_"sw" $

#align(center, box(stroke: 0.8pt + azul, inset: 6pt, radius: 3pt)[$ V_o = V_d dot (N_2) / (N_1) dot D $])

#ejemplo[
  Se quiere $V_o = 12 "V"$ desde $V_d = 400 "V"$ con $D = 0.3$:
  $ N_2 / N_1 = V_o / (V_d dot D) = 12 / (400 dot 0.3) = 0.1 $
  O sea un transformador $10 : 1$ (por ejemplo, $N_1 = 20$, $N_2 = 2$).
]

// (Clase 16)
// =====================================================================
= Inversores: aplicaciones
// =====================================================================

== Motor asincrónico de inducción

=== Principio de funcionamiento y velocidad de sincronismo

El *estator* tiene tres bobinados (fases A, B y C) alimentados con tres corrientes desfasadas $120°$. Eso crea un *campo magnético giratorio*. El *rotor* es una jaula de ardilla que "persigue" ese campo, pero siempre más lento: por eso se llama *asincrónico*.

//#imagen[Motor de inducción: estator, rotor y campo giratorio]

#figure(
  image("images/induction3.png", width: 90%)
) <fig:induction3>

#definicion[
  *Velocidad de sincronismo* (a la que gira el campo magnético):
  $ omega_s = (60 f) / (p p f) quad ["RPM"] $
  con $f$ la frecuencia en Hz (la genera el inverter) y $p p f$ los pares de polos por fase (cantidad de pares de bobinados de cada fase: 1, 2, 3...).

  El *deslizamiento* es la diferencia entre el campo y el rotor: $omega_(s l) = omega_s - omega_r$.
]

#ejemplo[
  Motor de $p p f = 2$:
  - $f = 50 "Hz"$ → $omega_s = 60 dot 50 / 2 = 1500 "RPM"$ (el rotor girará un poco menos, ej. 1450 RPM).
  - $f = 25 "Hz"$ → $omega_s = 750 "RPM"$.
  Variando $f$ con el inverter se varía la velocidad del motor.
]

=== Característica torque-velocidad

La curva $T_(e m)$ vs. $omega_r$ tiene una zona prácticamente *lineal* cerca del sincronismo (motor tipo B). Esa es la zona que se usa para *variar velocidad*: el motor trabaja a un deslizamiento chico.

Como la curva se puede correr en frecuencia, con un inverter el motor *puede arrancar con torque máximo* partiendo desde un $omega_s$ bajo (recta naranja de la figura @fig:induction3).

//#imagen[Curva torque-velocidad (Fig. 14-3)]

=== Aceleración y punto de equilibrio

$ T_"motor" - T_"resistente" = J dot(omega) $

La suma de torques es igual al momento de inercia por la aceleración angular. El motor se acelera mientras el torque motor es mayor que el resistente; se estabiliza en la *intersección* de ambas curvas (punto de equilibrio). Si cambia la carga, cambia la velocidad de equilibrio.

#figure(
  image("images/tmotor.png", width: 60%)
) <fig:tmotor>

#ejemplo[
  Una cinta transportadora que se carga con más peso aumenta $T_"resistente"$. La intersección se desplaza hacia una velocidad algo menor (más deslizamiento), hasta que el motor entrega el nuevo torque.
]

=== Control $V / f$ constante

Si bajamos $f$ pero dejamos $V$ fija, el flujo en el entrehierro $B$ sube y el núcleo se *satura*. El flujo es:

$ B = (integral_0^t V_(L m) dif t) / (N A_"min") = V_"RMS" / (4.44 f N A) $

#idea[
  Para que $B$ sea constante hay que mantener *$V_"RMS" / f$ constante*. Así la curva torque-velocidad *se desplaza* en frecuencia sin cambiar de forma ni tamaño (cada recta de la figura $f_1, f_2, f_3, f_4$ es la misma curva corrida).
]

//#imagen[Curvas $T_(e m)$ para distintas frecuencias con $phi_(a g)$ constante]

#figure(
  image("images/Bcte.png", width: 50%)
) <fig:tmotor>

#ejemplo[
  Motor de $380 "V"$ / $50 "Hz"$ ($V / f = 7.6 "V/Hz"$):
  - Para $f = 25 "Hz"$ se aplica $V = 7.6 dot 25 = 190 "V"$.
  - Para $f = 10 "Hz"$ se aplica $V = 76 "V"$.
  En un inverter esto se logra bajando $m_a$ junto con la frecuencia.
]

=== Carga centrífuga (ventiladores, bombas)

En estas cargas, $T_"carga" prop omega^2$. Para que el rotor gire a una cierta velocidad, hay que aplicar la $omega_s$ correspondiente (por ejemplo $omega_(s 3)$ u $omega_(s 2)$ en la figura). Es *la aplicación más común* de los variadores, porque bajar un poco la velocidad ahorra mucha energía.

#ejemplo[
  Si un ventilador baja de 100% a 50% de velocidad, el torque cae a $1/4$ y la potencia (torque × velocidad) a $1/8$ de la inicial.
]

=== Frenado regenerativo

Se *baja de golpe* la frecuencia de $f_0$ a $f_1 < f_0$. Para los tiempos de la electrónica, el rotor mantiene su velocidad por inercia, así que ahora $omega_r > omega_(s 1)$: el deslizamiento es negativo y el torque pasa a ser *negativo*, $T_(e m_1) < 0$.

La máquina pasa a funcionar como *generador*: convierte energía mecánica en eléctrica y la entrega al bus de continua $V_d$.

//#imagen[Frenado: la frecuencia baja de $f_0$ a $f_1$ y el torque se hace negativo]

#figure(
  image("images/gen.png", width: 50%)
) <fig:gen>

#ejemplo[
  Motor de 2 pares de polos girando a 1450 RPM (alimentado a 50 Hz, $omega_s = 1500 "RPM"$). Se baja $f$ a 40 Hz → $omega_(s 1) = 1200 "RPM"$. Como el rotor sigue a 1450 RPM $> 1200$, el motor frena y devuelve energía. El bus $V_d$ sube de tensión: hay que *devolverla a la red* (inverter bidireccional) o *disiparla* en una resistencia.
]

== Conexión Back to Back

El propósito fundamental de la conexión Back-to-Back  es conectar dos sistemas de corriente alterna (CA) que operan a frecuencias o tensiones distintas, permitiendo flujo bidireccional de potencia.

Se conectan *dos inversores* compartiendo el mismo bus de continua (capacitor $V_d$):

- *Lado motor* ($V_x$, $V_y$, $V_z$): alimenta la máquina con $V / F = "cte"$ y puede intercambiar $P$ y $Q$.
- *Lado red* ($V_a$, $V_b$, $V_c$): conectado a la red por inductores; maneja la potencia que entra o sale.

//#imagen[Back to Back con $P$ de la red al motor]

#figure(
  image("images/backToback.png", width: 80%)
) <fig:backToback>


Tiene varios modos de uso:

+ *Variador de velocidad:* $P$ fluye de la red al motor.
+ *Aerogenerador:* el motor opera como generador y $P$ fluye del generador a la red.
+ *Fotovoltaico:* un convertidor Boost ($V_(P V)$ con inductor $N_1$ y diodo) carga el bus de continua, y el inversor del lado red inyecta $P$ a la red.

#ejemplo[
  En un aerogenerador la frecuencia que genera la máquina varía con el viento. El inversor del lado generador la regula y el del lado red siempre entrega $50 "Hz"$ a la red.
]

#table(
  columns: (1.1fr, 1.4fr, 1.4fr),
  inset: 6pt, stroke: 0.5pt + gray, align: (left, left, left),
  fill: (x, y) => if y == 0 { azul.lighten(80%) },
  [*Característica*], [*Rectificador a diodos + Inversor*], [*Inversor Back to Back*],
  [Flujo de energía], [Unidireccional (Red $arrow.r$ Carga)], [*Bidireccional* (Red $arrow.l.r$ Carga)],
  [Frenado del motor], [Disipativo (resistencia de frenado)], [*Regenerativo* (devuelve energía a la red)],
  [Corriente de red], [Picos con alta distorsión (alto THD)], [*Senoidal limpia* con PWM (bajo THD)],
  [Factor de potencia], [No controlable (fijo)], [*Controlable* (típicamente $cos phi = 1$ o reactiva)],
  [Tensión de bus $V_d$], [Variable con la carga y la red], [*Regulada activamente* constante],
  [Aplicaciones típicas], [Cargas pasivas (bombas, ventiladores)], [Aerogeneradores, tracción (trenes), grúas],
)

== FACTS (Flexible AC Transmission Systems)

Un inversor conectado a la red a través de inductores puede controlar *potencia activa y reactiva* sin cambiar la fuente de continua.

Las cargas no lineales (fábricas, rectificadores, hornos) no solo consumen $P$ e intercambian $Q$: producen perturbaciones, armónicas y no linealidades. La potencia total es:

$ S(t) = P + underbrace( Q + tilde(q)(t) + tilde(p)(t), "valor medio nulo") $



#importante[
  Los sistemas eléctricos convencionales deberían entregar *solo $P$* para maximizar el rendimiento. El resto de los términos (reactiva y armónicos) es lo que un FACTS compensa.
]

#idea[
  Como $tilde(q)$ y $tilde(p)$ tienen valor medio nulo, solo producen un *ripple* $Delta V_d$ en el capacitor del bus: el inverter *no necesita una fuente de energía extra* para compensarlos.
]

//#imagen[FACTS: inversor en paralelo con la red y la carga no lineal]

#figure(
  image("images/facts.png", width: 90%)
) <fig:facts>

/*
== Resumen de fórmulas


#table(
  columns: (1fr, auto),
  inset: 8pt, stroke: 0.5pt + gray, align: (left, center),
  fill: (x, y) => if y == 0 { azul.lighten(80%) },
  [*Concepto*], [*Fórmula*],
  [Salida de la rama (SPWM)], [$v_(A o) = (v_"control" / hat(V)_"tri") V_d / 2$],
  [Índices de modulación], [$m_a = V_"sen" / V_"tri"$, #h(4pt) $m_f = f_"tri" / f_"sen"$],
  [Fundamental trifásica, $m_a <= 1$], [$V_("LL1,rms") approx 0.612 m_a V_d$],
  [Máximo (onda cuadrada)], [$V_("LL1,rms") = sqrt(6)/pi V_d approx 0.78 V_d$],
  [Ganancia Full Bridge], [$V_o = V_d (N_2 / N_1) D$],
  [Condición de diodos], [$i_("Lmin") / 2 - i_(L_(m 2)) / 2 > 0$],
  [Velocidad de sincronismo], [$omega_s = 60 f / (p p f)$ RPM],
  [Flujo constante], [$V_"RMS" / f = "cte"$],
  [Dinámica del rotor], [$T_"motor" - T_"resistente" = J dot(omega)$],
  [Inversor y red (fasores)], [$bold(V)_(A n) = bold(E)_A + j omega_1 L bold(I)_A$],
)
*/