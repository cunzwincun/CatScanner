//
//  ContentView.swift
//  SlidingIntroScreen
//
//  Created by Federico on 18/03/2022.
//

import SwiftUI
import PhotosUI
import CoreTransferable
import CoreML
import Vision

struct ContentView: View {
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    //let model = KucingPopulerAja_1()
    
    
    
    @State var selectedPhoto: [PhotosPickerItem] = []
    @State public var data: Data?
    @State var showImagePage = false
    var body: some View {
        ZStack{
            Color("hijauTosca").ignoresSafeArea(.all)
            if showImagePage == false {
                TabView(selection: $pageIndex) {
                    ForEach(pages) { page in
                        VStack {
                            Spacer()
                            PageView(page: page)
                            Spacer()
                            if page == pages.last {
                                
                                PhotosPicker(
                                    selection: $selectedPhoto,
                                    maxSelectionCount: 1,
                                    matching: .images
                                ) {
                                    Text("Pick Photo")
                                }
                                .onChange(of: selectedPhoto) { newValue in
                                    guard let item = selectedPhoto.first else {
                                        return
                                    }
                                    
                                    item.loadTransferable(type: Data.self) { result in
                                        switch result {
                                        case .success(let data):
                                            if let data = data {
                                                self.data = data
                                            } else {
                                                print("Data is nil")
                                            }
                                        case .failure(let failure):
                                            print(failure)
                                        }
                                    }
                                    
                                    let imageName = UUID().uuidString + ".png"
                                    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
                                    if let data = data, var uiimage = UIImage(data: data){
                                        uiimage = rotateImage(image: uiimage) ?? UIImage(data: data)!
                                        do {
                                            try uiimage.pngData()?.write(to: path)
                                            
                                            print("Image saved")
                                        }
                                        catch {
                                            print("some error" + error.localizedDescription)
                                        }
                                    }
                                    showImagePage.toggle()
                                }
                                
                            } else {
                                Button("next", action: incrementPage)
                                    .buttonStyle(.borderedProminent)
                                
                            }
                            Spacer()
                                .frame(height: 60)
                        }
                        .tag(page.tag)
                    }
                }
                .animation(.easeInOut, value: pageIndex)// 2
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .tabViewStyle(PageTabViewStyle())
                .onAppear {
                    dotAppearance.currentPageIndicatorTintColor = .black
                    dotAppearance.pageIndicatorTintColor = .gray
                }
                
                
                
            }
            else {
                ImageSelectedView(data: data)
            }
        }
    }
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func goToZero() {
        pageIndex = 0
    }
    
    //    func catIdentifier () {
    //        if let prediction = try? model.prediction(image: pixelBuffer) {
    //            let output = prediction.outputData
    //            // Process the output data as needed
    //        }
    
    //    }
    
    
    }


func rotateImage(image: UIImage) -> UIImage? {
    if image.imageOrientation == UIImage.Orientation.up {
        return image /// already upright, no need for changes
    }
    UIGraphicsBeginImageContext(image.size)
    image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
    let copy = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return copy
}



//var newPage: some View {
//    VStack {
//        if let data = data, let uiimage = UIImage(data: data){
//            Image(uiImage: uiimage)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 361, height: 361)
//
//        }
//                    Button("Identify", action: goToZero)
//                        .buttonStyle(.borderedProminent)
//
//
//
//
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
