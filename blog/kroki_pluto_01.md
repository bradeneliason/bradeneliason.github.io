
+++
title = "Kroki + Pluto = ❤"
hascode = true
date = Date(2021, 9, 28)
tags = ["Julia", "Pluto.jl"]
+++

{{pageheader}}

<!-- # Kroki + Pluto = ❤ -->

## Intro to {{jlpkg Pluto.jl }}

{{jlpkg Pluto.jl}} is a package for Julia for creating reactive notebooks in your browser. A notebook is a series of cells of code which display their outputs inline. When a function or variable is changed in the Pluto, all affected cells are updated automatically. When you add user interface elements such as sliders, buttons, and text fields with {{jlpkg PlutoUI.jl}}, a Pluto notebook becomes a powerful way to explore code interactively.

## Intro to Kroki

[Kroki](https://kroki.io/) is a unified API to create a panoply of diagrams from a variety of diagram specification languages. Kroki supports 22 different diagram specification languages and many of these languages like [Mermaid](https://mermaid-js.github.io/mermaid/#/), and [Vega](https://vega.github.io/vega/) can support many more diagram types. All the diagrams supported can be defined simply from text descriptions. Kroki is run as a free service where you can send the text description of the diagram to the server and get an image back. If you want to run Kroki without an internet connection or keep your diagrams private, you can install a self-managed service on a local machine. {{jlpkg Kroki.jl}} is a wrapper around the Kroki API

## Kroki + Pluto

Static diagrams can be made using a variety of string macros provided by {{jlpkg Kroki.jl}}. For example a PlantUML sequence diagram can be made using the `plantuml` string macro:

```julia
plantuml"Kroki -> Julia: Hello Julia!"
```

<!-- ![Hello Julia](/assets/blog_images/kroki_pluto_01_fig1.png) -->
{{postfig 1 "PlantUML Example Hello Julia" 50}}

Making diagrams interactively in Pluto is as simple as updating the string which defines the diagram. For example a text box could be used to update the name in the diagram above with a simple string interpolation. Note: it simpler to to interpolate the string and send it to the `Kroki.diagram` function than interpolating in a `plantuml"..."` macro string.

<!-- ![Hello Julia](/assets/blog_images/kroki_pluto_01_fig2.png) -->
{{postfig 2 "PlantUML Example with interactivity" 100}}

The demo on the right shows a Vega Lite diagram being interactively update from a data in a textbox. The raw input data is split into individual number and parsed as numbers. Then a vector of named tuples is created in the format of (`category=1, value=15)`. This named data is then converted directly into JSON inside the piechart specification string.

```julia
data = parse.(Float64, split(replace(input_data, ',' => ' ')))
named_data = [(category=i, value=d) for (i,d) in enumerate(data)]
vl_piechart = """
{
  "\$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "description": "A simple donut chart with embedded data.",
  "data": {
    "values": $(JSON.json(named_data))
  },
  "mark": {"type": "arc", "innerRadius": 50},
  "encoding": {
    "theta": {"field": "value", "type": "quantitative"},
    "color": {"field": "category", "type": "nominal"}
  },
  "view": {"stroke": null}
}"""
```

<!-- ![Hello Julia](/assets/blog_images/kroki_pluto_01_fig3.gif) -->
{{postfig 3 "Vega Lite diagram being interactivity" 100}}

If you want to explore these experiments for yourself, I've made a repository on my Github: [PlutoKrokiPlayground](https://github.com/bradeneliason/PlutoKrokiPlayground). Leave me a star on Github if you enjoyed this project.
