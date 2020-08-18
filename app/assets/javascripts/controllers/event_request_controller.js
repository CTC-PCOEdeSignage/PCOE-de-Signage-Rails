window.application.register('event_request', class extends Stimulus.Controller {
  static targets = ["dateTime", "date", "time"]

  connect() {
    this.update()
  }

  update() {
    if (this.dateTimeTarget && this.dateTarget && this.timeTarget) {
      this.dateTimeTarget.value = [this.dateTarget.value, this.timeTarget.value].join("T")
    }
  }
})
