Pod::Spec.new do |s|
  s.name         = "Balto-SDK"
  s.version      = "3.0.0-beta5"
  s.summary      = "Balto iOS SDK."
  s.description  = <<-DESC
                    Balto lets you leave feadback with a simple swipe on the screen.
                    Send design fixes or new ideas to the developer right away.

                    https://www.balto.io/
                   DESC

  s.homepage     = "https://github.com/goodpatch/Balto-SDK"
  s.license      = { :type => "Apache 2.0", :file => "LICENSE" }
  s.author       = { "Hiroki Terashima" => "h.terashima@goodpatch.com" }
  s.platform     = :ios, "9.0"
  s.requires_arc = true

  # s.source = { :http => "https://github.com/goodpatch/Balto-SDK/releases/download/#{s.version}/Cocoapods.zip" }
  s.source = { :git => "https://github.com/goodpatch/Balto-SDK.git", :tag => "#{s.version}" }

  s.preserve_paths      = 'BaltoSDK.framework'
  s.source_files        = 'BaltoSDK.framework/Headers/BaltoSDK-Swift.h'
  s.public_header_files = 'BaltoSDK.framework/Headers/BaltoSDK-Swift.h'
  s.vendored_frameworks = 'BaltoSDK.framework'

end
