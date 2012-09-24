var Stream = require('./stream');
export class Room {
  function initialize(name, sockets) {
    this.sockets = sockets;
    this.name    = name;
  }

  function say(data) {
    this.sockets.in(this.name).emit('receive', data);
  }

  function cmd(data) {
    var stream = new Stream(data.msg, self);
    stream.end('thanks for the command');
  }

}
