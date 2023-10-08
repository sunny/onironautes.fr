function timeDifference(from, to) {
  const diff = to < from ? 0 : to - from
  const minutes = diff / (60 * 1000)
  const hours = minutes / 60
  const days = hours / 24
  const months = days / 30
  const years = months / 12

  if (minutes < 60) return timeFormat(minutes, "minute")
  if (hours < 60) return timeFormat(hours, "hour")
  if (days < 30) return timeFormat(days, "day")
  if (months < 12) return timeFormat(months, "month")
  return timeFormat(years, "year")
}

function timeFormat(value, unit) {
  const language = document.documentElement.lang
  const formatter = new Intl.RelativeTimeFormat(language, { numeric: "auto" })
  return formatter.format(parseInt(value, 10), unit)
}

function insertEventTimeUntilSpan(parent, time) {
  const element = document.createElement("span")
  element.innerText = timeDifference(Date.now(), time)
  element.classList.add("event__badge")
  parent.querySelector("summary").insertAdjacentElement("beforeend", element)
}

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

    // Open next event and show time until
    element.classList.add("event--next")
    element.open = true;
    insertEventTimeUntilSpan(element, time)
    nextFound = true;
  })
}

document.addEventListener("DOMContentLoaded", () => {
  handleEvents()
})
