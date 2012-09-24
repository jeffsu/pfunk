export class Filters {
  function initialize() {
    this.writes = [];
    this.errors = [];
    this.chats  = [];
  }
  
  function write(funct) {
    if (typeof funct == 'function') {
      this.writes.push(funct);
    } else {
      var ret = funct;
      foreach (var f in this.writes) ret = f(ret); 
      return ret;
    }
  }

  function chat(funct) {
    if (typeof funct == 'function') {
      this.chats.push(funct);
    } else {
      var ret = funct;
      foreach (var f in this.chats) ret = f(ret); 
      return ret;
    }
  }


  function error(funct) {
    if (typeof funct == 'function') {
      this.errors.push(funct);
    } else {
      var ret = funct;
      foreach (var f in this.errors) ret = f(ret); 
      return ret;
    }
  }
}
