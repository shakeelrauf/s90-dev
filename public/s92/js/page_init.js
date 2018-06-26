$(document).ready(function(){
	'use-strict';
  $("#search-icon").click(function() {
		if ($("#search-box").val().length > 3) {
			apost("/search/search", "q=" + $("#search-box").val(), function(res) {
				alert(res);
			});
		}
  });

	$("body").show();
});
