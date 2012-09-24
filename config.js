var cli = require('./plugins/cli');

module.exports = function (server) {
  var front = server.room('front');

  require('./plugins/gh-issues')(front, { user: 'jeffsu', repo: 'mochiscript' });
  require('./plugins/time')(front);
  require('./plugins/cli')(front, 
    function (msg) { return msg.match(/^ls\s+/) },
    function (msg) { 
      var m = msg.match(/^ls\s+(.*)/);
      return 'ls ' + JSON.stringify(m[1]);
    });

  var frontDeploy = server.room('front-deploy');
  require('./plugins/cli-stream')(front, 
    function (msg) { return msg.match(/^tail\s+/) },
    function (msg) { 
      var m = msg.match(/^tail\s+(.*)/);
      return 'tail -f ' + JSON.stringify(m[1]);
    });

  server.listen(3000);
};
