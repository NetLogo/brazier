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
            src: ['node_modules/qunit/qunit/*']
          , dest: 'test/target/qunit'
          , expand:  true
          , filter:  'isFile'
          , flatten: true
          },

        ],
      },

    },
    file_append: {
      default_options: {
        files: [
          {
            append: "const QUnit = window?.QUnit; export { QUnit };",
            input:  'test/target/qunit/qunit.js',
            output: 'test/target/qunit/qunit.js'
          }
        ]
      }
    },
    connect: {
      server: {
        options: {
          protocol: 'http',
          port:     9005,
          middleware: (connect, options, middlewares) ->
                        middlewares.unshift((req, res, next) ->
                          if req.url.endsWith('.js')
                            res.setHeader('Content-Type', 'text/javascript')
                          next()
                        )
                        middlewares
        },
      },
    },
    qunit: {
      all: ['test/*.html'],
      options: {
        puppeteer: {
          ignoreDefaultArgs: true,
          args: [
            "--headless",
            "--disable-web-security",
            "--allow-file-access-from-files"
          ]
        },
      }
    }
  })

  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-qunit')
  grunt.loadNpmTasks('grunt-file-append')

  grunt.registerTask('default', ['coffeelint', 'coffee:compile', 'copy:publish'])
  grunt.registerTask('test',    ['default', 'coffee:test', 'copy:test', 'file_append', 'connect', 'qunit'])
