angular.module("ELS")
  .directive("itemList", function() {
    return {
      scope: {
        items: '=',
      },
      templateUrl: "items.html",
      controller: function($scope, $filter, $mdDialog, itemFields) {
        $scope.selectedItems = {};
        $scope.itemFields = itemFields;
        $scope.selectedCount = 0;

        $scope.selectAll = function() {
          angular.forEach( $scope.items, function( item ) {
            $scope.selectedItems[item["Item Number"]] = $scope.selectAllChecked;
          })

          $scope.selectedCount = ($scope.selectAllChecked ? $scope.items.length : 0);
        };

        $scope.selectItem = function(item) {
          $scope.selectAllChecked = false;
          $scope.selectedCount += ($scope.selectedItems[item["Item Number"]] ? 1 : -1);
        }

        $scope.showItemDetails = function( item ) {
          $scope.itemDetail = item;
        }

        $scope.addItem = function() {
          var i = ($scope.items.length > 0 ? $scope.items[$scope.items.length - 1]["Item Number"] : 0) + 1;
          var item = { "Item Number": i, attachments: [], history: [] };
          $scope.items.push( item );
          $scope.showItemDetails( item );
        }

        $scope.listSettings = function(event) {
          $mdDialog.show({
            template: '<md-dialog aria-label="List settings"> \
                        <md-toolbar> \
                          <div class="md-toolbar-tools"> \
                            <h2>List settings</h2> \
                            <span flex></span> \
                            <md-button class="md-icon-button" ng-click="close()" aria-label="Close dialog"> \
                              <md-icon>close</md-icon> \
                            </md-button> \
                          </div> \
                        </md-toolbar> \
                        <md-dialog-content> \
                          <div class="md-dialog-content"> \
                            <div ng-repeat="field in itemFields"><md-checkbox ng-model="field.displayInList">{{field.name}}</md-checkbox></div> \
                          </div> \
                        </md-dialog-content> \
                      </md-dialog>',
            controller: function($scope) { $scope.itemFields = itemFields, $scope.close = function() { $mdDialog.hide(); } },
            targetEvent: event,
            clickOutsideToClose: true,
          })
        };
      },
    }
  })
  .directive("itemDetail", function() {
    return {
      scope: {
        item: '=',
      },
      templateUrl: 'item-detail.html',
      controller: function($scope, $mdSidenav, itemFields) {
        $scope.itemFields = itemFields;

        $scope.showNav = function(navID) {
          $mdSidenav(navID).open();
        }

        $scope.hideNav = function(navID) {
          $mdSidenav(navID).close();
        }
      },
    }
  })
