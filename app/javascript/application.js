// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require assets/dailyreport_form
//= require cocoon


$(document).ready(function() {
    $(".dropdown-toggle").dropdown();
});


// Alert box when deleting stuff
$(document).ready(function() {
$(".delete-button").click(function(event) {
  event.preventDefault();
  if (confirm("Are you sure you want to delete this?")) {
    var form = $(this).parents("form")[0];
    form.submit();
  }
});
});


