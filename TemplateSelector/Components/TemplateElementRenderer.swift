//
//  TemplateElementRenderer.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import SwiftUI

// MARK: -TemplateElementRenderer.View

struct TemplateElementRenderer: View {
  @State var element: Template.Element

  var body: some View {
    GeometryReader { proxy in
      Rectangle()
        .fill(element.backgroundColor)
        .position(element.centerPosition(in: proxy.size))
        .frame(element.frame(in: proxy.size))
        .overlay(mediaOverlay(from: element))
        .overlay(childrenOverlay(from: element, size: proxy.size))
    }
  }
}

@ViewBuilder
private func mediaOverlay(from element: Template.Element) -> some View {
  if let media = element.media {
    Image(media.name)
      .resizable()
      .aspectRatio(contentMode: media.contentMode)
      .clipped()
  }
}

@ViewBuilder
private func childrenOverlay(from element: Template.Element, size containerSize: CGSize) -> some View {
  ForEach(element.children) { element in
    TemplateElementRenderer(element: element)
  }
  .padding(element.padding(in: containerSize))
}
