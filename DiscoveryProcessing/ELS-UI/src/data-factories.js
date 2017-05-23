angular.module("ELS")

  // MODELS

  .value( "dataClientModel", {
    "Id": "ID",
    "Name": "Name",
    "DataSegregationTypeId": null,
    "CustodianDisplayNameFormatTypeId": null,
    "CustodianCustomAttributes": null,
    "HistoricUid": null,
    "Created": "Created Date",
    "CreatedBy": "Created By",
    "Updated": "Updated Date",
    "UpdatedBy": "Updated By",
    "DataClientProjects": null,
    "DataSegregationType": "Segregation Type",
  })
  .value("dataClientFilters", {
    "Created": { filter: 'date' },
    "Updated": { filter: 'date' },
    "DataSegregationType": { filter: 'childField', data: 'DisplayName' },
  })
  .value( "projectModel", {
    "ID": "ID",
    "Name": "Name",
    "Code": "Project Code",
    "ClientID": null,
    "ClientName": "Client",
    "DomainServiceLineID": null,
    "DomainServiceLineName": "Service Line",
    "DomainProjectStatusID": null,
    "DomainProjectStatusName": "Project Status",
    "Requestor": "Requestor",
    "RootPath": "Root Path",
    "ActiveDirectorySecurityGroup": null,
    "DatabaseServer": "Database Server",
    "DatabaseName": "Database Name",
    "AdoConnectionString": null,
    "OleDbConnectionString": null,
    "OdbcConnectionString": null,
    "HasCertifiedContractTerms": "Has Certified Contract Terms",
  })
  .value("projectFilters", {
    "HasCertifiedContractTerms": { filter: 'yesNo' },
  })
  .value( "dataTransferModel", {
    "Id": "ID",
    "DataTransferTypeId": null,
    "DataTransferTypeName": "Type",
    "DataClientId": "Data Client",
    "BusinessProjectId": "Project",
    "CampusId": null,
    "DataTransferDatetime": "Transfer Date",
    "CollectingEvidenceHandlerId": null,
    "CollectingEvidenceHandlerDisplayName": "Collecting Evidence Handler",
    "DeliveringEvidenceHandlerId": null,
    "DeliveringEvidenceHandlerDisplayName": "Delivering Evidence Handler",
    "Name": "Name",
    "Description": "Description",
    "TrackingNumber": "Tracking Number",
    "HistoricUid": null,
    "Created": "Created Date",
    "CreatedBy": "Created By",
    "Updated": "Updated Date",
    "UpdatedBy": "Updated By",
  })
  .factory("dataTransferFilters", function( projects, dataClients ) {
    return {
      "DataClientId": { filter: 'lookup', data: { lookup: dataClients, identifier: 'Id', output: 'Name' } },
      "BusinessProjectId": { filter: 'lookup', data: { lookup: projects, identifier: 'ID', output: 'Name' } },
      "Created": { filter: 'date' },
      "Updated": { filter: 'date' },
    }
  })
  .value( "containerModel", {
    "Id": "ID",
    "IsPhysical": "Physical",
    "IsLogical": "Logical",
    "IsObscured": null,
    "ContainerTypeId": null,
    "ContainerTypeName": "Type",
    "ContainerSubtypeId": null,
    "ContainerSubTypeName": "Sub Type",
    "DataClientId": "Data Client",
    "DataTransferId": null,
    "DataTransferName": "Data Transfer",
    "ParentContainerId": "Parent Container",
    "DispositionStateId": null,
    "DispositionStateName": "Disposition State",
    "Description": "Description",
    "Password": "Password",
    "HistoricUid": null,
    "Created": "Created Date",
    "CreatedBy": "Created By",
    "Updated": "Updated Date",
    "UpdatedBy": "Updated By",
  })
  .factory("physicalContainerModel", function(containerModel) {
    return angular.extend({
      "EvidenceLocationId": null,
      "EvidenceLocationName": "Evidence Location",
      "Make": "Make",
      "Model": "Model",
      "SerialNumber": "Serial Number",
      "Capacity": "Capacity",
      "Label": "Label",
    }, containerModel)
  })
  .factory("digitalContainerModel", function(containerModel) {
    return angular.extend({
      "ContainerLocation": "Container Location",
      "FileName": "File Name",
    }, containerModel)
  })
  .factory("containerFilters", function( dataClients ) {
    return {
      "DataClientId": { filter: 'lookup', data: { lookup: dataClients, identifier: 'Id', output: 'Name' } },
      "IsPhysical": { filter: 'yesNo' },
      "IsLogical": { filter: 'yesNo' },
      "Created": { filter: 'date' },
      "Updated": { filter: 'date' },
    }
  })
  .value("custodyModel", {
    "Id": "ID",
    "ContainerId": null,
    "FromEvidenceHandlerId": null,
    "FromEvidenceHandlerDisplayName": "From Evidence Handler",
    "TransferredByEvidenceHandlerId": null,
    "TransferredByEvidenceHandlerDisplayName": "Transferred By Evidence Handler",
    "TransferDatetime": "Transfer Date",
    "ReasonForTransferId": null,
    "ReasonForTransferName": "Reason for Transfer",
    "NewEvidenceLocationId": null,
    "NewEvidenceLocationName": "New Evidence Location",
    "ServiceTicketNumber": "Service Ticket Number",
    "Notes": "Notes",
    "HistoricUid": null,
    "Created": "Created Date",
    "CreatedBy": "Created By",
    "Updated": "Updated Date",
    "UpdatedBy": "Updated By",
  })
  .value("listItemModel", {
    "Id": null,
    "Name": null,
  })

  // DATA FACTORIES

  // Application data
  .factory("projects", function( $resource, projectServiceURL, projectModel, generateODataService, generateODataServiceActions ) {
    return generateODataService( $resource(projectServiceURL + "/Projects(:id)", {id: "@ID"},
      generateODataServiceActions( projectModel, projectServiceURL + "/Projects", null, "Projects" )));
  })
  .factory("dataClients", function( $resource, dataClientServiceURL, dataClientModel, generateODataService, generateODataServiceActions ) {
    return generateODataService( $resource(dataClientServiceURL + "/DataClients(:id)?$expand=DataClientProjects,DataSegregationType",
      {id: "@Id"}, generateODataServiceActions( dataClientModel, dataClientServiceURL + "/DataClients?$expand=DataClientProjects,DataSegregationType", null, "Data Clients" )));
  })
  .factory("dataTransfers", function( dataTransfersResource, generateODataService ) {
    return generateODataService( dataTransfersResource, {'$select': 'Id,DataClientId,BusinessProjectId,Name'});
  })
  .factory("dataTransfersResource", function( $resource, eelsServiceURL, dataTransferModel, generateODataServiceActions ) {
    return $resource(eelsServiceURL + "/DataTransfers(:id)", {id: "@Id"},
      generateODataServiceActions( dataTransferModel, eelsServiceURL + "/DataTransfers", null, "Data Transfers" ));
  })
  .factory("containersResource", function( $resource, eelsServiceURL, containerModel, digitalContainerModel, physicalContainerModel, generateODataServiceActions ) {
    return $resource(eelsServiceURL + "/Containers(:id)", {id: "@Id"},
      generateODataServiceActions( containerModel, eelsServiceURL + "/DataTransfers(:transferID)/Containers", null, "Containers", [
        {name: "Digital", model: digitalContainerModel, url: eelsServiceURL + "/DigitalContainers(:id)"},
        {name: "Physical", model: physicalContainerModel, url: eelsServiceURL + "/PhysicalContainers(:id)"},
      ]));
  })
  .factory("custodiesResource", function( $resource, eelsServiceURL, custodyModel, generateODataServiceActions ) {
    return $resource(eelsServiceURL + "/Custodies(:id)", {id: "@Id"},
      generateODataServiceActions( custodyModel, eelsServiceURL + "/Containers(:containerId)/Custodies", null, "Custodies"));
  })

  // Domain resources
  .factory("dataTransferTypes", function( $resource, eelsServiceURL, generateODataServiceActions, listItemModel ) {
    return $resource(eelsServiceURL + "/DataTransferTypes", null, generateODataServiceActions( listItemModel, eelsServiceURL + "/DataTransferTypes", null, "Data Transfer Types" )).query();
  })
  .factory("evidenceHandlers", function( $resource, eelsServiceURL, generateODataServiceActions, listItemModel ) {
    return $resource(eelsServiceURL + "/EvidenceHandlers", null, generateODataServiceActions( listItemModel, eelsServiceURL + "/EvidenceHandlers", null, "Evidence Handlers" )).query();
  })
  .factory("evidenceLocations", function( $resource, eelsServiceURL, generateODataServiceActions, listItemModel ) {
    return $resource(eelsServiceURL + "/EvidenceLocations", null, generateODataServiceActions( listItemModel, eelsServiceURL + "/EvidenceLocations", null, "Evidence Locations" )).query();
  })
  .factory("containerTypes", function( $resource, eelsServiceURL, generateODataServiceActions, listItemModel ) {
    return $resource(eelsServiceURL + "/ContainerTypes", null, generateODataServiceActions( listItemModel, eelsServiceURL + "/ContainerTypes", null, "Container Types" )).query();
  })
  .factory("containerSubtypes", function( $resource, eelsServiceURL, generateODataServiceActions, listItemModel ) {
    return $resource(eelsServiceURL + "/ContainerSubtypes", null, generateODataServiceActions( listItemModel, eelsServiceURL + "/ContainerSubtypes", null, "Container Sub Types" )).query();
  })
  .factory("dispositionStates", function( $resource, eelsServiceURL, generateODataServiceActions, listItemModel ) {
    return $resource(eelsServiceURL + "/DispositionStates", null, generateODataServiceActions( listItemModel, eelsServiceURL + "/DispositionStates", null, "Disposition States" )).query();
  })

  // UTILITY FUNCTIONS

  .factory("generateODataService", function() {
    return function(serviceResource, defaultParams) {
      var initService;

      initService = function() {
        var serviceData = serviceResource.query(defaultParams);
        serviceData.$promise.catch( function( reason ) {
          serviceData.$error = reason;
        });

        serviceData.$refresh = initService;
        serviceData.$new = function(initialValues) { return new serviceResource( initialValues ) };

        return serviceData;
      }

      return initService();
    };
  })
  .factory("errorHandlerInterceptor", function($mdToast, $q) {
    return function(serviceCallDescription) {
      return {
        responseError: function( rejection ) {
            var toast = $mdToast.simple()
              .textContent(serviceCallDescription + ' request failed')
              .action('Dismiss')
              .highlightAction(true)
              .hideDelay( false )
              .parent( angular.element( document.getElementById('project-detail-container') ) )
              .position("top right");

            $mdToast.show(toast).then(function(response) {
              if ( response == 'ok' ) {
                $mdToast.hide();
              }
            });

            if( rejection.data )
              rejection.data.$error = true;

            return $q.reject( rejection );
          }
      };
    };
  })
  .factory("oDataResponseTransforms", function( $http ) {
    return function(model, transforms) {
      return $http.defaults.transformResponse.concat([
          function(data, headersGetter, status) {
            if( data && angular.isDefined( data.value ) )
              return data.value;
            else
              return data;
          },
          function(data, headersGetter, status) {
            function transformResponse( value ) {
              angular.forEach( transforms, function( transform, field ) {
                value[field] = transform( value[field] );
              });
              return angular.extend( {}, model, value );
            }

            if( data && !angular.isArray( data ) ) {
              return transformResponse( data );
            } else {
              angular.forEach( data, function( value, index ) {
                data[index] = transformResponse(value);
              });
              return data;
            }
          }
        ]);
    }
  })
  .factory("oDataRequestTransforms", function( $http ) {
    return function( model ) {
      return [function(data, headersGetter) {
                var requestObject = angular.copy( model );
                angular.forEach( requestObject, function( value, key ) {
                  requestObject[key] = (angular.isDefined( data[key] ) ? data[key] : null);
                });

                return requestObject;
              }].concat($http.defaults.transformRequest);
    }
  })
  .factory("generateODataServiceActions", function(errorHandlerInterceptor, oDataResponseTransforms, oDataRequestTransforms) {
    return function( model, queryURL, modelTransforms, serviceCallDescription, subModels ) {
      var interceptor = errorHandlerInterceptor(serviceCallDescription);
      var modelResponseTransforms = oDataResponseTransforms(model, modelTransforms);
      var modelRequestTransforms = oDataRequestTransforms(model);

      var actions = {
        query: {
          method: 'GET',
          isArray: true,
          url: queryURL,
          withCredentials: true,
          transformResponse: modelResponseTransforms,
          interceptor: interceptor,
        },
        get: {
          method: 'GET',
          isArray: false,
          withCredentials: true,
          transformResponse: modelResponseTransforms,
          interceptor: interceptor,
        },
        update: {
          method: 'PUT',
          withCredentials: true,
          transformResponse: modelResponseTransforms,
          transformRequest: modelRequestTransforms,
          interceptor: interceptor,
        },
        save: {
          method: 'POST',
          withCredentials: true,
          url: queryURL,
          params: { id: null },
          transformResponse: modelResponseTransforms,
          transformRequest: modelRequestTransforms,
          interceptor: interceptor,
        },
        delete: {
          method: 'DELETE',
          withCredentials: true,
          transformResponse: modelResponseTransforms,
          interceptor: interceptor,
        },
      };

      angular.forEach( subModels, function( subModel ) {
        var responseTransforms = oDataResponseTransforms(subModel.model, subModel.transforms);
        var requestTransforms = oDataRequestTransforms(subModel.model);

        actions["update" + subModel.name] = {
          method: 'PUT',
          url: subModel.url,
          withCredentials: true,
          transformResponse: responseTransforms,
          transformRequest: requestTransforms,
          interceptor: interceptor,
        };

        actions["save" + subModel.name] = {
          method: 'POST',
          withCredentials: true,
          url: subModel.url,
          params: { id: null },
          transformResponse: responseTransforms,
          transformRequest: requestTransforms,
          interceptor: interceptor,
        };
      });

      return actions;
    };
  })

  // MOCK DATA

  .value("savedSearches", [
    {
      name: "Jerry's Checked Out Items",
      criteria: [
        {
          AndOr: "And",
          fieldName: "Current Status",
          value: "OUT",
        },
        {
          AndOr: "And",
          fieldName: "Issued To",
          value: "Jerry",
        },
      ],
    },
    {
      name: "All Hard Drives",
      criteria: [
        {
          AndOr: "And",
          fieldName: "Category",
          value: "Hard Drive - Enclosure",
        },
        {
          AndOr: "Or",
          fieldName: "Category",
          value: "Hard Drive - No enclosure",
        },
      ],
    },
  ])
