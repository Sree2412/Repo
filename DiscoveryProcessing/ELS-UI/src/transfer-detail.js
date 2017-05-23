angular.module('ELS')
.controller('dataTransferDetail', function( $scope, $routeParams, $location, $route, $mdDialog,
    dataTransfers, projects, containersResource, requestQueue ) {
  $scope.transferID = $routeParams.transferID;

  if( $scope.transferID == "new" ) {
    $scope.dataTransfer = dataTransfers.$new({
      Id: 0,
      HistoricUid: 0,
      Created: new Date(),
      CreatedBy: 'test',
      Updated: new Date(),
      UpdatedBy: 'test',
    });
  } else {
    $scope.dataTransfer = dataTransfers.$new({ Id: $scope.transferID });
    $scope.dataTransfer.$get().then( function() {
      $scope.dataTransfer.DataTransferDatetime = new Date( $scope.dataTransfer.DataTransferDatetime );
      projects.$promise.then( function() {
        $scope.selectedProject = projects.find( function( project ) { return project.ID == $scope.dataTransfer.BusinessProjectId } );
      });
    })

    $scope.containers = containersResource.query( { transferID: $scope.transferID } );
  }

  $scope.$watch( 'dataTransfer', function( newValue, oldValue ) {
    if( !$scope.fetched ) {
      $scope.fetched = true;
    }
    else if( $scope.dataTransferForm.$valid ) {
      requestQueue.queueRequest( function() {
        if( $scope.transferID == "new" ) {
          $scope.fetched = false;
          return $scope.dataTransfer.$save().then( function() {
            dataTransfers.$promise.then( function() {
              dataTransfers.push( $scope.dataTransfer );
              $scope.transferID = $scope.dataTransfer.Id;

              var lastRoute = $route.current;
              var deregisterListener = $scope.$on('$locationChangeSuccess', function () {
                  $route.current = lastRoute;
                  deregisterListener();
              });
              $location.path("/data-transfer/" + $scope.dataTransfer.Id);
            });
          });
        } else {
          return $scope.dataTransfer.$update();
        }
      });
    }
  }, true );

  $scope.getProject = function( id ) {
    return projects.find( function( value ) { return value.ID == id; } );
  }

  $scope.getProjectText = function( project ) {
    return (project ? project.Code + ' - ' + project.Name : null);
  }

  $scope.viewCustody = function(selectedItems, ev) {
    $mdDialog.show({
      templateUrl: 'custody-detail.html',
      targetEvent: ev,
      locals: { selectedContainers: selectedItems },
      clickOutsideToClose: true,
      controller: function($scope, $q, custodiesResource, selectedContainers) {
        var containerCustodies = [];
        angular.forEach(selectedContainers, function( container ) {
          containerCustodies.push( custodiesResource.query( { containerId: container.Id } ) );
        });

        $q.all( containerCustodies.map( function( value ) { return value.$promise } ) ).then( function() {
          $scope.custodies = [].concat.apply([], containerCustodies);
          $scope.custodies.$resolved = true;
        })

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
  };

  $scope.selectContainer = function( container, index ) {
    $scope.selectedContainer = container;
    $scope.selectedContainerIndex = index;
  };

  $scope.addContainer = function() {
    $scope.selectContainer(new containersResource( {
      DataTransferId: $scope.dataTransfer.Id,
      HistoricUid: 0,
      Created: new Date(),
      CreatedBy: 'test',
      Updated: new Date(),
      UpdatedBy: 'test',
    }));
  }
})
