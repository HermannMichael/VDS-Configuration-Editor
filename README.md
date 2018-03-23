# VDS-Configuration-Editor

Efficiently edit and extend Vault Data Standard Configurations using this Visual Studio Solution; the solution contains several projects:
- API-2018.2-ScriptEditor: PowerShell Project referencing Vault 2018.2 SDK version; use this to explore Vault 2018.2 API quickly by scripting.
	Get started reusing the ConnectAndExecute script. Review the .\Tools\ folder for specifc API tasks and entry points.

- API-2019-ScriptEditor: PowerShell Project referencing Vault 2018.2 SDK version; use this to explore Vault 2018.2 API quickly by scripting.
	Get started reusing the ConnectAndExecute script. Review the .\Tools\ folder for specifc API tasks and entry points.

- VDS_SnippetsAndTemplates: frequently used powershell and some XAML code snippets to be copied or directyl added to your 
	Visual Studio -> Tools\Code Snippet Manager.

WPF type projects linking the default (RTM) and Quickstart (Autodesk Technical Sales EMEA issued Sample) configuration of VDS; 
	VDS has to be installed though. 
- VDS-2018.1-ConfigLinks: Project to visually edit XAML Dialogs or Tabs and edit all powershell scripts. Configuration files are linked that
	allows to directly edit your active configuration. Use separate projects for different configuration file sets, e.g. 2018.1-ConfigLinks-Quickstart uses
	custom names for scripts and additional configruation files. This project references 2018.2 SDK and VDS 2018.1 libraries.
- VDS-2019-ConfigLinks: the same as before, just referencing 2019 SDK and 2019 VDS libraries.

Best practice creating custom configuration file sets: comparing 2018.1 and 2018.1-Quickstart .\Custom\ folder file sets, you will recognize additional files.
	These are loaded as override, and may contain functions with equal names like "InitializeWindows". As VDS 2018.1 and later loads configurations, 
	all functions of .\Custom\ file sets are loaded. The file name is not relevant, so I prefer copying existing configuration files to new names indicating
	content to override or to add new functions. E.g. CAD.Custom\addins\MyDefault.ps1 script contains overriding functions having equal function names as in 
	default.ps1. 

Last but not least, the solution's disclaimer applies to any code and template, even if not added explicitly as a header.

Respectfully,

Markus Koechl, 	Solutions Engineer PDM|PLM - Autodesk Central Europe
