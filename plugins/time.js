module.exports = function (room) {
  room.plugin({
    canHandle: function(msg) { return msg.match(/^time$/i) },
    handle: function(msg, stream) { return stream.end((new Date).toString()); }
  });
};
