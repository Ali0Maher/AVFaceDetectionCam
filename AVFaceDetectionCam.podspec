
Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "AVFaceDetectionCam"
s.summary      = "A framework that creates a custom AVFoundation camera that uses ML Kit to return an image with a human face"
s.description  = <<-DESC
                    AVFaceDetectionCam is a framework that creates a custom AVFoundation camera that uses ML Kit to return an image with a human face
                   DESC
s.requires_arc = true

# 2
s.version = "1.0.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE.md" }

# 4 - Replace with your name and e-mail address
s.author = { "Ali Maher" => "ali.maheir@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/Ali0Maher/AVFaceDetectionCam"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/Ali0Maher/AVFaceDetectionCam.git", 
            :tag => "#{s.version}" }
# 7
s.frameworks = 'UIKit', 'Foundation', 'AVFoundation', 'MLKit'


# 8
s.source_files  = 'AVFaceDetectionCam', 'AVFaceDetectionCam/**/*.{swift}'

# 10
s.swift_version = "5"
end
