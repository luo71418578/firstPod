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

  # Frameworks
  s.frameworks   = 'UIKit', 'Foundation', 'AVFoundation', 'WebKit', 'CoreTelephony'

  # Requires ARC
  s.requires_arc = true

  # 根目录文件
  s.source_files = 'lhsCommonMethod/*.{h,m}'

  # Category
  s.subspec 'Category' do |ss|
    ss.source_files = 'lhsCommonMethod/Category/*.{h,m}'
  end

  # thirdPart 下的各个模块
  s.subspec 'CMMThirdPart' do |ss|
    ss.source_files = 'lhsCommonMethod/thirdPart/CMMThirdPart.{h,m}'
  end

  s.subspec 'CountdownTimer' do |ss|
    ss.source_files = 'lhsCommonMethod/thirdPart/CountdownTimer/*.{h,m}'
  end

  s.subspec 'CutDownButton' do |ss|
    ss.source_files = 'lhsCommonMethod/thirdPart/CutDownButton/*.{h,m}'
  end

  s.subspec 'DocumentPickerManager' do |ss|
    ss.source_files = 'lhsCommonMethod/thirdPart/DocumentPickerManager/*.{h,m}'
  end

  s.subspec 'HexColors' do |ss|
    ss.source_files = 'lhsCommonMethod/thirdPart/HexColors/*.{h,m}'
  end

  s.subspec 'LBXPermissions' do |ss|
    ss.source_files = 'lhsCommonMethod/thirdPart/LBXPermissions/*.{h,m}'
  end

  s.subspec 'MMLocationManager' do |ss|
    ss.source_files = 'lhsCommonMethod/thirdPart/MMLocationManager/*.{h,m}'
  end

  s.subspec 'Toast' do |ss|
    ss.source_files = 'lhsCommonMethod/thirdPart/Toast/*.{h,m}'
  end
end
