export class Stream {
  function initialize(room, cmdId) {
    this.room = room;
    this.cmdId = cmdId;
  }

  function write(msg) {
    this.room.sockets.emit('cmd-receive', { msg: msg, room: self.room.name, cmdId: this.cmdId });
  }

  function end(msg) {
    if (msg) this.room.sockets.emit('cmd-receive', { msg: msg, room: self.room.name, cmdId: this.cmdId });
  }

  function error(msg) {
    if (msg) this.room.sockets.emit('cmd-error', { msg: msg, room: self.room.name, cmdId: this.cmdId });
  }
}
