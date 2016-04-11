module.exports = (grunt) ->

  massAlias =
    (glob, base) ->
      files = grunt.file.expand({ filter: 'isFile' }, glob)
      regex = new RegExp(".*?/#{base}/(.*)\.js")
      splitter = (file) ->
        alias = file.match(regex)[1]
        "#{file}:#{alias}"
      files.map(splitter)

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffeelint: {
      app: ['src/**/*.coffee'],
      options: {
        configFile: 'coffeelint.json'
      }
    },
    coffee: {

      compile: {
        files: [
          {
            expand: true,
            cwd: 'src',
            src: ['**/*.coffee'],
            dest: 'target/brazier',
            ext: '.js'
          }
        ]
      },

      test: {
        files: [
          {
            expand: true,
            cwd: 'test',
            src: ['**/*.coffee'],
            dest: 'test/target/brazier',
            ext: '.js'
          }
        ]
      }

    },
    browserify: {
      main: {
        src: ['target/brazier/bootstrap.js'],
        dest: 'dist/brazier.js',
        options: {
          alias: []
        }
      }
    },
    copy: {

      publish: {
        files: [

          {
            src: ['target/brazier/brazier/*']
          , dest: 'publish'
          , expand:  true
          , filter:  'isFile'
          , flatten: true
          }

        ],
      }

      test: {
        files: [

          {
            src: ['node_modules/qunitjs/qunit/*']
          , dest: 'test/target/qunit'
          , expand:  true
          , filter:  'isFile'
          , flatten: true
          },

          {
            src: ['dist/brazier.js']
          , dest: 'test/target/brazier.js'
          }

        ],
      },

    },
    qunit: {
      all: ['test/*.html']
    }
  })

  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-qunit')
  grunt.loadNpmTasks('grunt-contrib-rename')

  # I do this because inlining it in `browserify`'s options causes the value to
  # be evaluated before any of the tasks are run, but we need to wait until
  # `coffee` runs for this to work --JAB (8/21/14)
  grunt.task.registerTask('gen_aliases', 'Find aliases, then run browserify', ->
    aliases = massAlias('./target/brazier/**/*.js', 'brazier')
    grunt.config(['browserify', 'main', 'options', 'alias'], aliases);
    return
  )

  grunt.registerTask('default', ['coffeelint', 'coffee:compile', 'copy:publish', 'gen_aliases', 'browserify'])
  grunt.registerTask('test',    ['default', 'coffee:test', 'copy:test', 'qunit'])
