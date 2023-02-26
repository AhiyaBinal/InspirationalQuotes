
#Introduction
Inspirational Quotes is an simple app of display quotes from Rapid API and share with your friends contains PageViewController, JSON Parsing and Share Functionality

#Requirements
Xcode 13 or above
SwiftLint 

#Installation
To install SwiftLint follow the steps from https://realm.github.io/SwiftLint/
To install RxSwift follow the steps from https://github.com/ReactiveX/RxSwift

#Configuration
Steps to implement PageViewController , Json Parsing and Share Functionality
PageView Controller
    Implement Page view controller delegated methods which are viewControllerBefore, viewControllerAfter, didFinishAnimating

Json Parsing
    Implement JSON parsing method called loadJSON using URLRequest

Share Functionality
    To share quote here I have created an image of quote using UIGraphics and share with the help of UIActivityViewController
