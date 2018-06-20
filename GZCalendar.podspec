Pod::Spec.new do |s|

  s.name         = "GZCalendar"
  s.version      = "0.0.2"
  s.summary      = "A GZCalendar For Developer."
  s.description  = <<-DESC
    For the convenience of the calendar library development and encapsulation
                   DESC
  s.platform     = :ios, '8.0'
  s.homepage     = "https://github.com/gushengya/GZCalendar"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "gushengya" => "759705236@qq.com" }
  s.source       = { :git => "https://github.com/gushengya/GZCalendar.git", :tag => "#{s.version}" }
  s.source_files  = "GZCalendar/**/*.{h,m}"
  s.frameworks = 'UIKit'
  
end
