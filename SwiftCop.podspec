Pod::Spec.new do |s|
  s.name         = "SwiftCop"
  s.version      = "1.0.0"
  s.summary      = "SwiftCop is a validation library fully written in Swift and inspired by the verbosity and clarity of Ruby On Rails Active Record validations"
  s.description  = <<-DESC
                   Build a standard drop-in library for validations in Swift while making it easily extensible for users to create custom validations. And avoid developers from writting over and over again the same code and validations for different projects.
                   DESC

  s.homepage     = "https://github.com/andresinaka/SwiftCop/tree/master"
  s.screenshots  = "https://github.com/andresinaka/SwiftCop/raw/master/swiftCop.png", "https://github.com/andresinaka/SwiftCop/raw/master/swiftCopExample.gif"

  s.license = 'MIT'
  s.author    = "Andres Canal"
  s.social_media_url   = "http://twitter.com/andangc"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/andresinaka/SwiftCop.git", :tag => s.version }
  s.source_files  = "SwiftCop/**/*.swift"
end
