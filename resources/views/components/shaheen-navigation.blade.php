@php
    $brandSymbol = asset('brand/logo/shaheen-os-symbol.svg');

    $navigation = [
        [
            'section' => 'Core',
            'items' => [
                ['label' => 'Home', 'icon' => '⌂', 'url' => '/'],
                ['label' => 'Explore', 'icon' => '◈', 'url' => '/explore'],
                ['label' => 'Search', 'icon' => '⌕', 'command' => true],
            ],
        ],
        [
            'section' => 'Platform',
            'items' => [
                ['label' => 'Agents', 'icon' => '✦', 'url' => '/agents'],
                ['label' => 'Models', 'icon' => '◉', 'url' => '/models'],
                ['label' => 'Workspace', 'icon' => '▦', 'url' => '/workspace'],
                ['label' => 'Marketplace', 'icon' => '◇', 'url' => '/marketplace'],
                ['label' => 'Tools', 'icon' => '⌘', 'url' => '/tools'],
            ],
        ],
        [
            'section' => 'System',
            'items' => [
                ['label' => 'Settings', 'icon' => '⚙', 'url' => '/settings'],
                ['label' => 'Help', 'icon' => '?', 'url' => '/help'],
            ],
        ],
    ];
@endphp

<aside
    class="shaheen-navigation"
    aria-label="SHAHEEN OS navigation"
>
    <a
        href="/"
        class="shaheen-navigation__brand"
        aria-label="SHAHEEN OS"
    >
        <span class="shaheen-navigation__brand-symbol">
            <img
                src="{{ $brandSymbol }}"
                alt="SHAHEEN OS"
                loading="eager"
            >
        </span>

        <span class="shaheen-navigation__brand-name">
            <span class="shaheen-navigation__brand-title">
                SHAHEEN OS
            </span>

            <span class="shaheen-navigation__brand-subtitle">
                Intelligent Platform
            </span>
        </span>
    </a>

    <button
        type="button"
        class="shaheen-navigation__search"
        data-shaheen-command-open
        aria-label="Open SHAHEEN OS command palette"
    >
        <span aria-hidden="true">⌕</span>

        <span class="shaheen-navigation__search-label">
            Search SHAHEEN OS
        </span>

        <span class="shaheen-navigation__shortcut">
            Ctrl K
        </span>
    </button>

    <nav class="shaheen-navigation__menu">
        @foreach ($navigation as $group)
            <div class="shaheen-navigation__section">
                <div class="shaheen-navigation__section-title">
                    {{ $group['section'] }}
                </div>

                @foreach ($group['items'] as $item)
                    @if (!empty($item['command']))
                        <button
                            type="button"
                            class="shaheen-navigation__item"
                            data-shaheen-command-open
                        >
                            <span
                                class="shaheen-navigation__icon"
                                aria-hidden="true"
                            >
                                {{ $item['icon'] }}
                            </span>

                            <span class="shaheen-navigation__label">
                                {{ $item['label'] }}
                            </span>
                        </button>
                    @else
                        <a
                            href="{{ $item['url'] }}"
                            class="shaheen-navigation__item"
                            data-shaheen-nav-link
                        >
                            <span
                                class="shaheen-navigation__icon"
                                aria-hidden="true"
                            >
                                {{ $item['icon'] }}
                            </span>

                            <span class="shaheen-navigation__label">
                                {{ $item['label'] }}
                            </span>
                        </a>
                    @endif
                @endforeach
            </div>
        @endforeach
    </nav>

    <div class="shaheen-navigation__footer">
        <div class="shaheen-navigation__profile">
            <div class="shaheen-navigation__avatar">
                S
            </div>

            <div class="shaheen-navigation__profile-info">
                <div class="shaheen-navigation__profile-name">
                    SHAHEEN OS
                </div>

                <div class="shaheen-navigation__profile-status">
                    System Online
                </div>
            </div>
        </div>
    </div>
</aside>

<nav
    class="shaheen-mobile-navigation"
    aria-label="SHAHEEN OS mobile navigation"
>
    <a
        href="/"
        class="shaheen-mobile-navigation__item"
        data-shaheen-mobile-nav
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >⌂</span>

        <span>Home</span>
    </a>

    <a
        href="/explore"
        class="shaheen-mobile-navigation__item"
        data-shaheen-mobile-nav
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >◈</span>

        <span>Explore</span>
    </a>

    <button
        type="button"
        class="shaheen-mobile-navigation__item"
        data-shaheen-command-open
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >⌕</span>

        <span>Search</span>
    </button>

    <a
        href="/workspace"
        class="shaheen-mobile-navigation__item"
        data-shaheen-mobile-nav
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >▦</span>

        <span>Workspace</span>
    </a>

    <a
        href="/settings"
        class="shaheen-mobile-navigation__item"
        data-shaheen-mobile-nav
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >⚙</span>

        <span>Settings</span>
    </a>
</nav>

<div
    class="shaheen-command-overlay"
    data-shaheen-command-overlay
    aria-hidden="true"
>
    <section
        class="shaheen-command"
        role="dialog"
        aria-modal="true"
        aria-label="SHAHEEN OS Command Palette"
    >
        <input
            type="search"
            class="shaheen-command__input"
            data-shaheen-command-input
            autocomplete="off"
            placeholder="Search SHAHEEN OS..."
            aria-label="Search SHAHEEN OS"
        >

        <div class="shaheen-command__results">
            @foreach ($navigation as $group)
                @foreach ($group['items'] as $item)
                    @if (!empty($item['url']))
                        <a
                            href="{{ $item['url'] }}"
                            class="shaheen-command__result"
                            data-shaheen-command-item
                        >
                            <span
                                class="shaheen-command__result-icon"
                                aria-hidden="true"
                            >
                                {{ $item['icon'] }}
                            </span>

                            <span class="shaheen-command__result-label">
                                {{ $item['label'] }}
                            </span>

                            <span class="shaheen-command__result-key">
                                {{ $group['section'] }}
                            </span>
                        </a>
                    @endif
                @endforeach
            @endforeach
        </div>
    </section>
</div>
