// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct UpdateRecipeMutation: GraphQLMutation {
  public static let operationName: String = "UpdateRecipe"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateRecipe($id: ID!, $recipe: RecipeInput!, $imageId: ID) { updateRecipe(id: $id, recipe: $recipe, imageId: $imageId) { __typename ...RecipeDetails } }"#,
      fragments: [RecipeDetails.self]
    ))

  public var id: ID
  public var recipe: RecipeInput
  public var imageId: GraphQLNullable<ID>

  public init(
    id: ID,
    recipe: RecipeInput,
    imageId: GraphQLNullable<ID>
  ) {
    self.id = id
    self.recipe = recipe
    self.imageId = imageId
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "id": id,
    "recipe": recipe,
    "imageId": imageId
  ] }

  nonisolated public struct Data: API.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("updateRecipe", UpdateRecipe.self, arguments: [
        "id": .variable("id"),
        "recipe": .variable("recipe"),
        "imageId": .variable("imageId")
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UpdateRecipeMutation.Data.self
    ] }

    public var updateRecipe: UpdateRecipe { __data["updateRecipe"] }

    /// UpdateRecipe
    ///
    /// Parent Type: `Recipe`
    nonisolated public struct UpdateRecipe: API.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.Recipe }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(RecipeDetails.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UpdateRecipeMutation.Data.UpdateRecipe.self,
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
