//
//  Configuration.swift
//
//  Copyright (c) 2021 Evolv Technology Solutions
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


//import Foundation
//
//// MARK: - Configuration
//public struct Configuration: Codable, EvolvConfig {
//    public let published: Double
//    public let client: Client
//    public let experiments: [Experiment]
//
//    enum CodingKeys: String, CodingKey {
//        case published = "_published"
//        case client = "_client"
//        case experiments = "_experiments"
//    }
//}
//
//// MARK: - Client
//// TODO: is it really needed for mobile version
//public struct Client: Codable {
//    public let browser, device, location, platform: String
//}
//
//// MARK: - Experiment
//public struct Experiment: Codable {
//    public let web: Key?
//    public let predicate: ExperimentPredicate
//    public let home, next, buttonColor, ctaText: Key?
//    public let id: String
//    public let paused: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case web
//        case predicate = "_predicate"
//        case id
//        case paused = "_paused"
//        case home, next
//        case buttonColor = "button_color"
//        case ctaText = "cta_text"
//    }
//}
//
//public class Key: Codable {
//    public let isEntryPoint: Bool?
//    public let predicate: ExperimentPredicate?
//    public let values: Bool?
//    public let initializers: Bool?
//    public let ctaText, layout, buttonColor: Key?
//    public let innerKey: Key?
//    public let dependencies: String?
//
//    public let innerKey1: Key?
//    public let innerKey2: Key?
//
//    enum CodingKeys: String, CodingKey {
//        case isEntryPoint = "_is_entry_point"
//        case predicate = "_predicate"
//        case values = "_values"
//        case initializers = "_initializers"
//        case ctaText = "cta_text"
//        case layout = "layout"
//        case buttonColor = "button_color"
//        case innerKey = "o7b7msnxd"
//        case innerKey1 = "21zti3xj5"
//        case innerKey2 = "hlvg8909z"
//        case dependencies
//    }
//
//    init(isEntryPoint: Bool?, predicate: ExperimentPredicate?, values: Bool?, initializers: Bool?, ctaText: Key?, layout: Key?, buttonColor: Key?, innerKey: Key?, innerKey1: Key?, innerKey2: Key, dependencies: String?) {
//        self.isEntryPoint = isEntryPoint
//        self.predicate = predicate
//        self.values = values
//        self.initializers = initializers
//        self.ctaText = ctaText
//        self.layout = layout
//        self.buttonColor = buttonColor
//        self.innerKey = innerKey
//        self.innerKey1 = innerKey1
//        self.innerKey2 = innerKey2
//        self.dependencies = dependencies
//    }
//}
//
//// MARK: - Rule
//public struct Rule: Codable {
//    public let field: String?
//    public let ruleOperator: RuleOperator?
//    public let value: String?
//
//    public let combinator: String?
//    public let rules: [Rule]?
//
//    enum CodingKeys: String, CodingKey {
//        case field
//        case ruleOperator = "operator"
//        case value
//        case combinator
//        case rules
//    }
//    
//    public enum RuleOperator: String, Codable {
//            case equal = "equal"
//            case notEqual = "not_equal"
//            case contains = "contains"
//            case notContains = "not_contains"
//            case exists
//            case regexMatch = "regex64_match"
//            case notRegexMatch = "not_regex_match"
//        }
//}
//
//
//public struct CompoundRule: Decodable {
//    enum Combinator: String, Decodable {
//        case and
//        case or
//    }
//
//    let id: String
//    let combinator: Combinator
//    let rules: [EvolvQuery]
//}
//
//public enum EvolvQuery: Decodable {
//
//    case rule(Rule)
//    case compoundRule(CompoundRule)
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//
//        if let rule = try? container.decode(Rule.self) {
//            self = .rule(rule)
//        } else if let compoundRule = try? container.decode(CompoundRule.self) {
//            self = .compoundRule(compoundRule)
//        } else {
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Mismatched Types")
//        }
//    }
//
//    static func evaluate(_ expression: EvolvQuery, context: [String: String]) -> Bool {
//        switch expression {
//        case .rule(let rule):
//            switch (rule.ruleOperator, rule.value) {
//            case (.exists, let value as String):
//                return context.keys.contains(where: { $0 == value })
//            case (.equal, let values as [String]) where values.count > 1:
//                return context.keys.contains(where: { $0 == values[0] }) && context[values[0]] == values[1]
//            case (.notEqual, let values as [String]) where values.count > 1:
//                return context.keys.contains(where: { $0 == values[0] }) && context[values[0]] != values[1]
//            case (.contains, let values as [String]) where values.count > 1:
//                return context.contains(where: { $0.key == values[0] && $0.value.contains(values[1]) })
//            case (.notContains, let values as [String]) where values.count > 1:
//                return context.contains(where: { $0.key == values[0] && $0.value.contains(values[1]) == false })
//            default:
//                return true
//            }
//        case .compoundRule(let compoundRule):
//            guard compoundRule.rules.isEmpty == false else {
//                return true
//            }
//
//            let results = compoundRule.rules.map({ evaluate($0, context: context) })
//
//            switch compoundRule.combinator {
//            case .and:
//                return !results.contains(false)
//            case .or:
//                return results.contains(true)
//            }
//        }
//    }
//
//}
//
//// MARK: - ExperimentPredicate
//public struct ExperimentPredicate: Codable {
//    public let id: Int?
//    public let combinator: String?
//    public let rules: [Rule]?
//}
//
//
