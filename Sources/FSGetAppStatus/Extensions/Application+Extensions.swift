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
//  Application+Extensions.swift
//
//
//  Created by Mykola Buhaiov on 09.03.2023.
//

import Vapor
@preconcurrency import MongoKitten

/// Extensions for storing and accessing custom application-level services and metadata.
extension Application {
    /// Storage key for the application status service.
    public struct GetAppStatusKey: StorageKey {
        /// The type of value stored for this key.
        public typealias Value = GetAppStatusServiceable
    }
    /// Provides access to the application status service.
    ///
    /// - Important: This must be configured before use, otherwise the app will crash.
    public var appStatus: GetAppStatusServiceable {
        get {
            guard let appStatus = storage[GetAppStatusKey.self] else {
                fatalError("GetAppStatus not setup.")
            }
            return appStatus
        }
        set {
            storage[GetAppStatusKey.self] = newValue
        }
    }
}

/// Extensions for tracking application uptime.
extension Application {
    /// Storage key for application uptime value.
    public struct ApplicationUpTimeKey: StorageKey {
        /// The type of value stored for this key.
        public typealias Value = TimeInterval
    }
    /// The total uptime of the application in seconds.
    ///
    /// Defaults to `0` if not set.
    public var applicationUpTime: TimeInterval {
        get {
            storage[ApplicationUpTimeKey.self] ?? .zero
        }
        set {
            storage[ApplicationUpTimeKey.self] = newValue
        }
    }
}

/// Extensions for tracking application start date.
extension Application {
    /// Storage key for application start date.
    public struct ApplicationUpDateKey: StorageKey {
        /// The type of value stored for this key.
        public typealias Value = String
    }
    /// The date when the application was started.
    ///
    /// Stored as a `String`. Defaults to `"0"` if not set.
    public var applicationUpDate: String {
        get {
            storage[ApplicationUpDateKey.self] ?? "0"
        }
        set {
            storage[ApplicationUpDateKey.self] = newValue
        }
    }
}

/// Extensions for MongoDB integration.
extension Application {
    /// Storage key for MongoDB database instance.
    private struct MongoDBStorageKey: StorageKey {
        /// The type of value stored for this key.
        typealias Value = MongoDatabase
    }
    /// Provides access to the configured MongoDB database.
    ///
    /// - Warning: This will crash if accessed before being set.
    public var mongoDB: MongoDatabase {
        get {
            guard let mongoDB = storage[MongoDBStorageKey.self] else {
                fatalError("MongoDB not setup.")
            }
            return mongoDB
        }
        set {
            storage[MongoDBStorageKey.self] = newValue
        }
    }
}

/// Extensions for shared date formatting utilities.
extension Application {
    /// A globally configured `DateFormatter` using the default date format.
    ///
    /// - Returns: A new instance of `DateFormatter` configured with `defaultDateFormat`.
    ///
    /// - Note: This creates a new instance every time it is accessed.
    var globalDateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = defaultDateFormat
        return formatter
    }
}
