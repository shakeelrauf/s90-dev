window.onerror = function(msg, url, lineNo, columnNo, error) {
	var message = [
            'Message: ' + msg,
            'URL: ' + url,
            'Line: ' + lineNo,
            'Column: ' + columnNo,
            'Error object: ' + JSON.stringify(error)
        ].join(' - ');

	var data = {"m": message , "l": document.location.href};
	$.ajax({
		method: 'POST',
	  url: "/sec/log_js_error",
	  data: data,
		headers: {}});

	return false;
 };
