var Stream = require('./stream');
export class Room {
  function initialize(name, sockets) {
    this.sockets = sockets;
    this.name    = name;
    this.plugins = [];
  }

  function socket() {
    return this.sockets.in(this.name);j
  }

  function say(data) {
    this.socket().emit('receive', data);
  }

  function cmd(data) {
    this.socket().emit('cmd-executed', data);
    var stream = new Stream(self, data.cmdId);
    var handled = false;
    foreach (var plugin in this.plugins) {
      if (plugin.canHandle(data.msg)) {
        plugin.handle(data.msg, stream);
        handled = true;
      } 
    }

    if (!handled) stream.error('cmd not found');
  }

  function plugin(plugin) {
    this.plugins.push(plugin);
  }
}
