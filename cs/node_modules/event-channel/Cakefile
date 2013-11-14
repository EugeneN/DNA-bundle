{spawn, exec} = require 'child_process'


build = (callback) ->
    coffee = spawn 'coffee', ['-c', '-o', 'lib-js', 'src']

    coffee.stderr.on 'data', (data) ->
        process.stderr.write data.toString()

    coffee.stdout.on 'data', (data) ->
        print data.toString()

    coffee.on 'exit', (code) ->
        console.log "build is done"
        callback?() if code is 0


task 'test', 'Run tests', ->
    exec "nodeunit test", {}, (error, stdout, stderr) ->
        console.log stdout if stdout
        console.log stderr if stderr


task 'build', 'Build lib-js/ from src/', -> build()

