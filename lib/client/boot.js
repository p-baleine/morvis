
/**
 * Module dependencies.
 */

var d3 = require('d3');

var width = 600,
    height = 300,
    margin = {
      top: 20,
      right: 20,
      bottom: 20,
      left: 20
    };

var form = d3.select('#target-text'),
    text = form.select('[type=text]');

var canvas = d3.select('#content').append('svg')
    .attr('width', width - margin.left - margin.right)
    .attr('height', height - margin.top - margin.bottom)
  .append('g')
    .attr('transform', 'translate(' + margin.top + ',' + margin.left + ')');

form.on('submit', function() {
  d3.event.preventDefault();
  var value = text.property('value');
  d3.json('/analyse?q=' + value, function(err, res) {
    // drawWords(res.ma_result.word_list.word);
    start(res.ma_result.word_list.word);
  });
});

// submit時はインプットをそのままキャンバスに描画して
// 解析が終わったら解析結果をもとに単語に分離したい
// 解析が終わったら一度分離しない形(用はインプットと同じ見た目)で描画して(enter)
// 全セレクションを解析結果をもとに更新してアニメーションしてあげれば良いか(update)

function drawWords(data) {
  var words = canvas.selectAll('g').data(data);

  var enter = words.enter().append('g')
      .attr('transform', function(d) { return 'translate(' + d.offset * 16 + ',0)'; })
      .attr('class', 'word');

  enter.append('text')
      .text(function(d) { return d.surface; });
}

function start(data) {
  var i = 1;
  var timer = setInterval(function() {
    drawWords(data.slice(0, i));
    i += 1;
    if (i === data.length) {
      clearInterval(timer);
      timer = void 0;
    }
  }, 1000);
}
