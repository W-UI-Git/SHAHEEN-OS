@php
    $brandLogo = asset('brand/logo/shaheen-os-horizontal.svg');
    $brandSymbol = asset('brand/logo/shaheen-os-symbol.svg');
@endphp

<div
    class="shaheen-brand"
    data-shaheen-brand
    aria-label="SHAHEEN OS"
>
    <img
        src="{{ $brandLogo }}"
        alt="SHAHEEN OS"
        loading="eager"
        style="height:32px;width:auto;display:block;"
    >
</div>
