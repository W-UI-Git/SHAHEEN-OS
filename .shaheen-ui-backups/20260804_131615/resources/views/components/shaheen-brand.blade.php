@props([
    'href' => null,
    'compact' => false,
])

@php
    $brandName = config('app.name', 'SHAHEEN OS');
    $brandHref = $href ?: route('home');
@endphp

<a
    href="{{ $brandHref }}"
    {{ $attributes->merge(['class' => 'shaheen-brand']) }}
    aria-label="{{ $brandName }}"
>
    <img
        src="{{ asset('brand/logo/shaheen-os-horizontal.svg') }}"
        alt="{{ $brandName }}"
        class="shaheen-brand-logo"
    >

    @unless($compact)
        <span class="shaheen-brand-name">
            SHAHEEN <span>OS</span>
        </span>
    @endunless
</a>
