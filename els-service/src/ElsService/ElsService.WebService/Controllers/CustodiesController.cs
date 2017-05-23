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
    public class CustodiesController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/Custodies
        [EnableQuery]
        public IQueryable<Custody> GetCustodies()
        {
            return db.Custodies;
        }

        // GET odata/Custodies(5)
        [EnableQuery]
        public SingleResult<Custody> GetCustody([FromODataUri] long key)
        {
            return SingleResult.Create(db.Custodies.Where(custody => custody.Id == key));
        }

        // PUT odata/Custodies(5)
        public IHttpActionResult Put([FromODataUri] long key, Custody custody)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != custody.Id)
            {
                return BadRequest();
            }

            db.Entry(custody).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CustodyExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(custody);
        }

        // POST odata/Custodies
        public IHttpActionResult Post(Custody custody)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Custodies.Add(custody);
            db.SaveChanges();

            return Created(custody);
        }

        // PATCH odata/Custodies(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] long key, Delta<Custody> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            Custody custody = db.Custodies.Find(key);
            if (custody == null)
            {
                return NotFound();
            }

            patch.Patch(custody);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CustodyExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(custody);
        }

        // DELETE odata/Custodies(5)
        public IHttpActionResult Delete([FromODataUri] long key)
        {
            Custody custody = db.Custodies.Find(key);
            if (custody == null)
            {
                return NotFound();
            }

            db.Custodies.Remove(custody);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/Custodies(5)/Container
        [EnableQuery]
        public SingleResult<Container> GetContainer([FromODataUri] long key)
        {
            return SingleResult.Create(db.Custodies.Where(m => m.Id == key).Select(m => m.Container));
        }

        // GET odata/Custodies(5)/FromEvidenceHandler
        [EnableQuery]
        public SingleResult<EvidenceHandler> GetFromEvidenceHandler([FromODataUri] long key)
        {
            return SingleResult.Create(db.Custodies.Where(m => m.Id == key).Select(m => m.FromEvidenceHandler));
        }

        // GET odata/Custodies(5)/TransferredByEvidenceHandler
        [EnableQuery]
        public SingleResult<EvidenceHandler> GetTransferredByEvidenceHandler([FromODataUri] long key)
        {
            return SingleResult.Create(db.Custodies.Where(m => m.Id == key).Select(m => m.TransferredByEvidenceHandler));
        }

        // GET odata/Custodies(5)/ReasonForTransfer
        [EnableQuery]
        public SingleResult<ReasonForTransfer> GetReasonForTransfer([FromODataUri] long key)
        {
            return SingleResult.Create(db.Custodies.Where(m => m.Id == key).Select(m => m.ReasonForTransfer));
        }

        // GET odata/Custodies(5)/EvidenceLocation
        [EnableQuery]
        public SingleResult<EvidenceLocation> GetEvidenceLocation([FromODataUri] long key)
        {
            return SingleResult.Create(db.Custodies.Where(m => m.Id == key).Select(m => m.EvidenceLocation));
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool CustodyExists(long key)
        {
            return db.Custodies.Count(e => e.Id == key) > 0;
        }
    }
}
