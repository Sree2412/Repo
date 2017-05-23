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
    public class DispositionStatesController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/DispositionStates
        [EnableQuery]
        public IQueryable<DispositionState> GetDispositionStates()
        {
            return db.DispositionStates;
        }

        // GET odata/DispositionStates(5)
        [EnableQuery]
        public SingleResult<DispositionState> GetDispositionState([FromODataUri] int key)
        {
            return SingleResult.Create(db.DispositionStates.Where(dispositionstate => dispositionstate.Id == key));
        }

        // PUT odata/DispositionStates(5)
        public IHttpActionResult Put([FromODataUri] int key, DispositionState dispositionstate)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != dispositionstate.Id)
            {
                return BadRequest();
            }

            db.Entry(dispositionstate).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DispositionStateExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(dispositionstate);
        }

        // POST odata/DispositionStates
        public IHttpActionResult Post(DispositionState dispositionstate)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.DispositionStates.Add(dispositionstate);
            db.SaveChanges();

            return Created(dispositionstate);
        }

        // PATCH odata/DispositionStates(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] int key, Delta<DispositionState> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            DispositionState dispositionstate = db.DispositionStates.Find(key);
            if (dispositionstate == null)
            {
                return NotFound();
            }

            patch.Patch(dispositionstate);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DispositionStateExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(dispositionstate);
        }

        // DELETE odata/DispositionStates(5)
        public IHttpActionResult Delete([FromODataUri] int key)
        {
            DispositionState dispositionstate = db.DispositionStates.Find(key);
            if (dispositionstate == null)
            {
                return NotFound();
            }

            db.DispositionStates.Remove(dispositionstate);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/DispositionStates(5)/Containers
        [EnableQuery]
        public IQueryable<Container> GetContainers([FromODataUri] int key)
        {
            return db.DispositionStates.Where(m => m.Id == key).SelectMany(m => m.Containers);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool DispositionStateExists(int key)
        {
            return db.DispositionStates.Count(e => e.Id == key) > 0;
        }
    }
}
