# THEOplayer React Native Reference App

THEO Technologies does not provide THEOplayer React Native components. These apps describes how our current THEOplayer iOS and Android SDKs can be wrapped in React Native Bridges. The sample React Native bridge code is provided AS-IS without any explicit nor implicit guarantees. The React Native bridge sample code only provides mapping for a number of commonly used THEOplayer APIs, it is the customer’s responsibility to further expand the mapping and subsequently maintain the code and ensure compatibility with future versions of THEOplayer SDKs.

This is the Chromeless basic application in React native with theoplayer. This app decribes on how to create a chromeless project of THEOplayer and React Native in Android, iOS and tvOS. 


## Getting Started on Android:
### Usage
##### Run project:
- install app libs `yarn`,
- run project `yarn run start`.

##### Run emulator:
- open project folder `<path to project>/android`,
- add emulator device configuration(AVD Manager).

##### Add THEOplayer SDK library:
- Please copy received THEOplayer license file theoplayer-android-[name]-[version]-minapiXX-release.aar into [theoplayer folder](./android/theoplayer) and rename it to theoplayer.aar.
- Sync Project with gradle files again 

Note: Please use minapi16-THEOplayer SDK for Android devices starting from 4.1 and above, while minapi21-THEOplayer SDK can be used for Android 5.0 and above.


## Getting Started on iOS:

### Import THEOplayer SDK:
- Drag and drop THEOplayer iOS SDK Framework file respectively in [ios/THEOlibs](./ios/THEOlibs) folder for iOS and tvOS.
- Add THEOplayer SDK Framework to the project as stated in our documentation: [Getting Started with tvOS and iOS in React Native](https://docs.portal.theoplayer.com/getting-started/02-frameworks/03-react-native/02-add-tvos.md)

##### Install libs/depandencies:
- install app libs `yarn`,
- install pods `pod install`.

##### Run project and emulator:
- Open TheoPlayerReactNative.xcworkspace from the ios folder or open xcode, add new project -> select workspace file in ios folder generated after pod install,
- click run project, project will start automatically -> terminal & emulator will start

## License
This project is licensed under the BSD 3 Clause License - see the [LICENSE ](../LICENSE) file for details