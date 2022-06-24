//
//  TemplateSelectorApp.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import ComposableArchitecture
import SwiftUI

@main
struct TemplateSelectorApp: App {
  var body: some Scene {
    WindowGroup {
      Main.View(
        store: .init(
          initialState: .initial,
          reducer: Main.reducer,
          environment: .init(
            fetchTemplates: fetchTemplates()
          )
        )
      )
    }
  }
}

private var mocked: [Template] = [
  .init(
    id: .init(),
    name: "Template 1",
    element: .init(
      id: .init(),
      relativePosition: .init(x: 0, y: 0),
      relativeSize: .init(width: 1, height: 1),
      anchorX: .left,
      anchorY: .bottom,
      relativePadding: .init(top: 0.1, leading: 0.1, bottom: 0.1, trailing: 0.1),
      media: nil,
      children: [
        .init(
          id: .init(),
          relativePosition: .init(x: 0, y: 0),
          relativeSize: .init(width: 1, height: 1),
          anchorX: .left,
          anchorY: .bottom,
          relativePadding: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
          media: .init(name: "media1", contentMode: .fit),
          children: [],
          backgroundColor: .black,
          isSelected: false
        )
      ],
      backgroundColor: Color.init(hex: "#73D3A2")!,
      isSelected: false
    )
  ),
  .init(
    id: .init(),
    name: "Template 1",
    element: .init(
      id: .init(),
      relativePosition: .init(x: 0, y: 0),
      relativeSize: .init(width: 1, height: 1),
      anchorX: .left,
      anchorY: .bottom,
      relativePadding: .init(top: 0.1, leading: 0.1, bottom: 0.1, trailing: 0.1),
      media: nil,
      children: [
        .init(
          id: .init(),
          relativePosition: .init(x: 0, y: 0),
          relativeSize: .init(width: 1, height: 1),
          anchorX: .left,
          anchorY: .bottom,
          relativePadding: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
          media: .init(name: "media1", contentMode: .fit),
          children: [],
          backgroundColor: .black,
          isSelected: false
        )
      ],
      backgroundColor: Color.init(hex: "#73D3A2")!,
      isSelected: false
    )
  ),
  .init(
    id: .init(),
    name: "Template 1",
    element: .init(
      id: .init(),
      relativePosition: .init(x: 0, y: 0),
      relativeSize: .init(width: 1, height: 1),
      anchorX: .left,
      anchorY: .bottom,
      relativePadding: .init(top: 0.1, leading: 0.1, bottom: 0.1, trailing: 0.1),
      media: nil,
      children: [
        .init(
          id: .init(),
          relativePosition: .init(x: 0, y: 0),
          relativeSize: .init(width: 1, height: 1),
          anchorX: .left,
          anchorY: .bottom,
          relativePadding: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
          media: .init(name: "media1", contentMode: .fit),
          children: [],
          backgroundColor: .black,
          isSelected: false
        )
      ],
      backgroundColor: Color.init(hex: "#73D3A2")!,
      isSelected: false
    )
  )
]

private func fetchTemplates() -> () -> Effect<Result<[Template], NSError>, Never> {
  return {
    Effect.init(value: .success(mocked))
  }
}
