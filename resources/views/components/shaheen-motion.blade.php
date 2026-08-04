@props([
    'type' => 'reveal',
    'class' => '',
])

@php
    $allowed = [
        'reveal' => 'shaheen-reveal',
        'scale' => 'shaheen-scale-reveal',
        'fade' => 'shaheen-fade',
        'stagger' => 'shaheen-stagger',
    ];

    $motionClass = $allowed[$type] ?? $allowed['reveal'];
@endphp

<div {{ $attributes->merge([
    'class' => trim($motionClass . ' ' . $class),
]) }}>
    {{ $slot }}
</div>
