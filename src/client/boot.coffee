
# module dependencies.
d3 = require("d3")

width = 600
height = 300

form = d3.select "#target-text"
text = form.select "[type=text]"

force = d3.layout.force()
    .charge(-120)
    .linkDistance(30)
    .size([width, height])

svg = d3.select("#content").append("svg")
    .attr("width", width)
    .attr("height", height)

start = (graph) ->
  force
      .nodes(graph.nodes)
      .links(graph.links)
      .start()

  link = svg.selectAll(".link")
      .data(graph.links)
    .enter().append("line")
      .attr("class", "link")

  node = svg.selectAll(".node")
      .data(graph.nodes)
    .enter().append("circle")
      .attr("class", "node")
      .attr("r", 5)

  force.on "tick", ->
    link.attr("x1", (d) -> d.source.x)
        .attr("y1", (d) -> d.source.y)
        .attr("x2", (d) -> d.target.x)
        .attr("y2", (d) -> d.target.y)

    node.attr("cx", (d) -> d.x)
        .attr("cy", (d) -> d.y)

form.on "submit", ->
  d3.event.preventDefault()
  value = text.property("value")
  d3.json "/analyse?q=" + value, (err, res) ->
    start res

