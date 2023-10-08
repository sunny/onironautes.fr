document.addEventListener("DOMContentLoaded", () => {
  let nextFound = false;
  document.querySelectorAll("[data-event]").forEach(element => {
    const timeElement = element.querySelector("[data-event-time]")
    const time = Date.parse(timeElement.attributes["datetime"].value)
    console.log(timeElement, time, Date.now())
    if (time < Date.now()) {
      element.classList.add("event--past")
    } else if (!nextFound) {
      element.classList.add("event--next")
      element.open = true;
      nextFound = true;
    }
  })
})
