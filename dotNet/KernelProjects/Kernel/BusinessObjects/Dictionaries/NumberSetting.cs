﻿using System;
using System.Xml.Linq;
using Makolab.Fractus.Kernel.Attributes;
using Makolab.Fractus.Kernel.Enums;
using Makolab.Fractus.Kernel.Exceptions;
using Makolab.Fractus.Kernel.Interfaces;

namespace Makolab.Fractus.Kernel.BusinessObjects.Dictionaries
{
    /// <summary>
    /// Class representing a document setting (dictionary entry).
    /// </summary>
    [XmlSerializable(XmlField = "numberSetting")]
    [DatabaseMapping(TableName = "numberSetting")]
    internal class NumberSetting : BusinessObject, ILabeledDictionaryBusinessObject, IVersionedBusinessObject, IOrderable
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
        /// Gets or sets <see cref="NumberSetting"/>'s number format. Cannot be null or <see cref="String.Empty"/>.
        /// </summary>
        [XmlSerializable(XmlField = "numberFormat")]
        [Comparable]
        [DatabaseMapping(ColumnName = "numberFormat")]
        public string NumberFormat { get; set; }

        /// <summary>
        /// Gets or sets <see cref="NumberSetting"/>'s series format. Cannot be null or <see cref="String.Empty"/>.
        /// </summary>
        [XmlSerializable(XmlField = "seriesFormat")]
        [Comparable]
        [DatabaseMapping(ColumnName = "seriesFormat")]
        public string SeriesFormat { get; set; }

        /// <summary>
        /// Gets or sets <see cref="NumberSetting"/>'s label. Cannot be null.
        /// </summary>
        [XmlSerializable(XmlField = "xmlLabels")]
        [Comparable]
        [DatabaseMapping(ColumnName = "xmlLabels")]
        public XElement Labels { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="NumberSetting"/> class with a specified xml root element.
        /// </summary>
        public NumberSetting()
            : base(null, BusinessObjectType.NumberSetting)
        {
            this.Labels = new XElement("labels");
        }

        /// <summary>
        /// Validates the object's consistency. Checks whether the object has all necessary xml nodes.
        /// </summary>
        public override void ValidateConsistency()
        {
            if (this.Labels == null || !this.Labels.HasElements)
                throw new ClientException(ClientExceptionId.FieldValidationError, null, "fieldName:xmlLabels");
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
