export class Stream {
  function initialize(room, cmdId, filters) {
    this.room  = room;
    this.cmdId = cmdId;
    this.filters = filters;
  }

  function write(msg) {
    this.room.sockets.emit('cmd-receive', { msg: this.filters.write(msg), room: self.room.name, cmdId: this.cmdId });
  }

  function end(msg) {
    if (msg) this.room.sockets.emit('cmd-receive', { msg: msg, room: self.room.name, cmdId: this.cmdId });
  }

  function error(msg) {
    if (msg) this.room.sockets.emit('cmd-error', { msg: this.filters.error(msg), room: self.room.name, cmdId: this.cmdId });
  }
}
