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
    Cookies.set(arg.name, arg.value);
    sendCookies();
  });

  Shiny.addCustomMessageHandler('rmcookie', function(arg) {
    Cookies.remove(arg);
    sendCookies();
  });


});
