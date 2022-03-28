# Trackpad settings on macos
## Point & Click
### Look up & data detectors
#### Force Click
```
    "Apple Global Domain"
        com.apple.trackpad.forceClick 0/1
```
#### Three Finger Tap
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadThreeFingerTapGesture 0/2
```
```
*currenthost
    AGD
        com.apple.trackpad.threeFingerTapGesture 0/2
```

### Secondary Click
```
    "Apple Global Domain"
        ContextMenuGesture = 0/1
```
#### Two Finger Click
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadRightClick 0/1
```
```
*currenthost
    AGD
        com.apple.trackpad.enableSecondaryClick 0/1
```
#### Bottom Right Click
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadCornerSecondaryClick 0/2
```
```
*currenthost
    AGD
        com.apple.trackpad.trackpadCornerClickBehavior 0/1
```
#### Bottom Left Click
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadCornerSecondaryClick 0/1
```
```
*currenthost
    AGD
        com.apple.trackpad.trackpadCornerClickBehavior 0/3
```

### Tap to click
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        Clicking 0/1
```
```
*currenthost
    AGD
        com.apple.mouse.tapBehavior
```

### Silent clicking
```
    com.apple.AppleMultitouchTrackpad
        ActuationStrength = 0 (absent otherwise)
```

### Force Click and Haptic Feedback
```
    com.apple.AppleMultitouchTrackpad
        ActuateDetents 1/0
        ForceSuppressed 0/1
```

### Scroll Direction: Natural
```
    "Apple Global Domain"
        com.apple.swipescrolldirection 0/1
```

### Zoom in or out
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadPinch 0/1
```
```
*currenthost
    AGD
        com.apple.trackpad.pinchGesture 0/1
```

### Smart Zoom
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadTwoFingerDoubleTapGesture 0/1
```
```
*currenthost
    AGD
        com.apple.trackpad.twoFingerDoubleTapGesture 0/1
```

### Rotate
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadRotate 0/1
```
```
*currenthost
    AGD
        com.apple.trackpad.rotateGesture 0/1
```

### Swipe Between Pages
#### 2-finger
```
    "Apple Global Domain"
        AppleEnableSwipeNavigateWithScrolls 0/1
```
#### 3-finger
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadThreeFingerHorizSwipeGesture 0/1
        TrackpadThreeFingerVertSwipeGesture 0/1
```

### Swipe between full-screen apps
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadThreeFingerHorizSwipeGesture 0/2
        TrackpadFourFingerHorizSwipeGesture 0/2
```
```
*currenthost
    "Apple Global Domain"
    com.apple.trackpad.threeFingerHorizSwipeGesture 0/2
    com.apple.trackpad.fourFingerHorizSwipeGesture 0/2
```

### Notification Center
```
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadTwoFingerFromRightEdgeSwipeGesture 0/3
```
```
*currenthost
    "Apple Global Domain"
        com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture 0/3
```

### Mission Control
mission control/app expose are coupled regarding number of fingers
```
    com.apple.dock
        showMissionControlGestureEnabled 0/1
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadThreeFingerVertSwipeGesture 0/2
        TrackpadFourFingerVertSwipeGesture 0/2
```
```
*currenthost
    "Apple Global Domain"
        com.apple.trackpad.fourFingerVertSwipeGesture 0/2
```

### App Expose
```
    com.apple.dock
        showAppExposeGestureEnabled 0/1
```

### Launchpad
```
    com.apple.dock
        showLaunchpadGestureEnabled
```

### Show Desktop" "Spread with thumb and three fingers
```
    com.apple.dock
        showDesktopGestureEnabled
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
        TrackpadFiveFingerPinchGesture 0/2
        TrackpadFourFingerPinchGesture 0/2
```
```
*currenthost
    "Apple Global Domain"
        com.apple.trackpad.fourFingerPinchSwipeGesture
        com.apple.trackpad.fiveFingerPinchSwipeGesture 0/2
```

## Notes
Furthermore, there is
```
* currenthost
Apple Global Domain
  com.apple.trackpad.momentumScroll 0/1
  com.apple.trackpad.scrollBehavior 2
