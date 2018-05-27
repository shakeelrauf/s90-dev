/* Named function used in jquery.fileuploads.s92.js */
function getUploadData() {
  //alert("getUploadData");
  var h = getCSRFHash()
  h["pid"] = $("#pid").val();
  return h;
}

$(document).ready(function(){
	'use-strict';
  initFiler($("#filer_songs"));
});
