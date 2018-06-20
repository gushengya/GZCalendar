Pod::Spec.new do |s|

    s.name         = "GZCalendar"
    s.version      = "0.0.3"
    s.summary      = "A GZCalendar For Developer."
    s.description  = <<-DESC
    For the convenience of the calendar library development and encapsulation
                   DESC
    s.platform     = :ios, '8.0'
    s.homepage     = "https://github.com/gushengya/GZCalendar"
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.author             = { "gushengya" => "759705236@qq.com" }
    s.source       = { :git => "https://github.com/gushengya/GZCalendar.git", :tag => "#{s.version}" }
    s.source_files  = "GZCalendar/GZCalendar.h"
    s.frameworks = 'UIKit'

    # --- 子目录 --- #
    s.subspec 'Category' do |cate|
    cate.source_files = "GZCalendar/Category/**/*.{h,m}"
    cate.public_header_files = "GZCalendar/Category/**/*.h"
    end

    s.subspec 'Manager' do |man|
    man.source_files = "GZCalendar/Manager/**/*.{h,m}"
    man.public_header_files = "GZCalendar/Manager/**/*.h"
    man.dependency "GZCalendar/Category"
    end

    s.subspec 'View' do |v|
    v.source_files = "GZCalendar/View/**/*.{h,m}"
    v.public_header_files = "GZCalendar/View/**/*.h"
    v.dependency "GZCalendar/Category"
    v.dependency "GZCalendar/Manager"
    end
  
end


