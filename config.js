var cli = require('./plugins/cli');

module.exports = function (server) {
  var front = server.room('front');

  require('./plugins/gh-issues')(front, { user: 'jeffsu', repo: 'mochiscript' });
  require('./plugins/time')(front);
  require('./plugins/cli')(front, 
    function (msg) { 
      return msg.match(/^ls\s+/) 
    },
    function (msg) { 
      var m = msg.match(/^ls\s+(.*)/);
      console.log('ls ' + JSON.stringify(m[1]));
      return 'ls ' + JSON.stringify(m[1]);
    });

  var frontDeploy = server.room('front-deploy');
  server.listen(3000);
};
