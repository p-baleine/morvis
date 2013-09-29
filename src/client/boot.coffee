
# module dependencies.
d3 = require "d3"
note = require "./note.coffee"
util = require "./util.coffee"

form = d3.select "#target-text"
text = form.select "textarea"
submit = form.select "[type=submit]"

submit.attr("disabled", "disabled")
sample = util.random(require("./sample.json"))

d3.timer ->
  d3.json "/analyse?q=" + encodeURIComponent(sample.sentence), (err, res) ->
    note res
    d3.select("#content").append("div")
        .attr("class", "sample")
        .text("サンプル from #{sample.name}")
    submit.attr("disabled", null)
, 1000

form.on "submit", ->
  d3.select(".sample").remove()
  d3.selectAll(".link,.node").remove()
  d3.event.preventDefault()
  value = text.property("value")
  d3.json "/analyse?q=" + encodeURIComponent(value), (err, res) ->
    note res

window.addEventListener "load", ->
  setTimeout ->
    window.scrollTo(0, 1)
  , 1000
, false
