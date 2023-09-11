//
//  AppStatusResponse.swift
//  
//
//  Created by Mykola Buhaiov on 21.04.2023.
//  Copyright © 2023 Freedom Space LLC
//  All rights reserved: http://opensource.org/licenses/MIT
//

import Vapor

/// A generic `App` status data that can be sent in response.
public struct AppStatusResponse: Content {
    /// Representable the App is work
    public var appStatus: String = "Ok"
    /// Representable app uptime in TimeInterval
    public var systemUptime: TimeInterval
    /// Server active Processor Count
    public var activeProcessorCount: Int
    /// Server Operating System
    public var operatingSystemVersion: String
    /// Physical Memory in Server
    public var physicalMemory: Double
    /// Representable Redis connection status
    public var redisConnectionStatus: String?
    /// Representable Redis version
    public var redisVersion: String?
    /// Representable PostgreSQL connection status
    public var psqlConnectionStatus: String?
    /// Representable PostgreSQL version
    public var psqlVersion: String?
    /// Representable MongoDB connection status
    public var mongoConnectionStatus: String?
    /// Representable MongoDB version
    public var mongoVersion: String?
    public var appName: String?
    public var appVersion: String?

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
