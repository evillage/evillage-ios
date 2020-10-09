# Clang #

[![Platforms](https://img.shields.io/badge/platforms-ios%20%7C%20macos%20%7C%20tvos%20%7C%20watchos-lightgrey.svg)](https://img.shields.io/badge/platforms-ios%20%7C%20macos%20%7C%20tvos%20%7C%20watchos-lightgrey.svg)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v0.0.5-blue)](https://img.shields.io/badge/pod-v0.0.4-blue)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-not%20compatible-red.svg)](https://img.shields.io/badge/Carthage-not%20compatible-red.svg)
[![SPM Compatible](https://img.shields.io/badge/SPM-not%20compatible-red.svg)](https://img.shields.io/badge/SPM-not%20compatible-red.svg)
[![Documentation](https://img.shields.io/badge/documentation-68%25-brightgreen.svg)](https://img.shields.io/badge/documentation-68%25-brightgreen.svg)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-11.2-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

This repository contains the Clang Mobile SDK with a demo IOS application which uses our custom [library for notifications]()
App is written in Swift, uses Firebase cloud messaging for notifications.

### How to run the application ###

* Clone this repository (default working branch is master)
* Open project directory in terminal and run `pod install` (if you don't have CocoaPods installed the run first `sudo gem install cocoapods`)
* Open .xcworkspace file in Xcode and you're ready for using it
* Run the app on simulator or connect an IOS device (supported IOS is 12 and 13). Remember push notifications won't work on the simulator.

### Clang library setup ###
To start using the Clang library you need to add some keys and values in your app's info.plist file. Add the following keys and values:

1. BASE_URL
2. AUTHORIZATION_TOKEN
3. INTEGRATION_ID

These values will be provided when you contact E-Village to start integrating with the Clang platform.

### Create a new version on Cocoapods
Cocoapods used the tag system of bitbucket to specifcy which version is being used. When you want to create a new version of the ClangNotifications pod
perfrom the following steps

1. Tag the version in Bitbucket with the new version number
2. Change the **$(spec.version)** in the ClangNotifications.podspec file to the same version as you just tagged in bitbucket
3. Open terminal and navigate to the root of the project and run `pod lib lint` to see if everything is correct
4. run `pod repo push evillage-podspecs ClangNotifications.podspec` in the same terminal to submit the code to Cocoapods

### Generate documentation
To generate documentation for this project, follow these simple steps:

1. Install Jazzy on your mac by going to terminal and run 'sudo gem install jazzy' this will install the required files need to generate documentation
2. Still in terminal navigate to the root of the project and run 'jazzy' the documentation will be generated in the /Documentation folder
3. Enjoy the generated documentation!

### Using the Clang library in your own project

* Install cocoapods by opening terminal and run `sudo gem install cocoapods`
* Open the root folder of your project and run `pod init` this will create a `POD` file which will contain all pod libraries you want to use in your project.
* Open the `POD` file in a text editor of your choice (I recommend Visual Studio Code) and uncomment the line where it says: `platform :iOS, 'XX.X'` and change the `XX.X` to `12.0`.
* Below the `target 'project_name' do` add `souce 'https://bitbucket.org/wi/evillage-podspecs.git'`
* Below the `# Pods for project_name` add `pod 'ClangNotifications'`
* Head back to the terminal and run `pod install` in the root project of your project (where the POD file is located)

### Links ###

* [Firebase project](https://console.firebase.google.com/project/test-a04ac/overview) (for access ask oboekesteijn@worth.systems or tpadalko@worth.systems)
* [Documentation in how to set certificates for Firebase and APN](https://docs.google.com/document/d/1RvWcAS-WYmlcAzUUiRgGu_iBPyzmXzr1Aez9DQdIL30/edit?usp=sharing)
* [Google doc with some edge cases, etc.](https://docs.google.com/document/d/1Nw7Ik1VY8Sz2PPtj86yaTUyZ9qnO__xaDHcRuk6Xsbk/edit?usp=sharing)
* [Server repo](https://bitbucket.org/wi/evillage-token-server/src)
* [Jazzy document generator](https://github.com/realm/jazzy)
* [Swiftlint](https://github.com/realm/SwiftLint)
* [Cocoapods documentation](https://guides.cocoapods.org/)
