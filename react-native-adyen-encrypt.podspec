require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-adyen-encrypt"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-adyen-encrypt
                   DESC
  s.homepage     = "https://github.com/voomflights/react-native-adyen-encrypt"
  s.license      = "MIT"
  s.platforms    = { :ios => "10.0" }
  s.authors      = { "voompair" => "voompair@voom.flights" }
  s.source       = { :git => "https://github.com/voomflights/react-native-adyen-encrypt.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "Adyen", '3.6.0'
end

