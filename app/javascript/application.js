import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import EventRequestController from "controllers/event_request_controller"

const application = Application.start()
// registered by name to keep the data-controller="event_request" identifier
application.register("event_request", EventRequestController)
