var exec = require('child_process').exec;

var children = {};

function cmd(msg, stream, transposer) {
  var child = exec(transposer(msg));
  var cmdId = stream.cmdId;
  child.stderr.on('data', function (data) { stream.writeStream(data.toString()) });
  child.stdout.on('data', function (data) { stream.writeStream(data.toString()) });
  children[stream.cmdId] = child;
  setTimeout(function () { kill(cmdId) }, 60000);
}

function kill(cmdId) {
  var child = children[cmdId];
  if (child) child.kill();
  delete children[cmdId];
}

module.exports = function (room, verifier, transposer) {
  room.plugin({
    canHandle: function (msg) { return msg.match(verifier) },
    handle:    function (msg, stream) { cmd(msg, stream, transposer) },
    kill:      kill
  });
};
