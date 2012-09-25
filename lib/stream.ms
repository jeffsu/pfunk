export class Stream {
  function initialize(room, cmdId, filters, persister) {
    this.room  = room;
    this.cmdId = cmdId;
    this.filters = filters;
    this.persister = persister;
  }

  function write(msg) {
    var data =  { msg: this.filters.write(msg), room: self.room.name, cmdId: this.cmdId };
    this.emit('cmd-recieve', data);
  }

  function writeStream(msg) {
   this.emit('cmd-stream', { msg: this.filters.write(msg), room: self.room.name, cmdId: this.cmdId });
  }

  function end(msg) {
    if (msg) this.emit('cmd-receive', { msg: msg, room: self.room.name, cmdId: this.cmdId });
  }

  function error(msg) {
    if (msg) this.emit('cmd-error', { msg: this.filters.error(msg), room: self.room.name, cmdId: this.cmdId });
  }

  function emit(type, data) {
    this.persister.write(type, data);
    this.room.sockets.emit(type, data);
  }
}
