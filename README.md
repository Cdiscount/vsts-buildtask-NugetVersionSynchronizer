# This repository contains the code of a Tfs build task that allows set the version field of a *.nuspec* file :

It is available on the Visual Studio Team Services marketplace : https://marketplace.visualstudio.com/items?itemName=CdiscountAlm.vsts-nugetversionsynchronizer-tasks

#To work on this extension :
## Using Visual Studio code
1. Execute the following command to install vscode:
   ~~~ 
   choco install visualstudiocode
   ~~~
1. clone this repository:
   ~~~ 
   cd <myParentGitFolder>
   git clone https://github.com/Cdiscount/vsts-buildtask-NugetVersionSynchronizer.git
   cd vsts-buildtask-NugetVersionSynchronizer
   ~~~
1. Retrieve the npm package to allow compilation under vscode:
   ~~~ 
   cd NugetVersionSynchronizer
   npm update
   ~~~
1. Start vscode, you can use the following command:
   ~~~
   code .
   ~~~
1. Then in vscode [CTRL+SHIFT+B] should compile without error.

* note: if it doesn't compile correctly, verify that you do not have a path to a bad typescript version (remove path like "C:\Program Files (x86)\Microsoft SDKs\TypeScript\1.0\; " from your PATH (system&user) environment variables).

# Create the extension
1. If you update the task/extension (not needed on creation) : increment the version number in the task.json file.
1. If you update the task/extension (not needed on creation) : increment the version number in the vss-extension.json file.
1. use the tfx framework, in the root folder of the git repository (where the file vss-extension.json is located), execute:
   ~~~ 
   tfx extension create
   ~~~ 
