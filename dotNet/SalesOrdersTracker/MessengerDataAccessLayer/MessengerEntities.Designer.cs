﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Data.Objects;
using System.Data.Objects.DataClasses;
using System.Data.EntityClient;
using System.ComponentModel;
using System.Xml.Serialization;
using System.Runtime.Serialization;

[assembly: EdmSchemaAttribute()]

namespace MessengerDataAccessLayer
{
    #region Contexts
    
    /// <summary>
    /// No Metadata Documentation available.
    /// </summary>
    public partial class MessengerEntities : ObjectContext
    {
        #region Constructors
    
        /// <summary>
        /// Initializes a new MessengerEntities object using the connection string found in the 'MessengerEntities' section of the application configuration file.
        /// </summary>
        public MessengerEntities() : base("name=MessengerEntities", "MessengerEntities")
        {
            this.ContextOptions.LazyLoadingEnabled = true;
            OnContextCreated();
        }
    
        /// <summary>
        /// Initialize a new MessengerEntities object.
        /// </summary>
        public MessengerEntities(string connectionString) : base(connectionString, "MessengerEntities")
        {
            this.ContextOptions.LazyLoadingEnabled = true;
            OnContextCreated();
        }
    
        /// <summary>
        /// Initialize a new MessengerEntities object.
        /// </summary>
        public MessengerEntities(EntityConnection connection) : base(connection, "MessengerEntities")
        {
            this.ContextOptions.LazyLoadingEnabled = true;
            OnContextCreated();
        }
    
        #endregion
    
        #region Partial Methods
    
        partial void OnContextCreated();
    
        #endregion
    
    }
    

    #endregion
    
    
}