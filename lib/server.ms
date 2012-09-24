var Operator = require('./operator');
export class Server {
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
    this.app.listen(port, function () {
      console.log("Express server listening on port %d in %s mode", port, self.app.settings.env);
    });

  }
}
