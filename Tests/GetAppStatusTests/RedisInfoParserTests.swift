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
//  RedisInfoParserTests.swift
//  fs-get-app-status
//
//  Created by Mykola Buhaiov on 15.04.2026.
//

@testable import GetAppStatus
import VaporTesting
import Testing

@Suite("Redis info parser tests", .serialized)
struct RedisInfoParserTests {
    @Test("Parse redis info with basic parsing")
    func basicParsing() {
        // Given
        let input =
        """
        # Server
        redis_version:7.4.1
        redis_mode:standalone
        uptime_in_seconds:2286
        """

        // When
        let result = input.parseRedisInfo()

        // Then
        #expect(result["redis_version"] == "7.4.1")
        #expect(result["redis_mode"] == "standalone")
        #expect(result["uptime_in_seconds"] == "2286")
    }

    @Test("Parse redis info with ignores comments and empty lines")
    func ignoresCommentsAndEmptyLines() {
        // Given
        let input = """
        # Server

        redis_version:7.4.1

        # Some comment
        redis_mode:standalone
        """

        // When
        let result = input.parseRedisInfo()

        // Then
        #expect(result.count == 2)
        #expect(result["# Server"] == nil)
        #expect(result[""] == nil)
    }

    @Test("Parse redis info with missing colon is ignored")
    func missingColonIsIgnored() {
        // Given
        let input = """
        redis_version:7.4.1
        invalidLineWithoutColon
        redis_mode:standalone
        """

        // When
        let result = input.parseRedisInfo()

        // Then
        #expect(result["redis_version"] == "7.4.1")
        #expect(result["redis_mode"] == "standalone")
        #expect(result.count == 2)
    }

    @Test("Parse redis info with over writes duplicate keys")
    func overwritesDuplicateKeys() {
        // Given
        let input =
        """
        redis_version:7.4.1
        redis_version:8.0.0
        """

        // When
        let result = input.parseRedisInfo()

        // Then
        #expect(result["redis_version"] == "8.0.0")
    }
}
