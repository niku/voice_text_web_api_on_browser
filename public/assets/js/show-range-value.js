$(function() {
  $("input[type='range']").on("change", function() {
    var output = $(this).next();
    output.val(this.value);
  });
});
