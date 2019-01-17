
Pod::Spec.new do |s|


  s.name         = "LSKit"
  s.version      = "0.0.2"
  s.summary      = "Lyson个人工具库"

 
  s.description  = "为了方便开发，收集的各类工具"

  s.homepage     = "https://www.baidu.com/"

  s.license      = "MIT"
  
  s.author       = { "Lyson" => "542634994@qq.com" }


  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  
#  s.source       = { :git => "./", :tag => s.version.to_s}
  s.source_files  = "LSKit/**/*.{h,m,swift}"
  s.source           = { :git => 'https://github.com/lysh123sdo/LSKit.git', :tag => s.version.to_s}
  s.requires_arc = true
  
  s.dependency 'CocoaLumberjack', '~> 3.3.0'
  s.dependency 'YYKit', '~> 1.0.9'
  s.dependency 'AFNetworking'
  s.dependency 'JTObjectMapping', '~> 1.1.2'
  
end
