
# module dependencies.
express = require "express"
request = require "request"
parser = require "libxml-to-js"
debug = require("debug") "http"
format = require "./lib/format"

app = exports = module.exports = express()

DA_SERVICE = "http://jlp.yahooapis.jp/DAService/V1/parse"
APP_ID = process.env.YAHOO_APP_ID or throw Error "APP ID is not specified"
PORT = process.env.PORT or 3000

# middleware
app.use express.static(__dirname + "/public")

# settings
app.set "view engine", "jade"
app.set "views", "."

# routes
app.get "/", (req, res) ->
  res.render "index"

app.get "/analyse", (req, res) ->
  throw new Error(403)  unless req.query.q

  request.post DA_SERVICE,
    headers:
      "User-Agent": "Yahoo AppID: #{APP_ID}"
    form:
      sentence: req.query.q
  , (err, response, body) ->
    console.log err
    console.log response
    throw new Error(500)  if err or response.statusCode isnt 200
    parser body, (err, result) ->
      res.send format result

# listen
unless module.parent
  app.listen PORT
  debug "listening on " + PORT
