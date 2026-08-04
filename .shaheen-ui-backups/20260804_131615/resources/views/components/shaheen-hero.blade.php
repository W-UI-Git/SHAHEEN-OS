<section {{ $attributes->merge(['class' => 'shaheen-hero']) }}>

    <div class="shaheen-orbit" aria-hidden="true"></div>

    <div class="relative z-10 mx-auto w-full max-w-7xl px-5 sm:px-8">

        <div class="shaheen-animate max-w-4xl">

            <div class="mb-5 inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/[.04] px-4 py-2 text-xs font-bold tracking-[.18em] text-white/70 backdrop-blur-xl">
                <span class="h-2 w-2 rounded-full bg-[#d8b85a] shadow-[0_0_18px_rgba(216,184,90,.65)]"></span>
                SHAHEEN OS
            </div>

            <h1 class="shaheen-hero-title">
                {{ $title ?? 'The next generation of the digital marketplace.' }}
            </h1>

            <p class="shaheen-hero-description">
                {{ $description ?? 'A premium digital ecosystem designed for speed, intelligence, discovery and modern commerce.' }}
            </p>

            <div class="mt-9 flex flex-col gap-3 sm:flex-row">

                <a
                    href="{{ $primaryUrl ?? route('listings.index') }}"
                    class="shaheen-button"
                >
                    {{ $primaryText ?? 'Explore SHAHEEN OS' }}
                </a>

                <a
                    href="{{ $secondaryUrl ?? route('register') }}"
                    class="shaheen-button shaheen-button-secondary"
                >
                    {{ $secondaryText ?? 'Create account' }}
                </a>

            </div>

        </div>

    </div>

</section>
