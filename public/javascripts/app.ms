class App {
  function initialize(host, port) {
    var serverAddress = host + ':' + port;
    var socket = io.connect(serverAddress);

    this.messenger = new Messenger(socket);

    socket.on('connected', function(data) {
      self.messenger.writeln(data);
    });

    socket.on('receive', function(data) {
      self.messenger.writeln(data);
    });

    socket.emit('join', { room: 'front' });
  }
}

class Messenger {
  function initialize(socket) {
    this.socket = socket;
    this.$msgPane = $('#msgPane');
    this.$msgPost = $('#msgPost');
    this.$msgLine = $('<div class="msgLine"></div>');
    this.$msgInput= this.$msgPost.find('input');
    this.$msgSend = this.$msgPost.find('button');
    
    this.registerEvents();
  }
  
  function registerEvents() {
    this.$msgInput.keypress(#(e) {
      if (e.which == 13) self.processInput();
    });

    this.$msgSend.click(#{ self.processInput(); });
  }

  function processInput() {
    var msg = this.$msgInput.val();
    var m = msg.match(/^\!\s+(.*)$/);
    if (m) {
      this.cmd(m[1]);
    } else {
      this.send(msg)
    }

    this.$msgInput.val('');
  }

  function cmd(cmd) {
    this.socket.emit('cmd', cmd.trim());
  }

  function send(msg) {
    this.socket.emit('say', { msg: msg, room: 'front' });
  }

  function writeln(data) {
    var msgLine = this.$msgLine.clone().html(data.msg);
    this.$msgPane.append(msgLine);
  }
}
