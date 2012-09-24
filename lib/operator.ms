var Room = require('./room');

export class Operator {
  function initialize(app) {
    this.io = require('socket.io').listen(app);
    this.setupIO(app, this.io);
    this.rooms = {};
  }

  function addRoom(name) {
    return this.rooms[name] = new Room(name, this.io.sockets.in(name));
  }

  function setupIO(app, io) {
    io.sockets.on('connection', function(socket) {
      socket.emit('connected', { msg: 'listening' });

      socket.on('say', function(data) {
      console.log('say', data);
        var room = self.getRoom(data.room);
        room.say(data);
      });
    });
  }

  function getRoom(name) {
    return this.rooms[name];
  }


  function join(room) {
    if (room in rooms) {
    }
  }
} 
