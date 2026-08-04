/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Global UI Runtime
|--------------------------------------------------------------------------
*/

(function () {
    "use strict";

    const reducedMotion = window.matchMedia(
        "(prefers-reduced-motion: reduce)"
    ).matches;

    function initReveal() {
        const elements = document.querySelectorAll(
            "[data-shaheen-reveal]"
        );

        if (!elements.length) {
            return;
        }

        if (reducedMotion || !("IntersectionObserver" in window)) {
            elements.forEach(function (element) {
                element.classList.add("shaheen-visible");
            });

            return;
        }

        const observer = new IntersectionObserver(
            function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        entry.target.classList.add("shaheen-visible");
                        observer.unobserve(entry.target);
                    }
                });
            },
            {
                threshold: 0.12
            }
        );

        elements.forEach(function (element) {
            observer.observe(element);
        });
    }

    function initBrandLinks() {
        document
            .querySelectorAll("[data-shaheen-brand]")
            .forEach(function (element) {
                element.addEventListener("click", function () {
                    window.scrollTo({
                        top: 0,
                        behavior: reducedMotion ? "auto" : "smooth"
                    });
                });
            });
    }

    function initImageMotion() {
        if (reducedMotion) {
            return;
        }

        document
            .querySelectorAll("[data-shaheen-image-motion]")
            .forEach(function (image) {
                image.addEventListener("pointermove", function (event) {
                    const rect = image.getBoundingClientRect();

                    const x =
                        ((event.clientX - rect.left) / rect.width - 0.5) *
                        2;

                    const y =
                        ((event.clientY - rect.top) / rect.height - 0.5) *
                        2;

                    image.style.transform =
                        "scale(1.025) translate(" +
                        x * 3 +
                        "px," +
                        y * 3 +
                        "px)";
                });

                image.addEventListener("pointerleave", function () {
                    image.style.transform = "";
                });
            });
    }

    function init() {
        initReveal();
        initBrandLinks();
        initImageMotion();

        document.documentElement.classList.add(
            "shaheen-os-ready"
        );
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
