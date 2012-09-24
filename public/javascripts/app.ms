var $s;

class Room {
  private {
    var template = jade.compile(<<END);
      .room
        h3= name
        .pane
        .form
          input(type='text')
    END
  }

  function initialize(name) {
    this.name = name;

    this.$ = $(template(this));
    this.$pane = this.$.find('.pane');
    this.$form = this.$.find('.form');
    this.$input = this.$.find('input');
    $('#rooms').append(this.$);

    this.$input.keypress(#(e) {
      if (e.which == 13) 
        self.processInput();
    });
  }

  function processInput() {
    var val = this.$input.val();
    var m = val.match(/^\!\s+(.*)$/);
    if (m) {
      this.cmd(m[1]);
    } else {
      this.send(val)
    }

    this.$input.val('');
  }

  function send(msg) {
    $s.emit('say', { room: this.name, msg: msg });
  }

  function cmd(msg) {
    $s.emit('cmd', { room: this.name, msg: msg });
  }

  function cmdReceive(cmd) {
    var $div = $('<div class="cmd" />').html(msg);
    this.$pane.append($div);
  }

  function receive(msg) {
    var $div = $('<div />').html(msg);
    this.$pane.append($div);
  }
}

class App {
  function initialize(host, port) {
    this.rooms = {};
    var serverAddress = host + ':' + port;
    $s = io.connect(serverAddress);

    $s.on('connected', function(data) { console.log('connected') });

    $s.on('receive', function(data) {
      var room = self.rooms[data.room];
      room.receive(data.msg);
    });

    $('#join').change(#{
      var name = this.value;
      $s.emit('join', { room: name });
      self.rooms[name] = new Room(name);
      this.selectedIndex = 0;
    });
  }
}

