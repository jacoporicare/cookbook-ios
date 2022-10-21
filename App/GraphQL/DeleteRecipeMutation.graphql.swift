// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import API

public class DeleteRecipeMutation: GraphQLMutation {
  public static let operationName: String = "DeleteRecipe"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation DeleteRecipe($id: ID!) {
        deleteRecipe(id: $id)
      }
      """
    ))

  public var id: API.ID

  public init(id: API.ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { API.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("deleteRecipe", Bool.self, arguments: ["id": .variable("id")]),
    ] }

    public var deleteRecipe: Bool { __data["deleteRecipe"] }
  }
}
