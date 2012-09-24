var cli = require('./plugins/cli');

module.exports = function (server) {
  var front = server.room('front');
  front.plugin(require('./plugins/time'));
  front.plugin(cli({
    transposer: function (msg) { 
      var m = msg.match(/^ls\s+(.*)/);
      console.log('ls ' + JSON.stringify(m[1]));
      return 'ls ' + JSON.stringify(m[1]);
    },
    verifier: function (msg) { return msg.match(/^ls\s+/) }
  }));

  var frontDeploy = server.room('front-deploy');

  server.listen(3000);
};
