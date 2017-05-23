angular.module("ELS")
  .directive("historyList", function() {
    return {
      scope: {
        item: '<',
      },
      templateUrl: 'history.html',
      controller: function( $scope ) {
        $scope.$watch( 'item', function() {
          if( $scope.item && $scope.item.Created ) {
            $scope.history = [
              { user: $scope.item.CreatedBy, time: $scope.item.Created, description: "Created" },
              { user: $scope.item.UpdatedBy, time: $scope.item.Updated, description: "Updated" },
            ];
          }
        }, true);
      },
    }
  })
