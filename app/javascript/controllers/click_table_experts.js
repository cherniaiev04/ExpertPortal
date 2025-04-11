document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".expert-row").forEach((row) => {
      row.addEventListener("click", (event) => {
        const expertId = event.currentTarget.dataset.expertId;
        if (expertId) {
          // Redirect to the project's show page
          window.location.href = `/experts/${expertId}`;
        }
      });
    });
  });