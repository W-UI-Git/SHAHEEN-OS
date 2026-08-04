/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Motion Controller
|--------------------------------------------------------------------------
*/

(() => {
    'use strict';

    const reducedMotion = window.matchMedia(
        '(prefers-reduced-motion: reduce)'
    );

    const revealElements = () => {
        const elements = document.querySelectorAll(
            '.shaheen-reveal, .shaheen-scale-reveal, .shaheen-fade, .shaheen-stagger'
        );

        if (!elements.length) {
            return;
        }

        if (reducedMotion.matches) {
            elements.forEach((element) => {
                element.classList.add('is-visible');
            });

            return;
        }

        if (!('IntersectionObserver' in window)) {
            elements.forEach((element) => {
                element.classList.add('is-visible');
            });

            return;
        }

        const observer = new IntersectionObserver(
            (entries, instance) => {
                entries.forEach((entry) => {
                    if (!entry.isIntersecting) {
                        return;
                    }

                    entry.target.classList.add('is-visible');

                    instance.unobserve(entry.target);
                });
            },
            {
                root: null,
                rootMargin: '0px 0px -8% 0px',
                threshold: 0.08,
            }
        );

        elements.forEach((element) => {
            observer.observe(element);
        });
    };

    const initNavigation = () => {
        const navigation = document.querySelector(
            '.market-nav-surface, nav'
        );

        if (!navigation) {
            return;
        }

        const update = () => {
            if (window.scrollY > 16) {
                navigation.classList.add(
                    'shaheen-nav-scrolled'
                );
            } else {
                navigation.classList.remove(
                    'shaheen-nav-scrolled'
                );
            }
        };

        update();

        window.addEventListener(
            'scroll',
            update,
            {
                passive: true,
            }
        );
    };

    const initButtons = () => {
        document
            .querySelectorAll(
                'button, a[type="button"], .btn'
            )
            .forEach((element) => {
                element.classList.add(
                    'shaheen-interactive'
                );
            });
    };

    const initCards = () => {
        document
            .querySelectorAll(
                '.card, [class*="card"]'
            )
            .forEach((element) => {
                if (!element.classList.contains(
                    'shaheen-card'
                )) {
                    return;
                }
            });
    };

    const init = () => {
        document.documentElement.classList.add(
            'shaheen-motion'
        );

        revealElements();
        initNavigation();
        initButtons();
        initCards();
    };

    if (document.readyState === 'loading') {
        document.addEventListener(
            'DOMContentLoaded',
            init,
            {
                once: true,
            }
        );
    } else {
        init();
    }
})();
