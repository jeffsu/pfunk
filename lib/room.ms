var Stream  = require('./stream');
var Filters = require('./filters');
var Encoder = require('node-html-encoder').Encoder;
var encoder = new Encoder('entity');

export class Room {
  function initialize(name, sockets) {
    this.sockets = sockets;
    this.name    = name;
    this.plugins = [];
    this.filters = new Filters();

    this.filters.write(#(msg) { return encoder.htmlEncode(msg);  });
    this.filters.error(#(msg) { return encoder.htmlEncode(msg);  });
  }

  function socket() {
    return this.sockets.in(this.name);j
  }

  function say(data) {
    data.msg = this.filters.chat(data.msg);
    this.socket().emit('receive', data);
  }

  function cmd(data) {
    this.socket().emit('cmd-executed', data);
    var stream = new Stream(this, data.cmdId, this.filters);
    var handled = false;
    foreach (var plugin in this.plugins) {
      if (plugin.canHandle(data.msg)) {
        plugin.handle(data.msg, stream);
        handled = true;
      } 
    }

    if (!handled) stream.error('command not found');
  }

  function plugin(plugin) {
    this.plugins.push(plugin);
  }
}
