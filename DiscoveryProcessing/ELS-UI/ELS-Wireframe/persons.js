angular.module("ELS")
  .directive("personList", function() {
    return {
      scope: {
        project: '=',
      },
      templateUrl: 'persons.html',
      controller: function( $scope ) {
        $scope.showPersonDetail = function( person ) {
          $scope.detailPerson = person;
        }

        $scope.addPerson = function() {
          var person = {};
          $scope.project.persons.push( person );
          $scope.showPersonDetail( person );
        }
      },
    }
  })
  .directive("personDetail", function() {
    return {
      scope: {
        person: '=',
      },
      templateUrl: 'person-detail.html',
    }
  })
