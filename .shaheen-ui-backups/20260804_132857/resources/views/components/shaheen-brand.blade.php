@php
    $shaheenSiteName = $generalSettings['site_name'] ?? config('app.name', 'SHAHEEN OS');
    $shaheenLogo = $generalSettings['site_logo_url'] ?? null;
    $shaheenDefaultLogo = asset('brand/logo/shaheen-os-horizontal.svg');
    $shaheenSymbol = asset('brand/logo/shaheen-os-symbol.svg');
@endphp

<a
    href="{{ route('home') }}"
    class="shaheen-brand"
    aria-label="{{ $shaheenSiteName }}"
>
    @if($shaheenLogo)
        <img
            src="{{ $shaheenLogo }}"
            alt="{{ $shaheenSiteName }}"
            class="shaheen-brand-logo"
        >
    @else
        <img
            src="{{ $shaheenDefaultLogo }}"
            alt="{{ $shaheenSiteName }}"
            class="shaheen-brand-logo"
            onerror="this.onerror=null;this.src='{{ $shaheenSymbol }}';"
        >
    @endif
</a>
