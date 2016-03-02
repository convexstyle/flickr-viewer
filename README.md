#Flickr Viewer

![Flickr Viewer](https://raw.githubusercontent.com/convexstyle/flickr-viewer/master/assets/flickr-viewer-logo.png "Flickr Viewer")

Flickr Viewer is a sample application that displays the photos of [Flickr](https://www.flickr.com/ "Flickr") public time.

## Requirements
* Ruby `2.2.3`
* CocoaPods `0.39.0`
* Xcode `7.2`
* iOS `9.2`
* Apple ID (optional. If you build this app to your device, it is required.)
* rbenv (optional)
* Internet connection (optional, but you see no image but error message)

## Features
- [x] Load public feed json from Flickr
- [x] Parse json and save it in the memory
- [x] Get thumbnail image, small image, medium image, original image and flickr page url with regular expression from json
- [x] Display thumbnail and large image in the UICollectionView respectively
- [x] Horizontal scrolling, Page enabled
- [x] Check the availability of Internet connection with Reachability
- [x] Open the page in Safari browser inside the app
- [x] AutoLayout
- [x] Rotation support
- [x] Universal application support
- [x] Unit testing
- [x] UITesting

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

## Build error
If you can't build the app to your device, please make sure the following.
1. Go to XCode Preference.
2. Go to Accounts tab.
3. Click plus "+" button on the on the bottom left to add your Apple ID.
4. Click Create button next to iOS Development.
5. Select FlickrViewer in the Project Navigator.
6. Select General tab.
7. If you see "No matching provisioning profiles found" warning under Team dropdown, then. click "Fix issue".
