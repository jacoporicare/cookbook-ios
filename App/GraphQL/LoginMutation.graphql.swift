// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import API

public class LoginMutation: GraphQLMutation {
  public static let operationName: String = "Login"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation Login($username: String!, $password: String!) {
        login(username: $username, password: $password) {
          __typename
          token
        }
      }
      """
    ))

  public var username: String
  public var password: String

  public init(
    username: String,
    password: String
  ) {
    self.username = username
    self.password = password
  }

  public var __variables: Variables? { [
    "username": username,
    "password": password
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { API.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("login", Login.self, arguments: [
        "username": .variable("username"),
        "password": .variable("password")
      ]),
    ] }

    public var login: Login { __data["login"] }

    /// Login
    ///
    /// Parent Type: `AuthPayload`
    public struct Login: API.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { API.Objects.AuthPayload }
      public static var __selections: [Selection] { [
        .field("token", String.self),
      ] }

      public var token: String { __data["token"] }
    }
  }
}
