// 🌙 Mode clair / sombre
const modeToggle = document.getElementById("mode-toggle");
if (modeToggle) {
  modeToggle.addEventListener("click", () => {
    document.body.classList.toggle("light");
    modeToggle.textContent = document.body.classList.contains("light") ? "🌙" : "☀️";
  });
}



// 🕵️‍♂️ Slide-in à l'affichage
const observer = new IntersectionObserver(entries => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add("visible");
      observer.unobserve(entry.target);
    }
  });
});

document.querySelectorAll(".slide-in").forEach(el => observer.observe(el));

