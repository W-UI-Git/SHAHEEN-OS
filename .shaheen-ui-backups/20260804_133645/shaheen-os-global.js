/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Global UI Runtime
|--------------------------------------------------------------------------
*/

(() => {
    "use strict";

    const SHAHEEN = {
        name: "SHAHEEN OS",
        version: "1.0.0",
    };

    window.SHAHEEN_OS = SHAHEEN;

    const init = () => {
        document.documentElement.dataset.shaheenOs = "true";

        document.querySelectorAll("[data-shaheen-hover]").forEach((element) => {
            element.classList.add("shaheen-os-hover");
        });

        document.querySelectorAll("[data-shaheen-glass]").forEach((element) => {
            element.classList.add("shaheen-os-glass");
        });

        document.querySelectorAll("[data-shaheen-reveal]").forEach((element) => {
            if (!element.hasAttribute("data-shaheen-reveal-ready")) {
                element.setAttribute("data-shaheen-reveal-ready", "true");
            }
        });

        window.dispatchEvent(
            new CustomEvent("shaheen:ready", {
                detail: SHAHEEN,
            })
        );
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init, { once: true });
    } else {
        init();
    }
})();
