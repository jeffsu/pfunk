var $s;

class Room {
  private {
    var ENTER = 13;

    var template = jade.compile(<<END);
      .room
        h3= name
        table.table.table-bordered
          tr
            td(width="70%")
              .pane.overflow(style="height: 400px; overflow: scroll;")
            td
              .cmd-pane.overflow(style="overflow: scroll; height: 400px;")
        .form
          input.cmd-input.span8(type="text")
    END

    var tab = jade.compile(<<END);
      li: a= name
    END

    var cmdReceive = jade.compile(<<END);
      pre.cmd-receive(class="cmd-#{cmdId}")!= msg
    END

    var cmdError = jade.compile(<<END);
      pre.cmd-error.text-error(class="cmd-#{cmdId}")!= msg
    END


    var receive = jade.compile(<<END);
      div
        if username
          i.username= username + ': '
        span.receive!= msg
    END

    var cmdExecuted = jade.compile(<<END);
      div.cmd-executed(data-cmdid=cmdId)
        a!= msg
    END
  }

  function initialize(name) {
    this.name = name;

    this.$ = $(template(this));
    this.$pane    = this.$.find('.pane');
    this.$form    = this.$.find('.form');
    this.$input   = this.$.find('.cmd-input');
    this.$cmdPane = this.$.find('.cmd-pane');

    var $li = $(tab(this));

    $('#room-tabs').append($li);
    $('#rooms').append(this.$);

    function select() { 
      $li.addClass('active').siblings().removeClass('active');
      self.$.show().siblings().hide(); 
    }

    $li.on('click', select);
    select();

    this.$input.keypress(#(e) {
      if (e.which == ENTER) self.processInput();
    });
  }

  function processInput() {
    var val = this.$input.val();
    var m = val.match(/^\!([^\d].*)$/);
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
    this.$pane.animate({ scrollTop: this.$pane[0].scrollHeight });
  }

  function cmd(msg) {
    $s.emit('cmd', this.newData(msg));
  }

  function cmdReceive(data) {
    this.$cmdPane.append(cmdReceive(data));
    this.$cmdPane.animate({ scrollTop: this.$cmdPane[0].scrollHeight });
  }

  function cmdError(data) {
    this.$cmdPane.append(cmdError(data));
    this.$cmdPane.animate({ scrollTop: this.$cmdPane[0].scrollHeight });
  }


  function cmdExecuted(data) {
    this.$pane.append(cmdExecuted(data));
    this.$pane.animate({ scrollTop: this.$pane[0].scrollHeight });
  }

  function escapeHTML(str) {
    return $('<div />').html(str).text();
  }

  function receive(data) {
    this.$pane.append(receive(data));
  }
}

class App {
  function initialize(host, port) {
    this.rooms = {};
    var serverAddress = host + ':' + port;
    $s = io.connect(serverAddress);

    $('#rooms').on('mouseenter', '.cmd-executed', #{ 
      var cmdId = $(this).data('cmdid');
      $('.cmd-' + cmdId).siblings().hide();
    }).on('mouseleave', '.cmd-executed', #{
      var cmdId = $(this).data('cmdid');
      $('.cmd-' + cmdId).siblings().show();
    });

    $s.on('connected', function(data) { self.join('front') });

    $s.on('receive', function(data) {
      var room = self.rooms[data.room];
      room.receive(data);
    });

    $s.on('cmd-receive', #(data) {
      var room = self.rooms[data.room];
      room.cmdReceive(data);
    });

    $s.on('cmd-error', #(data) {
      var room = self.rooms[data.room];
      room.cmdError(data);
    });

    $s.on('cmd-executed', #(data) {
      var room = self.rooms[data.room];
      room.cmdExecuted(data);
    });

    $('#join').change(#{ self.join(this.value); });
  }

  function join(name) {
    $s.emit('join', { room: name });
    self.rooms[name] = new Room(name);
    this.selectedIndex = 0;
  }
}

