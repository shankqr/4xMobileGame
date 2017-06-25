GA-SDK-IOS
==========

GameAnalytics native iOS SDK.

Documentation in the [wiki](https://github.com/GameAnalytics/GA-SDK-IOS/wiki).

> :information_source:
> Requirements:<br/>
> **iOS:** iOS 6.x and up

Changelog
---------
<!--(CHANGELOG_TOP)-->
**2.2.7**
* added bundle_id, app version and app build tracking

**2.2.6**
* possible to set custom dimensions before initialise

**2.2.5**
* fixed user_id tracking for iOS 10

**2.2.4**
* fix isAppStoreReceiptSandbox bug on iOS 6 devices and lower

**2.2.3**
* fixed bug for client timestamp handling and session length in certain edge cases

**2.2.2**
* added option for manual session handling

**2.2.1**
* fixed validator to allow 'cocos2d' as sdk wrapper

**2.2.0**
* feature for using a custom user id
* fix testflight issue with user id generation

**2.1.0**
* altered jailbreak check causing ios9 warning
* library / framework now compiled with bitcode
* alternative non-bitcode library (Xcode6) added
* restructuring to prepare for tvOS

**2.0.9**
* removed unnecessary files

**2.0.8**
* altered code to support Fabric tool
* added Framework
* updated podspec file to use Framework

**2.0.7**
* built library with Xcode7 (iOS 9.0)
* minor tweaks
* fix version

**2.0.5**
* use HTTPS as required by iOS9

**2.0.4**
* increased allowed character count to 64 for many parameters

**2.0.3**
* fixed an issue with going-to-background on iOS6
* fixed submit of birthyear value

**2.0.2**
* fixed a bug for iOS6

**2.0.1**
* iOS SDK for V2 api
* progression event
* validated business event
* resource event
* custom dimensions
