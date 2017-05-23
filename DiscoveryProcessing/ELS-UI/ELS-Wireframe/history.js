angular.module("ELS")
  .directive("historyList", function() {
    return {
      scope: {
        history: '=',
      },
      templateUrl: 'history.html',
    }
  })
