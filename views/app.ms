class App {
  function initialize(host, port) {
    var serverAddress = host + ':' + port;
    var socket = io.connect(serverAddress);

    this.messenger = new Messenger(socket);

    socket.on('connected', function(msg) {
      self.messenger.writeln(msg);
    });
    socket.on('receive', function(data) {
      self.messenger.writeln(data);
    });
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
    this.$msgInput.keypress(function(e) {
      if (e.which == 13) self.send();
    });
    this.$msgSend.click(function() {
      self.send()
    });
  }

  function send() {
    this.socket.emit('say', { body: self.$msgInput.val() });
    this.$msgInput.val('');
  }

  function writeln(data) {
    var msgLine = this.$msgLine.clone().html(data.body);
    this.$msgPane.append(msgLine);
  }
}
