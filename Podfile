platform :ios, '12.0'

def shared_pods
  pod 'SwiftLint'
end

target 'ClangNotifications' do
  use_frameworks!
  shared_pods
end


target 'ClangNotificationsDemoApp' do
  use_frameworks!
  shared_pods
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'ClangNotifications', :path => '.'
end
