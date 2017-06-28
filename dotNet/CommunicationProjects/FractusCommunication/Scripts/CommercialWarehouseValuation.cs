﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Makolab.Commons.Communication;
using Makolab.Fractus.Communication.DBLayer;
using System.Xml.Linq;
using Makolab.Commons.Communication.Exceptions;
using System.Data.SqlClient;
using Makolab.Fractus.Kernel.Managers;

namespace Makolab.Fractus.Communication.Scripts
{
    /// <summary>
    /// Process CommercialWarehouseValuation communication packages.
    /// </summary>
    public class CommercialWarehouseValuation : SnapshotScript
    {
        /// <summary>
        /// Document repository
        /// </summary>
        private DocumentRepository repository;

        /// <summary>
        /// Initializes a new instance of the <see cref="CommercialWarehouseValuation"/> class.
        /// </summary>
        /// <param name="unitOfWork">The unit of work - database context used in persistance.</param>
        public CommercialWarehouseValuation(IUnitOfWork unitOfWork, ExecutionController controller)
            : base(unitOfWork)
	    {
            this.repository = new DocumentRepository(unitOfWork, controller);
            this.ExecutionController = controller;
	    }

        /// <summary>
        /// Gets the root element name of main bussiness object in package.
        /// </summary>
        /// <value>The main object tag.</value>
        public override string MainObjectTag
        {
            get { return "commercialWarehouseValuation"; }
        }

        /// <summary>
        /// Process communication package persisting it's data to database.
        /// </summary>
        /// <param name="communicationPackage">The communication package to execute.</param>
        /// <returns>
        /// 	<c>true</c> if execution succeeded; otherwise, <c>false</c>
        /// </returns>
        public override bool ExecutePackage(ICommunicationPackage communicationPackage)
        {
            SessionManager.VolatileElements.DeferredTransactionId = communicationPackage.XmlData.DeferredTransactionId;
            SessionManager.VolatileElements.LocalTransactionId = this.LocalTransactionId;

            this.CurrentPackage = new DBXml(XDocument.Parse(communicationPackage.XmlData.Content));

            List<Guid> valuationsId = new List<Guid>();

            foreach (DBRow row in this.CurrentPackage.Table(this.MainObjectTag).Rows)
            {
                Guid valuationId = new Guid(row.Element("id").Value);
                valuationsId.Add(valuationId);
            }

            DBXml dbSnapshot = GetCurrentSnapshot(valuationsId);

            try
            {
                // TODO conflict detection & resolution
                //// Conflict detection
                //if (dbSnapshot != null && ValidateVersion(CurrentPackage, dbSnapshot) == false)
                //{
                //    throw new ConflictException("Conflict detected while changing " + this.MainObjectTag + " id: " + mainObjectId.ToString());
                //}

                PackageExecutionHelper.RemoveDeletedRows(this.CurrentPackage, dbSnapshot, this.MainObjectTag, this.Log);

                if (this.CurrentPackage.Table(MainObjectTag).HasRows == false) return true;
                //else do the rest

                DBXml changeset = GenerateChangeset(CurrentPackage, dbSnapshot);
                ExecuteChangeset(changeset);
            }
            catch (SqlException e)
            {
                if (e.Number == 50012) // Conflict detection
                {
                    throw new ConflictException("Conflict detected while changing " + this.MainObjectTag);
                }
                else
                {
                    this.Log.Error("SnapshotScript:ExecutePackage " + e.ToString());
                    return false;
                }
            }

            return true;
        }

        /// <summary>
        /// Executes the changeset. Operation is persisting changes to database.
        /// </summary>
        /// <param name="changeset">The changeset that is persisted.</param>
        public override void ExecuteChangeset(DBXml changeset)
        {
            repository.ExecuteOperations(changeset);
        }

        /// <summary>
        /// Gets xml representation of bussiness object with related objects.
        /// </summary>
        /// <param name="objectId">The object id.</param>
        /// <returns>
        /// 	<see cref="DBXml"/> from database with specified id.
        /// </returns>
        public override DBXml GetCurrentSnapshot(Guid objectId)
        {
            DBXml snapshot = this.repository.FindCommercialWarehouseValuations(new List<Guid> {objectId} );
            return GetSnapshotOrNull(snapshot);  
        }

        /// <summary>
        /// Gets the current snapshot.
        /// </summary>
        /// <param name="valuationsId">The valuations id.</param>
        /// <returns></returns>
        public DBXml GetCurrentSnapshot(List<Guid> valuationsId)
        {
            DBXml snapshot = this.repository.FindCommercialWarehouseValuations(valuationsId);
            return GetSnapshotOrNull(snapshot);              
        }

        /// <summary>
        /// Gets the number indicating previous version of contractor relations within database xml.
        /// </summary>
        /// <param name="dbXml">The database xml.</param>
        /// <returns>Previous version of contractor relations.</returns>
        public override Dictionary<string, string> GetPreviousVersion(DBXml dbXml)
        {
            return PackageExecutionHelper.GetPreviousVersion(dbXml, this.MainObjectTag);
        }

        /// <summary>
        /// Removes the previous version number from database xml.
        /// </summary>
        /// <param name="dbXml">The db XML.</param>
        /// <returns>
        /// Specified database xml without previous version number.
        /// </returns>
        public override DBXml RemovePreviousVersion(DBXml dbXml)
        {
            return PackageExecutionHelper.RemovePreviousVersion(dbXml);
        }

        /// <summary>
        /// Sets the previous version.
        /// </summary>
        /// <param name="dbXml">The db XML.</param>
        /// <param name="previousVersions">The previous versions.</param>
        public override void SetPreviousVersion(DBXml dbXml, Dictionary<string, string> previousVersions)
        {
            PackageExecutionHelper.SetPreviousVersion(dbXml, previousVersions, this.MainObjectTag);
        }
    }
}