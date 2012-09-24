export class Stream {
  function initialize(socket) {
    this.socket = socket;
  }

  function write(msg) {
    this.socket.emit('cmd-receive', { msg: msg });
  }

  function end(msg) {
    if (msg) this.socket.emit('cmd-receive', { msg: msg });
  }
}
