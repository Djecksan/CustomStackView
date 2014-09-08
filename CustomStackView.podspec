Pod::Spec.new do |s|
  s.name         = "CustomStackView"
  s.version      = "1.0"
  s.summary      = "Custom stack view is a view, which displays views as a stack. You can slide these views in differen directions (up, down, left and right)."
  s.homepage     = "https://github.com/Djecksan/CustomStackView"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Evgenyi Tyulenev" => "9koks9@gmail.com" }
  s.source       = { :git => "https://github.com/Djecksan/CustomStackView.git", :tag => "1.0" }

  s.platform     = :ios, '7.0'
  s.source_files = 'CSVStackView/*.{h,m}'
  s.requires_arc = true
end