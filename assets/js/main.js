// Theme toggle (persisted)
(function () {
  const root = document.documentElement;
  const stored = localStorage.getItem("theme");
  const prefersLight = window.matchMedia("(prefers-color-scheme: light)").matches;
  const initial = stored || (prefersLight ? "light" : "dark");
  if (initial === "light") root.setAttribute("data-theme", "light");

  const toggle = document.getElementById("theme-toggle");
  const setIcon = () => {
    const isLight = root.getAttribute("data-theme") === "light";
    toggle.textContent = isLight ? "●" : "○";
  };
  setIcon();

  toggle.addEventListener("click", () => {
    const isLight = root.getAttribute("data-theme") === "light";
    if (isLight) {
      root.removeAttribute("data-theme");
      localStorage.setItem("theme", "dark");
    } else {
      root.setAttribute("data-theme", "light");
      localStorage.setItem("theme", "light");
    }
    setIcon();
  });
})();

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
