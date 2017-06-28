﻿using System;
using System.Xml.Linq;
using Makolab.Fractus.Kernel.Attributes;
using Makolab.Fractus.Kernel.Enums;
using Makolab.Fractus.Kernel.Exceptions;
using Makolab.Fractus.Kernel.Interfaces;

namespace Makolab.Fractus.Kernel.BusinessObjects.Dictionaries
{
    /// <summary>
    /// Class representing a country (dictionary entry).
    /// </summary>
    [XmlSerializable(XmlField = "vatRegister")]
    [DatabaseMapping(TableName = "vatRegister")]
    internal class VatRegister : BusinessObject, ILabeledDictionaryBusinessObject, IVersionedBusinessObject, IOrderable
    {
        /// <summary>
        /// Object order in the database and in xml node list.
        /// </summary>
        [XmlSerializable(XmlField = "order")]
        [Comparable]
        [DatabaseMapping(ColumnName = "order")]
        public int Order { get; set; }

        /// <summary>
        /// Gets or sets a flag that forces the <see cref="BusinessObject"/> to save changes even if no changes has been made.
        /// </summary>
        public bool ForceSave { get; set; }

        /// <summary>
        /// Gets or sets <see cref="BusinessObject"/>'s new version number.
        /// </summary>
        public Guid? NewVersion { get; set; }

        /// <summary>
        /// Gets or sets <see cref="VatRegister"/>'s symbol. Cannot be null or <see cref="String.Empty"/>.
        /// </summary>
        [XmlSerializable(XmlField = "symbol")]
        [Comparable]
        [DatabaseMapping(ColumnName = "symbol")]
        public string Symbol { get; set; }

        /// <summary>
        /// Gets or sets <see cref="VatRegister"/>'s label. Cannot be null.
        /// </summary>
        [XmlSerializable(XmlField = "xmlLabels")]
        [Comparable]
        [DatabaseMapping(ColumnName = "xmlLabels")]
        public XElement Labels { get; set; }

        [XmlSerializable(XmlField = "xmlOptions")]
        [Comparable]
        [DatabaseMapping(ColumnName = "xmlOptions")]
        public XElement Options { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="Country"/> class with a specified xml root element.
        /// </summary>
        public VatRegister()
            : base(null, BusinessObjectType.VatRegister)
        {
            this.Labels = new XElement("labels");
            this.Options = new XElement("options");
        }

        /// <summary>
        /// Validates the object's consistency. Checks whether the object has all necessary xml nodes.
        /// </summary>
        public override void ValidateConsistency()
        {
            if (String.IsNullOrEmpty(this.Symbol))
                throw new ClientException(ClientExceptionId.FieldValidationError, null, "fieldName:symbol");

            if (this.Labels == null || !this.Labels.HasElements)
                throw new ClientException(ClientExceptionId.FieldValidationError, null, "fieldName:xmlLabels");

            if (this.Options == null || !this.Options.HasElements)
                throw new ClientException(ClientExceptionId.FieldValidationError, null, "fieldName:xmlOptions");
        }

        /// <summary>
        /// Saves changes of current <see cref="BusinessObject"/> to the operations list.
        /// </summary>
        /// <param name="document">Xml document containing operation list to execute.</param>
        public override void SaveChanges(XDocument document)
        {
            if (this.Id == null)
                this.GenerateId();

            if ((this.Status != BusinessObjectStatus.Unchanged && this.Status != BusinessObjectStatus.Unknown)
                || this.ForceSave)
            {
                BusinessObjectHelper.SaveBusinessObjectChanges(this, document, null, null);
            }
        }
    }
}
