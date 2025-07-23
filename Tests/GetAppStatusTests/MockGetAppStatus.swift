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
@testable import GetAppStatus

public struct MockGetAppStatus: GetAppStatusServiceable {
    public var eventLoop: EventLoop

    public init(eventLoop: EventLoop) {
        self.eventLoop = eventLoop
    }

    public func getRedisStatus() async -> (String, HTTPResponseStatus) {
        ("Ok", .ok)
    }

    public func getPostgresStatus() async -> (String, String, HTTPResponseStatus) {
        return ("Ok", "Ok", HTTPResponseStatus.ok)
    }

    public func getMongoDBStatus(host: String, port: String) async -> (String, HTTPResponseStatus) {
        return ("Ok", HTTPResponseStatus.ok)
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
