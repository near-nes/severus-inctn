// SEVERUS poster, A0. Layout and styling; the words are in content.typ.
//
//   typst compile poster.typ
//   typst compile --input fit=1 poster.typ   -> appends a fit report

#import "content.typ" as C

#let navy = rgb("#0e2648")
#let field = rgb("#dceaf7")
#let cardbg = white
#let line-c = rgb("#b6d0e8")
#let blue = rgb("#1b5fa8")
#let soft = rgb("#41556f")

#let PAGE-W = 841mm
#let PAGE-H = 1189mm
#let PAD-X = 26mm
#let GUTTER = 18mm
#let COL-W = (PAGE-W - 2 * PAD-X - GUTTER) / 2
#let BODY-W = COL-W - 22mm
#let PANEL-H = 74mm
#let QR-D = 70mm
#let HEAD-D = 50mm

#set page(
  width: PAGE-W,
  height: PAGE-H,
  margin: (x: PAD-X, top: 0mm, bottom: 24mm),
  fill: white,
)
#set text(font: "Source Sans 3", size: 29pt, fill: rgb("#101820"), lang: "en")
#set par(justify: true, leading: 0.62em, spacing: 1.1em)

// ─── styling helpers handed to content.typ ────────────────────────────────────

#let tab(label) = box(
  fill: navy,
  inset: (x: 9mm, y: 5mm),
  radius: 2mm,
  text(size: 39pt, weight: "bold", fill: white, tracking: 0.5pt, upper(label)),
)

#let card(label, body, height: auto) = block(
  width: 100%,
  height: height,
  above: 22mm,
  fill: cardbg,
  radius: 4mm,
  stroke: 2pt + line-c,
  inset: (x: 11mm, top: 18mm, bottom: 9mm),
)[
  #place(top + left, dx: -3mm, dy: -27mm, tab(label))
  #body
]

#let sub(title) = block(
  above: 15mm,
  below: 4mm,
  text(size: 32pt, weight: "bold", fill: navy, title),
)

#let callout(body) = block(
  width: 100%,
  above: 8mm,
  below: 8mm,
  fill: field,
  radius: 3mm,
  inset: (x: 9mm, y: 8mm),
  text(size: 29pt, fill: navy, body),
)

#let figimg(path, caption, height: none, title: none) = block(
  width: 100%,
  above: 18mm,
  below: 15mm,
  stack(
    dir: ttb,
    spacing: 4mm,
    ..if title == none { () } else {
      (block(inset: (bottom: 5mm), text(size: 27pt, weight: "bold", fill: navy, title)),)
    },
    align(center, if height == none { image(path, width: 100%) } else { image(path, height: height) }),
    text(size: 22pt, fill: soft, caption),
  ),
)

#let stack-fig(levels, coupler: none) = block(
  width: 100%,
  above: 8mm,
  below: 8mm,
)[
  #set par(justify: false)
  #set text(hyphenate: false)
  #block(
    width: 100%,
    below: 4mm,
    inset: (x: 8mm),
    grid(
      columns: (56mm, 1fr, 78mm),
      column-gutter: 9mm,
      text(size: 20pt, fill: soft, tracking: 0.8pt, upper[tool]),
      text(size: 20pt, fill: soft, tracking: 0.8pt, upper[what it computes]),
      text(size: 20pt, fill: soft, tracking: 0.8pt, upper[output]),
    ),
  )
  #for lvl in levels {
    block(
      width: 100%,
      below: 4mm,
      fill: field,
      radius: 3mm,
      inset: (x: 8mm, y: 7mm),
      grid(
        columns: (56mm, 1fr, 78mm),
        column-gutter: 9mm,
        align: horizon,
        if lvl.logo == none {
          text(size: 29pt, weight: "bold", fill: blue, lvl.tool)
        } else {
          align(center, image(lvl.logo, width: 52mm, height: 17mm, fit: "contain"))
        },
        text(size: 25pt, lvl.does),
        if lvl.hands == none {
          text(size: 22pt, fill: blue)[#sym.arrow.r #h(2mm) predicted spiking]
        } else {
          text(size: 22pt, fill: blue)[#sym.arrow.r #h(2mm) #lvl.hands]
        },
      ),
    )
  }
  #if coupler != none {
    block(
      width: 100%,
      above: 5mm,
      inset: (x: 8mm),
      grid(
        columns: (56mm, 1fr),
        column-gutter: 9mm,
        align: horizon,
        align(center, image(coupler.logo, width: 52mm, height: 15mm, fit: "contain")),
        text(size: 22pt, fill: soft, coupler.does),
      ),
    )
  }
]

