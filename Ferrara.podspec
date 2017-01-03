Pod::Spec.new do |s|
  s.name         = "Ferrara"
  s.version      = "0.0.1"
  s.summary      = "Spot differences between two arrays"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  Spot differences between two arrays
                   DESC

  s.homepage     = "https://github.com/muccy/#{s.name}"
  s.license      = "MIT"
  s.author       = { "Marco Muccinelli" => "muccymac@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/muccy/#{s.name}.git", :tag => s.version }
  s.source_files  = "Source", "Source/**/*.swift"


end
