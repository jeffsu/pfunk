module.exports = #(room, options) {

  room.plugin({
    canHandle: #(msg) { => msg.match(/^tag\s+(.*)$/i); },
    handle: #(msg, stream) {

      var m = msg.match(/^tag\s+(\w+)\s+(\w+)$/i);
      var command = m[1];
      var tag     = m[2];

      if (!m[1]) { 
        stream.error(<<END);
          USAGE: ! record [tag] 
          special characters not allowed
        END
      }

      switch (command) {
        case: "start":
          room.persister.write(options.table, { tag: m[1], begin: new Date(), end: null });
        break;
        case: "end":
          //room.persister.update(options.table, { tag: m[1], begin: new Date(), end: null });
        break;
        case: "list":
        break;
        case: "show":
        break;
      }
    }
  });
}
