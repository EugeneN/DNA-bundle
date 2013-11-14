{emitter} = require '../src/index'

module.exports =
    test_trigger_bind: (test) ->
        f1 = -> test.done()
        emitter.bind 'e1', f1
        emitter.trigger 'e1'


    test_pass_arguments: (test) ->
        f1 = (num) -> 
            test.ok num is 5
            test.done()

        emitter.bind 'e2', f1
        emitter.trigger 'e2', 5


    test_multiple_handlers: (test) ->
        test.expect 2

        f1 = -> test.ok true
        f2 = -> 
            test.ok true
            test.done()

        emitter.bind 'e3', f1
        emitter.bind 'e3', f2

        emitter.trigger 'e3'


    test_multiple_events: (test) ->
        test.expect 2

        f1 = -> test.ok true
        f2 = -> test.done()

        emitter.bind 'e4 e5', f1
        emitter.bind 'finish', f2

        emitter.trigger 'e4'
        emitter.trigger 'e5'
        emitter.trigger 'finish'