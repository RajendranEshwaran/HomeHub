//
//  SliderControl.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/12/26.
//

import SwiftUI

struct SliderControl: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let label: String?
    let showValue: Bool
    let leadingIcon: String?
    let trailingIcon: String?
    let accentColor: Color
    let valueFormatter: ((Double) -> String)?

    init(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double = 1.0,
        label: String? = nil,
        showValue: Bool = true,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        accentColor: Color = .white,
        valueFormatter: ((Double) -> String)? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
        self.showValue = showValue
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.accentColor = accentColor
        self.valueFormatter = valueFormatter
    }

    var body: some View {
        VStack(spacing: 10) {
            if let label = label {
                HStack {
                    Text(label)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                    if showValue {
                        Text(formattedValue)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }

            HStack(spacing: 15) {
                if let icon = leadingIcon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 24)
                }

                Slider(value: $value, in: range, step: step)
                    .accentColor(accentColor)

                if let icon = trailingIcon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 24)
                }
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
        }
    }

    private var formattedValue: String {
        if let formatter = valueFormatter {
            return formatter(value)
        }

        if step == 1.0 {
            return "\(Int(value))"
        } else {
            return String(format: "%.1f", value)
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()

        VStack(spacing: 20) {
            SliderControl(
                value: .constant(24.0),
                range: 16...30,
                step: 1.0,
                label: "Temperature",
                showValue: true,
                leadingIcon: "snowflake",
                trailingIcon: "flame.fill",
                accentColor: .white,
                valueFormatter: { "\(Int($0))°C" }
            )

            SliderControl(
                value: .constant(75.0),
                range: 0...100,
                step: 1.0,
                label: "Brightness",
                showValue: true,
                leadingIcon: "sun.min",
                trailingIcon: "sun.max.fill",
                accentColor: .yellow
            )

            SliderControl(
                value: .constant(50.0),
                range: 0...100,
                step: 1.0,
                label: "Volume",
                showValue: true,
                leadingIcon: "speaker.fill",
                trailingIcon: "speaker.wave.3.fill",
                accentColor: .purple
            )
        }
        .padding()
    }
}
