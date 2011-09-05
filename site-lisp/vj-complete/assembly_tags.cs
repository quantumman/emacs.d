// Generate C# "tags" files

// Copyright (C) 2007  Vagn Johansen

// This file is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2, or (at your option)
// any later version.

// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with GNU Emacs; see the file COPYING.  If not, write to the
// Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
// Boston, MA 02110-1301, USA.

using System;
using System.IO;
using System.Reflection;
using System.Text;
using System.Collections;

// make default run 

class AssemlyTags
{
  static public ArrayList LoadAllTypes(Assembly assembly)
  {           
    Type []types = assembly.GetExportedTypes();             
    ArrayList typeList = new ArrayList();
    foreach(Type type in types)
    {
      typeList.Add(type);
    }
    return typeList;
  }

  static void DumpAssembly(string filename)
  {
    Hashtable basetypeHash = new Hashtable();
    Hashtable interfaceHash = new Hashtable();

    using (FileStream fileStream = new FileStream("assembly_tags.txt", 
                                                  FileMode.Append,
                                                  FileAccess.Write))
      {
        StreamWriter stream = new StreamWriter(fileStream);

        Assembly assembly = Assembly.LoadFrom(filename);

        stream.WriteLine("ASSEMBLY "+filename);    

        ArrayList list = LoadAllTypes(assembly);
        foreach (Type type in list)
        {
          string typeFullName = type.FullName;
//          Console.WriteLine("TYPE: "+type.FullName);
          stream.Write("TYPE: "+type.FullName);

          Type baseType = type.BaseType;
          Type[] interfaces = type.GetInterfaces();
          
      
          string baseTypeFullName = "-";
          if (baseType!=null)
          {
            //          if (baseType.FullName!="System.Object")
            baseTypeFullName = baseType.FullName;
            basetypeHash.Add(typeFullName, baseTypeFullName);
          }
          stream.Write(", " + baseTypeFullName);

          string interfacesString = "";
          foreach (Type i in interfaces)
          {
            stream.Write(","+i.FullName);
            interfacesString += "," + i.FullName;
          }
          if (interfacesString.Length > 0)
            interfaceHash.Add(typeFullName, interfacesString);
          stream.WriteLine();
      
          // System.Reflection.EventInfo[] Events = type.GetEvents()

          foreach (ConstructorInfo ctor in type.GetConstructors())
          {
            bool privateField = (ctor.Attributes & MethodAttributes.Private)!=0;

            stream.Write("C:{0}{1}{2}", typeFullName , 
                         privateField ? "=":"-", ctor.Name);

            ParameterInfo []paramInfo = ctor.GetParameters();
                     
            StringBuilder parameters = new StringBuilder();
            for(int i =0; i< paramInfo.Length; i++)
            {
              parameters.Append(paramInfo[i].ParameterType.Name+" ");
              parameters.Append(paramInfo[i].Name);
              if(i < paramInfo.Length-1)
              {
                parameters.Append(", ");
              }
            }
            stream.Write("("+parameters+")");
            stream.WriteLine(" : Void");

          }

      
          foreach(FieldInfo field in type.GetFields(BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.NonPublic|BindingFlags.DeclaredOnly))
          {
            bool privateField = ((field.Attributes & FieldAttributes.Private) != 0);
            stream.WriteLine("F:{0}{1}{2} : {3} Attributes={4}",
                             typeFullName , 
                             privateField ? "=":"-",
                             field.Name, 
                             field.FieldType.FullName, field.Attributes);
          
          
          }
      
          foreach(PropertyInfo prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.NonPublic|BindingFlags.DeclaredOnly))
          {
            stream.WriteLine("P:{0}-{1} : {2}",typeFullName,prop.Name, prop.PropertyType.FullName);
          }
          foreach(MethodInfo method in type.GetMethods(BindingFlags.Public 
                                                       | BindingFlags.Instance 
                                                       | BindingFlags.Static 
                                                       | BindingFlags.NonPublic
                                                       |BindingFlags.DeclaredOnly))
          {
            string methodName = method.Name;
            if (methodName.Length > 2 && methodName.Substring(0,3)=="op_")
              continue;
            if (methodName.Length > 4 && methodName.Substring(0,4)=="get_")
              methodName = methodName.Substring(4);

            // if private use =
            bool isPrivate =  (method.Attributes & MethodAttributes.Private) != 0;

            stream.Write("M:"+typeFullName+(isPrivate?"=":"-")+methodName+"");
          
            ParameterInfo []paramInfo = method.GetParameters();                     
            StringBuilder parameters = new StringBuilder();
            for(int i =0; i< paramInfo.Length; i++)
            {
              parameters.Append(paramInfo[i].ParameterType.Name+" ");
              parameters.Append(paramInfo[i].Name);
              if(i < paramInfo.Length-1)
              {
                parameters.Append(", ");
              }
            }
            stream.Write("("+parameters+")");
            stream.WriteLine(" : "+method.ReturnType.FullName);

          }
        } 
        stream.Close();
      }

