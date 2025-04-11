document.addEventListener("DOMContentLoaded", () => {
    const clearButton = document.getElementById("clear-filters");
    const filtersForm = document.getElementById("filters-form");

    if (clearButton && filtersForm) {
        clearButton.addEventListener("click", () => {
            // Reset all form fields
            filtersForm.reset();

            // Submit the form to reload the page without filters
            filtersForm.submit();
        });
    }
});
