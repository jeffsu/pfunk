var Operator  = require('./operator');

export class Server {

  function initialize() {
    // Routes
    this.app = require('./app').createApp();

    this.app.get('/', function (req, res, next) {
      res.render('rooms', { title: 'pfunk' })
    });

    this.operator = new Operator(this.app);
  }

  function room(name) {
    return this.operator.addRoom(name);
  }

  function listen(port) {
    var persister = this.operator.persister;

    persister.ready(#{ 
      self.app.listen(port, #{
        console.log("Express server listening on port %d in %s mode", port, self.app.settings.env);
      });
    });
  }

  function persist(options) {
    this.operator.persist(options);
  }
}
