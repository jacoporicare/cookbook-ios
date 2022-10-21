// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import API

public class MeQuery: GraphQLQuery {
  public static let operationName: String = "Me"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query Me {
        me {
          __typename
          displayName
        }
      }
      """
    ))

  public init() {}

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { API.Objects.Query }
    public static var __selections: [Selection] { [
      .field("me", Me.self),
    ] }

    public var me: Me { __data["me"] }

    /// Me
    ///
    /// Parent Type: `User`
    public struct Me: API.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { API.Objects.User }
      public static var __selections: [Selection] { [
        .field("displayName", String.self),
      ] }

      public var displayName: String { __data["displayName"] }
    }
  }
}
