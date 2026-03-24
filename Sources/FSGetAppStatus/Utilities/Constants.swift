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
//  Constants.swift
//
//
//  Created by Mykola Buhaiov on 09.03.2023.
//

import Vapor

/// The default date format used across the application.
///
/// This format follows the pattern:
/// `yyyy-MM-dd HH:mm:ss.SSSz`
///
/// - Components:
///   - `yyyy`: Four-digit year
///   - `MM`: Two-digit month
///   - `dd`: Two-digit day
///   - `HH`: Hour in 24-hour format
///   - `mm`: Minutes
///   - `ss`: Seconds
///   - `SSS`: Milliseconds
///   - `z`: Time zone abbreviation
///
/// - Example: `2026-03-24 18:45:12.123+0200`
public let defaultDateFormat = "yyyy-MM-dd HH:mm:ss.SSSz"
