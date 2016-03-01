#Flickr Viewer

![Flickr Viewer](https://raw.githubusercontent.com/convexstyle/flickr-viewer/master/assets/flickr-viewer-logo.png "Flickr Viewer")

Flickr Viewer is a sample application that displays the photos of [Flickr](https://www.flickr.com/ "Flickr") public time.

## Requirements
* Ruby `2.2.3`
* CocoaPods `0.39.0`
* Xcode `7.2`
* iOS `9.2`
* rbenv (optional)
* Internet connection (optional, but you see no image but error message)

## Features
- [x] Load public feed in the json format from Flickr
- [x] Parse json
- [x] Get thumbnail image, small image, medium image, original image and flickr page url with regular expression
- [x] Display thumbnail and large image in the UICollectionView respectively
- [x] Horizontal scrolling
- [x] Check the availability of Internet connection with Reachability
- [x] Unit testing
- [x] UITesting
- [x] AutoLayout
- [x] UI

## Initialization
If you haven't installed rbenv, install [rbenv](https://github.com/rbenv/rbenv "rbenv") first.

```
  rbenv install 2.2.3
  gem install bundler
  bundle install
  pod install
```

If you don't want to care about Ruby and install CocoaPods to your system version.
```
  gem install cocoapods
```

## Run
Open **FlickrViewer.xcworkspace** and build this app to your iPhone or simulator.

Do not open FlickrViewer.xcodeproj as it doesn't include any library from CocoaPods.

## Tests
**Command + U** to run Unit tests. 

Select one of simulators such as iPhone 6s Plus.

Flickr Viewer is using [Quick](https://github.com/Quick/Quick "Quick") and [Nimble](https://github.com/Quick/Nimble "Nimble") for unit testing. The current version of Quick has some issues to run an individual tests class (QuickSpec), so the only solution is to run tests entirely with Command + U. The issue was mentioned [here](https://github.com/Quick/Quick/issues/373).

## UITests
**Command + U** to run UITests.

Select one of simulators such as iPhone 6s Plus.

## Known issues
- There are some flowLayout issues when iPad rotates. The setting of Universal app has this vital issue.
