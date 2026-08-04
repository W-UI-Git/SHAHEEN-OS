{{-- =========================================================================
     SHAHEEN OS
     Global reusable components
     ========================================================================= --}}

@props([
    'title' => null,
    'subtitle' => null,
    'badge' => null,
    'action' => null,
])

<section {{ $attributes->merge(['class' => 'sh-section']) }}>

    <div class="sh-container">

        @if($title || $subtitle || $badge || $action)

            <div class="sh-section-header">

                <div>

                    @if($badge)
                        <span class="sh-badge sh-badge-accent">
                            {{ $badge }}
                        </span>
                    @endif

                    @if($title)
                        <h2 class="sh-section-title">
                            {{ $title }}
                        </h2>
                    @endif

                    @if($subtitle)
                        <p class="sh-section-subtitle">
                            {{ $subtitle }}
                        </p>
                    @endif

                </div>

                @if($action)
                    <div>
                        {!! $action !!}
                    </div>
                @endif

            </div>

        @endif

        {{ $slot }}

    </div>

</section>
