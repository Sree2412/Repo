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
    public class DataTransfersController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/DataTransfers
        [EnableQuery]
        public IQueryable<DataTransfer> GetDataTransfers()
        {
            return db.DataTransfers;
        }

        // GET odata/DataTransfers(5)
        [EnableQuery]
        public SingleResult<DataTransfer> GetDataTransfer([FromODataUri] long key)
        {
            return SingleResult.Create(db.DataTransfers.Where(datatransfer => datatransfer.Id == key));
        }

        // PUT odata/DataTransfers(5)
        public IHttpActionResult Put([FromODataUri] long key, DataTransfer datatransfer)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != datatransfer.Id)
            {
                return BadRequest();
            }

            db.Entry(datatransfer).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DataTransferExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(datatransfer);
        }

        // POST odata/DataTransfers
        public IHttpActionResult Post(DataTransfer datatransfer)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.DataTransfers.Add(datatransfer);
            db.SaveChanges();

            return Created(datatransfer);
        }

        // PATCH odata/DataTransfers(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] long key, Delta<DataTransfer> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            DataTransfer datatransfer = db.DataTransfers.Find(key);
            if (datatransfer == null)
            {
                return NotFound();
            }

            patch.Patch(datatransfer);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DataTransferExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(datatransfer);
        }

        // DELETE odata/DataTransfers(5)
        public IHttpActionResult Delete([FromODataUri] long key)
        {
            DataTransfer datatransfer = db.DataTransfers.Find(key);
            if (datatransfer == null)
            {
                return NotFound();
            }

            db.DataTransfers.Remove(datatransfer);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/DataTransfers(5)/DataTransferType
        [EnableQuery]
        public SingleResult<DataTransferType> GetDataTransferType([FromODataUri] long key)
        {
            return SingleResult.Create(db.DataTransfers.Where(m => m.Id == key).Select(m => m.DataTransferType));
        }

        // GET odata/DataTransfers(5)/DataTransferCollectingEvidenceHandler
        [EnableQuery]
        public SingleResult<EvidenceHandler> GetDataTransferCollectingEvidenceHandler([FromODataUri] long key)
        {
            return SingleResult.Create(db.DataTransfers.Where(m => m.Id == key).Select(m => m.DataTransferCollectingEvidenceHandler));
        }

        // GET odata/DataTransfers(5)/DataTransferDeliveringEvidenceHandler
        [EnableQuery]
        public SingleResult<EvidenceHandler> GetDataTransferDeliveringEvidenceHandler([FromODataUri] long key)
        {
            return SingleResult.Create(db.DataTransfers.Where(m => m.Id == key).Select(m => m.DataTransferDeliveringEvidenceHandler));
        }

        // GET odata/DataTransfers(5)/Containers
        [EnableQuery]
        public IQueryable<Container> GetContainers([FromODataUri] long key)
        {
            return db.DataTransfers.Where(m => m.Id == key).SelectMany(m => m.Containers);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool DataTransferExists(long key)
        {
            return db.DataTransfers.Count(e => e.Id == key) > 0;
        }
    }
}
