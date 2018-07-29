$(function () {
  $('.timepicker').timepicker({
    showInputs: false,
    showMeridian: false
  })

  $('.timepicker').click(function(){
    $('.timepicker').blur();
  });
})
