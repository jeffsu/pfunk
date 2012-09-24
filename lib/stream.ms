export class Stream {
  function initialize(room) {
    this.room = room;
  }

  function write(msg) {
    this.room.sockets.emit('cmd-receive', { msg: msg, room: self.room.name });
  }

  function end(msg) {
    if (msg) this.room.sockets.emit('cmd-receive', { msg: msg, room: self.room.name });
  }

  function error(msg) {
    if (msg) this.room.sockets.emit('cmd-receive', { msg: msg, room: self.room.name });
  }
}
