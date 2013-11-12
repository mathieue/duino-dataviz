'use strict';

describe('Service: Datarest', function () {

  // load the service's module
  beforeEach(module('WebappApp'));

  // instantiate service
  var Datarest;
  beforeEach(inject(function (_Datarest_) {
    Datarest = _Datarest_;
  }));

  it('should do something', function () {
    expect(!!Datarest).toBe(true);
  });

});
