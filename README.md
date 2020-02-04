# THEOplayer React Native Reference App

THEO Technologies does not provide THEOplayer React Native components. These apps describes how our current THEOplayer iOS and Android SDKs can be wrapped in React Native Bridges. The sample React Native bridge code is provided AS-IS without any explicit nor implicit guarantees. The React Native bridge sample code only provides mapping for a number of commonly used THEOplayer APIs, it is the customer’s responsibility to further expand the mapping and subsequently maintain the code and ensure compatibility with future versions of THEOplayer SDKs.


## Rationale

In order to use the SDK in a streaming pipeline, it needs to be integrated within an application. During the development of these applications, developers need access to solid documentation and examples at the risk of integrations not being of sufficient quality. As these applications are developed by and owned by customers, it is not always possible for THEOplayer team to get insights into the code. As a result, when issues occur during integration or when the app is in production, it can be difficult to analyse where the issue is. Similarly, when issues occur in the integrated code which are hard to reproduce, this is most often related to mistakes in the integration.


## Reference Apps

Below are the example apps which define the following usecases in iOS and Android.

* [01 - THEO RN Master](./01-rn-master/README.md)
* [02 - THEO RN Basic](./02-rn-basic/README.md)
* [03 - THEO RN DRM](./03-rn-drm/README.md)
* [04 - THEO RN Ads](./04-rn-ads/README.md)
* [05 - THEO RN Analytics](./05-rn-analytics/README.md)
* [06 - THEO RN Listeners](./06-rn-event-listeners/README.md)
* [07 - THEO RN Chromecast](./07-rn-chromecast/README.md)
* [08 - THEO RN CustomUI](./08-rn-custom-ui/README.md)
* [09 - THEO RN iOS Swift 4.2](./09-rn-ios-swift-4.2/README.md)

## Streams/Content Rights:
The streams are provided by our Partner -[EZ DRM](https://ezdrm.com/) and hold all the rights for the content. These streams are DRM protected and cannot be used for any other purposes. 

## License
This project is licensed under the BSD 3 Clause License - see the [LICENSE ](LICENSE) file for details