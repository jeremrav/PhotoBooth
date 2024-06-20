//
//  ContentView.swift
//  PhotoBooth
//
//  Created by Jérémy Rava on 10/06/2024.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink {
                    CameraView(numberOfPhotos: 1)
                } label: {
                    Label {
                    } icon: {
                        Image("anniv_nicolas_photo_1")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .padding()

                NavigationLink {
                    CameraView(numberOfPhotos: 2)
                } label: {
                    Label {
                    } icon: {
                        Image("anniv_nicolas_photo_2")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .padding()
            }
            .background(Color.customGray)
        }
    }

    func click() {

    }
}

#Preview {
    ContentView()
}
