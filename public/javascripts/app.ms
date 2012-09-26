var $s;

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
      var $pane = $('.cmd-' + cmdId).closest('div');
      $pane.animate({ scrollTop: $pane[0].scrollHeight });
     
    }).on('click', '.cmd-executed', #{
      var cmd = $(this).find('a').html();
      $(this).closest('.room').find('.cmd-input').val('!' + cmd).focus();
    });

    $s.on('connected', #(data) { self.join('front') });

    $s.on('receive', #(data) {
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

