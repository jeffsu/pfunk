var mongo    = require('mongodb'),
    DbServer = mongo.Server,
    Db       = mongo.Db;

export class Persister {
  include $m.EventEmitter;

  function initialize() {
    this.status = 'idle';
  }

  function ready(cb) {
    if (this.status == 'connecting') 
      this.on('connected', #{ cb() });
    else cb();
  }

  function connect(options) { 
    this.status = 'connecting';
    var name = options.name || 'pfunk';
    var host = options.host || 'localhost';
    var port = options.port || 27017;

    var dbServer = new DbServer(host, port , { auto_reconnect: true });
    var db       = new Db(name, dbServer);

    db.open(#(err, db){
      if (!err) {
        console.log('connected to db on ' + host + ':' + port);
        self.status = 'connected';
        self.db = db;
        self.emit('connected', true);
      } else {
        return new Error('could not connect to database');
      }
    });
  }


  function write(type, data) {
    if (!this.db) return;
    var room = data.room;
    if (!room) return;

    this.db.collection(room, #(err, collection){
      collection.insert(self.wrap(type, data));
    });
  }

  function retrieve(name, query, cb) {
    if (!this.db) return;

    query = query || {};
    this.db.collection(name, #(err, collection){
      collection.find(query).each(#(err, item) {
        if (!err) cb(item);
      });
    });
  }

  function getDateRange(name, from, to, cb) {
    if (!this.db) return;

    var query = { timestamp: { $gte: from, $lt:  to } }
    this.retrieve(name, query, cb);
  }

  function wrap(type, data) {
    return {
      timestamp: data.timestamp || new Date(),
      username:  data.username,
      type:      type, 
      data: data
    };
  }
}

