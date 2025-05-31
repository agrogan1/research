// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "linux libertine",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "linux libertine",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black or heading-decoration == "underline"
           or heading-background-color != none) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)

#show: doc => article(
  title: [Multiple Methods for Multiple Reporters of Child Maltreatment],
  subtitle: [Results from the Lehigh Study],
  authors: (
    ( name: [Lehigh Measurement and Causal Inference Analyses Team],
      affiliation: [],
      email: [] ),
    ),
  date: [2025-05-31],
  sectionnumbering: "1.1.a",
  toc: true,
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)

= Background
<background>
The Lehigh Study presents a unique opportunity. Data are collected on experiences of abusive discipline as reported by #emph[administrative] reports, two #emph[parental] reports at two different time points, and two #emph[self] reports at two different time points. However, in the absence of a gold standard measure of abusive discipline, appropriately aggregating these multiple reports across multiple time points represents an analytic challenge.

In the manuscript below, we employ multiple strategies to estimate the relationship of these multiple reports from multiple reporters at multiple time points to a mental health outcome. We compare and contrast the advantages and disadvantages of these different methods, and conclude the manuscript with suggestions on optimal methodological approaches to confront the methodological challenges that are posed by having multiple reports from multiple reporters at multiple time points.

= Basic Conceptual Model
<basic-conceptual-model>
We begin with a basic conceptual model of the reports and time points in the data, without at this point suggesting any associational or causal relationships.

