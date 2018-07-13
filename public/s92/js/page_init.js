$(document).ready(function(){
	'use-strict';
  $("#search-icon").click(function() {
		if ($("#search-box").val().length > 3) {
			apost("/search/search", "q=" + $("#search-box").val(), function(res) {
				alert(res);
			});
		}
  });

  // Validate the form...
	if ($("#the_form") && $("#the_form").length > 0) {
		$("#the_form").validate();
	}

	// Fix the bottom player
	/*
  var toggleAffix = function(affixElement, scrollElement, wrapper) {
    var height = affixElement.outerHeight();
    var b = wrapper.offset().top;
    var ih = window.innerHeight;
    var sh = scrollElement.outerHeight();
    var t = ih - 55 + window.scrollY;
    $("#nav-nav").offset({top: t, left:0})
  };


  $('[data-toggle="affix"]').each(function() {
    var ele = $(this),
        wrapper = $('<div></div>');

    ele.before(wrapper);
    $(window).on('scroll resize', function() {
        toggleAffix(ele, $(this), wrapper);
    });

    // init
    toggleAffix(ele, $(window), wrapper);
  });
	*/

	$(".navigate-inner").click(function(e) {
		e.preventDefault();
		navigateInner($(this).prop('href'));
	});
});

function navigateInner(href) {
	aget(href, function(html) {
		$("#pcoded").html(html);
	});
}
