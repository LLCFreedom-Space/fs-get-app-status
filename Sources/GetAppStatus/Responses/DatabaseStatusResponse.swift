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
//  DatabaseStatusResponse.swift
//  fs-get-app-status
//
//  Created by Mykola Buhaiov on 23.04.2026.
//

import Vapor

/// Represents the connection status and metadata of a database service.
/// Use this structure to communicate the health, versioning, and availability
/// of specific database backends (such as Redis, PostgreSQL, or MongoDB)
/// within your API responses.
public struct DatabaseStatusResponse: Content {
    /// The descriptive status of the connection (e.g., "Ok", "Error", or "Maintenance").
    public var statusConnect: String
    /// The HTTP response status reflecting the current health of the service.
    public var statusCode: HTTPResponseStatus
    /// The version string of the database software.
    public var version: String

    /// Initializes a new database status response.
    /// - Parameters:
    ///   - statusConnect: A string describing the state. Defaults to an empty string.
    ///   - statusCode: The HTTP response status. Defaults to `.serviceUnavailable`.
    ///   - version: The database software version. Defaults to an empty string.
    public init(
        statusConnect: String = String(),
        statusCode: HTTPResponseStatus = .serviceUnavailable,
        version: String = String()
    ) {
        self.statusConnect = statusConnect
        self.statusCode = statusCode
        self.version = version
    }
}

extension DatabaseStatusResponse {
    /// Coding keys used to map properties to a `snake_case` JSON representation.
    public enum CodingKeys: String, CodingKey {
        case statusConnect = "status_connect"
        case statusCode = "status_code"
        case version
    }
}

extension DatabaseStatusResponse {
    /// An example instance of `DatabaseStatusResponse`.
    public static var example: DatabaseStatusResponse {
        DatabaseStatusResponse(
            statusConnect: "Ok",
            statusCode: .ok,
            version: "7.0.1"
        )
    }
}
