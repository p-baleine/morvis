
# module dependencies.
d3 = require("d3")

color = d3.scale.category10()

pallet = {}
["名詞", "助詞", "動詞", "助動詞", "形容詞", "副詞", "特殊"].map((pos, i) -> pallet[pos] = color i)

content = d3.select("#content")

width = parseInt content.style("width").replace(/px$/, ''), 10
height = width / 1257 * 920

force = d3.layout.force()
    .charge(-120)
    .linkDistance(80)
    .size([width, height])

svg = content.append("svg")
    .attr("width", width)
    .attr("height", height)

svg.append("rect")
    .attr("width", width)
    .attr("height", height)

start = (graph) ->
  force
      .nodes(graph.nodes)
      .links(graph.links)
      .gravity((d) -> d.weight * .04)
      .start()

  link = svg.selectAll(".link")
      .data(graph.links)
    .enter().append("line")
      .attr("class", "link")

  node = svg.selectAll(".node")
      .data(graph.nodes)
    .enter().append("text")
      .attr("class", (d) -> "node")
      # .style("font-size", (d) -> "#{d.weight * .5}em")
      .call(force.drag)

  node.selectAll(".node-morphem")
      .data((d) -> d.MorphemList)
    .enter().append("tspan")
      .style("stroke", (d) -> pallet[d.POS] or "#000")
      .style("fill", (d) -> pallet[d.POS] or "#000")
      .text((d) -> d.Surface)

  force.on "tick", ->
    link.attr("x1", (d) -> d.source.x)
        .attr("y1", (d) -> d.source.y)
        .attr("x2", (d) -> d.target.x)
        .attr("y2", (d) -> d.target.y)

    node.attr("transform", (d) -> "translate(#{d.x}, #{d.y})")

form = d3.select "#target-text"
text = form.select "textarea"

form.on "submit", ->
  d3.event.preventDefault()
  value = text.property("value")
  d3.json "/analyse?q=" + value, (err, res) ->
    start res

