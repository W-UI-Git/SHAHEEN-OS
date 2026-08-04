/**
 * SHAHEEN OS
 * Global Components Interaction Layer
 */

(function () {
    'use strict';

    const SHAHEEN = window.SHAHEEN || {};

    SHAHEEN.components = {
        initialized: false,

        init() {
            if (this.initialized) {
                return;
            }

            this.bindButtons();
            this.bindCards();
            this.bindKeyboard();

            this.initialized = true;

            document.documentElement.setAttribute(
                'data-shaheen-components',
                'ready'
            );
        },

        bindButtons() {
            document.addEventListener('click', (event) => {
                const button = event.target.closest('[data-sh-button]');

                if (!button) {
                    return;
                }

                if (
                    window.matchMedia &&
                    window.matchMedia(
                        '(prefers-reduced-motion: reduce)'
                    ).matches
                ) {
                    return;
                }

                button.animate(
                    [
                        {
                            transform: 'scale(1)'
                        },
                        {
                            transform: 'scale(.97)'
                        },
                        {
                            transform: 'scale(1)'
                        }
                    ],
                    {
                        duration: 180,
                        easing: 'cubic-bezier(.22,1,.36,1)'
                    }
                );
            });
        },

        bindCards() {
            document.addEventListener('pointermove', (event) => {
                const card = event.target.closest(
                    '[data-sh-card-tilt]'
                );

                if (!card) {
                    return;
                }

                if (
                    window.matchMedia &&
                    window.matchMedia(
                        '(prefers-reduced-motion: reduce)'
                    ).matches
                ) {
                    return;
                }

                const rect = card.getBoundingClientRect();

                const x =
                    (event.clientX - rect.left) /
                    rect.width;

                const y =
                    (event.clientY - rect.top) /
                    rect.height;

                const rotateX = (0.5 - y) * 2;
                const rotateY = (x - 0.5) * 2;

                card.style.transform =
                    `perspective(900px) ` +
                    `rotateX(${rotateX}deg) ` +
                    `rotateY(${rotateY}deg) ` +
                    `translateY(-3px)`;
            });

            document.addEventListener('pointerleave', () => {
                document
                    .querySelectorAll('[data-sh-card-tilt]')
                    .forEach((card) => {
                        card.style.transform = '';
                    });
            }, true);
        },

        bindKeyboard() {
            document.addEventListener('keydown', (event) => {
                if (
                    (event.ctrlKey || event.metaKey) &&
                    event.key.toLowerCase() === 'k'
                ) {
                    const target =
                        document.querySelector(
                            '[data-sh-command]'
                        );

                    if (target) {
                        event.preventDefault();
                        target.focus();
                    }
                }
            });
        }
    };

    window.SHAHEEN = SHAHEEN;

    if (document.readyState === 'loading') {
        document.addEventListener(
            'DOMContentLoaded',
            () => SHAHEEN.components.init()
        );
    } else {
        SHAHEEN.components.init();
    }
})();
