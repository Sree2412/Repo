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
    public class ContainerSubtypesController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/ContainerSubtypes
        [EnableQuery]
        public IQueryable<ContainerSubtype> GetContainerSubtypes()
        {
            return db.ContainerSubtypes;
        }

        // GET odata/ContainerSubtypes(5)
        [EnableQuery]
        public SingleResult<ContainerSubtype> GetContainerSubtype([FromODataUri] int key)
        {
            return SingleResult.Create(db.ContainerSubtypes.Where(containersubtype => containersubtype.Id == key));
        }

        // PUT odata/ContainerSubtypes(5)
        public IHttpActionResult Put([FromODataUri] int key, ContainerSubtype containersubtype)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != containersubtype.Id)
            {
                return BadRequest();
            }

            db.Entry(containersubtype).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ContainerSubtypeExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(containersubtype);
        }

        // POST odata/ContainerSubtypes
        public IHttpActionResult Post(ContainerSubtype containersubtype)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.ContainerSubtypes.Add(containersubtype);
            db.SaveChanges();

            return Created(containersubtype);
        }

        // PATCH odata/ContainerSubtypes(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] int key, Delta<ContainerSubtype> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            ContainerSubtype containersubtype = db.ContainerSubtypes.Find(key);
            if (containersubtype == null)
            {
                return NotFound();
            }

            patch.Patch(containersubtype);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ContainerSubtypeExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(containersubtype);
        }

        // DELETE odata/ContainerSubtypes(5)
        public IHttpActionResult Delete([FromODataUri] int key)
        {
            ContainerSubtype containersubtype = db.ContainerSubtypes.Find(key);
            if (containersubtype == null)
            {
                return NotFound();
            }

            db.ContainerSubtypes.Remove(containersubtype);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/ContainerSubtypes(5)/Containers
        [EnableQuery]
        public IQueryable<Container> GetContainers([FromODataUri] int key)
        {
            return db.ContainerSubtypes.Where(m => m.Id == key).SelectMany(m => m.Containers);
        }

        // GET odata/ContainerSubtypes(5)/ContainerType
        [EnableQuery]
        public SingleResult<ContainerType> GetContainerType([FromODataUri] int key)
        {
            return SingleResult.Create(db.ContainerSubtypes.Where(m => m.Id == key).Select(m => m.ContainerType));
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ContainerSubtypeExists(int key)
        {
            return db.ContainerSubtypes.Count(e => e.Id == key) > 0;
        }
    }
}
