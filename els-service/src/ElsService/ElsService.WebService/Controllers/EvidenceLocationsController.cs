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
    public class EvidenceLocationsController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/EvidenceLocations
        [EnableQuery]
        public IQueryable<EvidenceLocation> GetEvidenceLocations()
        {
            return db.EvidenceLocations;
        }

        // GET odata/EvidenceLocations(5)
        [EnableQuery]
        public SingleResult<EvidenceLocation> GetEvidenceLocation([FromODataUri] int key)
        {
            return SingleResult.Create(db.EvidenceLocations.Where(evidencelocation => evidencelocation.Id == key));
        }

        // PUT odata/EvidenceLocations(5)
        public IHttpActionResult Put([FromODataUri] int key, EvidenceLocation evidencelocation)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != evidencelocation.Id)
            {
                return BadRequest();
            }

            db.Entry(evidencelocation).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EvidenceLocationExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(evidencelocation);
        }

        // POST odata/EvidenceLocations
        public IHttpActionResult Post(EvidenceLocation evidencelocation)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.EvidenceLocations.Add(evidencelocation);
            db.SaveChanges();

            return Created(evidencelocation);
        }

        // PATCH odata/EvidenceLocations(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] int key, Delta<EvidenceLocation> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            EvidenceLocation evidencelocation = db.EvidenceLocations.Find(key);
            if (evidencelocation == null)
            {
                return NotFound();
            }

            patch.Patch(evidencelocation);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EvidenceLocationExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(evidencelocation);
        }

        // DELETE odata/EvidenceLocations(5)
        public IHttpActionResult Delete([FromODataUri] int key)
        {
            EvidenceLocation evidencelocation = db.EvidenceLocations.Find(key);
            if (evidencelocation == null)
            {
                return NotFound();
            }

            db.EvidenceLocations.Remove(evidencelocation);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/EvidenceLocations(5)/PhysicalContainers
        [EnableQuery]
        public IQueryable<PhysicalContainer> GetPhysicalContainers([FromODataUri] int key)
        {
            return db.EvidenceLocations.Where(m => m.Id == key).SelectMany(m => m.PhysicalContainers);
        }

        // GET odata/EvidenceLocations(5)/Custodies
        [EnableQuery]
        public IQueryable<Custody> GetCustodies([FromODataUri] int key)
        {
            return db.EvidenceLocations.Where(m => m.Id == key).SelectMany(m => m.Custodies);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool EvidenceLocationExists(int key)
        {
            return db.EvidenceLocations.Count(e => e.Id == key) > 0;
        }
    }
}
