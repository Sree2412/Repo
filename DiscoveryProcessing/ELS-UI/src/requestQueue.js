angular.module("ELS")
  .factory('requestQueue', ["$q", "$timeout", function($q, $timeout) {
    function requestQueue() {
      this.requestQueue = [];
      this.errorMessage = null;
      this.showSave = false;

      this.queueRequest = function( fn ) {
        this.showSave = false;
        var promise = $q.all( this.requestQueue ).then( fn );
        this.requestQueue.push( promise );

        return promise.then( function() {
            if( this.requestQueue.length <= 1 ) {
              this.showSave = true;
              $timeout(function() { this.showSave = false }.bind(this), 5000);
            }
          }.bind(this))
          .catch( function(response) {
            this.errorMessage = "Request failed"
            return $q.reject( this.errorMessage );
          }.bind(this))
          .finally( function() { this.requestQueue.splice( this.requestQueue.indexOf( promise ), 1 ); }.bind(this));
        }
    };

    return new requestQueue();
  }])
  .directive('requestQueueStatus', function() {
    return {
      scope: {
        darkMode: '@',
      },
      controller: function( $scope, requestQueue ) { $scope.requestQueue = requestQueue; },
      restrict: 'E',
      template: '<div layout-padding> \
        <div layout="row" layout-align="start center"> \
          <md-icon class="md-warn" ng-show="requestQueue.errorMessage"> \
            error \
            <md-tooltip>{{requestQueue.errorMessage}}</md-tooltip>\
          </md-icon> \
          <div ng-show="requestQueue.showSave" md-colors="{color: \'primary-hue-3\'}" class="request-queue-save" layout="row" layout-align="start center"> \
            Saved \
            <md-icon class="md-primary md-hue-3"> \
              check \
              <md-tooltip>Saved</md-tooltip>\
            </md-icon> \
          </div> \
          <md-progress-circular ng-class="{ \'md-hue-1\': darkMode, \'md-hue-3\': !darkMode }" md-mode="indeterminate" md-diameter="20" ng-show="requestQueue.requestQueue.length"></md-progress-circular> \
        </div> \
      </div>',
    }
  })
