
expect = require("chai").expect
format = require "../lib/format"

describe "format", ->

  it "should be a function", ->
    expect(format).to.be.a "function"

  it "should return `nodes` and `links`", ->
    formatted = format require "./fixtures/data"
    expect(formatted).to.have.property "nodes"
    expect(formatted).to.have.property "links"

