//
//  TemplateRenderer.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import Domain
import SwiftUI

// MARK: -TemplateRenderer.View

struct TemplateRenderer: View {
  @State var template: Template
  var onTap: (Template.Element) -> Void

  var body: some View {
    TemplateElementRenderer(
      element: template.element,
      onTap: onTap
    )
    .cornerRadius(9.0)
  }
}
