const languageSelector = document.getElementById("language-select");
const contentDiv = document.getElementById("content");

function loadXMLDoc(url) {
  return new Promise((resolve, reject) => {
    const xhttp = new XMLHttpRequest();
    xhttp.open("GET", url, true);
    xhttp.onreadystatechange = () => {
      if (xhttp.readyState === 4 && xhttp.status === 200) resolve(xhttp.responseXML);
    };
    xhttp.onerror = reject;
    xhttp.send();
  });
}

// 🔁 Traduire dynamiquement le menu HTML statique en haut de page
function traduireMenu(xml, lang) {
  const items = xml.getElementsByTagName("item");
  const links = document.querySelectorAll("#nav-menu a");

  links.forEach(link => {
    const id = link.getAttribute("data-id");
    for (let i = 0; i < items.length; i++) {
      if (items[i].getAttribute("id") === id) {
        const labels = items[i].getElementsByTagName("label");
        for (let j = 0; j < labels.length; j++) {
          if (labels[j].getAttribute("lang") === lang) {
            link.textContent = labels[j].textContent;
          }
        }
      }
    }
  });
}

async function renderPortfolio(lang) {
  try{
    const [xml, xsl] = await Promise.all([
    loadXMLDoc("data.xml"),
    loadXMLDoc("template.xsl")
    ]);

    // Met à jour la langue active dans le XML
    const langueNode = xml.getElementsByTagName("langue")[0];
    if (langueNode) langueNode.setAttribute("active", lang);

    // Direction RTL si arabe
    document.documentElement.setAttribute("dir", lang === "ar" ? "rtl" : "ltr");

    const processor = new XSLTProcessor();
    processor.importStylesheet(xsl);
    const result = processor.transformToFragment(xml, document);

    // Injecte le HTML transformé dans le contenu
    contentDiv.innerHTML = "";
    contentDiv.appendChild(result);

    // Appliquer la traduction du menu statique
    traduireMenu(xml, lang);

    // Réactiver les effets JS
    relancerEffets();

  }catch (err) {
    contentDiv.innerHTML = "<p style='color:red;'>Erreur de chargement. Veuillez réessayer plus tard.</p>";
    console.error("Erreur XSL/XML :", err);
  }
}

function relancerEffets() {
  const el = document.getElementById("typewriter");
  if (el) {
    const text = el.textContent.trim();
    el.textContent = "";
    let i = 0;
    const interval = setInterval(() => {
      el.textContent += text[i];
      i++;
      if (i >= text.length) clearInterval(interval);
    }, 50);
  }

  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
        observer.unobserve(entry.target);
      }
    });
  });

  document.querySelectorAll(".slide-in").forEach(el => observer.observe(el));
}

// Chargement initial
renderPortfolio("fr");

// Sur changement de langue
languageSelector.addEventListener("change", (e) => {
  renderPortfolio(e.target.value);
});
