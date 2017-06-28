﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Makolab.Fractus.Communication.DBLayer;
using System.Xml.Linq;
using System.Data.SqlClient;
using Makolab.Commons.Communication.Exceptions;
using Makolab.Commons.Communication;

namespace Makolab.Fractus.Communication.Scripts
{
    public class PriceRuleListScript : ExecutingScript
    {
        private ItemRepository repository;

        public PriceRuleListScript(IUnitOfWork unitOfWork, ExecutionController controller) : base(unitOfWork)
        {
            this.repository = new ItemRepository(unitOfWork, controller);
            this.ExecutionController = controller;
        }

        public override bool ExecutePackage(Makolab.Commons.Communication.ICommunicationPackage communicationPackage)
        {
            try
            {
                XDocument rulesXml = XDocument.Parse(communicationPackage.XmlData.Content);
                
                if (rulesXml.Root.Attribute("isCommunication") == null) rulesXml.Root.Add(new XAttribute("isCommunication", "true"));
                else rulesXml.Root.Attribute("isCommunication").Value = "true";

                this.repository.SetPriceRuleList(rulesXml);
            }
            catch (SqlException e)
            {
                if (e.Number == 50012) // Conflict detection
                {
                    throw new ConflictException("Conflict detected while execution package order=" + communicationPackage.OrderNumber + " id=" + communicationPackage.XmlData.Id);
                }
                else
                {
                    this.Log.Error("SnapshotScript:ExecutePackage " + e.ToString());
                    return false;
                }
            }

            return true;
        }
    }
}