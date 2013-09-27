
# module dependencies.
d3 = require("d3")

width = 960
height = 600

color = d3.scale.category10()

pallet = {}
["名詞", "動詞"].map((pos, i) -> pallet[pos] = color i)
console.log pallet
force = d3.layout.force()
    .charge(-200)
    .linkDistance(50)
    .size([width, height])

svg = d3.select("#content").append("svg")
    .attr("width", width)
    .attr("height", height)

svg.append("rect")
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
    .enter().append("text")
      .attr("class", "node")
      .style("stroke", (d) -> pallet[d.MorphemList[0].POS] or "#000")
      .text((d) -> d.MorphemList[0].Surface)

  force.on "tick", ->
    link.attr("x1", (d) -> d.source.x)
        .attr("y1", (d) -> d.source.y)
        .attr("x2", (d) -> d.target.x)
        .attr("y2", (d) -> d.target.y)

    node.attr("transform", (d) -> "translate(#{d.x}, #{d.y})")

form = d3.select "#target-text"
text = form.select "[type=text]"

form.on "submit", ->
  d3.event.preventDefault()
  value = text.property("value")
  d3.json "/analyse?q=" + value, (err, res) ->
    start res

