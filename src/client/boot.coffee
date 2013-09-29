
# module dependencies.
d3 = require "d3"
note = require "./note.coffee"
util = require "./util.coffee"

require "browsernizr/test/svg"
require "browsernizr/test/svg/inline"

Modernizr = require "browsernizr"

unless Modernizr.svg or Modernizr.inlinesvg
  return d3.select("#content").html """
    <div class="not-supported">
      <p>
        申し訳ありません、お使いのブラウザはサポートしていません。
        最新のブラウザに更新してお試しください。
      </p>
      <h2>サポートしている(つもりの)ブラウザ</h2>
      <ul>
        <li>Internet Explore: バージョン9以上</li>
        <li>Chrome</li>
        <li>Safari</li>
        <li>Fire Fox</li>
      </ul>
    </div>
  """

form = d3.select "#target-text"
text = form.select "textarea"
submit = form.select "[type=submit]"

submit.attr("disabled", "disabled")
sample = util.random(require("./sample.json"))

d3.timer ->
  d3.json "/analyse?q=" + encodeURIComponent(sample.sentence), (err, res) ->
    return alertError err if err
    note res
    d3.select("#content").append("div")
        .attr("class", "sample")
        .text("サンプル from #{sample.name}")
    submit.attr("disabled", null)
, 1000

form.on "submit", ->
  d3.event.preventDefault()

  value = text.property("value")
  return alert "文章を入力してください" if value.length is 0

  d3.select(".sample").remove()
  d3.selectAll(".link,.node").remove()
  d3.json "/analyse?q=" + encodeURIComponent(value), (err, res) ->
    return alertError err if err
    note res

alertError = (err) ->
  alert "エラーが発生しました、時間をあけてから試してください。"

window.addEventListener "load", ->
  setTimeout ->
    window.scrollTo(0, 1)
  , 1000
, false
