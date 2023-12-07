document.addEventListener('DOMContentLoaded', () => {
  setInterval(getMostLiked, 1000)
})

function getMostLiked() {
  const playtimeDiv = document.querySelector('#playtime')
  playtimeDiv.innerHTML = ''

  fetch('/playtime').
    then((response) => response.json()).
    then(data => {
      return data.map((d) => ({
        ...d,
        playtime: {
          hrs: Math.floor(d.total_time / 3600),
          mins: Math.floor(d.total_time / 60) % 60,
          secs: Math.floor(d.total_time % 60)
        }
      }))
    }).
    then((results) => {
      return results.map(r => `
        <div class="card">
          <strong>${r.username}</strong>
          has played for ${r.playtime.hrs}h ${r.playtime.mins}m ${r.playtime.secs}s
        </div>
      `)
    }).
    then((displayableStrings) => {
      playtimeDiv.innerHTML = displayableStrings.join('')
    })
}

