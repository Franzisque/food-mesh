(function ($) {
    var Accordion = function (element, options) {
        var $element = element;
        var $content = $element.find('.content');
        var $headings = $element.find('.header');

        $content.addClass('accordion-hide');
        $headings.on('click', function (evt) {
            var $currentTarget = $(evt.currentTarget);
            $currentTarget.next('.content').toggleClass('accordion-hide');
        });
    };

    $.fn.Accordion = function (options) {
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('Accodrion');
            if (!data) {
                $this.data('Accordion', (data = new Accordion($this, options)));
            }
        });
    };
})(jQuery);