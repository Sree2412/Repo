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

        $scope.focusOn = function( element ) {
          document.getElementById(element).focus();
        };

        $scope.selectProject = function( project ) {
          $scope.selectContext( project );
          $scope.projectFilter = project;
        }

        $scope.selectClient = function( client ) {
          $scope.selectContext( client );
          $scope.dataClientFilter = client;
        }

        $scope.filterClients = function( client ) {
          return !$scope.projectFilter || client.DataClientProjects.some( function( value ) {
            return value.BusinessProjectId == $scope.projectFilter.ID;
          });
        }

        $scope.filterProjects = function( project ) {
          return (!$scope.projectSearch || project.Name.toLowerCase().indexOf( $scope.projectSearch.toLowerCase() ) >= 0 ||
            project.Code.indexOf( $scope.projectSearch ) >= 0) &&
          (!$scope.dataClientFilter || $scope.dataClientFilter.DataClientProjects.some( function( value ) {
            return value.BusinessProjectId == project.ID;
          }));
        }

        $scope.showList = function( listName ) {
          $scope.activeList = listName;

          $scope.dataClientSearch = '';
          $scope.projectSearch = '';
          $scope.dataTransferFilter = '';
          $scope.savedSearchFilter = '';
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
          $location.path( "/data-transfer/new" );
        }
      },
      templateUrl: 'selector.html',
    }
  })
