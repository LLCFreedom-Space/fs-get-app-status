// FS App Configuration
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

extension Application {
    public struct GetAppStatusKey: StorageKey {
        public typealias Value = GetAppStatusServiceable
    }

    public var appStatus: GetAppStatusServiceable {
        get {
            guard let appStatus = storage[GetAppStatusKey.self] else {
                fatalError("GetAppStatus not setup.")
            }
            return appStatus
        }
        set { storage[GetAppStatusKey.self] = newValue }
    }
}

extension Application {
    public struct ApplicationUpTimeKey: StorageKey {
        
        public typealias Value = TimeInterval
    }
    
    public var applicationUpTime: TimeInterval {
        get { storage[ApplicationUpTimeKey.self] ?? 0 }
        set { storage[ApplicationUpTimeKey.self] = newValue }
    }
}

extension Application {
    public struct ApplicationUpDateKey: StorageKey {

        public typealias Value = String
    }
    
    public var applicationUpDate: String {
        get { storage[ApplicationUpDateKey.self] ?? "0" }
        set { storage[ApplicationUpDateKey.self] = newValue }
    }
}

extension Application {
    var globalDateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = defaultDateFormat
        return formatter
    }
}

extension Application {
    private struct MongoDBStorageKey: StorageKey {
    
        typealias Value = MongoDatabase
    }
    
    public var mongoDB: MongoDatabase {
        get { storage[MongoDBStorageKey.self]! }
        set { storage[MongoDBStorageKey.self] = newValue }
    }
}
