module.exports = function (server) {
  var front = server.addRoom('front');
  front.addPlugin(require('./plugins/time'));
  server.listen(3000);
};
