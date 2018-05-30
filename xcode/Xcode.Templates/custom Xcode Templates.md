### custom Xcode Templates

referenceUrl：

1.  [https://useyourloaf.com/blog/creating-custom-xcode-project-templates/](https://useyourloaf.com/blog/creating-custom-xcode-project-templates/)

2. [https://medium.com/@dima.cheverda/xcode-9-templates-596e2ed85609](https://medium.com/@dima.cheverda/xcode-9-templates-596e2ed85609)
3. [https://github.com/kharrison/Xcode-Templates](https://github.com/kharrison/Xcode-Templates)


#### Where Are The Xcode Templates
The iOS templates are in sub-folders here：
> /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/Project\ Templates/iOS

> /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/Project Templates/iOS/Application/Single View App.xctemplate


#### How Do They Work
**TemplateInfo.plist file**


#### Creating A New Project Template

$ mkdir -p ~/Library/Developer/Xcode/Templates/Project\ Templates/Personal

$ APP_TEMPLATES='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/Project Templates/iOS/Application'

  cd ~/Library/Developer/Xcode/Templates/Project\ Templates/Personal/
  cp -r "$APP_TEMPLATES/Single View App.xctemplate" "Manual Single View App.xctemplate"



===========
《Xcode n Template Documentation》
===========

#### Basic Project Template Tutorial

##### Your Cocoa Application Project Template

###### Copy existing project template 
Copy the entire Core Data Spotlight Application.xctemplate folder to the folder: ~/Library/Developer/Xcode/Templates/Project Templates

> Parts of this path may not exist, in which case you'll have to create the .../Templates/Project Templates folders.

###### Why Core Data Spotlight Application?
**Ancestors**

###### Make it unique
After copying the Core Data Spotlight Application.xctemplate folder you must do the following in order to create a working copy of the Cocoa Application project template:

1. rename the folder
2. change the Identifier in TemplateInfo.plist

For #1 you can name the folder My Core Data Spotlight Application.xctemplate or something like that but make sure you preserve the folder extension .xctemplate without which the template won't show up in the New Project dialog.

For #2 you should open (double-click) the TemplateInfo.plist file and change the Identifier key from com.apple.dt.unit.coreDataApplication to anything else - I'm going with MyCoreDataSpotlightApplication because the Identifier doesn't really need to be in reverse domain name notation.

These changes are necessary to make sure that the new project is considered a unique, new project template by Xcode 4 and will show up in the New Project dialog. Of course you might also want to modify the Name and Description values to complete the change and have them reflect the purpose of your customized template.

###### Et voila！
Mac-firstRespons-Xcode: Cmd+Shift+N

Here's the "My Cocoa Application" template showing up under the "Project Templates" category. If you select it and create a project based on this template you'll end up with exactly the same

project as with the original Cocoa Application template. You can now begin with customizing the project template.

###### Full Control？

##### Your Cocoa Touch Application Project Template
The most versatile starting point for Cocoa Touch applications is the Window-based Application project template. So let's make a copy of that template.
###### Copy the project template





