// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct RecipeDetails: API.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment RecipeDetails on Recipe { __typename id title imageUrl directions sideDish preparationTime servingCount tags ingredients { __typename id name isGroup amount amountUnit } cookedHistory { __typename id date user { __typename id displayName } } }"#
  }

  @_spi(Unsafe) public let __data: DataDict
  @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

  @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.Recipe }
  @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", API.ID.self),
    .field("title", String.self),
    .field("imageUrl", String?.self),
    .field("directions", String?.self),
    .field("sideDish", String?.self),
    .field("preparationTime", Int?.self),
    .field("servingCount", Int?.self),
    .field("tags", [String].self),
    .field("ingredients", [Ingredient].self),
    .field("cookedHistory", [CookedHistory].self),
  ] }
  @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
    RecipeDetails.self
  ] }

  public var id: API.ID { __data["id"] }
  public var title: String { __data["title"] }
  public var imageUrl: String? { __data["imageUrl"] }
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
  nonisolated public struct Ingredient: API.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.Ingredient }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", API.ID.self),
      .field("name", String.self),
      .field("isGroup", Bool.self),
      .field("amount", Double?.self),
      .field("amountUnit", String?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      RecipeDetails.Ingredient.self
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
  nonisolated public struct CookedHistory: API.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.RecipeCooked }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", API.ID.self),
      .field("date", API.Date.self),
      .field("user", User?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      RecipeDetails.CookedHistory.self
    ] }

    public var id: API.ID { __data["id"] }
    public var date: API.Date { __data["date"] }
    public var user: User? { __data["user"] }

    /// CookedHistory.User
    ///
    /// Parent Type: `User`
    nonisolated public struct User: API.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", API.ID.self),
        .field("displayName", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        RecipeDetails.CookedHistory.User.self
      ] }

      public var id: API.ID { __data["id"] }
      public var displayName: String { __data["displayName"] }
    }
  }
}
