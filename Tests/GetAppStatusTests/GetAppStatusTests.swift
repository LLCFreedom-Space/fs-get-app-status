// FS Get App Status
// Copyright (C) 2025  FREEDOM SPACE, LLC

//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

//
//  GetAppStatusTests.swift
//
//
//  Created by Mykola Buhaiov on 09.03.2023.
//

@testable import GetAppStatus
import FluentPostgresDriver
import MongoKitten
import VaporTesting
import Testing

@Suite("Get app status tests", .serialized)
struct GetAppStatusTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await test(app)
        } catch {
            throw error
        }
        try await app.asyncShutdown()
    }

    @Test("Get redis status")
    func getRedisStatus() async throws {
        try await withApp { app in
            app.appStatus = MockGetAppStatus()
            // docker run --name redis-test -p 6379:6379 -d redis
            //            app.appStatus = GetAppStatus(app: app)
            //            app.redis.configuration = try .init(hostname: "localhost")
            let (statusConnect, version, code) = await app.appStatus.getRedisStatus()
            #expect(statusConnect == "Ok")
            #expect(version != "Version undefined")
            #expect(code == .ok)
        }
    }

    func testGetPostgresStatusAsync() async throws {
        // docker run --name psql-test -e POSTGRES_DB=test -e POSTGRES_USER=test -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
        try await withApp { app in
            app.appStatus = MockGetAppStatus()
            //            app.appStatus = GetAppStatus(app: app)
            //            app.databases.use(
            //                .postgres(configuration:
            //                        .init(
            //                            hostname: "localhost",
            //                            port: 5432,
            //                            username: "test",
            //                            password: "password",
            //                            database: "test",
            //                            tls: .disable
            //                        )
            //                ),
            //                as: .psql
            //            )
            let (statusConnect, version, code) = await app.appStatus.getPostgresStatus()
            #expect(statusConnect == "Ok")
            #expect(version != "Version undefined")
            #expect(code == .ok)
        }
    }

    @Test("Get mongo db status")
    func getMongoDBStatus() async throws {
        // docker run --name test -p 27017:27017 -d mongo
        try await withApp { app in
//            app.appStatus = GetAppStatus(app: app)
            app.appStatus = MockGetAppStatus()
            let connectionString = "mongodb://localhost:27017/test"
            try app.initializeLazyMongoDatabase(connectionString: connectionString)
            let (statusConnect, version, code) = await app.appStatus.getMongoDBStatus()
            #expect(statusConnect == "Ok")
            #expect(version != "Version undefined")
            #expect(code == .ok)
        }
    }

    @Test("Application launch time")
    func applicationLaunchTime() async throws {
        try await withApp { app in
            app.appStatus = GetAppStatus(app: app)
            app.appStatus.applicationLaunchTime()
            #expect(app.applicationUpTime.isZero == false)
        }
    }

    @Test("Get application up time")
    func getApplicationUpTime() async throws {
        try await withApp { app in
            app.appStatus = GetAppStatus(app: app)
            app.applicationUpTime = Double(DispatchTime.now().uptimeNanoseconds)
            let defaultAppTime = app.appStatus.applicationUpTime()
            #expect(defaultAppTime.isZero == false)
        }
    }

    @Test("Get application up date")
    func getApplicationUpDate() async throws {
        try await withApp { app in
            app.appStatus = GetAppStatus(app: app)
            app.applicationUpDate = "2022-05-08 12:27:50.654GMT+3"
            let fullDateApplicationTime = app.appStatus.applicationUpDate()
            #expect(fullDateApplicationTime.isEmpty == false)
        }
    }
}
