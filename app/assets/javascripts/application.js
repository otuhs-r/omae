// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery/dist/jquery.min
//= require bootstrap/dist/js/bootstrap.min
//= require admin-lte/dist/js/adminlte.min
//= require bootstrap-timepicker/js/bootstrap-timepicker.min
//= require bootstrap-datepicker/dist/js/bootstrap-datepicker.min
//= require datatables.net/js/jquery.dataTables.min
//= require datatables.net-bs/js/dataTables.bootstrap.min 
//= require moment/min/moment.min
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require Chart.bundle
//= require chartkick

$(document).on('turbolinks:load', function() {
  $('body').layout('fix');
  $('.date').bootstrapMaterialDatePicker({ weekStart : 0, time: false });
  $('.time').bootstrapMaterialDatePicker({ date: false, format: 'HH:mm' });
  $('#attendances').DataTable({
    'order'         : [[0, "desc"]],
    'paging'        : true,
    'lengthChange'  : true,
    'lengthMenu'    : [20, 50, 100],
    'displayLength' : 20,
    'searching'     : true,
    'ordering'      : true,
    'info'          : true,
    'autoWidth'     : true
  });
  $.extend( $.fn.dataTable.defaults, {
    language: {
      url: "http://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Japanese.json"
    }
  });
});
