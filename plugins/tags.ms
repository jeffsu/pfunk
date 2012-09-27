module.exports = #(room, options) {
  newPlugin(room, options);
};

function newPlugin(room, options) {
  var currentTag  = null;
  var currentTime = null;

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
          saveTag(room.name, currentTag, currenTime, (new Date));
          stream.end('tagged ' + currentTag);
          currentTag = null;
        } else {
          currentTag = cmd; 
          currentTime = (new Date);
        }
      }
    }
  });
}

function saveTag(roomName, tag, start, end) {

}