#let hyp-inner(it) = {
  if it.at("panel", default: none) != none {
    block(width: 100%, below: 6mm, align(center, image(it.panel, height: PANEL-H)))
  }
  block(width: 100%, below: 7mm, text(size: 28pt, weight: "bold", fill: navy)[
    #text(fill: blue)[(#it.n)] #h(1.5mm) #it.title
  ])
  block(width: 100%, text(size: 25pt)[#set par(leading: 0.5em); #it.body])
  block(width: 100%, above: 11mm, text(size: 24pt)[
    #text(fill: blue, weight: "bold", tracking: 0.6pt, upper[predicts]) #h(2mm) #it.predicts
  ])
}

#let hyp-grid(items) = context {
  let cell-w = (BODY-W - 6mm) / 2
  let inner-w = cell-w - 14mm
  let cells = ()
  for i in range(0, items.len(), step: 2) {
    let pair = items.slice(i, calc.min(i + 2, items.len()))
    let h = calc.max(..pair.map(it => measure(block(width: inner-w, hyp-inner(it))).height))
    for it in pair {
      cells.push(block(
        width: 100%,
        height: h + 14mm,
        fill: field,
        radius: 3mm,
        inset: 7mm,
        hyp-inner(it),
      ))
    }
  }
  grid(columns: (1fr, 1fr), column-gutter: 6mm, row-gutter: 6mm, ..cells)
}

#let confound(what, fix) = block(width: 100%, above: 0mm, below: 0mm, grid(
  columns: (1fr, 1fr),
  column-gutter: 7mm,
  block(inset: (y: 2.5mm), text(size: 25pt, what)),
  block(inset: (y: 2.5mm, left: 7mm), stroke: (left: 3pt + blue), text(size: 25pt, fill: soft, fix)),
))

#let confound-head = block(width: 100%, above: 6mm, below: 3mm)[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 7mm,
    text(size: 20pt, fill: soft, tracking: 0.8pt, upper[the confound]),
    block(inset: (left: 7mm), text(size: 20pt, fill: soft, tracking: 0.8pt, upper[what closes it])),
  )
]

#let cite(t) = text(size: 21pt, fill: blue, style: "italic", t)

#let refs(items) = block(width: 100%, above: 6mm)[
  #line(length: 100%, stroke: 1pt + line-c)
  #v(5mm)
  #text(size: 19pt, fill: soft, tracking: 1pt, weight: "bold", upper[References])
  #v(4mm)
  #set par(justify: false, leading: 0.5em, spacing: 0.7em)
  #let per = calc.ceil(items.len() / 2)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 14mm,
    align: top,
    ..range(2).map(c => text(
      size: 17pt,
      fill: soft,
      items.slice(calc.min(c * per, items.len()), calc.min((c + 1) * per, items.len())).join(parbreak()),
    )),
  )
]

#let people(items) = grid(
  columns: (1fr,) * items.len(),
  column-gutter: 5mm,
  ..items.map(p => align(center)[
    #box(
      width: HEAD-D,
      height: HEAD-D,
      clip: true,
      radius: 50%,
      stroke: 2.5pt + rgb("#9dbcda"),
      image(p.img, width: 100%, height: 100%, fit: "cover"),
    )
    #v(3mm)
    #set par(justify: false, leading: 0.45em)
    #text(size: 23pt, fill: rgb("#cfe0f2"), hyphenate: false)[#p.first \ #p.last]
  ]),
)

#let H = (
  sub: sub,
  callout: callout,
  hyp-grid: hyp-grid,
  confound: confound,
  confound-head: confound-head,
  cite: cite,
  figimg: figimg,
  stack-fig: stack-fig,
  refs: refs,
)

