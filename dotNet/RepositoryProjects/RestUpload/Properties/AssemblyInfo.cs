﻿using System;
using System.Reflection;
using System.Runtime.InteropServices;

// General Information about an assembly is controlled through the following 
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("RestUpload")]
[assembly: AssemblyDescription("")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("Makolab SA")]
[assembly: AssemblyProduct("RestUpload")]
[assembly: AssemblyCopyright("Copyright © Makolab SA")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// Setting ComVisible to false makes the types in this assembly not visible 
// to COM components.  If you need to access a type in this assembly from 
// COM, set the ComVisible attribute to true on that type.
[assembly: ComVisible(false)]

// The following GUID is for the ID of the typelib if this project is exposed to COM
[assembly: Guid("6ae20425-da68-4bd4-be0f-4c5b570c6a2d")]

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
