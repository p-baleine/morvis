# drawWords(res.ma_result.word_list.word);


# submit時はインプットをそのままキャンバスに描画して
# 解析が終わったら解析結果をもとに単語に分離したい
# 解析が終わったら一度分離しない形(用はインプットと同じ見た目)で描画して(enter)
# 全セレクションを解析結果をもとに更新してアニメーションしてあげれば良いか(update)
drawWords = (data) ->
  words = canvas.selectAll("g").data(data)
  enter = words.enter().append("g").attr("transform", (d) ->
    "translate(" + d.offset * 16 + ",0)"
  ).attr("class", "word")
  enter.append("text").text (d) ->
    d.surface


start = (data) ->
  i = 1
  timer = setInterval(->
    drawWords data.slice(0, i)
    i += 1
    if i is data.length
      clearInterval timer
      timer = undefined
  , 1000)
d3 = require("d3")
width = 600
height = 300
margin =
  top: 20
  right: 20
  bottom: 20
  left: 20

form = d3.select("#target-text")
text = form.select("[type=text]")
canvas = d3.select("#content").append("svg").attr("width", width - margin.left - margin.right).attr("height", height - margin.top - margin.bottom).append("g").attr("transform", "translate(" + margin.top + "," + margin.left + ")")
form.on "submit", ->
  d3.event.preventDefault()
  value = text.property("value")
  d3.json "/analyse?q=" + value, (err, res) ->
    start res.ma_result.word_list.word

