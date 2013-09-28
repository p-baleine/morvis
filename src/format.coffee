
_ = require "underscore"

# Yahoo apiのレスポンスからノードとリンクを生成して返却する
#
# @param [Array] src
# @return [Object]
exports = module.exports = (src) ->
  nodes = []
  links = []
  Chunk = src.Result.ChunkList.Chunk

  unless _.isArray Chunk
    return {
      nodes: chunk Chunk
      links: []
    }

  Chunk.forEach (node) ->
    nodes.push chunk node

    links.push
      source: parseInt node.Id, 10
      target: parseInt node.Dependency, 10

  links.pop()

  {
    nodes: nodes
    links: links
  }

chunk = (c) ->
  Morphem = c.MorphemList.Morphem
  Id: c.Id
  Dependency: c.Dependency
  MorphemList: if _.isArray(Morphem) then Morphem else [Morphem]
