class EvalChannel {
  constructor(config, ...callbacks) {
    this.channel = App.cable.subscriptions.create({
      channel:     'Nstance::Rails::EvalChannel',
      token:       config.evalToken,
      channel_id:  this.generate_uuid()
    }, ...callbacks)
  }

  eval(data) {
    this.channel.perform('eval', data)
  }

  // Creates UUID to ensure unique ActionCable channel
  // source https://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript/2117523#2117523
  generate_uuid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }
}
