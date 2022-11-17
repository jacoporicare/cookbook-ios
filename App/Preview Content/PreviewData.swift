//
//  PreviewData.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import API
import Apollo
import ApolloAPI
import Foundation

private let recipe1: JSONObject = [
    "__typename": "Recipe",
    "id": "63506df6f463890829ae047b",
    "title": "With all details",
    "gridImageUrl": "https://api-test.zradelnik.eu/image/newx_63530d7af463890829ae04ed?size=640x640&format=webp",
    "listImageUrl": "https://api-test.zradelnik.eu/image/newx_63530d7af463890829ae04ed?size=240x180&format=webp",
    "fullImageUrl": "https://api-test.zradelnik.eu/image/newx_63530d7af463890829ae04ed?size=1280x960&format=webp",
    "directions": "Fsdfsdf",
    "sideDish": "sss",
    "preparationTime": 12,
    "servingCount": 22,
    "tags": ["Instant Pot"],
    "ingredients": [
        [
            "__typename": "Ingredient",
            "id": "63599979345b99a0f87f9d19",
            "name": "xxx",
            "isGroup": false
        ] as JSONObject
    ],
    "cookedHistory": [
        [
            "__typename": "RecipeCooked",
            "id": "1",
            "date": try! Date(_jsonValue: "2022-11-01T21:58:00.000Z"),
            "user": [
                "__typename": "User",
                "id": "5cfbe70e4309d1001b800400",
                "displayName": "Kubík"
            ]
        ] as JSONObject
    ]
]

private let recipe2: JSONObject = [
    "__typename": "Recipe",
    "id": "6320a3c94e2b78b722e5325d",
    "title": "Some long title and without any details",
    "tags": [String](),
    "ingredients": [JSONObject](),
    "cookedHistory": [JSONObject]()
]

private let recipe3: JSONObject = [
    "__typename": "Recipe",
    "id": "5b4f00f4f275000019d0c3b6",
    "title": "Bábovka",
    "gridImageUrl": "https://api-test.zradelnik.eu/image/babovka_60b625c871cc4b28a638d3fb?size=640x640&format=webp",
    "listImageUrl": "https://api-test.zradelnik.eu/image/babovka_60b625c871cc4b28a638d3fb?size=240x180&format=webp",
    "fullImageUrl": "https://api-test.zradelnik.eu/image/babovka_60b625c871cc4b28a638d3fb?size=1280x960&format=webp",
    "directions": "1. Vejce rozklepneme a oddělíme žloutky od bílků, žloutky vyšleháme s 1/3 cukru, z bílků ušleháme sníh s 1/3 cukru\n1. Všechny sypké ingredience smícháme v míse a přisypeme ke žloutkům\n1. Přidáme olej a vodu\n1. Opatrně vmícháme sníh\n1. Asi 2/3 těsta nalijeme do vymazané a moukou vysypané formy. Do zbylé třetiny těsta přidáme 2 lžíce kakaa, zamícháme a nalijeme na světlé těsto do formy.\n1. Bábovku vkládáme do předehřáté trouby a pečeme asi 60 minut na 160 °C (horkovzduch 140 °C). Zkusíme špejlí, jestli je uvnitř hotová\n1. Upečenou bábovku vyklopíme, pocukrujeme a můžeme servírovat",
    "preparationTime": 90,
    "tags": [String](),
    "ingredients": [
        [
            "__typename": "Ingredient",
            "id": "6043e32822d1620018b0c9af",
            "name": "polohrubá mouka",
            "isGroup": false,
            "amount": 2,
            "amountUnit": "hrnky"
        ] as JSONObject,
        [
            "__typename": "Ingredient",
            "id": "6043e32822d1620018b0c9b0",
            "name": "cukr",
            "isGroup": false,
            "amount": 1,
            "amountUnit": "hrnek"
        ],
        [
            "__typename": "Ingredient",
            "id": "6043e32822d1620018b0c9b1",
            "name": "řepkový olej",
            "isGroup": false,
            "amount": 1,
            "amountUnit": "sklenka"
        ],
        [
            "__typename": "Ingredient",
            "id": "6043e32822d1620018b0c9b2",
            "name": "teplá voda",
            "isGroup": false,
            "amount": 1,
            "amountUnit": "sklenka"
        ],
        [
            "__typename": "Ingredient",
            "id": "6043e32822d1620018b0c9b3",
            "name": "vejce",
            "isGroup": false,
            "amount": 3,
            "amountUnit": "ks"
        ],
        [
            "__typename": "Ingredient",
            "id": "6043e32822d1620018b0c9b4",
            "name": "prášek do pečiva",
            "isGroup": false,
            "amount": 1,
            "amountUnit": "ks"
        ],
        [
            "__typename": "Ingredient",
            "id": "6043e32822d1620018b0c9b5",
            "name": "vanilkový cukr",
            "isGroup": false,
            "amount": 1,
            "amountUnit": "ks"
        ],
        [
            "__typename": "Ingredient",
            "id": "6043e32822d1620018b0c9b6",
            "name": "kakao",
            "isGroup": false,
            "amount": 2,
            "amountUnit": "lžíce"
        ]
    ],
    "cookedHistory": [
        [
            "__typename": "RecipeCooked",
            "id": "1",
            "date": try! Date(_jsonValue: "2022-10-21T20:44:00.000Z"),
            "user": [
                "__typename": "User",
                "id": "5cfbe70e4309d1001b800400",
                "displayName": "Kubík"
            ]
        ] as JSONObject,
        [
            "__typename": "RecipeCooked",
            "id": "2",
            "date": try! Date(_jsonValue: "2022-10-22T20:44:00.000Z"),
            "user": [
                "__typename": "User",
                "id": "5cfbe70e4309d1001b800400",
                "displayName": "Kubík"
            ]
        ]
    ]
]

private let recipe4: JSONObject = [
    "__typename": "Recipe",
    "id": "6320a3c94e2b78b722e5324d",
    "title": "Some long title with preparation for list test",
    "preparationTime": 185,
    "tags": [String](),
    "ingredients": [JSONObject](),
    "cookedHistory": [JSONObject]()
]

private let data: JSONObject = [
    "recipes": [
        recipe1,
        recipe2,
        recipe3,
        recipe4
    ]
]

let recipePreviewData: [RecipesQuery.Data.Recipe] = RecipesQuery.Data(data: DataDict(data, variables: nil)).recipes
