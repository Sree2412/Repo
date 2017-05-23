angular.module('ELS')
  .directive('sideNavSelector', function() {
    return {
      controller: function( $scope, $location, $routeParams, projects, dataClients, savedSearches, dataTransfers ) {
        $scope.projects = projects;
        $scope.dataClients = dataClients;
        $scope.dataTransfers = dataTransfers;
        $scope.savedSearches = savedSearches;

        if( $location.path().indexOf( '/project') == 0 )
          $scope.activeList = 'projects';
        else if( $location.path().indexOf( '/data-client') == 0 )
          $scope.activeList = 'data-clients';
        else if( $location.path().indexOf( '/saved-search') == 0 )
          $scope.activeList = 'saved-searches';
        else
          $scope.activeList = 'data-transfers';

        $scope.selectContext = function( context ) {
          $scope.selectedContext = context;
        }

        $scope.selectProject = function( project ) {
          $scope.selectContext( project );
          $scope.projectFilter = project.projectCode;
        }

        $scope.selectClient = function( client ) {
          $scope.selectContext( client );
          $scope.dataClientFilter = client.clientID;
        }

        $scope.showList = function( listName ) {
          $scope.activeList = listName;
        }

        $scope.addSavedSearch = function() {
          savedSearches.push({
                name: "New Saved Search",
                criteria: [],
              });
          $scope.selectContext(savedSearches[savedSearches.length - 1]);
          $location.path( "/saved-search/" + (savedSearches.length - 1) );
        }

        $scope.addDataTransfer = function() {
          $scope.dataTransfers.push({
                name: "New Data Transfer",
                clientID: 0,
                projectCodes: [""],
              });
          $scope.selectContext(dataTransfers[$scope.dataTransfers.length - 1]);
          $location.path( "/data-transfer/" + ($scope.dataTransfers.length - 1) );
        }
      },
      templateUrl: 'selector.html',
    }
  })
