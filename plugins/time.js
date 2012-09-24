module.exports.canHandle = function (msg) {
  return msg.match(/^time$/i);
};

module.exports.handle = function (msg, stream) {
  stream.end((new Date).toString());
};
