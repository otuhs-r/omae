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
//= require moment/locale/ja
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require Chart.bundle
//= require chartkick

$(document).on('turbolinks:load', function() {
  $('body').layout('fix');
  $('.date').bootstrapMaterialDatePicker({
    weekStart : 0, time: false,
    lang: 'ja',
    cancelText: 'キャンセル',
    okTexk: '決定'
  });
  $('.time').bootstrapMaterialDatePicker({
    date: false, format: 'HH:mm',
    lang: 'ja',
    cancelText: 'キャンセル',
    okTexk: '決定'
  });
  $('#attendances').DataTable({
    'order'         : [[0, "desc"]],
    'paging'        : true,
    'lengthChange'  : true,
    'lengthMenu'    : [20, 50, 100],
    'displayLength' : 20,
    'searching'     : true,
    'ordering'      : true,
    'info'          : true,
    'autoWidth'     : true,
    'language': {
      "decimal": ".",
      "thousands": ",",
      "sProcessing": "処理中...",
      "sLengthMenu": "_MENU_ 件表示",
      "sZeroRecords": "データはありません。",
      "sInfo": " _TOTAL_ 件中 _START_ から _END_ まで表示",
      "sInfoEmpty": " 0 件中 0 から 0 まで表示",
      "sInfoFiltered": "（全 _MAX_ 件より抽出）",
      "sInfoPostFix": "",
      "sSearch": "検索:",
      "sUrl": "",
      "oPaginate": {
        "sFirst": "先頭",
        "sPrevious": "前",
        "sNext": "次",
        "sLast": "最終"
      }
    }
  });
});
//= require serviceworker-companion
