### custom Xcode Templates

referenceUrl：[https://useyourloaf.com/blog/creating-custom-xcode-project-templates/](https://useyourloaf.com/blog/creating-custom-xcode-project-templates/)

#### Where Are The Xcode Templates
The iOS templates are in sub-folders here：
> /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/Project\ Templates/iOS


#### How Do They Work
**TemplateInfo.plist file**


#### Creating A New Project Template

$ mkdir -p ~/Library/Developer/Xcode/Templates/Project\ Templates/Personal

$ APP_TEMPLATES='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/Project Templates/iOS/Application'

$ cd ~/Library/Developer/Xcode/Templates/Project\ Templates/Personal/
$ cp -r "$APP_TEMPLATES/Single View App.xctemplate" "Manual Single View App.xctemplate"



