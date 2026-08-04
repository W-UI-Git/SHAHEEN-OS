{{-- =========================================================================
     SHAHEEN OS — Global UI Integration
     ========================================================================= --}}

<div
    id="shaheen-os-root"
    data-shaheen-os="true"
    data-app-name="SHAHEEN OS"
    data-direction="{{ app()->getLocale() === 'ar' ? 'rtl' : 'ltr' }}"
    class="shaheen-os-root"
>
    <div class="shaheen-os-layer shaheen-os-layer-background"></div>

    <div class="shaheen-os-layer shaheen-os-layer-grid"></div>

    <div class="shaheen-os-layer shaheen-os-layer-glow"></div>

    <div class="shaheen-os-shell-layer">
        @if (View::exists('components.shaheen-brand'))
            @include('components.shaheen-brand')
        @endif

        @if (View::exists('components.shaheen-navigation'))
            @include('components.shaheen-navigation')
        @endif
    </div>
</div>
