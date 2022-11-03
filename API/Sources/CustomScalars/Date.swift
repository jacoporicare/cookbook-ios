// @generated
// This file was automatically generated and can be edited to
// implement advanced custom scalar functionality.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

import ApolloAPI
import Foundation

/// Date custom scalar type
public typealias Date = Foundation.Date

private let dateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions.insert(.withFractionalSeconds)
    return formatter
}()

extension Foundation.Date: CustomScalarType {
    public init(_jsonValue value: JSONValue) throws {
        guard let dateString = value.base as? String,
              let date = dateFormatter.date(from: dateString)
        else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Foundation.Date.self)
        }

        self = date
    }

    public var _jsonValue: JSONValue {
        dateFormatter.string(from: self)
    }
}
