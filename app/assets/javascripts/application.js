//= require turbolinks

var slideLength = function () {
  return parseInt(document.body.dataset.slideLength, 10) * 1000;
}

var nextSlideUrl = function () {
  return document.body.dataset.nextSlideUrl;
}

var isSlidePage = function () {
  return document.body.classList.contains('screen-layout') && (document.querySelectorAll('.slide').length === 1)
}

var isEventRequestFormPage = function () {
  return document.body.classList.contains("EventRequestNew")
}

var advanceToNextSlide = function () {
  Turbolinks.clearCache();
  Turbolinks.visit(nextSlideUrl());
}

var pingNextSlideUrl = function (opts) {
  var request = new XMLHttpRequest();
  request.open('get', nextSlideUrl(), true);

  request.onload = function () {
    if (request.status >= 200 && request.status < 400) {
      if (opts.success !== undefined) {
        opts.success();
      }
    } else {
      if (opts.failure !== undefined) {
        opts.failure();
      }
    }
  };

  request.onerror = function () {
    if (opts.failure !== undefined) {
      opts.failure();
    }
  };

  request.send();
}

var tryToAdvanceToNextSlide = function (opts) {
  pingNextSlideUrl({
    success: advanceToNextSlide,
    failure: goToNextSlideAfterTimeout
  });
}

var goToNextSlideAfterTimeout = function () {
  if (window.goToNextSlideAfterTimeoutId !== undefined) {
    clearTimeout(window.goToNextSlideAfterTimeoutId);
    window.goToNextSlideAfterTimeoutId = undefined;
  }

  window.goToNextSlideAfterTimeoutId =
    setTimeout(function () {
      tryToAdvanceToNextSlide();
    }, slideLength())
}

var log = function (stuff) {
  console.log(stuff);
}

var setupSlidePage = function () {
  if (!isSlidePage()) {
    log('Not Slide Page');
    return
  }

  goToNextSlideAfterTimeout();
}

var updateStartAt = function () {
  var startAt = document.querySelector("form #event_start_at")

  var eventDateValue = document.querySelector("form #event_date").value
  var eventTimeValue = document.querySelector("form #event_time").value

  if (eventDateValue && eventTimeValue) {
    startAt.value = [eventDateValue, eventTimeValue].join("T")
  }
  console.log(startAt.value)
}
var setupEventRequestPage = function () {
  if (!isEventRequestFormPage()) {
    log('Not Event RequestFormPage');
    return
  }

  document.querySelector("form #event_date").addEventListener("change", updateStartAt)
  document.querySelector("form #event_time").addEventListener("change", updateStartAt)
}

var ready = function () {
  setupSlidePage()
  setupEventRequestPage()
}

var keyDownEvent = function (event) {
  // right arrow key
  if (event.keyCode === 39) {
    advanceToNextSlide();
  }
};

document.addEventListener('turbolinks:load', ready, false);
document.addEventListener('keydown', keyDownEvent, false);
