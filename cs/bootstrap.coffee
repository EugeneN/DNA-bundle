# cs bundles and settings are not loaded yet here
# setting up basic logger to use until main one will be ready
window.is_debug = true
window.protolog = do ->
    can_log = if typeof console isnt "undefined" and console isnt null
        true
    else
        false

    debug: (args...) ->
        if can_log
            console.log (["<DEBUG>"].concat args)


window.AppState =
    stateid: 1
    realm: 'dna-playground'
    config:
        ENV:
            DEFAULT_PROTOCOLS: ["IDom", "IHelper"]
            LOG:
                cs_log_show_hash: "showlog"
                cs_log_show_time: "logtime"
                enabled: true
                logtime: false
                level:
                    DEBUG: true
                    ERROR: true
                    INFO: true
                    NOTICE: true
                    WARN: true
                ns: {}
            ROOT_NS: "window"
            csq_mimetype: "text/csq-def"
    modstate: {}
    services: {}
    stateid: 1