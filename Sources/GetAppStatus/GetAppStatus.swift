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
//  GetAppStatus.swift
//
//
//  Created by Mykola Buhaiov on 09.03.2023.
//

import FluentPostgresDriver
import Fluent
import Vapor
import Redis

/// Default implementation of `GetAppStatusServiceable`.
///
/// This service provides application health diagnostics, including connectivity
/// checks for external services and runtime metadata such as uptime and launch date.
public struct GetAppStatus: GetAppStatusServiceable {
    /// The Vapor `Application` instance.
    public let app: Application
    /// Creates a new status service.
    /// - Parameter app: The Vapor application instance.
    public init(app: Application) {
        self.app = app
    }

    /// Checks Redis connectivity.
    /// - Returns: A tuple containing a human-readable status and HTTP status code.
    public func getRedisStatus() async -> DatabaseStatusResponse {
        try? await app.asyncBoot()
        var databaseStatusResponse = DatabaseStatusResponse()
        do {
            let buffer = ByteBufferAllocator().buffer(string: "server")
            let response = try await app.redis.send(
                command: "INFO",
                with: [RESPValue.bulkString(buffer)]
            )
            if let string = response.string {
                let dict = string.parseRedisInfo()
                if let version = dict["redis_version"] {
                    databaseStatusResponse.version = version
                } else {
                    app.logger.error("No version in response: \(response).")
                    databaseStatusResponse.version = "Version undefined for database Redis."
                }
                databaseStatusResponse.statusConnect = "Ok"
                databaseStatusResponse.statusCode = .ok
            } else {
                app.logger.error("No connect to Redis database. Response: \(response).")
                databaseStatusResponse.version = "Version undefined for database Redis."
                databaseStatusResponse.statusConnect = "No connect to Redis database."
            }
        } catch {
            app.logger.error("No connect to Redis database. Reason: \(error).")
            databaseStatusResponse.version = "Version undefined for database Redis."
            databaseStatusResponse.statusConnect = "No connect to Redis database. Reason: \(error)."
        }
        return databaseStatusResponse
    }

    /// Checks PostgreSQL connectivity and retrieves version information.
    /// - Returns: A tuple containing connection status, database version, and HTTP status.
    public func getPostgresStatus() async -> DatabaseStatusResponse {
        var databaseStatusResponse = DatabaseStatusResponse()
        do {
            let rows = try await (app.db(.psql) as? PostgresDatabase)?
                .simpleQuery("SELECT version()")
                .get()

            let row = rows?.first?.makeRandomAccess()
            if let version = row?[data: "version"].string {
                databaseStatusResponse.version = version
                databaseStatusResponse.statusConnect = "Ok"
                databaseStatusResponse.statusCode = .ok
            } else {
                app.logger.error("No connect to Postgres database. Response: \(String(describing: row)).")
                databaseStatusResponse.version = "Version undefined for database Postgres."
                databaseStatusResponse.statusConnect = "No connect to Postgres database."
            }
        } catch {
            app.logger.error("No connect to Postgres database. Reason: \(error)")
            databaseStatusResponse.version = "Version undefined for database Postgres."
            databaseStatusResponse.statusConnect = "No connect to Postgres database. Reason: \(error)."
        }
        return databaseStatusResponse
    }

    /// Checks MongoDB connectivity via HTTP endpoint.
    /// - Returns: A tuple containing connection status and HTTP status code.
    public func getMongoDBStatus() async -> DatabaseStatusResponse {
        var databaseStatusResponse = DatabaseStatusResponse()
        do {
            let response = try await app.appStatusMongoDatabase.buildInfo()
            if response.ok == 1 {
                databaseStatusResponse.version = response.version
                databaseStatusResponse.statusConnect = "Ok"
                databaseStatusResponse.statusCode = .ok
            } else {
                app.logger.error("No connect to Mongo database. Response: \(response).")
                databaseStatusResponse.version = "Version undefined for database Mongo."
                databaseStatusResponse.statusConnect = "No connect to Mongo database."
            }
        } catch {
            app.logger.error("No connect to Mongo database. Reason: \(error).")
            databaseStatusResponse.version = "Version undefined for database Mongo."
            databaseStatusResponse.statusConnect = "No connect to Mongo database. Reason: \(error)."
        }
        return databaseStatusResponse
    }

    /// Records the application launch time.
    public func applicationLaunchTime() {
        app.applicationUpTime = Double(DispatchTime.now().uptimeNanoseconds)
    }

    /// Returns the application uptime.
    /// - Returns: The elapsed time in nanoseconds since application launch.
    public func applicationUpTime() -> Double {
        let timeNow = Double(DispatchTime.now().uptimeNanoseconds)
        return timeNow - app.applicationUpTime
    }

    /// Records the application launch date.
    public func applicationLaunchDate() {
        let today = Date()
        let dateString = app.globalDateFormat.string(from: today)
        app.applicationUpDate = dateString
    }

    /// Returns the application uptime as calendar components.
    /// - Returns: A string describing elapsed time.
    public func applicationUpDate() -> String {
        guard let date = app.globalDateFormat.date(from: app.applicationUpDate) else {
            return "0"
        }
        let units: [Calendar.Component] = [
            .year, .month, .day, .hour, .minute, .second, .timeZone
        ]
        let components = Calendar.current.dateComponents(Set(units), from: date, to: Date())
        return "\(components)"
    }
}
