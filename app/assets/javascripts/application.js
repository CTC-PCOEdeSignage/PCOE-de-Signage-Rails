//= require turbolinks

var slideLength = function() {
  return parseInt(document.body.dataset.slideLength, 10) * 1000;
}

var nextSlideUrl = function() {
  return document.body.dataset.nextSlideUrl;
}

var advanceToNextSlide = function() {
  Turbolinks.visit(nextSlideUrl());
  Turbolinks.clearCache();
}
var goToNextSlideWhenReady = function() {
  setTimeout(function() { advanceToNextSlide() }, slideLength())
}

var log = function(stuff) {
  console.log(stuff);
  // var error = document.querySelector(".error");
  // var currentText = error.innerHTML;
  //
  // error.innerHTML = stuff + '<br/>' + currentText;
}

var ready = function() {
  if (document.body.classList.contains("screen-layout")) {
    goToNextSlideWhenReady()
  } else {
    log("all screens");
  }
}

document.addEventListener('turbolinks:load', ready, false);
