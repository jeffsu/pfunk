var exec = require('child_process').exec;
function cmd(msg, stream, transposer) {
  console.log(transposer(msg));
  var child = exec(transposer(msg));
  child.stderr.on('data', function (data) { stream.error(data.toString()) });
  child.stdout.on('data', function (data) { stream.write(data.toString()) });
}

module.exports = function (room, verifier, transposer) {
  room.plugin({
    canHandle: verifier,
    handle: function (msg, stream) { cmd(msg, stream, transposer) }
  });

};
