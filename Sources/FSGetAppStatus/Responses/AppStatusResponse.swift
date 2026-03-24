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
//  AppStatusResponse.swift
//
//
//  Created by Mykola Buhaiov on 09.03.2023.
//

import Vapor

/// A generic application status response that can be returned from a health check endpoint.
///
/// This model aggregates system-level and service-level information such as uptime,
/// hardware metrics, and connectivity status for external dependencies like Redis,
/// PostgreSQL, and MongoDB.
public struct AppStatusResponse: Content {
    /// Indicates the overall application status (e.g., `"Ok"`, `"Degraded"`, `"Down"`).
    public var appStatus: String = "Ok"
    /// The total system uptime in seconds.
    public var systemUptime: TimeInterval
    /// The number of active CPU cores available to the application.
    public var activeProcessorCount: Int
    /// The operating system version running the application.
    public var operatingSystemVersion: String
    /// The total physical memory available on the server (in GB).
    public var physicalMemory: Double
    /// The current Redis connection status (e.g., `"Ok"` or `"Unavailable"`).
    public var redisConnectionStatus: String?
    /// The Redis server version.
    public var redisVersion: String?
    /// The current PostgreSQL connection status (e.g., `"Ok"` or `"Unavailable"`).
    public var psqlConnectionStatus: String?
    /// The PostgreSQL server version.
    public var psqlVersion: String?
    /// The current MongoDB connection status (e.g., `"Ok"` or `"Unavailable"`).
    public var mongoConnectionStatus: String?
    /// The MongoDB server version.
    public var mongoVersion: String?
    /// The name of the application.
    public var appName: String?
    /// The current version of the application.
    public var appVersion: String?

    /// Creates a new `AppStatusResponse`.
    ///
    /// - Parameters:
    ///   - appStatus: The overall application status. Defaults to `"Ok"`.
    ///   - systemUptime: The system uptime in seconds.
    ///   - activeProcessorCount: The number of active CPU cores.
    ///   - operatingSystemVersion: The OS version string.
    ///   - physicalMemory: The total physical memory (in GB).
    ///   - redisConnectionStatus: Redis connection status.
    ///   - psqlConnectionStatus: PostgreSQL connection status.
    ///   - mongoConnectionStatus: MongoDB connection status.
    ///   - redisVersion: Redis version string.
    ///   - psqlVersion: PostgreSQL version string.
    ///   - mongoVersion: MongoDB version string.
    ///   - appName: Application name.
    ///   - appVersion: Application version.
    public init(
        appStatus: String = "Ok",
        systemUptime: TimeInterval,
        activeProcessorCount: Int,
        operatingSystemVersion: String,
        physicalMemory: Double,
        redisConnectionStatus: String? = nil,
        psqlConnectionStatus: String? = nil,
        mongoConnectionStatus: String? = nil,
        redisVersion: String? = nil,
        psqlVersion: String? = nil,
        mongoVersion: String? = nil,
        appName: String? = nil,
        appVersion: String? = nil
    ) {
        self.appStatus = appStatus
        self.systemUptime = systemUptime
        self.activeProcessorCount = activeProcessorCount
        self.operatingSystemVersion = operatingSystemVersion
        self.physicalMemory = physicalMemory
        self.redisConnectionStatus = redisConnectionStatus
        self.psqlConnectionStatus = psqlConnectionStatus
        self.mongoConnectionStatus = mongoConnectionStatus
        self.redisVersion = redisVersion
        self.psqlVersion = psqlVersion
        self.mongoVersion = mongoVersion
        self.appName = appName
        self.appVersion = appVersion
    }

    /// An example instance of `AppStatusResponse` for testing or documentation purposes.
    public static var example: AppStatusResponse {
        AppStatusResponse(
            appStatus: "Ok",
            systemUptime: 123456,
            activeProcessorCount: 12,
            operatingSystemVersion: "12.1",
            physicalMemory: 12,
            redisConnectionStatus: "Ok",
            psqlConnectionStatus: "Ok",
            mongoConnectionStatus: "Ok",
            redisVersion: "12",
            psqlVersion: "12.9",
            mongoVersion: "20.2",
            appName: "Name of application",
            appVersion: "1.1.1"
        )
    }

    /// Coding keys used to map properties to snake_case JSON representation.
    public enum CodingKeys: String, CodingKey {
        case appStatus = "app_status"
        case systemUptime = "system_uptime"
        case activeProcessorCount = "active_processor_count"
        case operatingSystemVersion = "operating_system_version"
        case physicalMemory = "physical_memory"
        case redisConnectionStatus = "redis_connection_status"
        case psqlConnectionStatus = "psql_connection_status"
        case mongoConnectionStatus = "mongo_connection_status"
        case redisVersion = "redis_version"
        case psqlVersion = "psql_version"
        case mongoVersion = "mongo_version"
        case appName = "app_name"
        case appVersion = "app_version"
    }
}
