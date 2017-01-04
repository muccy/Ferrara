Pod::Spec.new do |s|
  s.name         = "Ferrara"
  s.version      = "1.0.0"
  s.summary      = "Spot differences between two collections"
  s.description  = <<-DESC
                    A framework which takes two collections and calculates differences between them. 
                    Ferrara returns you inserted indexes, deleted indexes, complete matches, partial matches and element movements.
                   DESC

  s.homepage     = "https://github.com/muccy/#{s.name}"
  s.license      = "MIT"
  s.author       = { "Marco Muccinelli" => "muccymac@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/muccy/#{s.name}.git", :tag => s.version }
  s.source_files  = "Source", "Source/**/*.swift"


end
