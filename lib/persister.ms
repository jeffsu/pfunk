var mongo    = require('mongodb'),
    DbServer = mongo.Server,
    Db       = mongo.Db;

export class Persister {
  include $m.EventEmitter;

  function initialize() {
    this.isConnected = false;
  }

  function connect(options) { 
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


  function write(name, data) {
    this.db.collection(name, #(err, collection){
      collection.insert(self.timestamp(data));
    });
  }

  function retrieve(name, query, cb) {
    query = query || {};
    this.db.collection(name, #(err, collection){
      collection.find(query).toArray(function(err, items) {
        console.log(items);
      });
    });
  }

  function getDateRange(name, from, to, cb) {
    var query = {
      timestamp: {
        $gte: from,
        $lt:  to
      }
    }
    this.retrieve(name, query, cb);
  }

  function timestamp(data) {
    if (!data.timestamp) {
      data['timestamp'] = new Date();
    }
    return data;
  }
}

