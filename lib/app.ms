module.exports.createApp = #(config) {
  var mochiscript = require('mochiscript');
  var express = require('express')
    , path = require('path');
  var dir = path.join(__dirname, '..');

  var app = module.exports = express.createServer();

  // Configuration
  app.configure(function(){
    console.log(dir);
    app.set('views', dir + '/views');
    app.set('view engine', 'jade');
    app.set("view options", { pretty: true });
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express.static(dir + '/public'));
  });

  app.configure('development', function(){
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
    app.use(mochiscript.middleware({ src: dir + '/public' }));
  });

  app.configure('production', function(){
    app.use(express.errorHandler());
    app.use(mochiscript.middleware({ 
      src:  path.join(__dirname, '/views'), 
      dest: path.join(__dirname, '/public/javascripts')
    }));
  });

  return app;
};
