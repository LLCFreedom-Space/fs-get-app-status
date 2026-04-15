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
import MongoKitten

extension Application {
    /// Storage key for GetAppStatus request context.
    public struct GetAppStatusKey: StorageKey {
        public typealias Value = GetAppStatusServiceable
    }
    /// GetAppStatus request context associated with the current request.
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
    
    /// Storage key for ApplicationUpTime request context.
    public struct ApplicationUpTimeKey: StorageKey {
        public typealias Value = TimeInterval
    }
    /// ApplicationUpTime request context associated with the current request.
    public var applicationUpTime: TimeInterval {
        get {
            storage[ApplicationUpTimeKey.self] ?? .zero
        }
        set {
            storage[ApplicationUpTimeKey.self] = newValue
        }
    }
    
    /// Storage key for ApplicationUpDate request context.
    public struct ApplicationUpDateKey: StorageKey {
        public typealias Value = String
    }
    /// ApplicationUpDate request context associated with the current request.
    public var applicationUpDate: String {
        get {
            storage[ApplicationUpDateKey.self] ?? "0"
        }
        set {
            storage[ApplicationUpDateKey.self] = newValue
        }
    }
    
    /// Storage key for MongoDB request context.
    private struct MongoDBStorageKey: StorageKey {
        typealias Value = MongoDatabase
    }
    /// MongoDB request context associated with the current request.
    public var appStatusMongoDatabase: MongoDatabase {
        get {
            guard let appStatusMongoDatabase = storage[MongoDBStorageKey.self] else {
                fatalError("MongoDB not setup.")
            }
            return appStatusMongoDatabase
        }
        set {
            storage[MongoDBStorageKey.self] = newValue
        }
    }
    
    /// Initializes MongoDB cluster with eager connection.
    /// - Parameter connectionString: MongoDB connection string.
    public func initializeMongoDatabase(connectionString: String) async throws {
        self.appStatusMongoDatabase = try await MongoDatabase.connect(to: connectionString)
    }

    /// Initializes MongoDB cluster with lazy connection.
    /// - Parameter connectionString: MongoDB connection string.
    public func initializeLazyMongoDatabase(connectionString: String) throws {
        self.appStatusMongoDatabase = try MongoDatabase.lazyConnect(to: connectionString)
    }
}

extension Application {
    /// ISO 8601-like date formatter (`yyyy-MM-dd'T'HH:mm:ss.SSS`).
    /// - Warning: `DateFormatter` is not thread-safe.
    /// - Note: Creates a new instance on each access.
    var globalDateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = defaultDateFormat
        return formatter
    }
}
