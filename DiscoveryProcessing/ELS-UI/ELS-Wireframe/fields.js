angular.module("ELS")
  .controller("fieldConfig", function( $scope, itemFields ) {
    $scope.itemFields = itemFields;

    $scope.addField = function() {
      itemFields.push( {} );
    }
  });
