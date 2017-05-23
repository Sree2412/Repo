angular.module('ELS')
.controller('projectDetail', function( $scope, $routeParams, $location, projects ) {
  $scope.projectCode = $routeParams.projectCode;

  projects.$promise.then( function() {
    $scope.project = projects.find( function( value ) { return value.Code == $scope.projectCode } );

    $scope.filterDataClients = function( dataClient ) {
      return dataClient.DataClientProjects.some( function( value ) {
        return value.BusinessProjectId == $scope.project.ID;
      });
    }
  });

  $scope.selectDataTransfer = function( dataTransfer ) {
    $location.path( "/data-transfer/" + dataTransfer.Id );
  };

  $scope.selectDataClient = function( dataClient ) {
    $location.path( "/data-client/" + dataClient.Id );
  };
})
.controller('clientDetail', function( $scope, $routeParams, $location, dataClients ) {
  $scope.clientID = parseInt($routeParams.clientID);

  dataClients.$promise.then( function() {
    $scope.client = dataClients.find( function( value ) { return value.Id == $scope.clientID } );

    $scope.filterProjects = function( project ) {
      return $scope.client.DataClientProjects.some( function( value ) {
        return value.BusinessProjectId == project.ID;
      });
    };
  });

  $scope.selectProject = function( project ) {
    $location.path("/project/" + project.Code);
  };

  $scope.selectDataTransfer = function( dataTransfer ) {
    $location.path( "/data-transfer/" + dataTransfer.Id );
  };
})
