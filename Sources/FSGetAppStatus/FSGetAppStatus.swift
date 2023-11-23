//
//  FSGetAppStatus.swift
//
//
//  Created by Mykola Buhaiov on 09.03.2023.
//  Copyright © 2023 Freedom Space LLC
//  All rights reserved: http://opensource.org/licenses/MIT
//

import FluentPostgresDriver
import Fluent
import Vapor
import Redis

public struct FSGetAppStatus: FSGetAppStatusServiceable {
    /// Application
    public let app: Application

    /// Get status for `Redis` database
    /// - Returns: `String` - Connection status. Example - `Ok`
    public func getRedisStatus() -> EventLoopFuture<String> {
        try? app.boot()
        var statusConnect = String()
        return app.redis.ping()
            .flatMapThrowing { responseRedis in
                if responseRedis.description == "PONG" {
                    statusConnect = "Ok"
                }
            }
            .flatMapErrorThrowing { error in
                app.logger.error("No connect to Redis database. Reason: \(error)")
                statusConnect = "No connect to Redis database. Reason: \(error)"
            }
            .map {
                statusConnect
            }
    }

    /// Get status for `PostgresSQL` database
    /// - Returns: `(String, String, HTTPResponseStatus)` - Connection status, version of database,  connection status code. Example - `Ok`, `PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit`,  `.ok`
    public func getPostgresStatus() -> EventLoopFuture<(String, String, HTTPResponseStatus)> {
        var statusConnect = String()
        var versionDatabase = String()
        var statusCode = HTTPResponseStatus.badRequest
        let version = (app.db(.psql) as? PostgresDatabase)?.simpleQuery("SELECT version()")
        return version.unsafelyUnwrapped.flatMapThrowing { rows -> Void  in
            let row = rows.first?.makeRandomAccess()
            if let version = row?[data: "version"].string {
                versionDatabase = version
                statusConnect = "Ok"
                statusCode = .ok
            }
        }
        .flatMapErrorThrowing { error in
            app.logger.error("No connect to Postgres database. Reason: \(error)")
            versionDatabase = "Version undefined for database Postgres"
            statusConnect = "No connect to Postgres database. Reason: \(error)"
        }
        .map {
            (status: statusConnect,
             version: versionDatabase,
             code: statusCode)
        }
    }

    /// Get status for `MongoDB` database
    /// - Parameters:
    ///   - host: `String` of mongo database on which works. Example - `127.0.0.1`, `localhost`
    ///   - port: `String` of mongo database on which works. Example - `27017`
    /// - Returns: `(String, HTTPResponseStatus)` - Connection status,  connection status code. Example - `Ok`, `.ok`
    public func getMongoDBStatus(host: String, port: String) -> EventLoopFuture<(String, HTTPResponseStatus)> {
        var statusConnect = String()
        var statusCode = HTTPResponseStatus.notFound

        return app.client.get(URI(string: "http://\(host):\(port)/?compressors=disabled&gssapiServiceName=mongodb"))
            .flatMapThrowing { res in
                if res.status == .ok {
                    statusConnect = "Ok"
                    statusCode = .ok
                }
            }
            .flatMapErrorThrowing { error in
                app.logger.error("No connect to MongoDB database. Reason: \(error)")
                statusConnect = "No connect to MongoDB database. Reason: \(error)"
            }
            .map {
                (status: statusConnect, code: statusCode)
            }
    }

    /// Get status for `Redis` database
    /// - Returns: `String` - Connection status. Example - `Ok`
    public func getRedisStatusAsync() async -> String {
        try? app.boot()
        do {
            let responseRedis = try await app.redis.ping().get()
            if responseRedis.description == "PONG" {
                return "Ok"
            } else {
                return "No connect to Redis database. Response: \(responseRedis.description)"
            }
        } catch {
            app.logger.error("No connect to Redis database. Reason: \(error)")
            return "No connect to Redis database. Reason: \(error)"
        }
    }

    /// Get status for `PostgresSQL` database
    /// - Returns: `(String, String, HTTPResponseStatus)` - Connection status, version of database,  connection status code. Example - `Ok`, `PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit`,  `.ok`
    public func getPostgresStatusAsync() async -> (String, String, HTTPResponseStatus) {
        var statusConnect = String()
        var versionDatabase = String()
        var statusCode = HTTPResponseStatus.badRequest
        do {
            let rows = try await (app.db(.psql) as? PostgresDatabase)?.simpleQuery("SELECT version()").get()
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

    /// Get status for `MongoDB` database
    /// - Parameters:
    ///   - host: `String` of mongo database on which works. Example - `127.0.0.1`, `localhost`
    ///   - port: `String` of mongo database on which works. Example - `27017`
    /// - Returns: `(String, HTTPResponseStatus)` - Connection status,  connection status code. Example - `Ok`, `.ok`
    public func getMongoDBStatusAsync(host: String, port: String) async -> (String, HTTPResponseStatus) {
        var statusConnect = String()
        var statusCode = HTTPResponseStatus.notFound

        do {
            let res = try await app.client.get(URI(string: "http://\(host):\(port)/?compressors=disabled&gssapiServiceName=mongodb"))
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

    /// Recording the start time for an `Application`. Example - `78647017841958.0`
    public func applicationLaunchTime() {
        app.applicationUpTime = Double(DispatchTime.now().uptimeNanoseconds)
    }

    /// Working time for `Application`
    /// - Returns: `Double` time the service has been running since it was started. Example - `98647017841958.0`
    public func applicationUpTime() -> Double {
        let timeNow = Double(DispatchTime.now().uptimeNanoseconds)
        return timeNow - app.applicationUpTime
    }

    /// Recording the start full time for an `Application`. Example - `2022-05-08 16:36:16.034GMT+3`
    public func applicationLaunchDate() {
        let today = Date()
        let dateString = app.globalDateFormat.string(from: today)
        app.applicationUpDate = dateString
    }

    /// Working time for `Application` in Calendar Date components
    /// - Returns: `String` time the service has been running since it was started. Example - `year: 0 month: 0 day: 0 hour: 4 minute: 18 second: 2 isLeapMonth: false`
    public func applicationUpDate() -> String {
        guard let date = app.globalDateFormat.date(from: app.applicationUpDate) else {
            return "0"
        }
        let units = Array<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .timeZone])
        let components = Calendar.current.dateComponents(Set(units), from: date, to: Date())
        return "\(components)"
    }
}
