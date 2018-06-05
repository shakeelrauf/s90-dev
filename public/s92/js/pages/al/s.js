/* Named function used in jquery.fileuploads.s92.js */
function getUploadData() {
  var h = getCSRFHash()
  h["pid"] = $("#pid").val();
  h["album_id"] = $("#album_id").val();
  return h;
}

/* Named function used in jquery.fileuploads.s92.js */
function onUploadComplete() {
  alert('upload complete');
}

$(document).ready(function(){
	'use-strict';
  initFiler($("#filer_songs"));
});
