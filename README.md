#Flickr Viewer

![Flickr Viewer](https://raw.githubusercontent.com/convexstyle/flickr-viewer/refactor-views/assets/flickr-viewer-logo.png "Flickr Viewer")

Flickr Viewer is a sample application that displays the photos of [Flickr](https://www.flickr.com/ "Flickr") public time.

## Requirements
* Ruby `2.2.3`
* CocoaPods `0.39.0`
* Xcode `7.2`
* iOS `9.2`
* rbenv (optional)

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

Flickr Viewer is using [Quick](https://github.com/Quick/Quick "Quick") and [Nimble](https://github.com/Quick/Nimble "Nimble") for unit testing. The current version of Quick has some issues to run an individual tests class (QuickSpec), so the only solution is to run tests entirely with Command + U. The issue was mentioned [here](https://github.com/Quick/Quick/issues/373).
