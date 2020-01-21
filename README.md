# README #

This is a proof of concept with a demo IOS application which uses our custom [library for notifications]()
App is written in Swift, uses Firebase cloud messaging for notifications.

### How to run the application ###

* clone this repository (default working branch is master)
* open project directory in terminal and run `pod install` (if you don't have CocoaPods installed the run first `sudo gem install cocoapods`)
* Open .xcworkspace file in Xcode and you're ready for using it
* Run the app on emulator or connect an IOS device (supported IOS is 12 and 13)

### Customer Id set up ###
Customer id as a unique identifier for an app which uses the library and set in the config file for build:
* Go to _your_workspace/ClangNotifications/Config.xcconfig_ and set _CUSTOMER_ID = your_application_unique_identifier_
* In the application directory (not library) go to _info.plist_ and by using variable substitution in the _.plist_ 
for the appropriate keys, substituting our custom variables from the xcconfig files:
**CUSTOMER_ID** as a key and  value set to **$(CUSTOMER_ID)** which will be read from env config file.

### Links ###

* [Firebase project](https://console.firebase.google.com/project/test-a04ac/overview) (for access ask oboekesteijn@worth.systems or tpadalko@worth.systems)
* [Documentation in how to set certificates for Firebase and APN](https://docs.google.com/document/d/1RvWcAS-WYmlcAzUUiRgGu_iBPyzmXzr1Aez9DQdIL30/edit?usp=sharing)
* [Google doc with some edge cases, etc.](https://docs.google.com/document/d/1Nw7Ik1VY8Sz2PPtj86yaTUyZ9qnO__xaDHcRuk6Xsbk/edit?usp=sharing)
* [Server repo](https://bitbucket.org/wi/evillage-token-server/src)
