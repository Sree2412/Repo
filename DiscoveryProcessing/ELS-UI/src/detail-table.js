angular.module('ELS')
  .directive("detailTable", function() {
    return {
      templateUrl: 'detail-table.html',
      scope: {
        defaultFieldsDisplayed: '<fieldsDisplayed',
        model: '<',
        fieldFilters: '<',
        onRowClick: '&',
        actions: '<',
        detail: '<',
        filterObject: '<',
        disableField: '@',
        listName: '@',
        showSelectBoxes: '<',
      },
      controller: function($scope, $mdDialog, $filter, $cookies) {
        if( !$scope.filterObject )
          $scope.filterObject = {};
        $scope.selectedItems = [];

        $scope.clickAction = function( action ) {
          action.action();
        }

        $scope.loadFieldsDisplayed = function() {
          var fieldsDisplayed = $cookies.getObject( $scope.listName );
          if( fieldsDisplayed )
            $scope.fieldsDisplayed = fieldsDisplayed;
          else
            $scope.fieldsDisplayed = $scope.defaultFieldsDisplayed;
        }

        $scope.saveFieldsDisplayed = function() {
          $cookies.putObject( $scope.listName, $scope.fieldsDisplayed );
        }

        $scope.selectAll = function() {
          if( $scope.selectAllChecked ) {
            $scope.selectedItems = angular.extend([], $scope.detail);
          } else {
            $scope.selectedItems = [];
          }
        };

        $scope.sortBy = function( field ) {
          if( $scope.sortingBy != field ) {
            $scope.sortingBy = field;
            $scope.sortingReverse = false;
          }
          else if( $scope.sortingReverse == false )
            $scope.sortingReverse = true;
          else
            $scope.sortingBy = null;
        }

        $scope.selectItem = function( item ) {
          $scope.selectAllChecked = false;

          var index = $scope.selectedItems.indexOf( item );
          if( index >= 0 )
            $scope.selectedItems.splice( index, 1 );
          else
            $scope.selectedItems.push( item );
        };

        $scope.exportCSV = function( content ) {
          var link = document.createElement("a");
          link.setAttribute("href", "data:text/csv," + encodeURI(content));
          link.setAttribute("download", "export.csv");
          document.body.appendChild(link);

          link.click();

          link.remove();
        }

        $scope.clickRow = function( item, index ) {
          if( !$scope.disableField || !item[$scope.disableField] ) {
            $scope.onRowClick( { item: item, index: index } );
          }
        }

        $scope.exportList = function() {
          var fieldNames = $scope.fieldsDisplayed.map( function( field ) { return $scope.model[field] });
          var csv = '"' + fieldNames.join('","') + '"\r\n';

          var sortedList = $filter('orderBy')(
            $filter('filter')($scope.detail, $scope.filterObject),
            $scope.sortingBy, $scope.sortingReverse);
          angular.forEach(sortedList, function(record) {
            var fields = [];
            angular.forEach($scope.fieldsDisplayed, function(field) {
              fields.push( record[field] );
            });

            csv += '"' + fields.join('","') + '"\r\n';
          });

          $scope.exportCSV( csv );
        }

        $scope.listSettings = function(event) {
          $scope.fields = $filter('orderBy')(Object.keys( $scope.model ), function(value) { return $scope.model[value] });

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
                            <div ng-repeat="field in fields" ng-if="model[field]"> \
                              <md-checkbox ng-checked="fieldsDisplayed.indexOf( field ) >= 0" ng-click="selectField( field )">{{model[field]}}</md-checkbox> \
                            </div> \
                          </div> \
                        </md-dialog-content> \
                      </md-dialog>',
            controller: function($scope) {
              $scope.close = function() {
                $mdDialog.hide();
              }

              $scope.selectField = function( field ) {
                var index = $scope.fieldsDisplayed.indexOf( field );
                if( index >= 0 )
                  $scope.fieldsDisplayed.splice( index, 1 );
                else
                  $scope.fieldsDisplayed.push( field );
              }
            },
            scope: $scope,
            preserveScope: true,
            targetEvent: event,
            clickOutsideToClose: true,
          })
          .finally(function() {
            $scope.saveFieldsDisplayed();
          })
        };

        $scope.selectedItems = [];
        $scope.loadFieldsDisplayed();
      },
    }
  })
  .filter("customFilter", function($filter) {
    return function(input, filter) {
      if( filter )
        return $filter(filter.filter)(input, filter.data);
      else
        return input;
    }
  })
  .filter("join", function() {
    return function(input) {
      return input.join( ', ' );
    }
  })
  .filter("deCamelCase", function() {
    return function(input) {
      input = input.replace(/(?:^|\.?)([a-z][A-Z])/g, function (x,y){return y[0] + " " + y[1]});
      return input.charAt(0).toUpperCase() + input.substr(1);
    }
  })
  .filter("yesNo", function() {
    return function(input) {
      return (input ? 'Yes' : 'No');
    }
  })
  .filter("childField", function() {
    return function(input, data) {
      return input[data];
    }
  })
  .filter("lookup", function($filter) {
    return function(input, data) {
      var filterObject = {};
      filterObject[data.identifier] = input;

      var matches = $filter('filter')(data.lookup, filterObject)
      if( matches.length > 0 )
        return matches[0][data.output];
    }
  })
