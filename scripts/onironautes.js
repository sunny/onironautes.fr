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

// This can be replaced by the `:playing` CSS pseudo-class when there is more
// browser support.
// https://developer.mozilla.org/en-US/docs/Web/CSS/:playing
function handleVideoPlay() {
  const playing = () => { document.body.classList.add("is-video-playing") }
  const stopped = () => { document.body.classList.remove("is-video-playing") }

  document.querySelectorAll("video").forEach(video => {
    video.addEventListener("play", playing)
    video.addEventListener("pause", stopped)
    video.addEventListener("ended", stopped)
  })
}

// Pause all videos when clicking outside of them.
function pauseOnClickOutsideVideo() {
  document.addEventListener("click", event => {
    if (!event.target.closest("video")) {
      document.querySelectorAll("video").forEach(video => video.pause())
    }
  })
}

handleEvents()
handleVideoPlay()
pauseOnClickOutsideVideo()
