import SwiftUI

struct ProfileView: View {

    @State private var isVisible = false
    @State private var favoritesCount = 0

    var body: some View {

        NavigationView {

            VStack(spacing: 24) {

                Spacer()

                Image(systemName: "film.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.blue)
                    .scaleEffect(isVisible ? 1 : 0.6)
                    .opacity(isVisible ? 1 : 0)

                Text("Movie Explorer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(isVisible ? 1 : 0)

                Text("Discover and save your favorite movies")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isVisible ? 1 : 0)

                VStack(spacing: 12) {

                    Text("Favorites")
                        .font(.headline)

                    Text("\(favoritesCount)")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.red)

                    Text("movies saved")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .opacity(isVisible ? 1 : 0)

                Spacer()

                Text("Powered by OMDb API")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)

            }
            .padding()
            .navigationTitle("Profile")
            .onAppear {

                favoritesCount = FavoritesManager.shared
                    .getFavorites()
                    .count

                withAnimation(.easeInOut(duration: 0.7)) {
                    isVisible = true
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
