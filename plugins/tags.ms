module.exports = #(room, options) {
  var currentTag  = null;
  var currentTime = null;
  var table       = options.table || 'tags';

  /*
   * !tag scrum
   * !tag end
   */
  room.plugin({
    canHandle: #(msg) { 
      return msg.match(/^tag\s+(.*)$/i); 
    },

    handle: #(msg, stream) {
      var m = msg.match(/^tag\s+(.*)\s*$/);
      if (m) {
        var cmd = m[1];
        if (cmd == 'end' && !currentTag) 
          return stream.error("Can't call 'tag end' without calling 'tag <tag>' first");

        if (currentTag && cmd != 'end') 
          return stream.error("Must end tag ('tag end') before starting a new tag");

        if (cmd == 'end' && currentTag) {
          saveTag(room, table, currentTag, currentTime, (new Date));
          stream.end('tagged ' + currentTag);
          currentTag  = null;
          currentTime = null;
        } else {
          currentTag = cmd; 
          currentTime = (new Date);
        }
      }
    }
  });
}

function saveTag(room, table, tag, start, end) {
  var data = { 
    room: room.name,
    tag: tag,
    start: start,
    end: end
  }
  room.persister.write(table, data)
}


