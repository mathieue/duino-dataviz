'use strict';

angular.module('webAppApp')
  .controller('DashboardCtrl', function ($scope, EsService) {

   var server = EsService.server('http://localhost:9200/duinodataviz/_search');
   var esCall = {
     "query": {
      "filtered" : {
          "query" : {
             "match_all" : { } 
          },
          "filter" : {
              "term" : {
                  "type" : "son" }
              }
          }
      }
    ,"facets" : {
        "temperature" : {
            "date_histogram" : {
                "field" : "datetime",
                "value_field" : "value",
                "interval" : "10m"
            }

        }
    }
   };

   $scope.dataSonore = server.post(esCall);
    

   var esCall = {
     "query": {
      "filtered" : {
          "query" : {
             "match_all" : { } 
          },
          "filter" : {
              "term" : {
                  "type" : "lumiere" }
              }
          }
      }
    ,"facets" : {
        "temperature" : {
            "date_histogram" : {
                "field" : "datetime",
                "value_field" : "value",
                "interval" : "10m"
            }

        }
    }
   };

   $scope.dataLumiere = server.post(esCall);


   var esCall = {
     "query": {
      "filtered" : {
          "query" : {
             "match_all" : { } 
          },
          "filter" : {
              "term" : {
                  "type" : "temperature" }
              }
          }
      }
    ,"facets" : {
        "temperature" : {
            "date_histogram" : {
                "field" : "datetime",
                "value_field" : "value",
                "interval" : "10m"
            }

        }
    }
   };

   $scope.dataTemperature = server.post(esCall);

});