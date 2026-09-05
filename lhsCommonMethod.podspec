Pod::Spec.new do |s|
  s.name         = 'lhsCommonMethod'
  s.version      = '0.0.9'
  s.summary      = 'A common utility library for iOS projects'
  s.description  = <<-DESC
    lhsCommonMethod is a common utility library providing tools for permissions,
    network reachability, toast notifications, color utilities, and more.
  DESC
  s.homepage     = 'https://github.com/luo71418578/firstPod'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'luo71418578' => 'luo71418578@example.com' }
  s.source       = { :git => 'https://github.com/luo71418578/firstPod.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  # Source files
  s.source_files = 'lhsCommonMethod/**/*.{h,m}'

  # Frameworks
  s.frameworks   = 'UIKit', 'Foundation', 'AVFoundation', 'WebKit', 'CoreTelephony'

  # Requires ARC
  s.requires_arc = true
end
