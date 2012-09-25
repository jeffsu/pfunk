var Operator  = require('./operator');
var Persister = require('./persister');

export class Server {
  include $m.EventEmitter;

  function initialize() {
    // Routes
    this.app = require('./app').createApp();
    this.operator = new Operator(this.app);

    this.app.get('/', function (req, res, next) {
      res.render('rooms', { title: 'pfunk' })
    });
  }

  function room(name) {
    return this.operator.addRoom(name);
  }

  function listen(port) {
    if (this.persister && this.persister.isConnected) {
      this._listen(port);
    } else {
      this.persister.on('connected', #{ self._listen(port); });
    }
  }

  function _listen(port) {
    this.app.listen(port, #{
      console.log("Express server listening on port %d in %s mode", port, self.app.settings.env);
    });
  }
  
  function persist(host, port) {
    self.persister = new Persister(host, port);
  }
}
