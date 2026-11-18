import SwiftUI

struct DetailItem: View {
    let dish: Dish

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                DishImage(url: dish.imageURL)
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                HStack(alignment: .firstTextBaseline) {
                    Text(dish.title ?? "")
                        .font(.llHeading)
                        .foregroundStyle(Color.llCharcoal)

                    Spacer()

                    if let category = dish.category, !category.isEmpty {
                        Text(category.capitalized)
                            .font(.llSmall)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.llPrimaryGreen)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.llLightGray)
                            .clipShape(Capsule())
                    }
                }

                Text(dish.formattedPrice)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.llPrimaryGreen)

                Text(dish.descriptionDish ?? "")
                    .font(.llBody)
                    .foregroundStyle(Color.llCharcoal)
            }
            .padding()
        }
        .background(Color.white)
        .navigationTitle(dish.title ?? "Dish")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }
}
