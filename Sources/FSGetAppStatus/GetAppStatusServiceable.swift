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

import FluentPostgresDriver
import Fluent
import Vapor
import Redis

public protocol GetAppStatusServiceable: Sendable {
    func getRedisStatus() async -> (String, HTTPResponseStatus)

    func getPostgresStatus() async -> (String, String, HTTPResponseStatus)

    func getMongoDBStatus(host: String, port: String) async -> (String, HTTPResponseStatus)

    func applicationLaunchTime()

    func applicationUpTime() -> Double

    func applicationLaunchDate()

    func applicationUpDate() -> String
}
