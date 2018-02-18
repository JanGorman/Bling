Pod::Spec.new do |s|

  s.name         = "Bling"
  s.version      = "1.0.0"
  s.summary      = "Open Exchange Rates API wrapper written in Swift"

  s.description  = <<-DESC
                   Access the Open Exchange Rates API in Swift. Provides easy access to all API calles listed in https://docs.openexchangerates.org
                   DESC

  s.homepage     = "https://github.com/JanGorman/Bling"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Jan Gorman" => "gorman.jan@gmail.com" }
  s.social_media_url   = "http://twitter.com/JanGorman"

  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/JanGorman/Bling.git", :tag => s.version}

  s.source_files  = "Classes", "Bling/*.swift"

end