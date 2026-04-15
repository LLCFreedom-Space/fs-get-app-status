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
    public func getRedisStatus() async -> (String, HTTPResponseStatus) {
        try? await app.asyncBoot()
        let statusCode = HTTPResponseStatus.serviceUnavailable
        do {
            let responseRedis = try await app.redis.ping().get()
            if responseRedis.description == "PONG" {
                return ("Ok", .ok)
            } else {
                return ("No connect to Redis database. Response: \(responseRedis.description)", statusCode)
            }
        } catch {
            app.logger.error("No connect to Redis database. Reason: \(error)")
            return ("No connect to Redis database. Reason: \(error)", statusCode)
        }
    }

    /// Checks PostgreSQL connectivity and retrieves version information.
    /// - Returns: A tuple containing connection status, database version, and HTTP status.
    public func getPostgresStatus() async -> (String, String, HTTPResponseStatus) {
        var statusConnect = String()
        var versionDatabase = String()
        var statusCode = HTTPResponseStatus.badRequest
        do {
            let rows = try await (app.db(.psql) as? PostgresDatabase)?
                .simpleQuery("SELECT version()")
                .get()

            let row = rows?.first?.makeRandomAccess()
            if let version = row?[data: "version"].string {
                versionDatabase = version
                statusConnect = "Ok"
                statusCode = .ok
            } else {
                app.logger.error("No connect to Postgres database. Response: \(String(describing: row))")
                versionDatabase = "Version undefined for database Postgres."
                statusConnect = "No connect to Postgres database."
            }
        } catch {
            app.logger.error("No connect to Postgres database. Reason: \(error)")
            versionDatabase = "Version undefined for database Postgres."
            statusConnect = "No connect to Postgres database. Reason: \(error)"
        }
        return (status: statusConnect, version: versionDatabase, code: statusCode)
    } 

    /// Checks MongoDB connectivity via HTTP endpoint.
    /// - Parameters:
    ///   - host: The MongoDB host.
    ///   - port: The MongoDB port.
    /// - Returns: A tuple containing connection status and HTTP status code.
    public func getMongoDBStatus(host: String, port: String) async -> (String, HTTPResponseStatus) {
        var statusConnect = String()
        var statusCode = HTTPResponseStatus.notFound
        do {
            let res = try await app.client.get(
                URI(string: "http://\(host):\(port)/?compressors=disabled&gssapiServiceName=mongodb")
            )
            if res.status == .ok {
                statusConnect = "Ok"
                statusCode = .ok
            }
        } catch {
            app.logger.error("No connect to MongoDB database. Reason: \(error)")
            statusConnect = "No connect to MongoDB database. Reason: \(error)"
        }
        return (status: statusConnect, code: statusCode)
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
