This extension set the version field of a *.nuspec* file :

```xml
<?xml version="1.0"?>
<package>
  <metadata>
      <version>THIS_EXTENSION_SET_THIS_FIELD</version>
     ...
  </metadata>
  <files>
    ...
  </files>
</package>
```

 - From the *FileVersion* property of a file ([doc](https://msdn.microsoft.com/en-us/library/system.diagnostics.fileversioninfo.fileversion.aspx))
 - Specified manually in the tasks parameters

___

## How its work

1. Set the parameters :
   * Working directory : The relative working directory path 
	   * Ex: `$(System.DefaultWorkingDirectory)\$(DropFolderPath)`
   * Nuspec file name : The *.nuspec* file to set
	   * Ex: `myApplication.nuspec`
   * Model version filename :  The file to get the version (for example a dll or exe file who have a non-empty ([FileVersion](https://msdn.microsoft.com/en-us/library/system.diagnostics.fileversioninfo.fileversion.aspx)) field to copy from.
	   * Ex: `myApplication.dll`
   * Force version number : If no empty this value will be directly paste in the `<version>` field of the *.nuspec* file
   
1. **Log example : **  *(with Force version number option activated)*

> 2017-04-27T14:53:48.3223011Z Parameters : nuspecFileName=MyApplication.nuspec, modelVersionFileName=MyApplication.dll, forceToVersion=2.9.9.10
2017-04-27T14:53:48.3223011Z Starting NugetVersionSynchronizerTask
2017-04-27T14:53:48.3223011Z Location : D:\A01\_work\c624c7979\MyApplication Production\drop
2017-04-27T14:53:48.3848091Z Attempting to force set version 2.9.9.10 to nuspec file D:\A01\_work\c624c7979\MyApplication Production\drop\MyApplication.nuspec
2017-04-27T14:53:48.3848091Z Attempting to load file D:\A01\_work\c624c7979\MyApplication Production\drop\MyApplication.nuspec
2017-04-27T14:53:48.3848091Z Attempting to get package node
2017-04-27T14:53:48.3848091Z Set version value from 0.0.0.1.Node.InnerText to 2.9.9.10
2017-04-27T14:53:48.4004258Z Attempting to save file D:\A01\_work\c624c7979\MyApplication Production\drop\MyApplication.nuspec
2017-04-27T14:53:48.4004258Z Ending NugetVersionSynchronizerTask
___

## Enjoy!


Credits : Jean-Michel Michel, Alm Team, Cdiscount France.