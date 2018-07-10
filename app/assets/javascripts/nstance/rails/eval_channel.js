class EvalChannel {
  constructor(config, ...callbacks) {
    this.channel = App.cable.subscriptions.create({
      channel:     'Nstance::Rails::EvalChannel',
      token:       config.evalToken,
      source_gid:  $('[data-source-gid]').data('source-gid'),
      cid:         config.cid
    }, ...callbacks)
  }

  eval(data) {
    this.channel.perform('eval', data)
  }
}
