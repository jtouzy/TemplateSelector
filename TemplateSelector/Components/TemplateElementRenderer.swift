//
//  TemplateElementRenderer.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import Domain
import SwiftUI

// MARK: -TemplateElementRenderer.View

struct TemplateElementRenderer: View {
  var element: Template.Element
  var selectedElementId: Template.Element.ID?
  var onTap: (Template.Element) -> Void

  var body: some View {
    GeometryReader { proxy in
      Rectangle()
        .fill(element.backgroundColor.opacity(element.id == selectedElementId ? 0.7 : 1))
        .position(element.swiftUIPosition(in: proxy.size))
        .frame(element.swiftUIFrame(in: proxy.size))
        .overlay(mediaOverlay(from: element))
        .overlay(
          childrenOverlay(
            from: element,
            selectedElementId: selectedElementId,
            size: proxy.size,
            onTap: onTap
          )
        )
        .onTapGesture { onTap(element) }
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
private func childrenOverlay(
  from element: Template.Element,
  selectedElementId: Template.Element.ID?,
  size containerSize: CGSize,
  onTap: @escaping (Template.Element) -> Void
) -> some View {
  ForEach(element.children) { element in
    TemplateElementRenderer(
      element: element,
      selectedElementId: selectedElementId,
      onTap: onTap
    )
  }
  .padding(element.swiftUIPadding(in: containerSize))
}
