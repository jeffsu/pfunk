
/**
 * Module dependencies.
 */
require('mochiscript');

var Server = require('./lib/server');
var server = new Server();
require('./config')(server);
