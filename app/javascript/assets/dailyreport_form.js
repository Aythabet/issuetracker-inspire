  $(document).on("click", ".add-issue", function(){
    var newIssue = $(".issues-fields:last").clone();
    newIssue.find("input").val("");
    newIssue.appendTo(".issues-fields-container");
  });
  $(document).on("click", ".remove-issue", function(){
    $(this).closest(".issues-fields").remove();
  });
