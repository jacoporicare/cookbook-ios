// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import API

public struct RecipeDetails: API.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString { """
    fragment RecipeDetails on Recipe {
      __typename
      id
      title
      gridImageUrl: imageUrl(size: {width: 640, height: 640}, format: WEBP)
      listImageUrl: imageUrl(size: {width: 240, height: 180}, format: WEBP)
      fullImageUrl: imageUrl(size: {width: 1280, height: 960}, format: WEBP)
      directions
      sideDish
      preparationTime
      servingCount
      tags
      ingredients {
        __typename
        id
        name
        isGroup
        amount
        amountUnit
      }
      cookedHistory {
        __typename
        id
        date
        user {
          __typename
          id
          displayName
        }
      }
    }
    """ }

  public let __data: DataDict
  public init(data: DataDict) { __data = data }

  public static var __parentType: ParentType { API.Objects.Recipe }
  public static var __selections: [Selection] { [
    .field("id", API.ID.self),
    .field("title", String.self),
    .field("imageUrl", alias: "gridImageUrl", String?.self, arguments: [
      "size": [
        "width": 640,
        "height": 640
      ],
      "format": "WEBP"
    ]),
    .field("imageUrl", alias: "listImageUrl", String?.self, arguments: [
      "size": [
        "width": 240,
        "height": 180
      ],
      "format": "WEBP"
    ]),
    .field("imageUrl", alias: "fullImageUrl", String?.self, arguments: [
      "size": [
        "width": 1280,
        "height": 960
      ],
      "format": "WEBP"
    ]),
    .field("directions", String?.self),
    .field("sideDish", String?.self),
    .field("preparationTime", Int?.self),
    .field("servingCount", Int?.self),
    .field("tags", [String].self),
    .field("ingredients", [Ingredient].self),
    .field("cookedHistory", [CookedHistory].self),
  ] }

  public var id: API.ID { __data["id"] }
  public var title: String { __data["title"] }
  public var gridImageUrl: String? { __data["gridImageUrl"] }
  public var listImageUrl: String? { __data["listImageUrl"] }
  public var fullImageUrl: String? { __data["fullImageUrl"] }
  public var directions: String? { __data["directions"] }
  public var sideDish: String? { __data["sideDish"] }
  public var preparationTime: Int? { __data["preparationTime"] }
  public var servingCount: Int? { __data["servingCount"] }
  public var tags: [String] { __data["tags"] }
  public var ingredients: [Ingredient] { __data["ingredients"] }
  public var cookedHistory: [CookedHistory] { __data["cookedHistory"] }

  /// Ingredient
  ///
  /// Parent Type: `Ingredient`
  public struct Ingredient: API.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { API.Objects.Ingredient }
    public static var __selections: [Selection] { [
      .field("id", API.ID.self),
      .field("name", String.self),
      .field("isGroup", Bool.self),
      .field("amount", Double?.self),
      .field("amountUnit", String?.self),
    ] }

    public var id: API.ID { __data["id"] }
    public var name: String { __data["name"] }
    public var isGroup: Bool { __data["isGroup"] }
    public var amount: Double? { __data["amount"] }
    public var amountUnit: String? { __data["amountUnit"] }
  }

  /// CookedHistory
  ///
  /// Parent Type: `RecipeCooked`
  public struct CookedHistory: API.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { API.Objects.RecipeCooked }
    public static var __selections: [Selection] { [
      .field("id", API.ID.self),
      .field("date", API.Date.self),
      .field("user", User.self),
    ] }

    public var id: API.ID { __data["id"] }
    public var date: API.Date { __data["date"] }
    public var user: User { __data["user"] }

    /// CookedHistory.User
    ///
    /// Parent Type: `User`
    public struct User: API.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { API.Objects.User }
      public static var __selections: [Selection] { [
        .field("id", API.ID.self),
        .field("displayName", String.self),
      ] }

      public var id: API.ID { __data["id"] }
      public var displayName: String { __data["displayName"] }
    }
  }
}
