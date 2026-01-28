//
//  InviteCard.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/20/26.
//

import SwiftUI


struct InviteCard: View {
    let title: String
    @Binding var people: [InvitePerson]
    var onAddTap: () -> Void = {}
    var onPersonTap: (InvitePerson) -> Void = { _ in }
    var onRemove: (InvitePerson) -> Void = { _ in }
    var isEditable: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerView

            if !people.isEmpty {
                Divider()
                    .background(Color.white.opacity(0.3))

                peopleListView
            }
        }
        .padding(16)
        .background { glassyBackground }
        .animation(.easeInOut(duration: 0.3), value: people.count)
    }

    private var headerView: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Spacer()

            if isEditable {
                Button(action: onAddTap) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.purple.opacity(0.6),
                                        Color.indigo.opacity(0.7)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                            .shadow(color: .purple.opacity(0.3), radius: 4, x: 0, y: 2)

                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var peopleListView: some View {
        VStack(spacing: 12) {
            ForEach(people) { person in
                PersonRow(
                    person: person,
                    isEditable: isEditable,
                    onTap: { onPersonTap(person) },
                    onRemove: { onRemove(person) }
                )
            }
        }
    }

    private var glassyBackground: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.25),
                        Color.white.opacity(0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.0)
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
    }
}

struct PersonRow: View {
    let person: InvitePerson
    var isEditable: Bool = true
    var onTap: () -> Void = {}
    var onRemove: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            personAvatar

            VStack(alignment: .leading, spacing: 2) {
                Text(person.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(person.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isEditable {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.gray.opacity(0.6))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
    }

    @ViewBuilder
    private var personAvatar: some View {
        if let image = person.image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
        } else {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.4),
                                Color.indigo.opacity(0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)

                Text(person.name.prefix(1).uppercased())
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 20) {
            InviteCard(
                title: "Household Members",
                people: .constant([
                    InvitePerson(name: "John Doe", email: "john@example.com"),
                    InvitePerson(name: "Jane Smith", email: "jane@example.com"),
                    InvitePerson(name: "Alex Johnson", email: "alex@example.com")
                ]),
                onAddTap: {},
                isEditable: true
            )

            InviteCard(
                title: "Invited People",
                people: .constant([]),
                onAddTap: {},
                isEditable: true
            )

            InviteCard(
                title: "Family Members",
                people: .constant([
                    InvitePerson(name: "Mom", email: "mom@family.com")
                ]),
                isEditable: false
            )
        }
        .padding()
    }
}
