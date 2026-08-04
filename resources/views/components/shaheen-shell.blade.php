@props([
    'brand' => 'SHAHEEN OS',
    'logo' => '/brand/logo/shaheen-os-symbol.svg',
    'homeUrl' => '/',
    'navigation' => [],
    'primaryLabel' => null,
    'primaryUrl' => null,
])

<div {{ $attributes->merge(['class' => 'shaheen-shell']) }}>

    <header class="shaheen-shell-header">

        <div class="shaheen-shell-container">

            <div class="shaheen-shell-header-inner">

                <a
                    href="{{ $homeUrl }}"
                    class="shaheen-shell-brand"
                    aria-label="{{ $brand }}"
                >
                    <span class="shaheen-shell-brand-symbol">
                        <img
                            src="{{ $logo }}"
                            alt=""
                            width="32"
                            height="32"
                            loading="eager"
                            decoding="async"
                        >
                    </span>

                    <span class="shaheen-shell-brand-name">
                        {{ $brand }}
                    </span>
                </a>

                @if(count($navigation))
                    <nav
                        class="shaheen-shell-nav"
                        aria-label="{{ $brand }} navigation"
                    >
                        @foreach($navigation as $item)
                            <a
                                href="{{ $item['url'] ?? '#' }}"
                                class="shaheen-shell-nav-link"
                                @if(!empty($item['active']))
                                    aria-current="page"
                                @endif
                            >
                                {{ $item['label'] ?? '' }}
                            </a>
                        @endforeach
                    </nav>
                @endif

                <div class="shaheen-shell-actions">

                    @if($primaryLabel && $primaryUrl)
                        <a
                            href="{{ $primaryUrl }}"
                            class="shaheen-shell-button shaheen-shell-button-primary"
                        >
                            {{ $primaryLabel }}
                        </a>
                    @endif

                    <button
                        type="button"
                        class="shaheen-shell-menu-toggle"
                        data-shaheen-menu-toggle
                        aria-expanded="false"
                        aria-controls="shaheen-mobile-navigation"
                        aria-label="Open navigation"
                    >
                        <span aria-hidden="true">☰</span>
                    </button>

                </div>

            </div>

            @if(count($navigation))
                <nav
                    id="shaheen-mobile-navigation"
                    class="shaheen-shell-mobile"
                    data-shaheen-mobile-menu
                    aria-label="{{ $brand }} mobile navigation"
                >
                    <div class="shaheen-shell-mobile-inner">

                        @foreach($navigation as $item)
                            <a
                                href="{{ $item['url'] ?? '#' }}"
                                class="shaheen-shell-mobile-link"
                                @if(!empty($item['active']))
                                    aria-current="page"
                                @endif
                            >
                                {{ $item['label'] ?? '' }}
                            </a>
                        @endforeach

                    </div>
                </nav>
            @endif

        </div>

    </header>

    <main class="shaheen-shell-main">
        {{ $slot }}
    </main>

    <footer class="shaheen-shell-footer">

        <div class="shaheen-shell-footer-inner">

            <span>
                © {{ date('Y') }} {{ $brand }}
            </span>

            <span>
                Premium Digital Experience
            </span>

        </div>

    </footer>

</div>
