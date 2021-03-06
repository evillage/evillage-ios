platform :ios, '12.0'
install! 'cocoapods', :disable_input_output_paths => true

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
