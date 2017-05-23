angular.module('ELS', ['ngMaterial', 'ngRoute', 'ngResource', 'ngCookies'])
  .config( function( $routeProvider, $mdThemingProvider, $httpProvider ) {
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
      resolve: {
        dataClientModel: 'dataClientModel',
        dataClientFilters: 'dataClientFilters',
        dataTransferModel: 'dataTransferModel',
        dataTransferFilters: 'dataTransferFilters',
        dataClients: 'dataClients',
        dataTransfers: 'dataTransfers',
      },
    })
    .when('/data-client/:clientID', {
      templateUrl: 'client-detail.html',
      controller: 'clientDetail',
      resolve: {
        projectModel: 'projectModel',
        projectFilters: 'projectFilters',
        dataTransferModel: 'dataTransferModel',
        dataTransferFilters: 'dataTransferFilters',
        projects: 'projects',
        dataTransfers: 'dataTransfers',
      },
    })
    .when('/data-transfer/:transferID', {
      templateUrl: 'transfer-detail.html',
      controller: 'dataTransferDetail',
      resolve: {
        containerModel: 'containerModel',
        containerFilters: 'containerFilters',
        dataClients: 'dataClients',
        projects: 'projects',
        dataTransferTypes: 'dataTransferTypes',
        evidenceHandlers: 'evidenceHandlers',
      },
    })
    .when('/saved-search/:searchID', {
      templateUrl: 'saved-search.html',
      controller: 'savedSearch',
    })
    .otherwise({
      redirectTo: '/',
    });
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
  .directive("resizeWindowOnAnimation", function( $window, $animate ) {
    return {
      restrict: 'A',
      link: function( scope, element, attributes ) {
        $animate.on( attributes.resizeWindowOnAnimation, element, function(triggerElement, phase) {
          if( triggerElement[0] === element[0] && phase == "close" )
            angular.element( $window ).triggerHandler('resize');
        });
      },
    }
  })
  .directive("virtualSelect", function() {
    return {
      restrict: 'E',
      replace: true,
      scope: {
        model: '=',
        items: '<',
        identifier: '@',
        label: '@',
        placeholder: '@',
        getItemText: '&',
        required: '<',
      },
      template: '<md-select \
                      ng-required="required" \
                      ng-model="selectedID" \
                      ng-change="model = selectedID.identifier" \
                      md-on-open="topIndex=getIndex(model); searchText=\'\';" \
                      md-selected-text="(model != null ? getText(getItem(model)) : placeholder)" \
                      flex flex-order="1"> \
                    <md-select-header class="select-filter-header"> \
                      <div layout="row"> \
                        <div flex class="select-header-input-area"> \
                          <input id="dropdown-search-{{$id}}" ng-model="searchText" class="parameter-search" placeholder="Filter" onkeydown="event.stopPropagation(); topIndex = 0;" /> \
                        </div> \
                        <div> \
                          <md-button class="md-icon-button select-header-button" ng-click="focusOn( \'dropdown-search-{{$id}}\' )"><md-icon>search</md-icon></md-button> \
                          <md-button class="md-icon-button select-header-button" ng-click="paramSelectClose()"><md-icon>close</md-icon></md-button> \
                        </div> \
                      </div> \
                    </md-select-header> \
                    <md-option ng-value="selectedID" ng-if="!_mdSelectIsOpen && model != null">{{getText(getItem(model))}}</md-option> \
                    <md-virtual-repeat-container ng-if="_mdSelectIsOpen" style="height: 200px;" md-top-index="topIndex"> \
                      <md-option md-virtual-repeat="item in items | filter:filterItems" ng-value="{ identifier: item[identifier] }">{{getText(item)}}</md-option> \
                    </md-virtual-repeat-container> \
                  </md-select>',
      controller: function($scope, $mdSelect) {
        $scope.selectedID = { identifier: $scope.model };

        $scope.getIndex = function( id ) {
          if( !$scope.items ) return -1;
          return $scope.items.findIndex( function( value ) { return value[$scope.identifier] == id; } );
        };

        $scope.getItem = function( id ) {
          if( !$scope.items ) return null;
          return $scope.items.find( function( value ) { return value[$scope.identifier] == id; } );
        };

        $scope.getText = function( item ) {
          if( item ) {
            if( $scope.label ) {
              return item[$scope.label];
            } else {
              return $scope.getItemText( { item: item } );
            }
          }
        };

        $scope.paramSelectClose = function() {
          $mdSelect.hide();
        };

        $scope.filterItems = function( item ) {
          return !$scope.searchText || $scope.getText( item ).toLowerCase().indexOf( $scope.searchText.toLowerCase() ) >= 0;
        };
      },
    }
  })
  .filter("defaultIfNull", function() {
    return function(input, defaultValue) {
      return input ? input : defaultValue;
    }
  })
