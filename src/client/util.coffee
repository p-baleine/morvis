
# 1回だけ`fn`を実行する
once = (fn) ->
  ran = false
  memo = null
  ->
    return memo if ran
    ran = true
    memo = fn.apply @, arguments
    fn = null
    memo

# `array`からランダムに要素を選んで返却する
random = (array) ->
  array[Math.floor(Math.random() * array.length)]

# expose
exports.once = once
exports.random = random
