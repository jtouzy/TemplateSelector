//
//  TemplateSelectorApp.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import SwiftUI

@main
struct TemplateSelectorApp: App {
  var body: some Scene {
    WindowGroup {
      Rectangle()
        .fill(Color.red)
        .frame(width: 350, height: 600)
        .overlay(
          // https://ptitchevreuil.github.io/mojo/templates.json
          TemplateElementRenderer(
            element: .init(
              id: .init(),
              relativePosition: .init(x: 0, y: 0),
              relativeSize: .init(width: 1, height: 1),
              anchorX: .left,
              anchorY: .bottom,
              backgroundColor: Color.init(hex: "#73D3A2")!,
              relativePadding: .init(top: 0.1, leading: 0.1, bottom: 0.1, trailing: 0.1),
              media: nil,
              children: [
                .init(
                  id: .init(),
                  relativePosition: .init(x: 0, y: 0),
                  relativeSize: .init(width: 1, height: 1),
                  anchorX: .left,
                  anchorY: .bottom,
                  backgroundColor: .black,
                  relativePadding: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
                  media: .init(name: "media1", contentMode: .fit),
                  children: []
                )
              ]
            )
          )
        )
    }
  }
}
