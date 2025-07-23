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
            // docker run --name redis-test -p 6379:6379 -d redis
            app.redis.configuration = try .init(hostname: "localhost")
            let redisStatus = await app.appStatus.getRedisStatus()
            #expect(redisStatus.0 == "Ok")
        }
    }

    func testGetPostgresStatusAsync() async throws {
        // docker run --name psql-test -e POSTGRES_DB=test -e POSTGRES_USER=test -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
        try await withApp { app in
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
            let psqlStatus = await app.appStatus.getPostgresStatus()
            #expect(psqlStatus.0 == "Ok")
            #expect(psqlStatus.1 != "Version undefined")
            #expect(psqlStatus.2 == .ok)
        }
    }

    @Test("Get mongo db status")
    func getMongoDBStatus() async throws {
        try await withApp { app in
            let hosts: [ConnectionSettings.Host] = [.init(hostname: "localhost", port: 27017)]
            let settings = ConnectionSettings(
                authentication: .unauthenticated,
                authenticationSource: "test",
                hosts: hosts,
                targetDatabase: "test"
            )

            try await app.mongoDB = MongoDatabase.connect(to: settings)
            let mongoStatus = await app.appStatus.getMongoDBStatus(host: "localhost", port: "27017")
            #expect(mongoStatus.0 == "Ok")
            #expect(mongoStatus.1 == .ok)
        }
    }

    @Test("Application launch time")
    func applicationLaunchTime() async throws {
        try await withApp { app in
            app.appStatus.applicationLaunchTime()
            #expect(app.applicationUpTime.isZero == false)
        }
    }

    @Test("Get application up time")
    func getApplicationUpTime() async throws {
        try await withApp { app in
            app.applicationUpTime = Double(DispatchTime.now().uptimeNanoseconds)
            let defaultAppTime = app.appStatus.applicationUpTime()
            #expect(defaultAppTime.isZero == false)
        }
    }

    @Test("Get application up date")
    func getApplicationUpDate() async throws {
        try await withApp { app in
            app.applicationUpDate = "2022-05-08 12:27:50.654GMT+3"
            let fullDateApplicationTime = app.appStatus.applicationUpDate()
            #expect(fullDateApplicationTime.isEmpty == false)
        }
    }
}
