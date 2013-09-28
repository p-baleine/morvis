
# module dependencies.
d3 = require("d3")

color = d3.scale.category10()

pallet = ["名詞", "助詞", "動詞", "助動詞", "形容詞", "副詞", "特殊"].reduce (memo, val) ->
  memo[val] = color val
  memo
, {}

content = d3.select("#content")

parse = (pxStr) ->
  parseInt pxStr.replace(/px$/, ''), 10

width = parse content.style("width")
height = width / 1257 * 950

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

   force.on "end", once renderPallet

# パレット描画
renderPallet = ->
  list = content.append("ul")
      .attr("class", "pallet")
  console.log(d3.map(pallet).entries().map((d) -> [d.key, d.value]))

  list.selectAll(".item")
      .data(d3.map(pallet).entries().map((d) -> [d.key, d.value]))
    .enter().append("li")
      .attr("class", "item hidden-xs")
      .style("color", (d) -> d[1])
    .selectAll("span")
      .data((d) -> d)
    .enter().append("span")
      .attr("class", (d, i) -> if i is 0 then "key" else "value")
      .text((d) -> d)

once = (fn) ->
  ran = false
  memo = null
  ->
    return memo if ran
    ran = true
    memo = fn.apply @, arguments
    fn = null
    memo

form = d3.select "#target-text"
text = form.select "textarea"

form.on "submit", ->
  d3.event.preventDefault()
  value = text.property("value")
  d3.json "/analyse?q=" + value, (err, res) ->
    start res

window.addEventListener "load", ->
  setTimeout ->
    window.scrollTo(0, 1)
  , 1000
, false
