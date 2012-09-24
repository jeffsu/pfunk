export class Room {
  function initialize(name, sroom) {
    this.socket = sroom;
    this.name   = name;
  }

  function say(data) {
    this.socket.emit('receive', data);
  }

}
