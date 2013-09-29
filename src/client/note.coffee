
# Module dependencies.
d3 = require "d3"
util = require "./util.coffee"
renderPallet = require "./pallet.coffee"

pallet = renderPallet.dictionary

content = d3.select("#content")

node = content.node()
width = node.innerWidth || node.clientWidth
height = width / 1257 * 950 # 背景画像の比率

svg = content.append("svg")
    .attr("width", width)
    .attr("height", height)

svg.append("rect")
    .attr("width", width)
    .attr("height", height)

start = (graph) ->
  force = d3.layout.force()
      .charge(-80)
      .linkDistance(60)
      .size([width, height])

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
    .enter().append("g")
      .attr("class", "node")
      .call(force.drag)

  node.append("circle")
      .attr("r", "3px")

  text = node.append("text")

  text.selectAll(".node-morphem")
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

   force.on "end", util.once renderPallet

# expose
module.exports = start
