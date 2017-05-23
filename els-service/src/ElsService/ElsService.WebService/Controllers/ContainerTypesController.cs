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
    public class ContainerTypesController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/ContainerTypes
        [EnableQuery]
        public IQueryable<ContainerType> GetContainerTypes()
        {
            return db.ContainerTypes;
        }

        // GET odata/ContainerTypes(5)
        [EnableQuery]
        public SingleResult<ContainerType> GetContainerType([FromODataUri] int key)
        {
            return SingleResult.Create(db.ContainerTypes.Where(containertype => containertype.Id == key));
        }

        // PUT odata/ContainerTypes(5)
        public IHttpActionResult Put([FromODataUri] int key, ContainerType containertype)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (key != containertype.Id)
            {
                return BadRequest();
            }

            db.Entry(containertype).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ContainerTypeExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(containertype);
        }

        // POST odata/ContainerTypes
        public IHttpActionResult Post(ContainerType containertype)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.ContainerTypes.Add(containertype);
            db.SaveChanges();

            return Created(containertype);
        }

        // PATCH odata/ContainerTypes(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] int key, Delta<ContainerType> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            ContainerType containertype = db.ContainerTypes.Find(key);
            if (containertype == null)
            {
                return NotFound();
            }

            patch.Patch(containertype);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ContainerTypeExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Updated(containertype);
        }

        // DELETE odata/ContainerTypes(5)
        public IHttpActionResult Delete([FromODataUri] int key)
        {
            ContainerType containertype = db.ContainerTypes.Find(key);
            if (containertype == null)
            {
                return NotFound();
            }

            db.ContainerTypes.Remove(containertype);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/ContainerTypes(5)/ContainerSubtypes
        [EnableQuery]
        public IQueryable<ContainerSubtype> GetContainerSubtypes([FromODataUri] int key)
        {
            return db.ContainerTypes.Where(m => m.Id == key).SelectMany(m => m.ContainerSubtypes);
        }

        // GET odata/ContainerTypes(5)/Containers
        [EnableQuery]
        public IQueryable<Container> GetContainers([FromODataUri] int key)
        {
            return db.ContainerTypes.Where(m => m.Id == key).SelectMany(m => m.Containers);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ContainerTypeExists(int key)
        {
            return db.ContainerTypes.Count(e => e.Id == key) > 0;
        }
    }
}
