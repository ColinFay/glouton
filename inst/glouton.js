$(document).on('shiny:connected', function(event) {
  function sendCookies(){
    var res = Cookies.get();
    Shiny.setInputValue("gloutoncookies", res, {priority: "event"});
  }

  sendCookies();

  Shiny.addCustomMessageHandler('fetchcookie', function(name) {
    var res = Cookies.get(name);
    Shiny.setInputValue("gloutoncookie", res, {priority: "event"});
  });

  Shiny.addCustomMessageHandler('fetchcookies', function(arg) {
    sendCookies();
  });

  Shiny.addCustomMessageHandler('addcookie', function(arg) {
    var c = Cookies.set(arg.name, arg.value, arg.options);
    if (arg.debug) console.log(c);
    sendCookies();
  });

  Shiny.addCustomMessageHandler('rmcookie', function(arg) {
    Cookies.remove(arg.name);
    sendCookies();
  });

  // R6Class
  function send_cookie(name){
    var res = Cookies.get(name);
    Shiny.setInputValue(name, res, {priority: "event"});
  }

  Shiny.addCustomMessageHandler('get-cookie', function(opts) {
    var res = Cookies.get(opts.name);
    send_cookie(opts.name);
  });

  Shiny.addCustomMessageHandler('set-cookie', function(opts) {
    Cookies.set(opts.name, opts.value, opts.options);
    send_cookie(opts.name);
  });

  Shiny.addCustomMessageHandler('rm-cookie', function(opts) {
    Cookies.remove(opts.name);
    send_cookie(opts.name);
  });

});
