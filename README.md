# Get App Status

Quick implementation of getting the application status.

## Swift version

The latest version of FSGetAppStatus requires **Swift 5.9** and **MacOS v13** or later. You can download this version of the Swift binaries by following this [link](https://swift.org/download/).

## Usage

### Swift Package Manager

#### Add dependencies using the version
Add the `FSGetAppStatus` package to the dependencies within your application’s `Package.swift` file. Substitute `"x.x.x"` with the latest `FSGetAppStatus` [release](https://github.com/LLCFreedom-Space/fs-get-app-status/releases).
```swift
.package(url: "https://github.com/LLCFreedom-Space/fs-get-app-status.git", from: "x.x.x")
```
Add `FSGetAppStatus` to your target's dependencies:
```swift
.target(name: "FSGetAppStatus", dependencies: ["FSGetAppStatus"]),
```
#### Import package
```swift
import FSGetAppStatus
```

#### Add dependencies using the branch
Add the `FSGetAppStatus` package to the dependencies within your application’s `Package.swift` file. Substitute `"name branch"` with the latest `FSGetAppStatus` [release](https://github.com/LLCFreedom-Space/fs-get-app-status/releases).
```swift
.package(url: "https://github.com/LLCFreedom-Space/fs-get-app-status.git", branch: "name branch")
```
Add `FSGetAppStatus` to your target's dependencies:
```swift
.target(name: "FSGetAppStatus", dependencies: ["FSGetAppStatus"]),
```
#### Import package
```swift
import FSGetAppStatus
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
