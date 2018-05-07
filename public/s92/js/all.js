/* all.js */
function setCookie(cname, cvalue, domainCookie) {
    var d = new Date();
    d.setTime(d.getTime() + (365*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    var suffix = "";
    if (domainCookie) {
    	// Create a hostname in the form or .cocooningfinance.net
    	h = document.location.hostname;
    	if (h.indexOf(".") != -1) {
	  		h = h.substring(h.indexOf("."));   // Keep .cocooningfinance.net
    	}
    	suffix = ";domain=" + h + ";path=/";
    }
    document.cookie = cname + "=" + cvalue + "; " + expires + suffix;
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
    }
    return "";
}

function deleteCookie( name ) {
	document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}

function startSessionPing() {
	setTimeout(sessionCheck, 5 * 60000);
}

function sessionCheck() {
	$.ajax({
		method: 'GET',
	    url: '/sec/ping'
	})
	.done(function(j) {
		if (j['res'] != 'ok') {
			document.location = "/sec/timeout";
		} else {
			startSessionPing();
		}
	})
	.fail(function() {
		document.location = "/sec/login";
	});
}

/*
 * AJAX post, encapsulates the error handing, CSRF
 * Assumes a JSON response
 * onDone: A function that takes an object
 */
function apost(url, data, onDone) {
	if (url == null) {
		alert(i18n('error.server_error'));
		return;
	}

  // Add the RoR CSRF token
  if (data == null) {
    data = "";
  }
  var v = $("meta[name=csrf-token]").prop('content');
  data += "&authenticity_token=" + encodeURIComponent(v);

	$.ajax({
		method: 'POST',
	    url: url,
	    data: data,
		headers: { 'csrf_header': getCookie('csrf_cookie') }})

	.done(function(json) {
		if (onDone) {
			onDone(json);
		}
	})
	.fail(function() {
	    alert(i18n('error.server_error'));
	});
}

function aget(url, onDone) {
	if (url == null) {
		alert(i18n('error.server_error'));
		return;
	}

	$.ajax({
		method: 'GET',
	    url: url
	})
	.done(function(r) {
		if (onDone) {
			onDone(r);
		}
	})
	.fail(function() {
	    alert(i18n('error.server_error'));
	});
}

window.I18n = {
}

function i18n(key) {
    if(!key){
      return "N/A";
    }

    var keys = key.split(".");
    var comp = window.I18n;
    $(keys).each(function(_, value) {
      if(comp){
        comp = comp[value];
      }
    });

    if(!comp && console){
      console.debug("No translation found for key: " + key);
      return key;
    }

    return comp;
}
