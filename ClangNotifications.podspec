#
#  Be sure to run `pod spec lint ClangNotifications.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name                 = 'ClangNotifications'
  spec.version              = '0.1.9'
  spec.license              = { :type => 'MIT', :file => 'FILE_LICENSE' }
  spec.summary              = 'Clang Library for registering events @ clang env'
  spec.homepage             = 'https://github.com/evillage/evillage-ios'
  spec.author               = { 'e-Village' => 'info@e-village.nl' }
  spec.source               = { :git => 'https://github.com/evillage/evillage-ios.git', :tag => spec.version }
  spec.description          = <<-DESC
                              Clang Library for registering events! @ clang env
  DESC

  spec.ios.deployment_target = '11.0'
  spec.swift_versions = ['5.0']

  spec.source_files = 'ClangNotifications/**/*.swift'
end
