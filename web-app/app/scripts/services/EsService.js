'use strict';

angular.module('webAppApp')
.service('EsService', function EsService($http) {
    // AngularJS will instantiate a singleton by calling "new" on this function

    var
    // save reference to global object
    // `window` in browser
    // `exports` on server
    root = this,
    es;

    // create namespace
    // use existing es object if it exists
    if (typeof exports !== 'undefined') {
      es = exports;
    } else {
      if (root.es == null) {
        es = root.es = {};
      } else {
        es = root.es;
      }
    }

    // get our server instance
    // define the es server inplementation
    es.server = function(url) {

      // server instance
      return {

        opt: {
          contentType: 'application/json',
          dataType: 'json',
          processData: false,
          url: url,
          error:  function( req, status, err ) {
            console.log( 'something went wrong on elascticsearch call', status, err );
          }
        },
        post: function(esQuery) {
          return $http({
            method: 'POST',
            url: url,
            data: JSON.stringify(esQuery),
            headers: {'Content-Type': 'application/json'}
          });
        }
      }
    };
    return es;

});