#let body = C.make(H, fig-path: 76mm)

// ─── masthead ─────────────────────────────────────────────────────────────────

#let masthead = block(
  width: 100%,
  fill: navy,
  outset: (x: PAD-X),
  inset: (top: 26mm, bottom: 16mm),
)[
  #grid(
    columns: (1fr, 230mm),
    column-gutter: 24mm,
    align: top,
    [
      #par(justify: false, text(size: 60pt, weight: "bold", fill: white, hyphenate: false, C.TITLE))

      #v(8mm)

      #text(size: 28pt, weight: "semibold", fill: rgb("#cfe0f2"), C.AUTHORS)

      #v(2mm)

      #text(size: 23pt, fill: rgb("#9dbcda"), C.AFFIL)

      #v(8mm)
      #line(length: 100%, stroke: 1.5pt + rgb("#3a5a80"))
      #v(8mm)

      #text(size: 31pt, fill: white, C.LEDE)
    ],
    [
      #people(C.PEOPLE)
      #v(10mm)
      #align(right, image("img/logo-strip-white.png", width: 100%))
    ],
  )
]

#masthead

// ─── the cards ────────────────────────────────────────────────────────────────

#v(30mm)

#context {
  let tail = box(width: 0pt, height: 0pt)
  let lc = [#body.left #tail]
  let rc = [#body.right #tail]
  let L = "In silico: multiscale modelling"
  let R = "In vitro: innovative 3D platform"
  let hl = measure(block(width: COL-W, card(L)[#lc])).height
  let hr = measure(block(width: COL-W, card(R)[#rc])).height
  let h = calc.max(hl, hr)

  grid(
    columns: (1fr, GUTTER, 1fr),
    align: top,
    card(L, height: h)[#lc], [], card(R, height: h)[#rc],
  )
}

#card("What happens next")[#body.next]

#v(1fr)

#refs(body.refs)

#grid(
  columns: (1fr, auto),
  align: horizon,
  column-gutter: 16mm,
  block(width: 100%, above: 7mm)[
    #line(length: 100%, stroke: 1pt + line-c)
    #v(7mm)
    #set par(justify: false)
    #text(size: 19pt, fill: soft, C.FUNDER)
    #v(3mm)
    #text(size: 23pt, fill: soft)[
      #C.VENUE #h(6mm) · #h(6mm)
      #link("mailto:alberto.antonietti@polimi.it")[alberto.antonietti\@polimi.it]
      #h(6mm) · #h(6mm) #C.QR-LABEL
    ]
  ],
  image("img/qr-severus.png", width: QR-D),
)

// ─── fit report ───────────────────────────────────────────────────────────────

#if sys.inputs.at("fit", default: "0") == "1" {
  pagebreak()
  context {
    let mm(x) = calc.round(x / 1mm, digits: 1)
    let hl = measure(block(width: BODY-W, body.left)).height
    let hr = measure(block(width: BODY-W, body.right)).height
    let hn = measure(block(width: PAGE-W - 2 * PAD-X - 22mm, body.next)).height
    let chrome = 22mm + 18mm + 11mm
    let hrefs = measure(block(width: PAGE-W - 2 * PAD-X, refs(body.refs))).height
    let used = 30mm + calc.max(hl, hr) + chrome + hn + chrome + hrefs + 14mm + 46mm + 24mm
    let hm = measure(block(width: PAGE-W - 2 * PAD-X, masthead)).height
    set text(size: 26pt)
    [= Fit report

      page #mm(PAGE-H) mm · column width #mm(COL-W) mm · text measure #mm(BODY-W) mm \
      left column #mm(hl) mm · right column #mm(hr) mm · padded to #mm(calc.max(hl, hr)) mm \
      masthead #mm(hm) mm · body below it needs #mm(used) mm \
      #text(fill: rgb("#1b5fa8"))[slack at the foot: #mm(PAGE-H - hm - used) mm —
        grow the two figure placeholders (`fig-stack`, `fig-chip`) to spend it.]
    ]
  }
}
