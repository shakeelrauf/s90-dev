window.onerror = function(msg, url, lineNo, columnNo, error) {
  var message = [
            'Message: ' + msg,
            'URL: ' + url,
            'Line: ' + lineNo,
            'Column: ' + columnNo,
            'Error object: ' + JSON.stringify(error)
        ].join(' - ');

  var data = "m=" + message + "&l=" + document.location;
  apost("/sec/log_js_error", data, function() {});
  return false;
}
