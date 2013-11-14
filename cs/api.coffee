# this is *the* place to define CS Api
# python should probably read this somehow
CSQS =
    DEFINE_QUEUE: 'define-queue'
    INIT_QUEUE: 'init-queue'
    DOM_READY_QUEUE: 'dom-ready-queue'
    DOC_LOAD_QUEUE: 'doc-loaded-queue'
    CONFIG_READY_QUEUE: 'cfg-ready-queue'
    BOOTSTRAP_QUEUE: 'bootstrap-queue'

CSMTS =
    CSM: 'csm'
    RAW: 'raw'
    CUSTOM_INIT: 'custom-init'
    DEFINE: 'define'
    STATE: 'state'
    CONFIG: 'config'

valid_queue = (q) -> q in (v for own k,v of CSQS)

value_to_type = (v) ->
    if v instanceof Type
        v
    else
        switch v.type
            when CSMTS.CSM then new TRunCSM v
            when CSMTS.RAW then new TRunRaw v
            when CSMTS.DEFINE then new TDefine v
            when CSMTS.STATE then new TState v
            when CSMTS.CONFIG then new TConfig v
            when CSMTS.CUSTOM_INIT then new TCustomInit v
            else throw new TypeError "Unknown type: #{v}"


# just a root of type hierarchy
class Type
    _name: 'Type'
    toString: ->
        "#{@_name} #{@value}"

# TODO split into TModule and TQItem where
# TQItem = TQItem { queue :: TQueue, module :: TModule}
# TModule = TModule { type :: String, modname :: string, ... }

class TRunRaw extends Type
    constructor: ({modname, queue, raw, singleton}={}) ->
        throw "Bad cs queue: #{queue}" unless valid_queue queue
        throw "Bad type constructor arguments" unless modname and queue and raw
        @_name = 'TRunRaw'
        @value =
            type: CSMTS.RAW
            modname: modname
            raw: raw
            queue: queue
            singleton: singleton or false

class TRunCSM extends Type
    constructor: ({modname, queue, args, singleton}={}) ->
        throw "Bad cs queue: #{queue}" unless valid_queue queue
        throw "Bad type constructor arguments" unless modname and queue and args
        @_name = 'TRunCSM'
        @value =
            type: CSMTS.CSM
            modname: modname
            args: args
            queue: queue
            singleton: singleton or false

class TState extends Type
    constructor: ({stateid, key, value, queue}={}) ->
        throw "Bad type constructor arguments" unless stateid and key
        throw "Bad cs queue: #{queue}" if queue and not valid_queue queue
        @_name = 'TState'
        @value =
            type: CSMTS.STATE
            stateid: stateid
            key: key
            value: value
            queue: queue or CSQS.DEFINE_QUEUE

class TDefine extends Type
    constructor: ({modname, submodname, modbody, queue}={}) ->
        throw "Bad type constructor arguments" unless modname and submodname and modbody
        throw "Bad cs queue: #{queue}" if queue and not valid_queue queue
        @_name = 'TDefine'
        @value =
            type: CSMTS.DEFINE
            modname: modname
            submodname: submodname
            modbody: modbody
            queue: queue or CSQS.DEFINE_QUEUE

class TConfig extends Type
    constructor: ({modname, key, value, queue}={}) ->
        throw "Bad type constructor arguments" unless modname and key
        throw "Bad cs queue: #{queue}" if queue and not valid_queue queue
        throw "Bad config key: #{key}. You can only override a CS. subdomain" \
            if key[0..2] isnt 'CS.'
        @_name = 'TConfig'
        @value =
            type: CSMTS.CONFIG
            modname: modname
            key: key
            value: value
            queue: queue or CSQS.CONFIG_READY_QUEUE

# exclusive for client-side use
class TCustomInit extends Type
    constructor: ({modname, queue, fun}={}) ->
        throw "Bad cs queue: #{queue}" unless valid_queue queue
        throw "Bad type constructor arguments" unless modname and queue and fun
        @_name = 'TCustomInit'
        @value =
            modname: modname
            queue: queue
            fun: fun
            type: CSMTS.CUSTOM_INIT


module.exports = {CSQS, CSMTS, Type, TRunCSM, TRunRaw, TState, TDefine, TConfig,
    TCustomInit, valid_queue, value_to_type}
