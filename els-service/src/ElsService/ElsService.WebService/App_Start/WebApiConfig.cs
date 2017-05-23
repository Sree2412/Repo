using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.OData.Builder;
using System.Web.OData.Extensions;
using System.Web.Http.Cors;

namespace ElsService.WebService
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            ODataModelBuilder builder = new ODataConventionModelBuilder();
            builder.EntitySet<Container>("Containers");
            builder.EntitySet<DigitalContainer>("DigitalContainers");
            builder.EntitySet<PhysicalContainer>("PhysicalContainers");
            builder.EntitySet<ContainerType>("ContainerTypes");
            builder.EntitySet<ContainerSubtype>("ContainerSubtypes");
            builder.EntitySet<ContainerBusinessProjectMapping>("ContainerBusinessProjectMappings");
            builder.EntitySet<DispositionState>("DispositionStates");
            builder.EntitySet<Custody>("Custodies");
            builder.EntitySet<DataTransfer>("DataTransfers");
            builder.EntitySet<DataTransferType>("DataTransferTypes");
            builder.EntitySet<ReasonForTransfer>("ReasonsForTransfer");
            builder.EntitySet<EvidenceHandler>("EvidenceHandlers");
            builder.EntitySet<EvidenceLocation>("EvidenceLocations");

            config.MapODataServiceRoute("odata", "odata", model: builder.GetEdmModel());

            config.EnableCors(new EnableCorsAttribute("*", "*", "*") { SupportsCredentials = true });
        }
    }
}
