// Add and remove issue fields in the daily report form
$(document).on("click", ".add_fields", function(e) {
  e.preventDefault();
  var time = new Date().getTime();
  var regexp = new RegExp($(this).data("id"), "g");
  var newFields = $("#issues_fields").html();
$(this).before(newFields);
});

$(document).on("click", ".remove_fields", function(e) {
  e.preventDefault();
  $(this).closest(".nested-fields").remove();
});