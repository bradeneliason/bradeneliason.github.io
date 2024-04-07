+++
title = "Graph Vizualization in Pluto Notebooks"
date = Date(2021, 9, 28)
tags = ["Julia", "Pluto.jl"]
hascode = true
+++

{{pageheader}}

<!-- # Graph Vizualization in Pluto Notebooks -->

I made an experimental {{jlpkg Pluto.jl}} notebook to display graphs using [Cytoscape.js](https://js.cytoscape.org/). Cytoscape is a graph visualization library written in pure JavaScript. I used the package {{jlpkg HypertextLiteral.jl}} to generate HTML output inside of a Pluto notebook. The output HTML pane has four buttons to fit, center, redraw, and download the graph. You can also swap out different graphs, styles, and layout methods interactively.

Currently this project is just a prototype which you can view and download on my Github: PlutoGraphViz. There are many features of Cytoscape which I have note implemented yet. If you found this project interesting, leave me a star on Github.

## Animated Demo
<!-- TODO: Image -->

<!-- ![alt text](/assets/blog_images/pluto_graphviz_01_fig1.gif) -->
{{postfig 1 "Interactive demo of graph visualization" 100}}