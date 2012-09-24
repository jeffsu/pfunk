var exec = require('child_process').exec;

var children = {};

function cmd(msg, stream, transposer) {
  var child = exec(transposer(msg));
  child.stderr.on('data', function (data) { stream.writeStream(data.toString()) });
  child.stdout.on('data', function (data) { stream.writeStream(data.toString()) });
  children[stream.cmdId] = child;
}

function kill(cmdId) {
  var child = children[cmdId];
  if (child) child.kill();
}

module.exports = function (room, verifier, transposer) {
  room.plugin({
    canHandle: verifier,
    handle:   function (msg, stream) { cmd(msg, stream, transposer) },
    kill:     kill
  });
};


