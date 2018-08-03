$(function () {
  $('.15minute-step').timepicker({
    showInputs: false,
    showMeridian: false
  })

  $('.1minute-step').timepicker({
    showInputs: false,
    showMeridian: false,
    minuteStep: 1
  })

  $('.timepicker').click(function(){
    $('.timepicker').blur();
  });
})
