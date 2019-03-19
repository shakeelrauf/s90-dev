
$(document).ready(function(){
    mainJS();
})
function mainJS(){
    var $win = $(window);
    var $doc = $(document);
    const $header = $('.header');

    $('.collapsible').collapse();

    // initAutocomplete();

    function initAutocomplete() {
        const states = [
            'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
            'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
            'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa',
            'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland',
            'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi',
            'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire',
            'New Jersey', 'New Mexico', 'New York', 'North Carolina',
            'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania',
            'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee',
            'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington',
            'West Virginia', 'Wisconsin'
        ];

        const artists = [
            "Coheed and Cambria",
            "Korn",
            "Greta Van Fleet",
            "Five Finger Death Punch",
            "Godsmack",
        ]

        $('#autocomplete').autocomplete({
            source: [states, artists],
        });
    }



    // Add Class

    $('body').on('click','.list-role-selection .btn', function(event) {
        // event.preventDefault();

        $(this).closest('li').siblings().find('.btn').removeClass('active');
        $(this).addClass('active');
    });

    //

    $('body').on('click mouseenter','.song .song__dots', function() {
        $(this).closest('.song__actions').addClass('active');
    });

    $('body').on('mouseleave','.song', function() {
        $(this).find('.song__actions').removeClass('active');
    });

    $('body').on('click', '.song .js-trigger',function(event) {
        event.preventDefault();
        const $dropdown = $('.song .song__dropdown');
        $(this).next().slideToggle();
    });

    $('body').on('click','.event .event__like', function() {
        $(this).toggleClass('active');
    });

    $win.on('load resize', function() {
        if( $win.width() < 1025 ) {
            $('.slider-tiles-square').slick({
                slidesToShow: 4,
                responsive: [
                    {
                        breakpoint: 767,
                        settings: {
                            slidesToShow: 2,
                        }
                    },

                    {
                        breakpoint: 360,
                        settings: {
                            slidesToShow: 1,
                        }
                    }
                ]
            });
        }

        if( $win.width() < 1025 ) {
            $('.slider-tiles-circle').slick({
                slidesToShow: 4,
                responsive: [
                    {
                        breakpoint: 767,
                        settings: {
                            slidesToShow: 2,

                        }
                    },

                    {
                        breakpoint: 360,
                        settings: {
                            slidesToShow: 1,

                        }
                    }
                ]
            });
        }

        if( $win.width() < 768 ) {
            $('.slider-songs').slick({
                slidesToShow: 1,
            });
        }
    });

    $('.slider-top-albums').slick({
        variableWidth: true,
        centerMode: true,
    });

    $('body').on('click','.nav-ultilities .js-search', function(event) {
        event.preventDefault();
        const $this = $(this);

        $this.addClass('active');
        $this.next().addClass('active');
    });

    $('body').on('blur','.search .search__field', function() {
        const $this = $(this);

        $this.closest('.nav-ultilities').find('.js-search').removeClass('active');
        $this.closest('.nav-ultilities').find('.search').removeClass('active');
    });

    $win.on('scroll', function() {
        if( $win.scrollTop() > 50 ) {
            $header.addClass('active');
        }

        else {
            $header.removeClass('active');
        }
    });

    $('body').on('click','.nav .has-dropdown > a', function(event) {
        event.preventDefault();
        const $this = $(this);
        $this.parent().toggleClass('active');
        $this.parent().find('.nav-dropdown').slideToggle();
    });

    $('body').on('click','.nav-trigger', function(event) {
        event.preventDefault();
        $(this).closest('.header').find('.menu').addClass('active');
        $header.addClass('menu-on');
    });

    $('body').on('click','.menu-close', function() {
        $(this).parent().removeClass('active');
        $header.removeClass('menu-on');
    });


}