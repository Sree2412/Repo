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
    public class DataTransferTypesController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/DataTransferTypes
        [EnableQuery]
        public IQueryable<DataTransferType> GetDataTransferTypes()
        {
            return db.DataTransferTypes;
        }

        // GET odata/DataTransferTypes(5)
        [EnableQuery]
        public SingleResult<DataTransferType> GetDataTransferType([FromODataUri] int key)
        {
            return SingleResult.Create(db.DataTransferTypes.Where(datatransfertype => datatransfertype.Id == key));
        }

        // PUT odata/DataTransferTypes(5)
        public IHttpActionResult Put([FromODataUri] int key, DataTransferType datatransfertype)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != datatransfertype.Id)
            {
                return BadRequest();
            }

            db.Entry(datatransfertype).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DataTransferTypeExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(datatransfertype);
        }

        // POST odata/DataTransferTypes
        public IHttpActionResult Post(DataTransferType datatransfertype)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.DataTransferTypes.Add(datatransfertype);
            db.SaveChanges();

            return Created(datatransfertype);
        }

        // PATCH odata/DataTransferTypes(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] int key, Delta<DataTransferType> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            DataTransferType datatransfertype = db.DataTransferTypes.Find(key);
            if (datatransfertype == null)
            {
                return NotFound();
            }

            patch.Patch(datatransfertype);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DataTransferTypeExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(datatransfertype);
        }

        // DELETE odata/DataTransferTypes(5)
        public IHttpActionResult Delete([FromODataUri] int key)
        {
            DataTransferType datatransfertype = db.DataTransferTypes.Find(key);
            if (datatransfertype == null)
            {
                return NotFound();
            }

            db.DataTransferTypes.Remove(datatransfertype);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/DataTransferTypes(5)/DataTransfers
        [EnableQuery]
        public IQueryable<DataTransfer> GetDataTransfers([FromODataUri] int key)
        {
            return db.DataTransferTypes.Where(m => m.Id == key).SelectMany(m => m.DataTransfers);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool DataTransferTypeExists(int key)
        {
            return db.DataTransferTypes.Count(e => e.Id == key) > 0;
        }
    }
}
