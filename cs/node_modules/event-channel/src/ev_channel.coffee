Emitter = ->
  callbacks = {}

  sub = (ev, callback) ->
    evs   = ev.split(' ')
    calls = callbacks
    for name in evs
      callbacks[name] or= []
      callbacks[name].push callback


  pub = (args...) ->
    ev = args.shift()
    return unless callbacks[ev]
    for callback in callbacks[ev]
      if callback(args...) is false
        break
    true


  unsub = (ev, callback) ->
    evs = ev.split ' '
    for name in evs
      list = callbacks[name]
      continue unless list
      unless callback
        delete callbacks[name]
        continue
      for cb, i in list when (cb is callback)
        list = list.slice()
        list.splice i, 1
        callbacks[name] = list
        break


  callbacks_map = -> callbacks

  {sub, pub, unsub, callbacks_map}

emitter = new Emitter()

module.exports = {emitter, Emitter}
