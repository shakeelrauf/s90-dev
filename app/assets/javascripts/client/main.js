
$(document).ready(function(){
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

    $('.list-role-selection .btn').on('click', function(event) {
        // event.preventDefault();

        $(this).closest('li').siblings().find('.btn').removeClass('active');
        $(this).addClass('active');
    });

    //

    $('.song .song__dots').on('click mouseenter', function() {
        $(this).closest('.song__actions').addClass('active');
    });

    $('.song').on('mouseleave', function() {
        $(this).find('.song__actions').removeClass('active');
    });

    $('.song .js-trigger').on('click', function(event) {
        event.preventDefault();
        const $dropdown = $('.song .song__dropdown');
        $(this).next().slideToggle();
    });

    $('.event .event__like').on('click', function() {
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

    $('.nav-ultilities .js-search').on('click', function() {
        event.preventDefault();
        const $this = $(this);

        $this.addClass('active');
        $this.next().addClass('active');
    });

    $('.search .search__field').on('blur', function() {
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

    $('.nav .has-dropdown > a').on('click', function(event) {
        event.preventDefault();
        const $this = $(this);
        $this.parent().toggleClass('active');
        $this.parent().find('.nav-dropdown').slideToggle();
    });

    $('.nav-trigger').on('click', function(event) {
        event.preventDefault();
        $(this).closest('.header').find('.menu').addClass('active');
        $header.addClass('menu-on');
    });

    $('.menu-close').on('click', function() {
        $(this).parent().removeClass('active');
        $header.removeClass('menu-on');
    });




})
