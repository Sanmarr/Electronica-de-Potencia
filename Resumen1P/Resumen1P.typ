#import "@preview/mitex:0.2.7": *
 
 ``#set document(
  author: "Ignacio Sammartino",
  description: 
    "Archivo hecho para practicar Typst",
  keywords: "Microelectronica", 
  date: auto
)

//Aca hago una Super caratula
#set page(columns: 1, fill: rgb("444352"),
margin: (
  top: 3cm,
  bottom: 2cm,
  x: 0.8cm,
))

//Mas configuraciones -------------------------------------------------------------------------
#set text(lang: "es")
#set text(fill: rgb("fdfdfd"))


//#set math.equation(numbering: "(1.1)")
// Number equations based on the current section and reset the equation counter
#set heading(numbering: "1.")
#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}

#set math.equation(numbering: n => {
  numbering("(1.1)", counter(heading).get().first(), n)
})

// Customize the reference format
//#show ref: it => {
//  let el = it.element
//  if el != none and el.func() == math.equation {
//    // Reconstructs "Section.Equation" numbering (e.g., Eq. 1.2)
//    [Eq. ] + numbering("(1.1)", counter(heading).get().first(), el.numbering().at//(0))
//  } else {
//    it
//  }
//}
//Mas configuraciones -------------------------------------------------------------------------



//Seteo el formato del texto
#set text(
  //font: "Linux Biolinum O",
  size: 14pt,
  tracking: 0pt, // (Default = 0pt2)
  spacing: 100%,
  fractions: false /* Se rompe por algun motivo con true*/
)

//Formato del titulo
#show title: set text(size: 20pt)
#show title: set align(center)
#show title: set block(below: 4em)

#align(center)[#text(size: 24pt)[Instituto Tecnológico de Buenos Aires (ITBA)]] 

#figure(
  image("files/images/indice/itbaSVG_white.svg", width: 30%)
) <fig:indice>

#title[
25.28 - Electronica IV 2026-2Q

Resumen
]



\


//Aca Termina la caratula


#set page(
    header: context [
    #grid(
      columns: (1fr, auto),
      align: center,
      [#align(left)[25.28 - Electronica IV]],
      [#align(right)[#image("files/images/indice/itbaSVG.svg", width: 33%)]]
    )
  ],
  numbering: "1 of 1",
  columns: 2,
)

#pagebreak()
#set page(columns: 1, fill: rgb("#ffffff"))
#set text(fill: rgb("#000000"))

#set page(numbering: "1 of 1")
#set heading(numbering: "1. 1. a -")
#set math.equation(numbering: none)

#set page(columns: 2)
#outline()
#set page(columns: 1)

#pagebreak()
#include "files/Clase1.typ"

#pagebreak()
#include "files/Clase2.typ"

#pagebreak()
#include "files/Clase3.typ"

#pagebreak()
#include "files/Clase5.typ"
