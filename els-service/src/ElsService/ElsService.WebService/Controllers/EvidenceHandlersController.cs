using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.ModelBinding;
using System.Web.OData;
using System.Web.OData.Routing;
using ElsService;

namespace ElsService.WebService.Controllers
{
    /*
    To add a route for this controller, merge these statements into the Register method of the WebApiConfig class. Note that OData URLs are case sensitive.

    using System.Web.Http.OData.Builder;
    using ElsService;
    ODataConventionModelBuilder builder = new ODataConventionModelBuilder();
    builder.EntitySet<EvidenceHandler>("EvidenceHandlers");
    builder.EntitySet<DataTransfer>("DataTransfer"); 
    builder.EntitySet<Custody>("Custody"); 
    config.Routes.MapODataRoute("odata", "odata", builder.GetEdmModel());
    */
    public class EvidenceHandlersController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/EvidenceHandlers
        [EnableQuery]
        public IQueryable<EvidenceHandler> GetEvidenceHandlers()
        {
            return db.EvidenceHandlers;
        }

        // GET odata/EvidenceHandlers(5)
        [EnableQuery]
        public SingleResult<EvidenceHandler> GetEvidenceHandler([FromODataUri] int key)
        {
            return SingleResult.Create(db.EvidenceHandlers.Where(evidencehandler => evidencehandler.Id == key));
        }

        // PUT odata/EvidenceHandlers(5)
        public IHttpActionResult Put([FromODataUri] int key, EvidenceHandler evidencehandler)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != evidencehandler.Id)
            {
                return BadRequest();
            }

            db.Entry(evidencehandler).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EvidenceHandlerExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(evidencehandler);
        }

        // POST odata/EvidenceHandlers
        public IHttpActionResult Post(EvidenceHandler evidencehandler)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.EvidenceHandlers.Add(evidencehandler);
            db.SaveChanges();

            return Created(evidencehandler);
        }

        // PATCH odata/EvidenceHandlers(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] int key, Delta<EvidenceHandler> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            EvidenceHandler evidencehandler = db.EvidenceHandlers.Find(key);
            if (evidencehandler == null)
            {
                return NotFound();
            }

            patch.Patch(evidencehandler);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EvidenceHandlerExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(evidencehandler);
        }

        // DELETE odata/EvidenceHandlers(5)
        public IHttpActionResult Delete([FromODataUri] int key)
        {
            EvidenceHandler evidencehandler = db.EvidenceHandlers.Find(key);
            if (evidencehandler == null)
            {
                return NotFound();
            }

            db.EvidenceHandlers.Remove(evidencehandler);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/EvidenceHandlers(5)/DataTransfersCollectingEvidenceHandler
        [EnableQuery]
        public IQueryable<DataTransfer> GetDataTransfersCollectingEvidenceHandler([FromODataUri] int key)
        {
            return db.EvidenceHandlers.Where(m => m.Id == key).SelectMany(m => m.DataTransfersCollectingEvidenceHandler);
        }

        // GET odata/EvidenceHandlers(5)/DataTransfersDeliveringEvidenceHandler
        [EnableQuery]
        public IQueryable<DataTransfer> GetDataTransfersDeliveringEvidenceHandler([FromODataUri] int key)
        {
            return db.EvidenceHandlers.Where(m => m.Id == key).SelectMany(m => m.DataTransfersDeliveringEvidenceHandler);
        }

        // GET odata/EvidenceHandlers(5)/CustodiesFromEvidenceHandler
        [EnableQuery]
        public IQueryable<Custody> GetCustodiesFromEvidenceHandler([FromODataUri] int key)
        {
            return db.EvidenceHandlers.Where(m => m.Id == key).SelectMany(m => m.CustodiesFromEvidenceHandler);
        }

        // GET odata/EvidenceHandlers(5)/CustodiesTransferredByEvidenceHandler
        [EnableQuery]
        public IQueryable<Custody> GetCustodiesTransferredByEvidenceHandler([FromODataUri] int key)
        {
            return db.EvidenceHandlers.Where(m => m.Id == key).SelectMany(m => m.CustodiesTransferredByEvidenceHandler);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool EvidenceHandlerExists(int key)
        {
            return db.EvidenceHandlers.Count(e => e.Id == key) > 0;
        }
    }
}
