//= require turbolinks

var slideLength = function() {
  return parseInt(document.body.dataset.slideLength, 10) * 1000;
}

var nextSlideUrl = function() {
  return document.body.dataset.nextSlideUrl;
}

var isSlidePage = function() {
  return document.body.classList.contains("screen-layout") && (document.querySelectorAll(".slide").length === 1)
}

var advanceToNextSlide = function() {
  Turbolinks.clearCache();
  Turbolinks.visit(nextSlideUrl());
}

var goToNextSlideAfterTimeout = function() {
  setTimeout(function() {
    advanceToNextSlide()
  }, slideLength())
}

var log = function(stuff) {
  console.log(stuff);
}

var ready = function() {
  if (isSlidePage()) {
    goToNextSlideAfterTimeout()
  } else {
    log("all screens");
  }
}

var keyDownEvent = function(event) {
  // right arrow key
  if (event.keyCode === 39) {
    advanceToNextSlide();
  }
};

document.addEventListener('turbolinks:load', ready, false);
document.addEventListener('keydown', keyDownEvent, false);
