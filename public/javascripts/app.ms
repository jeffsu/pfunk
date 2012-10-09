var $s;

class App {

  private {
    var uiVisible = false;
  }

  function initialize(host, port) {

    var serverAddress = host + ':' + port;
    $s = io.connect(serverAddress);

    this.rooms = {};
    this.members = {};

    this.$messenger = $('#messenger:first');
    this.$tabs  = $('#room-tabs');
    this.$panes = $('#rooms');

    this.$panes.on('mouseenter', '.cmd-executed', #{ 
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
    })

    this.$tabs.on('click', '.leave-room', #{
      var tab = $(this).parents('li');
      var pane= self.$panes.children().eq(tab.index());
      tab.remove();
      pane.remove();
      self.leave(tab.data('room'));

    });

    // $s.on('connected', #(data) { self.join('front') });

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

    var $joinForm = $('#join');
    var $joinUser  = $joinForm.find('#username');
    var $joinRoom  = $joinForm.find('#join-room');
    $joinForm.find('#join-room').change(#{ 
      self.join(this.value, $joinUser.val()); 
    });
    $('#join').submit(#{ 
      self.join($joinRoom.val(), $joinUser.val()); => false; 
    });
  }

  function join(name, username) {
    // TODO: better error handling
    if (name == '') => alert('you must choose room');
    $s.emit('join', { room: name });
    self.rooms[name] = new Room(name);
    if (!uiVisible && _.size(self.rooms) > 0) {
      this.showUI();
    }
  }

  function leave(name) {
    $s.emit('leave', { room: name });
    delete this.rooms[name];
    if (_.size(self.rooms) == 0 && uiVisible) {
      this.hideUI();
    } else {
      this.$tabs.find('a:first').tab('show');
    }
  }

  function showUI() {
    uiVisible = true;
    this.$messenger.show();
  }

  function hideUI() {
    uiVisible = false;
    this.$messenger.hide();
  }
}
