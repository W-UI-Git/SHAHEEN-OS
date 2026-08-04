@php
    $shaheenSiteName = $generalSettings['site_name'] ?? config('app.name', 'SHAHEEN OS');

    $shaheenDescription = $generalSettings['site_description']
        ?? 'A premium digital marketplace built for the next generation.';
@endphp

<section class="shaheen-hero-enter" class="shaheen-hero shaheen-os">

    <div class="shaheen-hero-content">

        <div class="shaheen-hero-kicker">
            <span aria-hidden="true">✦</span>
            <span>{{ $shaheenSiteName }}</span>
        </div>

        <h1 class="shaheen-hero-title">
            {{ $shaheenSiteName }}
            <br>
            <span>Beyond Ordinary.</span>
        </h1>

        <p class="shaheen-hero-description">
            {{ $shaheenDescription }}
        </p>

        <div class="shaheen-hero-actions">

            <a
                href="{{ route('listings.index') }}"
                class="shaheen-button shaheen-button-primary"
            >
                Explore Marketplace
            </a>

            <a
                href="{{ route('register') }}"
                class="shaheen-button shaheen-button-secondary"
            >
                Create Account
            </a>

        </div>

    </div>

</section>
