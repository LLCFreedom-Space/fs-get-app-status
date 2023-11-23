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

struct MockFSGetAppStatus: FSGetAppStatusServiceable {
    var eventLoop: EventLoop

    func getRedisStatus() -> EventLoopFuture<String> {
        return eventLoop.future("Ok")
    }

    func getPostgresStatus() -> EventLoopFuture<(String, String, HTTPResponseStatus)> {
        return eventLoop.future(("Ok", "Ok", HTTPResponseStatus.ok))
    }

    func getMongoDBStatus(host: String, port: String) -> EventLoopFuture<(String, HTTPResponseStatus)> {
        return eventLoop.future(("Ok", HTTPResponseStatus.ok))
    }

    func getRedisStatusAsync() async -> String {
        "Ok"
    }

    func getPostgresStatusAsync() async -> (String, String, HTTPResponseStatus) {
        return ("Ok", "Ok", HTTPResponseStatus.ok)
    }

    func getMongoDBStatusAsync(host: String, port: String) async -> (String, HTTPResponseStatus) {
        return ("Ok", HTTPResponseStatus.ok)
    }

    func applicationLaunchTime() { }

    func applicationUpTime() -> Double {
        Double()
    }

    func applicationLaunchDate() { }

    func applicationUpDate() -> String {
        ""
    }
}
