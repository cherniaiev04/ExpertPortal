document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById("search-input");
    const projectCards = document.querySelectorAll(".card");
  
    // Add event listener to search input
    searchInput.addEventListener("input", (e) => {
      const query = e.target.value.toLowerCase(); // Get search input value
      projectCards.forEach((card) => {
        const projectName = card.querySelector(".card-title").textContent.toLowerCase(); // Project name text
        const projectType = card.querySelector(".text-secondary").textContent.toLowerCase(); // Project type text
        const location = card.querySelector(".location_badge").textContent.toLowerCase(); // Location text
  
        // Check if the query matches the project name, type, or location
        if (
          projectName.includes(query) ||
          projectType.includes(query) ||
          location.includes(query)
        ) {
          card.parentElement.style.display = "block"; // Show matching cards
        } else {
          card.parentElement.style.display = "none"; // Hide non-matching cards
        }
      });
    });
  });
  