//
//  Application+Extensions.swift
//  
//
//  Created by Mykola Buhaiov on 09.03.2023.
//  Copyright © 2023 Freedom Space LLC
//  All rights reserved: http://opensource.org/licenses/MIT
//

import Vapor
import MongoKitten

extension Application {
    private struct FSGetAppStatusKey: StorageKey {
        typealias Value = FSGetAppStatusServiceable
    }

    var appStatus: FSGetAppStatusServiceable? {
        get { storage[FSGetAppStatusKey.self] }
        set { storage[FSGetAppStatusKey.self] = newValue }
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
