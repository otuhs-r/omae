$('.datepicker').datepicker({
  format: "yyyy/mm/dd",
  todayBtn: "linked",
  autoclose: true,
  todayHighlight: true
})

$('.datepicker').click(function(){
  $('.datepicker').blur();
});
