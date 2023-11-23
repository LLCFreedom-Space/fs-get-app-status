//
//  MockFSGetAppStatus.swift
//  
//
//  Created by Mykola Buhaiov on 23.11.2023.
//  Copyright © 2023 Freedom Space LLC
//  All rights reserved: http://opensource.org/licenses/MIT
//

import Vapor
@testable import FSGetAppStatus

public struct MockFSGetAppStatus: FSGetAppStatusServiceable {
    public var eventLoop: EventLoop

    public init(eventLoop: EventLoop) {
        self.eventLoop = eventLoop
    }

    public func getRedisStatus() -> EventLoopFuture<(String, HTTPResponseStatus)> {
        return eventLoop.future(("Ok", .ok))
    }

    public func getPostgresStatus() -> EventLoopFuture<(String, String, HTTPResponseStatus)> {
        return eventLoop.future(("Ok", "Ok", HTTPResponseStatus.ok))
    }

    public func getMongoDBStatus(host: String, port: String) -> EventLoopFuture<(String, HTTPResponseStatus)> {
        return eventLoop.future(("Ok", HTTPResponseStatus.ok))
    }

    public func getRedisStatusAsync() async -> (String, HTTPResponseStatus) {
        ("Ok", .ok)
    }

    public func getPostgresStatusAsync() async -> (String, String, HTTPResponseStatus) {
        return ("Ok", "Ok", HTTPResponseStatus.ok)
    }

    public func getMongoDBStatusAsync(host: String, port: String) async -> (String, HTTPResponseStatus) {
        return ("Ok", HTTPResponseStatus.ok)
    }

    public func applicationLaunchTime() { }

    public func applicationUpTime() -> Double {
        Double()
    }

    public func applicationLaunchDate() { }

    public func applicationUpDate() -> String {
        ""
    }
}
