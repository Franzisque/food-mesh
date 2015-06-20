/**
 * jquery.line_chart.js
 *
 * university:  University of Applied Sciences Salzburg
 * studie:      MultiMediaTechnology
 * usage:        Multimediaprojekt 2a (MMP2a)
 * author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
 *              - Franziska Oberhauser
 */

(function ($, d3) {
    var PieChart = function (element, options) {
        this.element = element;

        this.$svg = d3.select('#' + this.element.attr('id'));

        this.$element = $(element);
        this.$pieElements = this.$element.find('.pie-item');
        this.$pieItems = this.$element.find('.pie-path-back');

        this.loadingAnimation();

        if (options.controll) {
            this.$controlles = $(options.controll);
            this.$controlItems = this.$controlles.find('.col');
            this.$controlItems.on('mouseenter', this.highLightPie.bind(this));
        }
    };

    PieChart.prototype.loadingAnimation = function () {
        this.$element.css('display', '');
        var elements = this.$svg.selectAll('.clip-path').each(function (idx, element) {
            var element = d3.select(this);
            var radius = element.attr('r');

            element.attr('r', 0);
            element.transition().duration(500 + Math.random() * 500).attr('r', radius).ease('bounce');
        });
    };

    PieChart.prototype.highLightPie = function (evt) {
        var dataReference = $(evt.currentTarget).data('pie-reference');
        var pieElement = this.$svg.select('#' + dataReference + ' .pie-path');
        var clipPath = this.$svg.select('#' + dataReference + ' .clip-path');
        var originalRadius = clipPath.attr('r');

        clipPath.transition().attr('r', originalRadius * 1.1).ease('bounce');

        $(evt.currentTarget).on('mouseleave', (function (evt) {
            clipPath.transition().attr('r', originalRadius);
        }).bind(this));
    };


    PieChart.prototype.mouseLeaveEvent = function (evt) {
        this.$pieElements.children('text').animate({
            opacity: 1
        });
    };


//currently not used
//    PieChart.prototype.mouseOverEvent = function(evt) {
//        var $currentTarget = $(evt.currentTarget);
//        var $parrentWrapper = $currentTarget.closest('g');
//        var $clipPath = $parrentWrapper.find('clippath circle');
//        var $text = $parrentWrapper.children('text');
//
//
//        this.hideAllLabels($parrentWrapper.attr('id'));
//
//        $text.animate({
//            opacity: 1
//        }, {queue: false});
//
//        $clipPath.animate({
//            r: 0
//        }, {queue: false});
//    };
//
//    PieChart.prototype.hideAllLabels = function(id) {
//        this.$pieElements.not('#' + id).children('text').animate({
//            opacity: 0.1
//        });
//    };

    $.fn.PieChart = function (options) {
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('PieChart');
            if (!data) {
                $this.data('PieChart', (data = new PieChart($this, options)));
            }
        });
    };
})(jQuery, d3);