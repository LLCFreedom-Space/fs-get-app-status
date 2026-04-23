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
public protocol GetAppStatusServiceable: Sendable {
    /// Checks the connection status of the Redis service.
    /// - Returns: A `DatabaseStatusResponse` containing the connection status
    func getRedisStatus() async -> DatabaseStatusResponse

    /// Checks the connection status of PostgreSQL and retrieves its version.
    /// - Returns: A `DatabaseStatusResponse` containing the connection status
    func getPostgresStatus() async -> DatabaseStatusResponse

    /// Checks the connection status of the MongoDB service.
    /// - Returns: A `DatabaseStatusResponse` containing the connection status
    func getMongoDBStatus() async -> DatabaseStatusResponse

    /// Records the application launch time.
    func applicationLaunchTime()

    /// Returns the application uptime.
    /// - Returns: The elapsed time since application launch.
    func applicationUpTime() -> Double

    /// Records the application launch date.
    func applicationLaunchDate()

    /// Returns the application uptime as a formatted string.
    /// - Returns: A human-readable representation of elapsed time since launch.
    func applicationUpDate() -> String
}
