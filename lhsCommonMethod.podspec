Pod::Spec.new do |s|
  s.name         = "lhsCommonMethod"
  s.version      = "0.0.4"
  s.summary      = "lhsCommonMethod,常用方法"
  s.description  = <<-DESC
                    一些开发中经常使用的方法
                   DESC
  s.homepage     = "https://github.com/luo71418578/firstPod"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "luo71418578" => "921257813@qq.com" }
  s.source       = { :git => "https://github.com/luo71418578/firstPod.git", :tag => "#{s.version}" }

  s.platform     = :ios, '13.0'
  s.source_files = "lhsCommonMethod/**/*.{h,m}"

  s.framework    = "UIKit"
  s.requires_arc = true
end
