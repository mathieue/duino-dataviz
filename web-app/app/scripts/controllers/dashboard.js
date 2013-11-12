'use strict';

angular.module('webAppApp')
  .controller('DashboardCtrl', function ($scope, EsService) {

   var server = EsService.server('http://localhost:9200/duinodataviz/_search');
   var esCall = {
     "query": {
      "match_all" : { } 
    }
   };


  server.post(esCall).then(function(result) {
     console.log(result);
     $scope.results = result.data;
     $scope.total = result.data.hits.total;
  });
      
});