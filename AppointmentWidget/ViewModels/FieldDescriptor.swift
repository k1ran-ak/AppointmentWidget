//
//  FieldDescriptor.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 07/07/25.
//


import SwiftUI

/// A one‐line description of how to render one piece of your AppointmentWidgetModel.
struct FieldDescriptor<Model>: Identifiable {
  let id: AppointmentWidgetField
  let label: String
  let makeText: (Model) -> String

  init(
    _ id: AppointmentWidgetField,
    label: String,
    makeText: @escaping (Model) -> String
  ) {
    self.id = id
    self.label = label
    self.makeText = makeText
  }
}

