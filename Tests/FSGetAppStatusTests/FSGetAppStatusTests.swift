//
//  FSGetAppStatusTests.swift
//
//
//  Created by Mykola Buhaiov on 09.03.2023.
//  Copyright © 2023 Freedom Space LLC
//  All rights reserved: http://opensource.org/licenses/MIT
//

@testable import FSGetAppStatus
import FluentPostgresDriver
import MongoKitten
import XCTest
import Vapor

final class FSGetAppStatusTests: XCTestCase {
    var app: Application!
    
    override func setUpWithError() throws {
        app = Application(.testing)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testGetRedisStatus() throws {
        // docker run --name redis-test -p 6379:6379 -d redis
        app.redis.configuration = try .init(hostname: "localhost")
        let redisStatus = try app.appStatus?.getRedisStatus().wait()
        XCTAssertEqual(redisStatus, "Ok")
    }
    
    func testGetPostgresStatus() throws {
        // docker run --name psql-test -e POSTGRES_DB=test -e POSTGRES_USER=test -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
        app.databases.use(
            .postgres(configuration:
                    .init(
                        hostname: "localhost",
                        port: 5432,
                        username: "test",
                        password: "password",
                        database: "test",
                        tls: .disable
                    )
            ),
            as: .psql
        )
        let psqlStatus = try app.appStatus?.getPostgresStatus().wait()
        XCTAssertEqual(psqlStatus?.0, "Ok")
        XCTAssertNotEqual(psqlStatus?.1, "Version undefined")
        XCTAssertEqual(psqlStatus?.2, .ok)
    }
    
    func testGetMongoDBStatus() async throws {
        let hosts: [ConnectionSettings.Host] = [.init(hostname: "localhost", port: 27017)]
        let settings = ConnectionSettings(
            authentication: .unauthenticated,
            authenticationSource: "test",
            hosts: hosts,
            targetDatabase: "test"
        )
        
        try await app.mongoDB = MongoDatabase.connect(to: settings)
        let mongoStatus = try await app.appStatus?.getMongoDBStatus(host: "localhost", port: "27017").get()
        XCTAssertEqual(mongoStatus?.0, "Ok")
        XCTAssertEqual(mongoStatus?.1, .ok)
    }

    func testGetRedisStatusAsync() async throws {
        // docker run --name redis-test -p 6379:6379 -d redis
        app.redis.configuration = try .init(hostname: "localhost")
        let redisStatus = await app.appStatus?.getRedisStatusAsync()
        XCTAssertEqual(redisStatus, "Ok")
    }

    func testGetPostgresStatusAsync() async throws {
        // docker run --name psql-test -e POSTGRES_DB=test -e POSTGRES_USER=test -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
        app.databases.use(
            .postgres(configuration:
                    .init(
                        hostname: "localhost",
                        port: 5432,
                        username: "test",
                        password: "password",
                        database: "test",
                        tls: .disable
                    )
            ),
            as: .psql
        )
        let psqlStatus = await app.appStatus?.getPostgresStatusAsync()
        XCTAssertEqual(psqlStatus?.0, "Ok")
        XCTAssertNotEqual(psqlStatus?.1, "Version undefined")
        XCTAssertEqual(psqlStatus?.2, .ok)
    }

    func testGetMongoDBStatusAsync() async throws {
        let hosts: [ConnectionSettings.Host] = [.init(hostname: "localhost", port: 27017)]
        let settings = ConnectionSettings(
            authentication: .unauthenticated,
            authenticationSource: "test",
            hosts: hosts,
            targetDatabase: "test"
        )
        
        try await app.mongoDB = MongoDatabase.connect(to: settings)
        let mongoStatus = await app.appStatus?.getMongoDBStatusAsync(host: "localhost", port: "27017")
        XCTAssertEqual(mongoStatus?.0, "Ok")
        XCTAssertEqual(mongoStatus?.1, .ok)
    }
    
    func testApplicationLaunchTime() throws {
        app.appStatus?.applicationLaunchTime()
        XCTAssertNotNil(app.applicationUpTime)
    }
    
    func testGetApplicationUpTime() throws {
        app.applicationUpTime = Double(DispatchTime.now().uptimeNanoseconds)
        let defaultAppTime = app.appStatus?.applicationUpTime()
        XCTAssertNotNil(defaultAppTime)
    }
    
    func testGetApplicationUpDate() throws {
        app.applicationUpDate = "2022-05-08 12:27:50.654GMT+3"
        let fullDateApplicationTime = app.appStatus?.applicationUpDate()
        XCTAssertNotNil(fullDateApplicationTime)
    }
}
