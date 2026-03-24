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
//  GetAppStatusServiceable.swift
//
//
//  Created by Mykola Buhaiov on 09.03.2023.
//

import Vapor

/// A service interface for retrieving application health status and runtime metrics.
///
/// Types conforming to this protocol provide:
/// - Connectivity checks for external services (Redis, PostgreSQL, MongoDB)
/// - Application uptime tracking
/// - Launch time and human-readable uptime representation
///
/// ## Overview
/// Use this protocol to abstract health-check logic and allow different
/// implementations (e.g., for testing, mocking, or different environments).
///
/// ## Topics
/// ### Service Checks
/// - ``getRedisStatus()``
/// - ``getPostgresStatus()``
/// - ``getMongoDBStatus(host:port:)``
///
/// ### Runtime Metrics
/// - ``applicationLaunchTime()``
/// - ``applicationUpTime()``
/// - ``applicationLaunchDate()``
/// - ``applicationUpDate()``
public protocol GetAppStatusServiceable: Sendable {
    /// Checks the connection status of the Redis service.
    ///
    /// - Returns: A tuple containing:
    ///   - `String`: Human-readable connection status (e.g., `"Ok"` or error description)
    ///   - `HTTPResponseStatus`: HTTP status representing the result
    ///
    /// ## Discussion
    /// Implementations should perform a lightweight operation (such as `PING`)
    /// to verify Redis availability.
    func getRedisStatus() async -> (String, HTTPResponseStatus)

    /// Checks the connection status of PostgreSQL and retrieves its version.
    ///
    /// - Returns: A tuple containing:
    ///   - `String`: Connection status (e.g., `"Ok"` or error message)
    ///   - `String`: Database version string
    ///   - `HTTPResponseStatus`: HTTP status representing the result
    ///
    /// ## Discussion
    /// Implementations typically execute a simple query like `SELECT version()`
    /// to validate connectivity and fetch server information.
    func getPostgresStatus() async -> (String, String, HTTPResponseStatus)

    /// Checks the connection status of the MongoDB service.
    ///
    /// - Parameters:
    ///   - host: The MongoDB host (e.g., `"localhost"`, `"127.0.0.1"`)
    ///   - port: The MongoDB port (e.g., `"27017"`)
    ///
    /// - Returns: A tuple containing:
    ///   - `String`: Connection status (e.g., `"Ok"` or error message)
    ///   - `HTTPResponseStatus`: HTTP status representing the result
    ///
    /// ## Discussion
    /// Implementations may use an HTTP check or a database driver ping
    /// depending on the environment and configuration.
    func getMongoDBStatus(host: String, port: String) async -> (String, HTTPResponseStatus)

    /// Records the application launch time.
    ///
    /// ## Discussion
    /// This method should store a reference timestamp (preferably monotonic,
    /// such as system uptime) used later to compute total runtime.
    func applicationLaunchTime()

    /// Returns the application uptime.
    ///
    /// - Returns: The elapsed time since application launch.
    ///
    /// ## Discussion
    /// Implementations should calculate uptime based on the value recorded
    /// by ``applicationLaunchTime()``.
    func applicationUpTime() -> Double

    /// Records the application launch date.
    ///
    /// ## Discussion
    /// This method should store a formatted date representing when the
    /// application started, typically used for human-readable reporting.
    func applicationLaunchDate()

    /// Returns the application uptime as a formatted string.
    ///
    /// - Returns: A human-readable representation of elapsed time since launch.
    ///
    /// ## Discussion
    /// Implementations typically convert stored launch date into
    /// `DateComponents` (years, months, days, etc.).
    func applicationUpDate() -> String
}
