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
//  MockGetAppStatus.swift
//
//
//  Created by Mykola Buhaiov on 09.03.2023.
//

import Vapor
import GetAppStatus

public struct MockGetAppStatus: GetAppStatusServiceable {
    private var databaseStatusResponse: DatabaseStatusResponse
    
    public init(databaseStatusResponse: DatabaseStatusResponse = DatabaseStatusResponse.example) {
        self.databaseStatusResponse = databaseStatusResponse
    }
    
    public func getRedisStatus() async -> DatabaseStatusResponse {
        return databaseStatusResponse
    }

    public func getPostgresStatus() async -> DatabaseStatusResponse {
        return databaseStatusResponse
    }

    public func getMongoDBStatus() async -> DatabaseStatusResponse {
        return databaseStatusResponse
    }

    public func applicationLaunchTime() { }

    public func applicationUpTime() -> Double {
        Double()
    }

    public func applicationLaunchDate() { }

    public func applicationUpDate() -> String {
        ""
    }
}
