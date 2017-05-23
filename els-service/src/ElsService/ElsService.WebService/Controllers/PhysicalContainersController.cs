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
    public class PhysicalContainersController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // PUT odata/PhysicalContainers(5)
        public IHttpActionResult Put([FromODataUri] long key, PhysicalContainer container)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != container.Id)
            {
                return BadRequest();
            }

            db.Entry(container).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ContainerExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(container);
        }

        // POST odata/PhysicalContainers
        public IHttpActionResult Post(PhysicalContainer container)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Containers.Add(container);
            db.SaveChanges();

            return Created(container);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ContainerExists(long key)
        {
            return db.Containers.Count(e => e.Id == key) > 0;
        }
    }
}
