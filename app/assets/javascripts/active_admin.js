//= require active_admin/base

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
})