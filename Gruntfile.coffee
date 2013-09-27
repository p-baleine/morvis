
exports = module.exports = (grunt) ->

  grunt.initConfig
    watch:
      browserify:
        files: ["src/client/**/*.coffee"]
        tasks: ["browserify"]
      coffee:
        files: ["app.coffee", "src/*.coffee", "spec/*.coffee", "!src/client/boot.coffee"]
        tasks: ["coffee"]
      less:
        files: ["less/**/*.less"]
        tasks: ["less"]
      mochaTest:
        files: ["lib/**/*.js", "spec/**/*.spec.js"]
        tasks: ["mochaTest"]

    coffee:
      server:
        files: [
          "app.js": ["app.coffee"]
          {
            expand: on
            cwd: "./src"
            src: ["**/*.coffee", "!client/**/*.coffee"]
            dest: "./lib"
            ext: ".js"
          }
          {
            expand: on
            cwd: "."
            src: ["spec/**/*.coffee"]
            dest: "."
            ext: ".spec.js"
          }
        ]

    browserify:
      dev:
        files:
          "public/application.js": ["src/client/boot.coffee"]
        options:
          debug: true
      options:
        transform: ["coffeeify"]

    mochaTest:
      unit:
        options:
          reporter: "dot"
          growl: on
        src: ["spec/**/*.spec.js"]

    less:
      dev:
        files:
          "public/application.css": [
            "bower_components/bootstrap/less/bootstrap.less"
            "less/**/*.less"
          ]

    nodemon:
      dev: {}

  grunt.loadNpmTasks "grunt-browserify"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-mocha-test"
  grunt.loadNpmTasks "grunt-nodemon"

