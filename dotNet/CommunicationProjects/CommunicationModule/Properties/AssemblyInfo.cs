﻿using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System;

// General Information about an assembly is controlled through the following 
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("CommunicationModule")]
[assembly: AssemblyDescription("Fractus communication module.")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("MakoLab")]
[assembly: AssemblyProduct("CommunicationModule")]
[assembly: AssemblyCopyright("Copyright ©  2008")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// Setting ComVisible to false makes the types in this assembly not visible 
// to COM components.  If you need to access a type in this assembly from 
// COM, set the ComVisible attribute to true on that type.
[assembly: ComVisible(false)]

// The following GUID is for the ID of the typelib if this project is exposed to COM
[assembly: Guid("1688a78c-7d31-44fa-8ea4-078adab656ee")]

// Version information for an assembly consists of the following four values:
//
//      Major Version
//      Minor Version 
//      Build Number
//      Revision
//
// You can specify all the values or you can default the Build and Revision Numbers 
// by using the '*' as shown below:
// [assembly: AssemblyVersion("1.0.*")]
#if SETVERSION
    [assembly: AssemblyVersion("${MajorVersion}.${MinorVersion}.${BuildVersion}.${RevisionVersion}")]  
#else
    [assembly: AssemblyVersion("1.0.0.*")]
#endif
[assembly: CLSCompliant(true)]
[assembly: log4net.Config.XmlConfigurator(Watch = true)]