//= require active_admin/base
//= require recurring_select

document.addEventListener('DOMContentLoaded', function (event) {
  $('body')
    .on('submit', 'form#bulk_schedule', function (_event) {
      document.querySelector("div.results").innerHTML = "<p>Processing...</p>"
    })
    .on('ajax:success', 'form#bulk_schedule', function (_event, result) {
      document.querySelector("div.results").innerHTML = result
    })
    .on("ajax:error", function (event) {
      document.querySelector("div.results").innerHTML = "<p>ERROR</p>"
    })
})