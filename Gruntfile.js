
exports = module.exports = function(grunt) {

  grunt.initConfig({

    watch: {
      browserify: {
        files: ['lib/client/**/*.js'],
        tasks: ['browserify']
      },
      less: {
        files: ['less/**/*.less'],
        tasks: ['less']
      }
    },

    browserify: {
      dev: {
        files: {
          "public/application.js": ['lib/client/boot.js']
        },
        options: {
          debug: true
        }
      }
    },

    less: {
      dev: {
        files: {
          "public/application.css": [
            'less/**/*.less',
            'bower_components/bootstrap/less/bootstrap.less'
          ]
        }
      }
    },

    nodemon: {
      dev: {}
    }

  });

  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-nodemon');

};
