var mongo    = require('mongodb'),
    DbServer = mongo.Server,
    Db       = mongo.Db;

export class Persister {
  include $m.EventEmitter;

  function initialize(options) {
    this.isConnected = false;
    var name = options.name || 'pfunk';
    var host = options.host || 'localhost';
    var port = options.port || 27017;

    var dbServer = new DbServer(host, port , { auto_reconnect: true });
    var db       = new Db(name, dbServer);

    db.open(#(err, db){
      if (!err) {
        console.log('connected to db on ' + host + ':' + port);
        self.isConnected = true;
        self.db = db;
        self.emit('connected', true);
      } else {
        return new Error('could not connect to database');
      }
    });
  }

  function add(name, data) {
    this.db.collection(name, #(err, collection){
      collection.insert(data);
    });
  }

  function retrieve(name, query) {
    query = query || {};
    this.db.collection(name, #(err, collection){
      collection.find(query).toArray(function(err, items) {
        console.log(items);
      });
    });
  }
}

