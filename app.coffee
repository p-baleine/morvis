
# module dependencies.
express = require "express"
request = require "request"
parser = require "libxml-to-js"
debug = require("debug") "http"
staticAsset = require "static-asset"
format = require "./lib/format"

app = exports = module.exports = express()

DA_SERVICE = "http://jlp.yahooapis.jp/DAService/V1/parse"
APP_ID = process.env.YAHOO_APP_ID or throw Error "APP ID is not specified"
PORT = process.env.PORT or 3000

# middleware
app.use express.compress()
app.use staticAsset "#{__dirname}/public"
app.use express.static "#{__dirname}/public", maxAge: 31557600000 # 1 year
app.use app.router
app.use express.errorHandler()

# settings
app.set "view engine", "jade"
app.set "views", "."

# routes
app.get "/", (req, res) ->
  res.render "index"

app.get "/analyse", (req, res, next) ->
  return next new Error(403) unless req.query.q

  request.post DA_SERVICE,
    headers:
      "User-Agent": "Yahoo AppID: #{APP_ID}"
    form:
      sentence: req.query.q
  , (err, response, body) ->
    return next new Error(500) if err or response.statusCode isnt 200
    parser body, (err, result) ->
      res.send format result

# listen
unless module.parent
  app.listen PORT
  debug "listening on " + PORT
