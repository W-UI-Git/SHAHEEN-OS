/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Navigation Interaction Engine
|--------------------------------------------------------------------------
*/

(() => {
    "use strict";

    const state = {
        commandOpen: false,
        selectedIndex: 0,
    };

    const qs = (selector, root = document) =>
        root.querySelector(selector);

    const qsa = (selector, root = document) =>
        [...root.querySelectorAll(selector)];

    function openCommand() {
        const overlay = qs("[data-shaheen-command-overlay]");
        const input = qs("[data-shaheen-command-input]");

        if (!overlay) return;

        state.commandOpen = true;

        overlay.classList.add("is-open");
        overlay.setAttribute("aria-hidden", "false");

        document.body.classList.add("shaheen-command-open");

        requestAnimationFrame(() => {
            input?.focus();
        });
    }

    function closeCommand() {
        const overlay = qs("[data-shaheen-command-overlay]");

        if (!overlay) return;

        state.commandOpen = false;

        overlay.classList.remove("is-open");
        overlay.setAttribute("aria-hidden", "true");

        document.body.classList.remove("shaheen-command-open");
    }

    function filterCommands(value) {
        const query = value.trim().toLowerCase();

        const results = qsa("[data-shaheen-command-item]");

        results.forEach((item) => {
            const text =
                item.textContent.toLowerCase();

            const visible =
                !query || text.includes(query);

            item.hidden = !visible;
        });

        state.selectedIndex = 0;

        updateSelection();
    }

    function updateSelection() {
        const results = qsa(
            "[data-shaheen-command-item]:not([hidden])"
        );

        results.forEach((item, index) => {
            item.classList.toggle(
                "is-selected",
                index === state.selectedIndex
            );
        });
    }

    function activateSelected() {
        const results = qsa(
            "[data-shaheen-command-item]:not([hidden])"
        );

        const selected = results[state.selectedIndex];

        if (!selected) return;

        const href = selected.getAttribute("href");

        if (href) {
            closeCommand();
            window.location.href = href;
        }
    }

    function setupCommandPalette() {
        const overlay = qs("[data-shaheen-command-overlay]");
        const input = qs("[data-shaheen-command-input]");

        if (!overlay) return;

        qsa("[data-shaheen-command-open]").forEach((button) => {
            button.addEventListener("click", openCommand);
        });

        qsa("[data-shaheen-command-close]").forEach((button) => {
            button.addEventListener("click", closeCommand);
        });

        overlay.addEventListener("click", (event) => {
            if (event.target === overlay) {
                closeCommand();
            }
        });

        input?.addEventListener("input", () => {
            filterCommands(input.value);
        });

        input?.addEventListener("keydown", (event) => {
            const results = qsa(
                "[data-shaheen-command-item]:not([hidden])"
            );

            if (event.key === "ArrowDown") {
                event.preventDefault();

                if (results.length) {
                    state.selectedIndex =
                        (state.selectedIndex + 1) %
                        results.length;

                    updateSelection();
                }
            }

            if (event.key === "ArrowUp") {
                event.preventDefault();

                if (results.length) {
                    state.selectedIndex =
                        (state.selectedIndex - 1 + results.length) %
                        results.length;

                    updateSelection();
                }
            }

            if (event.key === "Enter") {
                event.preventDefault();
                activateSelected();
            }

            if (event.key === "Escape") {
                event.preventDefault();
                closeCommand();
            }
        });
    }

    function setupKeyboardShortcut() {
        document.addEventListener("keydown", (event) => {
            const modifier =
                event.ctrlKey || event.metaKey;

            if (modifier && event.key.toLowerCase() === "k") {
                event.preventDefault();

                if (state.commandOpen) {
                    closeCommand();
                } else {
                    openCommand();
                }
            }

            if (event.key === "Escape" && state.commandOpen) {
                closeCommand();
            }
        });
    }

    function setupActiveNavigation() {
        const currentPath =
            window.location.pathname.replace(/\/+$/, "") || "/";

        qsa("[data-shaheen-nav-link]").forEach((link) => {
            const href = link.getAttribute("href");

            if (!href || href.startsWith("#")) {
                return;
            }

            try {
                const url = new URL(
                    href,
                    window.location.origin
                );

                const path =
                    url.pathname.replace(/\/+$/, "") || "/";

                if (path === currentPath) {
                    link.classList.add("is-active");
                    link.setAttribute("aria-current", "page");
                }
            } catch (_) {
                // Ignore malformed URLs.
            }
        });
    }

    function setupMobileNavigation() {
        qsa("[data-shaheen-mobile-nav]").forEach((item) => {
            item.addEventListener("click", () => {
                qsa("[data-shaheen-mobile-nav]").forEach((node) => {
                    node.classList.remove("is-active");
                });

                item.classList.add("is-active");
            });
        });
    }

    function init() {
        document.body.classList.add(
            "shaheen-navigation-active"
        );

        setupCommandPalette();
        setupKeyboardShortcut();
        setupActiveNavigation();
        setupMobileNavigation();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }

    window.SHAHEENNavigation = {
        openCommand,
        closeCommand,
    };
})();
