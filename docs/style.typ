#import "@preview/ilm:2.1.1": ilm

#let pt(x) = math.bold(math.upright(x))

#let document(
  title: "",
  authors: (),
  date: none,
  body,
) = {

  show raw.where(block: true): it => [
    #block(
      fill: rgb("#f6f8fa"),
      stroke: 0.5pt + rgb("#d0d7de"),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      it,
    )
  ]
  

  set par(justify: true)
  
  show: ilm.with(
    title: title,
    authors: authors,
    date: date,
    table-of-contents: outline(
      depth: 3,
    )
  )
  
  body
}