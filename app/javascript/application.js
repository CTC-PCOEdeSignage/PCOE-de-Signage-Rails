import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import EventRequestController from "controllers/event_request_controller"

const application = Application.start()
application.register("event-request", EventRequestController)
