document.addEventListener('DOMContentLoaded', () => {
  setInterval(getMostLiked, 1000)
})

function getMostLiked() {
  const playtimeDiv = document.querySelector('#playtime')
  playtimeDiv.innerHTML = ''

  fetch('/playtime').
    then((response) => response.json()).
    then(data => {
      const result = {}

      for (let [key, val] of Object.entries(data)) {
        const total_playtime = val.reduce((acc, cur) => acc += cur.total_time, 0)
        result[key] = {
          total_playtime,
          artists: val.map(({ artist_name, total_time }) => ({ artist_name, total_time }))
        }
      }

      return result
    }).
    then((results) => {
      let html = ""
      for (let [username, data] of Object.entries(results)) {
        playtimeDiv.innerHTML += `
          <div class="card">
            <strong>${username}</strong> has played for ${formatTime(data.total_playtime)}
          </div>
        `
      }
    });
}

function formatTime(seconds) {
  const hrs = Math.floor(seconds / 3600)
  const mins = Math.floor(seconds/ 60) % 60
  const secs = Math.floor(seconds % 60)

  return `${hrs}h ${mins}m ${secs}s`
}
