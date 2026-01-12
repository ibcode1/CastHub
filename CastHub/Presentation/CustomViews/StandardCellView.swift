//
//  StandardCellView.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 22/12/2025.
//


import SwiftUI
import IbToolKit

struct StandardCellView: View {
    let title: String
    var subtitle: String?
    var length: String = ""
    var date: Date?
    var imageURL: URL?
    var horizontalPadding: CGFloat = 16.0

    var body: some View {
        HStack {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
            } placeholder: {
                ZStack {
                    //Color(.secondarySystemBackground)
                    //ProgressView()
                    CustomImgUtils()
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(.rect(cornerRadius: 8.0))

            VStack(alignment: .leading, spacing: 4.0) {
                Text(title)
                    .ibFont(.h5Bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)

                if let subtitle {
                    Text(subtitle)
                        .ibFont(.h5Light)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                }

                HStack {
                    if length.isEmpty == false {
                        Text("\(length)")
                            .ibFont(.h5Light)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.6)
                    }

                    Text("\(date?.formatted(date: .abbreviated, time: .omitted) ?? "")")
                        .ibFont(.h5Light)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.6)

                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    //StandardCellView(title: "TITLE")
}
