/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Premium Responsive Shell Runtime
|--------------------------------------------------------------------------
*/

(() => {
    "use strict";

    const initShaheenShell = () => {
        const header = document.querySelector(".shaheen-shell-header");
        const menuToggle = document.querySelector(
            "[data-shaheen-menu-toggle]"
        );
        const mobileMenu = document.querySelector(
            "[data-shaheen-mobile-menu]"
        );

        if (header) {
            const updateHeader = () => {
                header.classList.toggle(
                    "is-scrolled",
                    window.scrollY > 12
                );
            };

            updateHeader();

            window.addEventListener(
                "scroll",
                updateHeader,
                { passive: true }
            );
        }

        if (menuToggle && mobileMenu) {
            const closeMenu = () => {
                mobileMenu.classList.remove("is-open");
                menuToggle.setAttribute("aria-expanded", "false");
            };

            const toggleMenu = () => {
                const open = mobileMenu.classList.toggle("is-open");

                menuToggle.setAttribute(
                    "aria-expanded",
                    open ? "true" : "false"
                );
            };

            menuToggle.addEventListener("click", toggleMenu);

            mobileMenu
                .querySelectorAll("a")
                .forEach((link) => {
                    link.addEventListener("click", closeMenu);
                });

            document.addEventListener("keydown", (event) => {
                if (event.key === "Escape") {
                    closeMenu();
                }
            });

            window.addEventListener("resize", () => {
                if (window.innerWidth > 1024) {
                    closeMenu();
                }
            });
        }

        window.dispatchEvent(
            new CustomEvent("shaheen:shell-ready", {
                detail: {
                    project: "SHAHEEN OS",
                    version: "1.0.0",
                },
            })
        );
    };

    if (document.readyState === "loading") {
        document.addEventListener(
            "DOMContentLoaded",
            initShaheenShell,
            { once: true }
        );
    } else {
        initShaheenShell();
    }
})();
