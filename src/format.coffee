
_ = require "underscore"

# Yahoo apiのレスポンスからノードとリンクを生成して返却する
#
# @param [Array] src
# @return [Object]
exports = module.exports = (src) ->
  nodes = []
  links = []

  src.Result.ChunkList.Chunk.forEach (node) ->
    Morphem = node.MorphemList.Morphem
    nodes.push
      Id: node.Id
      Dependency: node.Dependency
      MorphemList: if _.isArray(Morphem) then Morphem else [Morphem]

    links.push
      source: parseInt node.Id, 10
      target: parseInt node.Dependency, 10

  links.pop()

  {
    nodes: nodes
    links: links
  }
