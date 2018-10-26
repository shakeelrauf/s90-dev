function loadTable(fn) {
  apost("/admin/i18n_table", "fn=" + fn, function(html) {
    $("#div-table").html(html);
  });
}

function pageSpecificReady() {
  $("#select-files").change(function() {
    debugger;
    loadTable($("#select-files").val());
  });

  var fn = $("#input-fn").val();
  if (fn != null && fn != "") {
    loadTable(fn);
  }
}
