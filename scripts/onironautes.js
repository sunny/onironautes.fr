function handleEvents() {
  let nextFound = false;
  document.querySelectorAll("[data-event]").forEach(element => {
    if (nextFound) return;

    const timeElement = element.querySelector("[data-event-time]")
    const time = Date.parse(timeElement.attributes["datetime"].value)

    // Strike old events
    if (time < Date.now() + 3_600) {
      element.classList.add("event--past")
      return
    }

    // Open next event
    element.classList.add("event--next")
    element.open = true;
    nextFound = true;
  })
}

handleEvents()
