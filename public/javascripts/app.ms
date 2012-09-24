var $s;

class Room {
  private {
    var template = jade.compile(<<END);
      .room
        h3= name
        table.table
          tr
            td.pane(width="70%")
            td.cmd-pane
        .form
          input(type='text')
    END

    var tab = jade.compile(<<END);
      li: a= name
    END

    var cmdReceive = jade.compile(<<END);
      .cmd-receive= msg
    END

    var receive = jade.compile(<<END);
      div
        if username
          i.username= username + ':'
        span.receive!= html
    END

    var cmdExecuted = jade.compile(<<END);
      div.cmd-executed
        a= msg
    END
  }

  function initialize(name) {
    this.name = name;

    this.$ = $(template(this));
    this.$pane    = this.$.find('.pane');
    this.$form    = this.$.find('.form');
    this.$input   = this.$.find('input');
    this.$cmdPane = this.$.find('.cmd-pane');

    var $li = $(tab(this));

    $('#room-tabs').append($li);
    $('#rooms').append(this.$);

    function select() { self.$.show().siblings().hide(); }

    $li.on('click', select);
    select();

    this.$input.keypress(#(e) {
      if (e.which == 13) self.processInput();
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

  function newData(msg) {
    return { room: this.name, msg: msg, username: $('#username').val() };
  }

  function send(msg) {
    $s.emit('say', this.newData(msg));
  }

  function cmd(msg) {
    $s.emit('cmd', this.newData(msg));
  }

  function cmdReceive(data) {
    this.$cmdPane.append(cmdReceive(data));
  }

  function cmdExecuted(data) {
    this.$pane.append(cmdExecuted(data));
  }

  function escapeHTML(str) {
    return $('<div />').html(str).text();
  }

  function receive(data) {
    data.html = this.escapeHTML(data.msg);
    data.html = data.html.replace(/#(\d+)/g, '<a href="https://github.com/Factual/front/issues/$1">#$1</a>');
    this.$pane.append(receive(data));
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
      room.receive(data);
    });

    $s.on('cmd-receive', #(data) {
      var room = self.rooms[data.room];
      room.cmdReceive(data);
    });

    $s.on('cmd-executed', #(data) {
      var room = self.rooms[data.room];
      room.cmdExecuted(data);
    });


    $('#join').change(#{
      var name = this.value;
      $s.emit('join', { room: name });
      self.rooms[name] = new Room(name);
      this.selectedIndex = 0;
    });
  }
}

