Pod::Spec.new do |s|

  s.name         = "Bling"
  s.version      = "2.0.0"
  s.summary      = "Open Exchange Rates API wrapper written in Swift"
  s.swift_version= "5.1"

  s.description  = <<-DESC
                   Access the Open Exchange Rates API in Swift. Provides easy access to all API calles listed in https://docs.openexchangerates.org
                   DESC

  s.homepage     = "https://github.com/JanGorman/Bling"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Jan Gorman" => "gorman.jan@gmail.com" }
  s.social_media_url   = "http://twitter.com/JanGorman"

  s.platform     = :ios, "13.0"

  s.source       = { :git => "https://github.com/JanGorman/Bling.git", :tag => s.version}

  s.source_files  = "Classes", "Bling/*.swift"

end
