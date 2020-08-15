//= require active_admin/base
//= require recurring_select

document.addEventListener('DOMContentLoaded', function (event) {
  var editorElement = document.querySelector("div#editor")
  if (editorElement) {
    var editor = ace.edit("editor")
    var mirroredElement = document.querySelector(editorElement.dataset.mirrorWith)

    editor.session.setMode("ace/mode/yaml")
    editor.getSession().on('change', function () {
      mirroredElement.value = editor.getSession().getValue();
    })
  }

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