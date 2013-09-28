
# module dependencies.
d3 = require("d3")

content = d3.select("#content")

color = d3.scale.category10()

dictionary = [
  "名詞"
  "助詞"
  "動詞"
  "助動詞"
  "形容詞"
  "副詞"
  "特殊"
].reduce (memo, val) ->
  memo[val] = color val
  memo
, {}

# パレット描画
renderPallet = ->
  list = content.append("ul")
      .attr("class", "pallet hidden-xs")

  list.selectAll(".item")
      .data(d3.map(dictionary).entries().map((d) -> [d.key, d.value]))
    .enter().append("li")
      .attr("class", "item")
      .style("color", (d) -> d[1])
    .selectAll("span")
      .data((d) -> d)
    .enter().append("span")
      .attr("class", (d, i) -> if i is 0 then "key" else "value")
      .text((d) -> d)

# expose
module.exports = renderPallet
module.exports.dictionary = dictionary
