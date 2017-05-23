angular.module('ELS')
.controller('projectDetail', function( $scope, $routeParams, $filter, projects, items ) {
  $scope.projectCode = $routeParams.projectCode;
  $scope.items = $filter("filter")(items, {projectCode: $scope.projectCode}, true);

  var matching = $filter("filter")(projects, { projectCode: $scope.projectCode }, true);
  if( matching.length > 0 )
    $scope.project = matching[0];
})
.controller('clientDetail', function( $scope, $routeParams, $filter, dataClients, items ) {
  $scope.clientID = parseInt($routeParams.clientID);
  $scope.items = $filter("filter")(items, {dataClientID: $scope.clientID}, true);

  var matching = $filter("filter")(dataClients, { clientID: $scope.clientID }, true);
  if( matching.length > 0 )
    $scope.client = matching[0];
}).controller('dataTransferDetail', function( $scope, $routeParams, $filter, projects, dataClients, dataTransfers, items ) {
  $scope.transferID = $routeParams.transferID;
  $scope.dataTransfer = dataTransfers[$scope.transferID];
  $scope.items = $filter("filter")(items, {dataClientID: $scope.dataTransfer.clientID}, true);

  var matching = $filter("filter")(dataClients, { clientID: $scope.dataTransfer.clientID }, true);
  if( matching.length > 0 )
    $scope.client = matching[0];
})
