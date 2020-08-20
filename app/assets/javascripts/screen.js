//= require turbolinks

var slideLength = function () {
  return (parseInt(document.body.dataset.slideLength, 10) * 1000);
}

var nextSlideUrl = function () {
  return document.body.dataset.nextSlideUrl;
}

var isSlidePage = function () {
  return (document.querySelectorAll('.slide').length === 1);
}

var advanceToNextSlide = function () {
  Turbolinks.clearCache();
  Turbolinks.visit(nextSlideUrl());
}

var pingNextSlideUrl = function (opts) {
  var request = new XMLHttpRequest();
  request.open('HEAD', nextSlideUrl(), true);

  request.onload = function () {
    if (request.status >= 200 && request.status < 400) {
      if (opts.success) {
        opts.success();
      }
    } else {
      if (opts.failure) {
        opts.failure();
      }
    }
  };

  request.onerror = function () {
    if (opts.failure) {
      opts.failure();
    }
  };

  request.send();
}

var tryToAdvanceToNextSlide = function () {
  pingNextSlideUrl({
    success: advanceToNextSlide,
    failure: goToNextSlideAfterTimeout
  });
}

var goToNextSlideAfterTimeout = function () {
  if (window.goToNextSlideAfterTimeoutId) {
    clearTimeout(window.goToNextSlideAfterTimeoutId);
    window.goToNextSlideAfterTimeoutId = undefined;
  }

  window.goToNextSlideAfterTimeoutId = setTimeout(tryToAdvanceToNextSlide, slideLength());
}

var log = function (string) {
  console.log(string);
}

var setupSlidePage = function () {
  if (!isSlidePage()) {
    log('Not Slide Page');
    return;
  }

  goToNextSlideAfterTimeout();
}

var ready = function () {
  setupSlidePage();
}

var keyEvents = {
  39: advanceToNextSlide // right arrow key
};

var keyDownEvent = function (event) {
  var lookup = keyEvents[event.keyCode];
  if (lookup) {
    lookup(event);
  }
};

document.addEventListener('turbolinks:load', ready, false);
document.addEventListener('keydown', keyDownEvent, false);