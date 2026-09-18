// @generated
// This file was automatically generated and can be edited to
// implement advanced custom scalar functionality.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

@_spi(Execution) @_spi(Internal) import ApolloAPI
import Foundation

/// Date custom scalar type
public typealias Date = Foundation.Date

// `ISO8601FormatStyle` is a Sendable value type, unlike `ISO8601DateFormatter`, which
// matters now that the generated package builds in Swift 6 language mode.
private let iso8601WithFractionalSeconds = Foundation.Date.ISO8601FormatStyle(includingFractionalSeconds: true)
private let iso8601 = Foundation.Date.ISO8601FormatStyle(includingFractionalSeconds: false)

extension Foundation.Date: @retroactive CustomScalarType {
    @_spi(Internal)
    public init(_jsonValue value: JSONValue) throws {
        guard let dateString = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Foundation.Date.self)
        }

        // The API sends fractional seconds; the plain form is accepted as a fallback so
        // a date without milliseconds does not fail to parse.
        if let date = try? iso8601WithFractionalSeconds.parse(dateString) {
            self = date
        } else if let date = try? iso8601.parse(dateString) {
            self = date
        } else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Foundation.Date.self)
        }
    }

    @_spi(Internal)
    public var _jsonValue: JSONValue {
        iso8601WithFractionalSeconds.format(self)
    }

    @_spi(Execution)
    public static var _asOutputType: Selection.Field.OutputType {
        .nonNull(.customScalar(Foundation.Date.self))
    }
}
