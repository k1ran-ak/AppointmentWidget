//
//  FieldInputType.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 07/07/25.
//


import SwiftUI

enum FieldInputType {
  case text
  case multiline
  case date
}

/// Describes *one* editable field on your AppointmentWidgetModel:
struct EditableFieldDescriptor<Model>: Identifiable {
  let id: AppointmentWidgetField
  let label: String
  let inputType: FieldInputType
  /// pull the raw value out (always as String for simplicity)
  let get: (Model) -> String
  /// write a new String back into the model
  let set: (inout Model, String) -> Void
}
