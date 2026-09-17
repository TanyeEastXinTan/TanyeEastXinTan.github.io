// Mobile nav toggle
(function () {
  const btn = document.getElementById("nav-toggle");
  const links = document.getElementById("nav-links");
  if (!btn || !links) return;
  btn.addEventListener("click", () => links.classList.toggle("open"));
  links.querySelectorAll("a").forEach((a) =>
    a.addEventListener("click", () => links.classList.remove("open"))
  );
})();

// Scroll reveal
(function () {
  const els = document.querySelectorAll(".reveal");
  if (!("IntersectionObserver" in window) || els.length === 0) {
    els.forEach((el) => el.classList.add("in"));
    return;
  }
  const io = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("in");
          io.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.12 }
  );
  els.forEach((el) => io.observe(el));
})();

// Footer year
(function () {
  const el = document.getElementById("year");
  if (el) el.textContent = new Date().getFullYear();
})();

// MapMyVisitors renders its globe at full document width and keeps re-measuring
// itself after load, so it has to be rescaled down to footer size repeatedly.
(function () {
  const TARGET_WIDTH = 200;
  function shrinkGlobe() {
    const outer = document.querySelector(".mmvst_outer");
    const wrap = document.querySelector(".footer-globe");
    if (!outer || !wrap) return;
    outer.style.transform = "none";
    const w = outer.offsetWidth;
    const h = outer.offsetHeight;
    if (!w || !h) return;
    const scale = TARGET_WIDTH / w;
    outer.style.transformOrigin = "top left";
    outer.style.transform = "scale(" + scale + ")";
    wrap.style.height = Math.round(h * scale) + "px";
  }
  [300, 1000, 2000, 4000].forEach((delay) => setTimeout(shrinkGlobe, delay));
  window.addEventListener("resize", shrinkGlobe);
})();