#figure([
#box(image("Slide1.png"))
], caption: figure.caption(
position: bottom, 
[
conceptual model
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-conceptual>


= Variable Abbreviations
<variable-abbreviations>
For parsimony, we use the following conventions for variable names in equations and statistical syntax.

#figure([
#table(
  columns: 2,
  align: (auto,left,),
  table.header([Variable], [Label],),
  table.hline(),
  [`administrative`], [administrative report],
  [`PR1`], [parental report in early childhood],
  [`PR2`], [parental report in middle childhood],
  [`SR1`], [adolescent self report],
  [`SR2`], [adult self report],
  [`covariates`], [covariates (multiple variables)],
  [`outcome`], [mental health outcome],
)
], caption: figure.caption(
position: top, 
[
Variables and Variable Labels
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-variables>


= Methods
<methods>
== OLS Regression
<ols-regression>
Our outcome is continuous. Therefore we here employ #emph[ordinary least squares regression];. Were our outcome to be dichotomous, we could as easily employ #emph[logistic regression];.

=== Diagram
<diagram>
#figure([
#box(image("Slide2.png"))
], caption: figure.caption(
position: bottom, 
[
OLS
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-OLS>


=== Equation
<equation>
#math.equation(block: true, numbering: "(1)", [ $ upright("outcome") = beta_0 + beta upright("P1") + beta upright("P2") + beta upright("SR1") + beta upright("SR2") + beta upright("administrative") + Sigma beta upright("covariates") + e_i $ ])<eq-OLS>

=== Syntax
<syntax>
#block[
```stata
regress outcome P1 P2 SR1 SR2 administrative covariates
```

]
For logistic regression, the appropriate syntax would be:

#block[
```stata
logit outcome P1 P2 SR1 SR2 administrative covariates, or
```

]
== Summing Across Reporters
<summing-across-reporters>
=== Diagram
<diagram-1>
#figure([
#box(image("Slide3.png"))
], caption: figure.caption(
position: bottom, 
[
summing across reporters
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-sum>


=== Equation
<equation-1>
First, we average parental reports:

#math.equation(block: true, numbering: "(1)", [ $ P = frac(P 1 + P 2, 2) $ ])<eq-average-parental>

Then, we average self reports:

#math.equation(block: true, numbering: "(1)", [ $ S R = frac(S R 1 + S R 2, 2) $ ])<eq-average-self>

Lastly, we estimate an OLS model in which averaged parental and self reports are variables in the model.

#math.equation(block: true, numbering: "(1)", [ $ upright("outcome") = beta_0 + beta upright("P") + beta upright("SR") + beta upright("administrative") + Sigma beta upright("covariates") + e_i $ ])<eq-average-reporters>

=== Syntax
<syntax-1>
#block[
```stata
generate P = (P1 + P2) / 2 // is averaging appropriate?
  
generate SR = (SR1 + SR2) / 2 // is averaging appropriate?

regress outcome P SR administrative covariates
```

]
== Path Model
<path-model>
=== Diagram
<diagram-2>
#figure([
#box(image("Slide4.png"))
], caption: figure.caption(
position: bottom, 
[
path model
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-path>


=== Equation
<equation-2>
#math.equation(block: true, numbering: "(1)", [ $ upright("outcome") = beta_0 + beta upright("P1") + beta upright("P2") + beta upright("SR1") + beta upright("SR2") + beta upright("administrative") + Sigma beta upright("covariates") + e_i $ ])<eq-path>

$ upright("SR2") = beta_0 + beta upright("SR1") + e_i $ $ upright("P2") = beta_0 + beta upright("P1") + e_i $

=== Syntax
<syntax-2>
#block[
```stata
sem (outcome <- covariates SR1 SR2 PR1 PR2 administrative) ///
  (SR2 <- SR1) ///
  (PR2 <- PR1) ///
  cov(e.outcome*e.SR2*e.PR2) // correlated errors
```

]
== Latent Construct(s)
<latent-constructs>
=== Diagram
<diagram-3>
#figure([
#box(image("Slide5.png"))
], caption: figure.caption(
position: bottom, 
[
latent construct
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-latent-construct>


=== Equation
<equation-3>
=== Syntax
<syntax-3>
#block[
```stata
sem ///
  (P1 P2 SR1 SR2 administrative <- X) /// measurement
  (outcome <- covariates X) // structural
```

]
== Latent Profile Analysis (Person Centered Approach)
<latent-profile-analysis-person-centered-approach>
=== Diagram
<diagram-4>
#figure([
#box(image("Slide6.png"))
], caption: figure.caption(
position: bottom, 
[
latent profile
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-latent-profile>


=== Equation
<equation-4>
=== Syntax
<syntax-4>
We first run a latent class analysis to generate latent underlying classes based upon the reports of discipline from the different reporterers

In the syntax below, we estimate three latent classes. The actual number of latent classes is determined by running models with different numbers of latent classes, and comparing those models using #emph[fit statistics];, and #emph[likelihood ratio tests];.

#block[
```stata
gsem (P1 P2 SR1 SR2 administrative <-, gaussian), (lclass(C 3))
```

]
We then use class membership to predict the outcome.

#block[
```stata
regress outcome i.class covariates
```

]
== Network Analysis
<network-analysis>
=== Diagram
<diagram-5>
#figure([
#box(image("Slide7.png"))
], caption: figure.caption(
position: bottom, 
[
network model
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-network>


=== Equation
<equation-5>
#math.equation(block: true, numbering: "(1)", [ $  & upright("P1") & upright("P2") & upright("SR1") & upright("SR2") & upright("administrative") & upright("outcome")\
upright("P1") & 1 & r_(upright("P1, P2")) & r_(upright("P1, SR1")) & r_(upright("P1, SR2")) & r_(upright("P1, administrative")) & r_(upright("P1, outcome"))\
upright("P2") &  & 1 & r_(upright("P2, SR1")) & r_(upright("P2, SR2")) & r_(upright("P2, administrative")) & r_(upright("P2, outcome"))\
upright("SR1") &  &  & 1 & r_(upright("SR1, SR2")) & r_(upright("SR1, administrative")) & r_(upright("SR1, outcome"))\
upright("SR2") &  &  &  & 1 & r_(upright("SR2, administrative")) & r_(upright("SR2, outcome"))\
upright("administrative") &  &  &  &  & 1 & r_(upright("administrative, outcome"))\
\
upright("outcome") &  &  &  &  &  & 1 $ ])<eq-network-matrix>

=== Syntax
<syntax-5>
#block[
```stata
corr P1 P2 SR1 SR2 administrative outcome
```

]
== #strike[Multilevel Modeling]
<multilevel-modeling>
== #strike[Classification and Regression Tree (CART) (Machine Learning)]
<classification-and-regression-tree-cart-machine-learning>
== #strike[Random Forest (Machine Learning)]
<random-forest-machine-learning>
= References
<references>


 
  
#set bibliography(style: "apa.csl") 


#bibliography("bibliography.bib")

