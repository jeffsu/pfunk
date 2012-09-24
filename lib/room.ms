export class Room {
  function initialize(name, sockets) {
    this.sockets = sockets;
    this.name    = name;
  }

  function say(data) {
    this.sockets.in(this.name).emit('receive', data);
  }

}
