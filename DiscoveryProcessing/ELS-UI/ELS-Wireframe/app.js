angular.module('ELS', ['ngMaterial', 'ngRoute'])
  .config( function( $routeProvider, $mdThemingProvider ) {
    $mdThemingProvider.definePalette('consilio-blue',
      $mdThemingProvider.extendPalette('blue',
      {
        '500': '#092e6e',
        '300': '#1978B0',
      }));
      $mdThemingProvider.definePalette('consilio-orange',
        $mdThemingProvider.extendPalette('orange',
        {
          'A200': '#FD8204',
          'A100': '#FDD184',
        }));
      $mdThemingProvider.definePalette('consilio-background', {
        '50': '#F4F4F4',
        '100': '#39474F',
        '200': '#39474F',
        '300': '#39474F',
        '400': '#39474F',
        '500': '#F4F4F4',
        '600': '#F4F4F4',
        '700': '#F4F4F4',
        '800': '#F4F4F4',
        '900': '#F4F4F4',
        'A100': '#F4F4F4',
        'A200': '#F4F4F4',
        'A400': '#F4F4F4',
        'A700': '#F4F4F4',
        });
    $mdThemingProvider.theme('default')
      .primaryPalette( 'consilio-blue' )
      .accentPalette( 'consilio-orange' );

    $routeProvider.when('/', {
      template: '',
    })
    .when('/project/:projectCode', {
      templateUrl: 'project-detail.html',
      controller: 'projectDetail',
    })
    .when('/data-client/:clientID', {
      templateUrl: 'client-detail.html',
      controller: 'clientDetail',
    })
    .when('/data-transfer/:transferID', {
      templateUrl: 'transfer-detail.html',
      controller: 'dataTransferDetail',
    })
    .when('/saved-search/:searchID', {
      templateUrl: 'saved-search.html',
      controller: 'savedSearch',
    })
    .otherwise({
      redirectTo: '/',
    });
  })
  .run( function( $rootScope ) {
    $rootScope.showFieldConfig = function() {
      $rootScope.configPanel = 'fields.html';
    };

    $rootScope.showAdvancedSearch = function() {
      $rootScope.configPanel = 'saved-search.html';
    };

    $rootScope.hideConfigPanel = function() {
      $rootScope.configPanel = null;
    };
  })
  .directive('focusOn', function ($timeout) {
      return {
          restrict: 'A',
          priority: -100,
          link: function ($scope, $element, $attr) {

              $scope.$watch($attr.ngShow,
                  function (_focusVal) {
                      $timeout( function () {
                          var inputElement = $element[0].tagName == 'input'
                              ? $element
                              : $element.find('input');

                          if( inputElement.length == 0 )
                            inputElement = $element.find('textarea');

                           _focusVal ? inputElement.focus()
                                     : inputElement.blur();
                      });
                  }
              );

          }
      };
  })
  .directive('floatingPosition', function($document, $window, $timeout, $animate, $compile) {
    return {
      restrict: 'A',
      priority: -100,
      transclude: true,
      link: function( $scope, $element, $attr, ctrl, $transclude ) {
        var elementClone = $element.clone();
        $transclude(function( clone ) {
          elementClone.append( clone );
        });
        $element[0].style = "visibility: hidden;";

        alignFloatingElement = function() {
          var rect = $element[0].getBoundingClientRect();
          var x = rect.left;
          var y = rect.top;
          var width = rect.right - rect.left;
          var height = rect.bottom - rect.top;

          elementClone[0].style = "position: absolute; left: " + x + "px; top: " + y + "px; width: " + width + "px; height: " + height + "px;";
        }

        $timeout( function() {
          alignFloatingElement();
          $document[0].body.append(elementClone[0]);
          $animate.addClass(elementClone, "appear");
        });

        $scope.$on('$destroy', function() {
          elementClone.remove();
        });

        angular.element($window).on( "resize", alignFloatingElement );
        $animate.on( "enter", $element.parent(), function( element, phase ) {
          if( phase == "close" ) {
            alignFloatingElement();
          }
        });
      },
    }
  })
