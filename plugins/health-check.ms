var request = require('request');
var jade    = require('jade');
var template = jade.compile(<<END);
  table
    each server in servers
      tr
        td(style="color: #{server.color}")= server.name
END

module.exports = function (room) {
  room.plugin({
    canHandle: function(msg) { return msg.match(/^health$/i) },
    handle: function(msg, stream) { 
      request('http://dashboard.factual.com/widgets/health', function(err, res, body){
        if (err) return stream.error('cannot connnect to dashboard');
        stream.endHTML(template({ servers: JSON.parse(body) }));
      });
    }
  });
};
