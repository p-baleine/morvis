
/**
 * Module dependencies.
 */

var express = require('express'),
    request = require('request'),
    parser = require('libxml-to-js'),
    debug = require('debug')('http');

var app = exports = module.exports = express();

var DA_SERVICE = 'http://jlp.yahooapis.jp/DAService/V1/parse';
var APP_ID = 'dj0zaiZpPUtTSFpQVDBYeG15TSZzPWNvbnN1bWVyc2VjcmV0Jng9Yzg-';

// middleware

app.use(express.static(__dirname + '/public'));

// settings

app.set('view engine', 'jade');
app.set('views', '.');

// routes

app.get('/', function(req, res) {
  res.render('index');
});

app.get('/analyse', function(req, res) {
  if (!req.query.q) { throw new Error(403); }

  request.post(DA_SERVICE, {
    headers: { "User-Agent": 'Yahoo AppID: ' + APP_ID },
    form: { sentence: req.query.q }
  }, function(err, response, body) {
    if (err || response.statusCode !== 200) { throw new Error(500); }
    parser(body, function(err, result) {
      res.send(result);
    });
  });
});

var port = process.env.PORT || 3000;
if (!module.parent) {
  app.listen(port);
  debug('listening on ' + port);
}
