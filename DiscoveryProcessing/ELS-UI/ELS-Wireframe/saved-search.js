angular.module("ELS")
  .controller("savedSearch", function( $scope, $routeParams, $filter, items, itemFields, savedSearches ) {
    $scope.savedSearch = savedSearches[$routeParams.searchID];
    $scope.itemFields = itemFields;
    $scope.items = items;

    angular.forEach( $scope.savedSearch.criteria, function( criterion ) {
      var matches = $filter("filter")(itemFields, {name: criterion.fieldName}, true);
      if( matches.length > 0 )
        criterion.field = matches[0];
    });

    $scope.addCriteria = function() {
      $scope.criteria.push( { AndOr: "And" } );
    }
  })
