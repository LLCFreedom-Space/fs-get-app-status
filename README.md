[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
![GitHub release (with filter)](https://img.shields.io/github/v/release/LLCFreedom-Space/fs-get-app-status)
 [![Read the Docs](https://readthedocs.org/projects/docs/badge/?version=latest)](https://llcfreedom-space.github.io/fs-get-app-status/)
![example workflow](https://github.com/LLCFreedom-Space/fs-get-app-status/actions/workflows/docc.yml/badge.svg?branch=main)
![example workflow](https://github.com/LLCFreedom-Space/fs-get-app-status/actions/workflows/lint.yml/badge.svg?branch=main)
![example workflow](https://github.com/LLCFreedom-Space/fs-get-app-status/actions/workflows/test.yml/badge.svg?branch=main)
 [![codecov](https://codecov.io/github/LLCFreedom-Space/fs-get-app-status/graph/badge.svg?token=2EUIA4OGS9)](https://codecov.io/github/LLCFreedom-Space/fs-get-app-status)

# Get App Status

Quick implementation of getting the application status.

## Swift version

The latest version of GetAppStatus requires **Swift 6.0** and **MacOS v15** or later. You can download this version of the Swift binaries by following this [link](https://swift.org/download/).

## Usage

### Swift Package Manager

#### Add dependencies using the version
Add the `GetAppStatus` package to the dependencies within your application’s `Package.swift` file. Substitute `"x.x.x"` with the latest `GetAppStatus` [release](https://github.com/LLCFreedom-Space/fs-get-app-status/releases).
```swift
.package(url: "https://github.com/LLCFreedom-Space/fs-get-app-status.git", from: "x.x.x")
```
Add `GetAppStatus` to your target's dependencies:
```swift
.target(name: "GetAppStatus", dependencies: ["GetAppStatus"]),
```
#### Import package
```swift
import GetAppStatus
```

#### Add dependencies using the branch
Add the `GetAppStatus` package to the dependencies within your application’s `Package.swift` file. Substitute `"name branch"` with the latest `GetAppStatus` [release](https://github.com/LLCFreedom-Space/fs-get-app-status/releases).
```swift
.package(url: "https://github.com/LLCFreedom-Space/fs-get-app-status.git", branch: "name branch")
```
Add `FSGetAppStatus` to your target's dependencies:
```swift
.target(name: "GetAppStatus", dependencies: ["GetAppStatus"]),
```
#### Import package
```swift
import GetAppStatus
```

## Getting Started
An example of a method call from this library 
```
app.appStatus.getRedisStatus()
```
To access the methods that are in this library, you need to call the application, since this library is an extension to the application

## API Documentation
There are functions that are used in a pair. Example:
```
func applicationLaunchTime vs func applicationLaunchDate
```
need use when you configuration your Application. In last line in configure.swift file. Because this function records the start time in the application.
And the function where you need to understand how long the application has been running since it started.
```
func applicationUpTime vs func applicationUpDate
``` 
Depending on which value you want, you call one or the second function.

## Links

LLC Freedom Space – [@LLCFreedomSpace](https://twitter.com/llcfreedomspace) – [support@freedomspace.company](mailto:support@freedomspace.company)

Distributed under the GNU AFFERO GENERAL PUBLIC LICENSE Version 3. See [LICENSE.md][license-url] for more information.

 [GitHub](https://github.com/LLCFreedom-Space)

[swift-image]:https://img.shields.io/badge/swift-6.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-GPLv3-blue.svg
[license-url]: LICENSE
