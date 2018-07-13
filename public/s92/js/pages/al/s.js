'use-strict';

/* Named function used in jquery.fileuploads.s92.js */
function getUploadData() {
  var h = getCSRFHash()
  h["pid"] = $("#pid").val();
  h["album_id"] = $("#album_id").val();
  return h;
}

/* Named function used in jquery.fileuploads.s92.js */
function onUploadComplete() {
}


$(document).ready(function(){

  initFiler($("#filer_songs"));

  $("#btn-save").click(function() {
    let data = $("#the_form").serialize();
    apost("/album/save/" + $("#pid").val(), data, (j) => {
      notify("top", "center", "", "inverse",
             "animated fadeIn", "animated fadeOut",
             "", "The data was saved.");
    });
  });

  // $("#icon-playing").css("font-size", "50px");
});