        using (FileStream fileStream = new FileStream("assembly_tags.cla.txt",
                 FileMode.Append, 
                 FileAccess.Write))
        {
          StreamWriter streamWriter = new StreamWriter(fileStream);

          // FIXME What about C++ (MI)?
          foreach (string key in basetypeHash.Keys)
          {
            string text = "";
            string typeName = "";
            try {
                typeName = basetypeHash[key].ToString();
            } 
            catch (Exception ex) 
            { 
                Console.WriteLine("Error: "+key+" not found un basetypeHash; "+ex.Message);
                continue;
            }


            text += key + " -> " + typeName;
            if (interfaceHash.Contains(typeName))
            {
//              text += "("+interfaceHash[typeName].ToString()+")";
            }
            while (basetypeHash.Contains(typeName))
            {
              typeName = basetypeHash[typeName].ToString();
              text += " -> " + typeName;
            }
            streamWriter.WriteLine(text);
          }
          streamWriter.Close();
        }

  }


  static void Main(string[] args) 
  {
//      System.Diagnostics.Debugger.Break();

    try 
    {
      if (args.Length==0)
      {
        Console.WriteLine("Usage: exe FILENAME");
        return;
      }

      System.IO.StreamReader sr = new StreamReader( args[0] );
      string [] rows = sr.ReadToEnd().Split(Environment.NewLine.ToCharArray());
      ArrayList list = new ArrayList();
      for ( int i = 0, count = rows.Length; i < count; i++ )
      {
        string filename = rows[i].Trim();
        if ( filename.Length > 0 )
        {
          if (File.Exists(filename))
          {
            list.Add( rows[ i ] );
          } else 
            Console.WriteLine("File not found: {0}",rows[ i ]);
        }
      }

      if (list.Count==0)
      {
        Console.WriteLine("Nothing to do.");
        return;
      }

      File.Delete("assembly_tags.txt");
      File.Delete("assembly_tags.cla.txt");


      foreach (string filename in (string[])list.ToArray(typeof(string)))
      {
        Console.WriteLine("Dump {0}",filename);
		try {
            DumpAssembly(filename);
		}
		catch (Exception ex)
		{
		  Console.WriteLine("ERROR: "+ex.GetType()+": "+ex.Message);
          if (ex.InnerException!=null)
              Console.WriteLine("- Inner: "+ex.InnerException.Message);
		}
      }


//    DumpAssembly("Reflector.exe"); return;
    

//    DumpAssembly("c:/projects/IVANHOE/AnalyzerControl/Source/NUnitAnalyzerControl/bin/Debug/AnalyzerControl.dll");

      // FUTURE read from FrameworkDir and FrameworkVersion
//    string frameworkdir = "C:\\WINDOWS\\Microsoft.NET\\Framework\\v1.1.4322";
//    DumpAssembly(frameworkdir+"\\mscorlib.dll");
//    DumpAssembly(frameworkdir+"\\mscorlib.dll");
 
//      DumpAssembly("classes.exe");

//     DumpAssembly("c:/projects/IVANHOE/AnalyzerControl/Source/NUnitAnalyzerControl/bin/Debug/AnalyzerControl.dll");
//     DumpAssembly("c:/projects/ivanhoe/AnalyzerControl/Source/NUnitAnalyzerControl/bin/Debug/nunit.framework.dll");
    }
    catch (System.IO.FileNotFoundException ex)
    {
      Console.WriteLine("Error: "+ex.Message);
    }
    Console.WriteLine("done");
  }
}
