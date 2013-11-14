do (AppState) ->
    proto = require 'libprotocol'
    proto.discover_protocols()

    {info, warn, error, debug} = proto.dispatch_impl 'ILogger', "#{realm}/Main"
    {run_init_queue, CSQS, CSMTS} =  require 'queue-manager'

    $ = proto.dispatch_impl 'IDom', document.body
    realm = AppState.realm

    init_dna =
        type: CSMTS.CUSTOM_INIT
        modname: 'init-dna'
        queue: CSQS.INIT_QUEUE
        fun: ->
            dna = require 'dna-lang'
            {get_config} = require 'config'
            dp = get_config 'ENV.DEFAULT_PROTOCOLS', AppState

            dna.start_synthesis document.body, dp

#            pi = require 'platform-info'
#            if pi.is_ie() and pi.get_browser_version() < 9
#                warn 'Old IE detected, using manual dom mutation detection'
#                {emitter} = require 'event-channel'
#                emitter.sub 'dom-node-inserted', (new_node) ->
#                    dna.synthesize_node new_node, dp

    hello =
        type: CSMTS.CUSTOM_INIT
        modname: 'hello'
        queue: CSQS.INIT_QUEUE
        fun: ->
            info 'hello'

    $.on_dom_ready ->
        run_init_queue [init_dna, hello], AppState