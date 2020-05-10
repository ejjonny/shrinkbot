//
//  NotificationModal.swift
//  shrinkbot
//
//  Created by Ethan John on 5/9/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import SwiftUI

struct NotificationModal: View {
    @Environment(\.presentationMode) var presentation
    @State var reminder: Reminder? = ReminderController.shared.reminders.first
    @State var date: Date = ReminderController.shared.reminders.first?.timeOfDay ?? Date()
    @State var on: Bool = ReminderController.shared.reminders.first?.isOn ?? false
    var body: some View {
        VStack {
            ModalHandle()
            HStack {
                Text("Daily reminder \(on ? "ON" : "OFF"): \(date.asTimeSpecificString())")
                    .defaultFont(20, weight: .bold)
                Spacer()
                Button(action: {
                    self.on.toggle()
                }) {
                    Image(systemName: on ? "bell.fill" : "bell.slash.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .background(
                                Circle()
                                    .foregroundColor(Color("Standard"))
                    )
                }
                .frame(height: 62)
                .buttonStyle(BubbleButton())
            }
            .padding()
            DatePicker(selection: $date, displayedComponents: .hourAndMinute) {
                EmptyView()
            }
            .labelsHidden()
            Spacer()
            DoneButton() {
                if let reminder = self.reminder {
                    if reminder.isOn != self.on {
                        ReminderController.shared.toggle(reminder: reminder)
                    }
                    if reminder.isOn {
                        ReminderController.shared.update(reminder: reminder, timeOfDay: self.date) { _ in }
                    }
                } else {
                    ReminderController.shared.createReminderWith(date: self.date) { _ in }
                }
                self.presentation.wrappedValue.dismiss()
            }
            .frame(width: 100, height: 100)
            .padding()
        }
        .padding()
        .background(Color("Background"))
        .edgesIgnoringSafeArea([.bottom])
    }
}
