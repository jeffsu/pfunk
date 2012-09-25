var cli = require('./plugins/cli');

module.exports = function (server) {
  // configure mongo
  server.persist({
    name: 'pfunk',
    host: 'localhost',
    port: 27017
  });

  var front = server.room('front');

  require('./plugins/gh-issues')(front, { user: 'jeffsu', repo: 'mochiscript' });
  require('./plugins/time')(front);

  require('./plugins/cli')(front, /^ls\s+/,
    function (msg) { 
      var m = msg.match(/^ls\s+(.*)/);
      return 'ls ' + JSON.stringify(m[1]);
    });

  var frontDeploy = server.room('front-deploy');
  require('./plugins/cli-stream')(front, /^tail\s+/,
    function (msg) { 
      var m = msg.match(/^tail\s+(.*)/);
      return 'tail -f ' + JSON.stringify(m[1]);
    });

  server.listen(3000);
  setInterval(function () {
    require('fs').appendFile(__dirname + "/tmp/foo", (new Date).toString() + "\n");
  }, 2000);
};
