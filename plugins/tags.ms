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
      return msg.match(currentTag ? /^tag\s+end$/i : /^tag\s+(.*)$/i); 
    },

    handle: #(msg, stream) {
      var m = msg.match(/^tag\s+(.*)\s*$/);
      if (m) {
        var cmd = m[1];
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


