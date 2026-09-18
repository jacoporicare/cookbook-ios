// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct RecipeCookedMutation: GraphQLMutation {
  public static let operationName: String = "RecipeCooked"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation RecipeCooked($id: ID!, $date: Date!) { recipeCooked(id: $id, date: $date) { __typename ...RecipeDetails } }"#,
      fragments: [RecipeDetails.self]
    ))

  public var id: ID
  public var date: Date

  public init(
    id: ID,
    date: Date
  ) {
    self.id = id
    self.date = date
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "id": id,
    "date": date
  ] }

  nonisolated public struct Data: API.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("recipeCooked", RecipeCooked.self, arguments: [
        "id": .variable("id"),
        "date": .variable("date")
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      RecipeCookedMutation.Data.self
    ] }

    public var recipeCooked: RecipeCooked { __data["recipeCooked"] }

    /// RecipeCooked
    ///
    /// Parent Type: `Recipe`
    nonisolated public struct RecipeCooked: API.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.Recipe }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(RecipeDetails.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        RecipeCookedMutation.Data.RecipeCooked.self,
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

      public struct Fragments: FragmentContainer {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        public var recipeDetails: RecipeDetails { _toFragment() }
      }

      public typealias Ingredient = RecipeDetails.Ingredient

      public typealias CookedHistory = RecipeDetails.CookedHistory
    }
  }
}
