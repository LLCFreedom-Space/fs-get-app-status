//
//  FSGetAppStatusServiceable.swift
//
//
//  Created by Mykola Buhaiov on 23.11.2023.
//  Copyright © 2023 Freedom Space LLC
//  All rights reserved: http://opensource.org/licenses/MIT
//

import FluentPostgresDriver
import Fluent
import Vapor
import Redis

public protocol FSGetAppStatusServiceable {
    func getRedisStatus() -> EventLoopFuture<(String, HTTPResponseStatus)>

    func getPostgresStatus() -> EventLoopFuture<(String, String, HTTPResponseStatus)>

    func getMongoDBStatus(host: String, port: String) -> EventLoopFuture<(String, HTTPResponseStatus)>

    func getRedisStatusAsync() async -> (String, HTTPResponseStatus)

    func getPostgresStatusAsync() async -> (String, String, HTTPResponseStatus)

    func getMongoDBStatusAsync(host: String, port: String) async -> (String, HTTPResponseStatus)

    func applicationLaunchTime()

    func applicationUpTime() -> Double

    func applicationLaunchDate()

    func applicationUpDate() -> String
}
