angular.module("ELS")
  .controller("savedSearch", function( $scope, $routeParams, $filter, savedSearches ) {
    $scope.savedSearch = savedSearches[$routeParams.searchID];

    $scope.addCriteria = function() {
      $scope.criteria.push( { AndOr: "And" } );
    }
  })
