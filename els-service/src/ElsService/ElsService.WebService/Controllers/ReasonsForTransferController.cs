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
    public class ReasonsForTransferController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/ReasonsForTransfer
        [EnableQuery]
        public IQueryable<ReasonForTransfer> GetReasonsForTransfer()
        {
            return db.ReasonForTransfers;
        }

        // GET odata/ReasonsForTransfer(5)
        [EnableQuery]
        public SingleResult<ReasonForTransfer> GetReasonForTransfer([FromODataUri] int key)
        {
            return SingleResult.Create(db.ReasonForTransfers.Where(reasonfortransfer => reasonfortransfer.Id == key));
        }

        // PUT odata/ReasonsForTransfer(5)
        public IHttpActionResult Put([FromODataUri] int key, ReasonForTransfer reasonfortransfer)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != reasonfortransfer.Id)
            {
                return BadRequest();
            }

            db.Entry(reasonfortransfer).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ReasonForTransferExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(reasonfortransfer);
        }

        // POST odata/ReasonsForTransfer
        public IHttpActionResult Post(ReasonForTransfer reasonfortransfer)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.ReasonForTransfers.Add(reasonfortransfer);
            db.SaveChanges();

            return Created(reasonfortransfer);
        }

        // PATCH odata/ReasonsForTransfer(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] int key, Delta<ReasonForTransfer> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            ReasonForTransfer reasonfortransfer = db.ReasonForTransfers.Find(key);
            if (reasonfortransfer == null)
            {
                return NotFound();
            }

            patch.Patch(reasonfortransfer);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ReasonForTransferExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(reasonfortransfer);
        }

        // DELETE odata/ReasonsForTransfer(5)
        public IHttpActionResult Delete([FromODataUri] int key)
        {
            ReasonForTransfer reasonfortransfer = db.ReasonForTransfers.Find(key);
            if (reasonfortransfer == null)
            {
                return NotFound();
            }

            db.ReasonForTransfers.Remove(reasonfortransfer);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/ReasonsForTransfer(5)/Custodies
        [EnableQuery]
        public IQueryable<Custody> GetCustodies([FromODataUri] int key)
        {
            return db.ReasonForTransfers.Where(m => m.Id == key).SelectMany(m => m.Custodies);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ReasonForTransferExists(int key)
        {
            return db.ReasonForTransfers.Count(e => e.Id == key) > 0;
        }
    }
}
