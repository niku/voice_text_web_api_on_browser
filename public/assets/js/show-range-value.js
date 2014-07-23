$(function() {
  $("form").on("change reset", function() {
    $(this).find("input[type='range']").each(function() {
      var output = $(this).next();
      output.text(this.value);
    });
  });
});
