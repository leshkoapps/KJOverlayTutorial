Pod::Spec.new do |s|
  s.name             = "KJOverlayTutorial"
  s.version          = "1.0.1"
  s.summary          = "A Tutorial for iOS"
  s.homepage         = "https://github.com/tranquan/KJOverlayTutorial"
  s.license          = { :type => "MIT" }
  s.authors          = { "Tran Quan" => "https://github.com/tranquan" }
  s.source           = { :git => "https://github.com/leshkoapps/KJOverlayTutorial.git", :tag => "v#{s.version}" }

  s.source_files     = "OverlayTutorial/ClassExt.swift", "OverlayTutorial/KJOverlayTutorialVC.swift", "OverlayTutorial/KJTutorial.swift"

  s.swift_version = "4.0"
  s.ios.deployment_target = "9.0"
  s.requires_arc = true
  s.framework      = 'Foundation'
  s.framework  = 'UIKit'

end