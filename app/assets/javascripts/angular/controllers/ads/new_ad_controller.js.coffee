angular.module('TorSearch').controller('NewAdCtrl',
['$scope', '$window','railsResourceFactory', 'searchResourceFactory', '$route', '$location',
($scope, $window, railsResourceFactory, searchResourceFactory, $route, $location) ->
  Ad = railsResourceFactory({url: '/api/ad', name: 'ad'})
  # Configure search to use the basic CRUD Service
  $scope.active = $route.current.$$route.controller

  $scope.ad = new Ad({title: 'Example Title', protocol: 'HTTP', path: 'www.example.com?rel=ts', display_path: 'www.example.com', line_1: 'this is an', line_2: 'example ad'})

  $scope.save = () =>
    if $scope.ad.title && $scope.ad.path && $scope.ad.displayPath
      $scope.ad.create().then (result) ->
        $location.path('/ads/'+result.id)
])