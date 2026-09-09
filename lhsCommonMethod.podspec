Pod::Spec.new do |s|
  s.name         = 'lhsCommonMethod'
  s.version      = '0.0.11'
  s.summary      = 'A common utility library for iOS projects'
  s.description  = <<-DESC
    lhsCommonMethod is a common utility library providing tools for permissions,
    network reachability, toast notifications, color utilities, and more.
  DESC
  s.homepage     = 'https://github.com/luo71418578/firstPod'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'luo71418578' => '921257813@qq.com' }
  s.source       = { :git => 'https://github.com/luo71418578/firstPod.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  # Umbrella header (主入口)
  s.source_files = 'lhsCommonMethod/lhsCommonMethod.h'

  # Preserve directory structure for headers
  s.header_mappings_dir = 'lhsCommonMethod'

  # Frameworks
  s.frameworks   = 'UIKit', 'Foundation', 'AVFoundation', 'WebKit', 'CoreTelephony'

  # Requires ARC
  s.requires_arc = true

  # ── Subspecs (对应 Xcode 中的文件夹分组) ──

  s.subspec 'HexColors' do |ss|
    ss.source_files = 'lhsCommonMethod/HexColors/*.{h,m}'
  end

  s.subspec 'LBXPermissions' do |ss|
    ss.source_files = 'lhsCommonMethod/LBXPermissions/*.{h,m}'
  end

  s.subspec 'MMLocationManager' do |ss|
    ss.source_files = 'lhsCommonMethod/MMLocationManager/*.{h,m}'
  end

  s.subspec 'CountdownTimer' do |ss|
    ss.source_files = 'lhsCommonMethod/CountdownTimer/*.{h,m}'
  end

  s.subspec 'CutDownButton' do |ss|
    ss.source_files = 'lhsCommonMethod/CutDownButton/*.{h,m}'
  end

  s.subspec 'DocumentPickerManager' do |ss|
    ss.source_files = 'lhsCommonMethod/DocumentPickerManager/*.{h,m}'
  end

  s.subspec 'Toast' do |ss|
    ss.source_files = 'lhsCommonMethod/Toast/*.{h,m}'
  end

  s.subspec 'Category' do |ss|
    ss.source_files = 'lhsCommonMethod/Category/*.{h,m}'
  end

  s.subspec 'Core' do |ss|
    ss.source_files = 'lhsCommonMethod/CMMUtility.{h,m}',
                     'lhsCommonMethod/HWToolBox.{h,m}',
                     'lhsCommonMethod/lhsDataMacros.{h,m}',
                     'lhsCommonMethod/TLJumpNavManager.{h,m}',
                     'lhsCommonMethod/CMMThirdPart.{h,m}'
    ss.dependency 'lhsCommonMethod/HexColors'
    ss.dependency 'lhsCommonMethod/Category'
    ss.dependency 'lhsCommonMethod/LBXPermissions'
    ss.dependency 'lhsCommonMethod/Toast'
  end

  # 默认安装所有 subspec
  s.default_subspecs = 'Core', 'HexColors', 'LBXPermissions', 'MMLocationManager', 'CountdownTimer', 'CutDownButton', 'DocumentPickerManager', 'Toast', 'Category'
end
