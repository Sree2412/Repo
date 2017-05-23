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
    public class ContainersController : ODataController
    {
        private EvidenceLoggingSystemStoreContainer db = new EvidenceLoggingSystemStoreContainer();

        // GET odata/Containers
        [EnableQuery]
        public IQueryable<Container> GetContainers()
        {
            return db.Containers;
        }

        // GET odata/Containers(5)
        [EnableQuery]
        public SingleResult<Container> GetContainer([FromODataUri] long key)
        {
            return SingleResult.Create(db.Containers.Where(container => container.Id == key));
        }

        // PUT odata/Containers(5)
        public IHttpActionResult Put([FromODataUri] long key, Container container)
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

        // PATCH odata/Containers(5)
        [AcceptVerbs("PATCH", "MERGE")]
        public IHttpActionResult Patch([FromODataUri] long key, Delta<Container> patch)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            Container container = db.Containers.Find(key);
            if (container == null)
            {
                return NotFound();
            }

            patch.Patch(container);

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

        // DELETE odata/Containers(5)
        public IHttpActionResult Delete([FromODataUri] long key)
        {
            Container container = db.Containers.Find(key);
            if (container == null)
            {
                return NotFound();
            }

            db.Containers.Remove(container);
            db.SaveChanges();

            return StatusCode(HttpStatusCode.NoContent);
        }

        // GET odata/Containers(5)/DispositionState
        [EnableQuery]
        public SingleResult<DispositionState> GetDispositionState([FromODataUri] long key)
        {
            return SingleResult.Create(db.Containers.Where(m => m.Id == key).Select(m => m.DispositionState));
        }

        // GET odata/Containers(5)/ContainerSubtype
        [EnableQuery]
        public SingleResult<ContainerSubtype> GetContainerSubtype([FromODataUri] long key)
        {
            return SingleResult.Create(db.Containers.Where(m => m.Id == key).Select(m => m.ContainerSubtype));
        }

        // GET odata/Containers(5)/ContainerBusinessProjectMappings
        [EnableQuery]
        public IQueryable<ContainerBusinessProjectMapping> GetContainerBusinessProjectMappings([FromODataUri] long key)
        {
            return db.Containers.Where(m => m.Id == key).SelectMany(m => m.ContainerBusinessProjectMappings);
        }

        // GET odata/Containers(5)/Custodies
        [EnableQuery]
        public IQueryable<Custody> GetCustodies([FromODataUri] long key)
        {
            return db.Containers.Where(m => m.Id == key).SelectMany(m => m.Custodies);
        }

        // GET odata/Containers(5)/ContainerType
        [EnableQuery]
        public SingleResult<ContainerType> GetContainerType([FromODataUri] long key)
        {
            return SingleResult.Create(db.Containers.Where(m => m.Id == key).Select(m => m.ContainerType));
        }

        // GET odata/Containers(5)/ParentContainer
        [EnableQuery]
        public IQueryable<Container> GetParentContainer([FromODataUri] long key)
        {
            return db.Containers.Where(m => m.Id == key).SelectMany(m => m.ParentContainer);
        }

        // GET odata/Containers(5)/DataTransfer
        [EnableQuery]
        public SingleResult<DataTransfer> GetDataTransfer([FromODataUri] long key)
        {
            return SingleResult.Create(db.Containers.Where(m => m.Id == key).Select(m => m.DataTransfer));
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
