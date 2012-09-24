module.exports = function (room, options) {
  var user = options.user;
  var repo = options.repo;
  var anchor = '<a href="https://github.com/' + user + '/' + repo + '/issues/$1">#$1</a>';

  room.filters.chat(function (msg) {
    return msg.replace(/#(\d+)/g, anchor);
  });
};
