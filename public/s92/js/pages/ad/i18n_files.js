function loadTable(fn) {
  if (fn == "") {
    return;
  }
  apost("/ad/i18n_table", "fn=" + fn, function(html) {
    $("#div-table").html(html);
  });
}

$(document).ready(function() {
  $("#select-files").change(function() {
    loadTable($("#select-files").val());
  });

  var fn = $("#input-fn").val();
  if (fn != null && fn != "") {
    loadTable(fn);
  }
});
