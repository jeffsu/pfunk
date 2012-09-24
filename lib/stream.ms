export class Stream {
  function initialize(cmd, room) {
    this.room = room;
  }

  function write(msg) {
    this.room.sockets.emit('cmd-receive', { msg: msg });
  }

  function end(msg) {
    if (msg) this.room.sockets.emit('cmd-receive', { msg: msg });
  }
}
