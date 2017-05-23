angular.module('ELS')
.directive("containerDetail", function() {
  return {
    scope: {
      container: '=',
      containerList: '=',
      index: '=',
    },
    templateUrl: 'container-detail.html',
    controller: function($scope, $mdSidenav, $mdDialog,
        containerTypes, containerSubtypes, dispositionStates, evidenceLocations, dataClients, requestQueue, containersResource, custodiesResource) {
      $scope.containerTypes = containerTypes;
      $scope.containerSubtypes = containerSubtypes;
      $scope.dispositionStates = dispositionStates;
      $scope.dataClients = dataClients;
      $scope.evidenceLocations = evidenceLocations;

      $scope.showNav = function(navID) {
        $mdSidenav(navID).open();
      }

      $scope.hideNav = function(navID) {
        $mdSidenav(navID).close();
      }

      $scope.navigatePrevious = function() {
        $scope.container = $scope.containerList[--$scope.index];
      }

      $scope.navigateNext = function() {
        $scope.container = $scope.containerList[++$scope.index];
      }

      $scope.findById = function( items, id ) {
        return items.find( function( item ) { return item.Id == id } );
      }

      $scope.viewCustody = function(ev) {
        $mdDialog.show({
          templateUrl: 'custody-detail.html',
          targetEvent: ev,
          locals: { containerId: $scope.container.Id },
          clickOutsideToClose: true,
          controller: function($scope, custodiesResource, containerId) {
            $scope.custodies = custodiesResource.query( { containerId: containerId } );

            $scope.cancel = function() {
              $mdDialog.hide();
            };

            $scope.print = function() {
              var mywindow = window.open('', 'PRINT', 'height=400,width=600');

              mywindow.document.write('<html><head><title>' + document.title  + '</title>');
              mywindow.document.write('</head><body >');
              mywindow.document.write(document.getElementById('custodyList').outerHTML);
              mywindow.document.write('</body></html>');

              mywindow.document.close(); // necessary for IE >= 10
              mywindow.focus(); // necessary for IE >= 10*/

              mywindow.print();
              mywindow.close();
            };
          },
        });
      }

      $scope.saveContainer = function() {
        requestQueue.queueRequest(function() {
          if( $scope.container.Id ) {
            if( $scope.container.IsPhysical ) {
              return $scope.container.$updatePhysical();
            } else {
              return $scope.container.$updateDigital();
            }
          } else {
            $scope.container.Id = 0;
            var promise;

            if( $scope.container.IsPhysical ) {
              promise = $scope.container.$savePhysical();
            } else {
              promise = $scope.container.$saveDigital();
            }

            return promise.then(function() {
              $scope.index = $scope.containerList.push( $scope.container ) - 1;
            });
          }
        });
      };

      $scope.duplicateToNewItem = function() {
        $scope.container = new containersResource(
          angular.extend( {},
            $scope.container,
            {
              Id: 0,
              HistoricUid: 0,
              Created: new Date(),
              CreatedBy: 'test',
              Updated: new Date(),
              UpdatedBy: 'test',
            }
          ));

          $scope.saveContainer();
      }

      $scope.$watch( 'container', function( newValue, oldValue ) {
        if( newValue && oldValue && newValue != oldValue && newValue.Id == oldValue.Id && newValue != oldValue && $scope.containerForm.$valid ) {
          $scope.saveContainer();
        }
      }, true );
    },
  }
})
