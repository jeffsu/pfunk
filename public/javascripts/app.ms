var $s;

class Room {
  private {
    var ENTER = 13;

    var template = jade.compile(<<END);
      .room
        table.table.table-bordered
          tr
            td(width="50%")
              .pane.overflow(style="height: 400px; overflow: scroll;")
            td
              .cmd-pane.overflow(style="overflow: scroll; height: 400px;")
        .form
          input.cmd-input.span8(type="text")
    END

    var tab = jade.compile(<<END);
      li: a(href="#")= name
    END

    var cmdReceive = jade.compile(<<END);
      pre.cmd-receive(class="cmd-#{cmdId}")!= msg
    END

    var cmdStream = jade.compile(<<END);
      pre.cmd-stream(class="cmd-stream-#{cmdId} cmd-#{cmdId}", style="max-height: 200px; overflow: auto")
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

    this.historyIdx = 0;
    this.history  = [];

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
      this.historyIdx = 0;
      this.history.push(val);
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

  function scrollDown($ele) {
    $ele.animate({ scrollTop: $ele[0].scrollHeight });
  }

  function cmd(msg) {
    $s.emit('cmd', this.newData(msg));
  }

  function cmdReceive(data) {
    this.$cmdPane.append(cmdReceive(data));
    this.scrollDown(this.$cmdPane);
  }

  function cmdError(data) {
    this.$cmdPane.append(cmdError(data));
    this.scrollDown(this.$cmdPane);
  }


  function cmdExecuted(data) {
    this.$pane.append(cmdExecuted(data));
    this.scrollDown(this.$pane);
  }

  function cmdStream(data) {
    var $div = $('.cmd-stream-' + data.cmdId);

    if (!$div.length) {
      $div = $(cmdStream(data));
      this.$cmdPane.append($div);
      this.scrollDown(this.$cmdPane);
    }

    $div.append(data.msg);
    this.scrollDown($div);
  }


  function escapeHTML(str) {
    return $('<div />').html(str).text();
  }

  function receive(data) {
    this.$pane.append(receive(data));
    this.scrollDown(this.$pane);
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
    }).on('click', '.cmd-executed', #{
      var cmd = $(this).find('a').html();
      $(this).closest('.room').find('.cmd-input').val('!' + cmd).focus();
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

    $s.on('cmd-stream', #(data) {
      var room = self.rooms[data.room];
      room.cmdStream(data);
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

