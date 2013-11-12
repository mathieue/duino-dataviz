'use strict';

angular.module('webAppApp')
  .directive('timeline', function () {
    return {
      restrict: 'E',
      scope: {
           onClick:  '=',
           width:    '=',
           height:   '=',
           bind:     '=',
           duration: '@'
      },
      link: function postLink(scope, element, attrs) {

        scope.$watch('bind', function(data) {


          if (!data) {
            return;
          }

          console.log(data);

          var ratioEcran = 0.625;

          var width = 1140,
              height = 100;

          function draw() {
            var svg = d3.select(element[0]).append("svg")
                .attr("width", width)
                .attr("height", height);

            var barWidth = width / data.facets.temperature.entries.length,
                barHeight = 90;

            var max = d3.max(data.facets.temperature.entries, function(d, i) { return d.max });
            var min = d3.min(data.facets.temperature.entries, function(d, i) { return d.max });

            var scaleY = d3.scale.linear()
            .domain([min, max])
            .range([1, barHeight]);

            var scaleX = d3.scale.linear()
            .domain([0, data.facets.temperature.entries.length])
            .range([0, width]);

            var g = svg.append("g");

            g.selectAll("rect.temperature")
             .data(data.facets.temperature.entries)
               .enter().append("rect")
                 .attr("class", "temperature")
                 .attr("x", function(d, i) { return scaleX(i) })
                 .attr("y", function(d, i) { return barHeight - scaleY(d.max) })
                 .attr("width", barWidth - 0.5)
                 .attr("height", function(d, i) { return scaleY(d.max) });

          }

          return draw();

        });

       
      }
    };
  });
