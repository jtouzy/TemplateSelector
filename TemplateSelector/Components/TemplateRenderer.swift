//
//  TemplateRenderer.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import SwiftUI

// MARK: -TemplateRenderer.View

struct TemplateRenderer: View {
  @State var template: Template

  var body: some View {
    TemplateElementRenderer(element: template.element)
      .cornerRadius(9.0)
  }
}
