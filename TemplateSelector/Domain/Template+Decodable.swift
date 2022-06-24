//
//  Template+Decodable.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import SwiftUI

// MARK: -Template wrapper for API call

struct TemplateAPI {
  struct Response: Decodable {
    let templates: [Template]
  }
}

// MARK: -Template decodable implementation

extension Template: Decodable {
  enum CodingKeys: CodingKey {
    case name, data
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = .init()
    name = try container.decode(String.self, forKey: .name)
    element = try container.decode(Template.Element.self, forKey: .data)
  }
}

// MARK: -Template.Element decodable implementation

extension Template.Element: Decodable {
  enum CodingKeys: CodingKey {
    case x, y, width, height, padding, anchorX, anchorY, backgroundColor, media, mediaContentMode, children
  }

  // NOTE: Here the decoder is implemented manually to manage default values.
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = .init()
    relativePosition = try container.decodeRelativePosition()
    relativeSize = try container.decodeRelativeSize()
    anchorX = try container.decodeIfPresent(AnchorX.self, forKey: .anchorX, withDefaultValue: .left)
    anchorY = try container.decodeIfPresent(AnchorY.self, forKey: .anchorY, withDefaultValue: .bottom)
    relativePadding = try container.decodeRelativePadding()
    media = try container.decodeMedia()
    children = try container.decodeIfPresent([Template.Element].self, forKey: .children, withDefaultValue: [])
    backgroundColor = try container.decodeIfPresent(Color.self, forKey: .backgroundColor, withDefaultValue: .clear)
    isSelected = false
  }
}

private extension KeyedDecodingContainer where Key == Template.Element.CodingKeys {
  func decodeRelativePosition() throws -> Template.Element.RelativePosition {
    let x = try decodeIfPresent(Float.self, forKey: .x, withDefaultValue: .zero)
    let y = try decodeIfPresent(Float.self, forKey: .y, withDefaultValue: .zero)
    return .init(x: CGFloat(x), y: CGFloat(y))
  }
  func decodeRelativeSize() throws -> Template.Element.RelativeSize {
    let width = try decode(Float.self, forKey: .width)
    let height = try decode(Float.self, forKey: .height)
    return .init(width: CGFloat(width), height: CGFloat(height))
  }
  func decodeRelativePadding() throws -> EdgeInsets {
    let padding = try decodeIfPresent(Float.self, forKey: .padding, withDefaultValue: .zero)
    return .uniform(CGFloat(padding))
  }
  func decodeMedia() throws -> Template.Element.Media? {
    guard
      let mediaName = try decodeIfPresent(String.self, forKey: .media),
      let mediaContentMode = try decodeIfPresent(ContentMode.self, forKey: .mediaContentMode)
    else {
      return .none
    }
    return .init(name: mediaName, contentMode: mediaContentMode)
  }
}
