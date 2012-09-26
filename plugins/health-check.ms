var request = require('request');
var jade    = require('jade');
var template = jade.compile(<<END);
  ul.archetypes
    each server in servers
      li(style="color: #{server.color}")
        = server.name
        ul
          each instance in server.instances
            li
              a(style="color: #{instance.color}", href="#{instance.ipAddress}")= instance.ipAddress
          
  script(type='text/javascript')
    $(function() {
      $('.archetypes li').each(function() {
        $(this).popover();
      });
    });
    
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
