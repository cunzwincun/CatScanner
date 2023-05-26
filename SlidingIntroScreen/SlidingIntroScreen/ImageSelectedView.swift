//
//  ImageSelectedView.swift
//  SlidingIntroScreen
//
//  Created by Wincun Marthadiarto on 23/05/23.
//

import SwiftUI
import CoreML
import Vision

struct ImageSelectedView: View {
    
    @State private var resultText: String = ""
    var uiimage: UIImage?
    let catClassifier: VNCoreMLModel = {
        do {
            let config = MLModelConfiguration()
            let model = try KucingPopulerAja_1 (configuration: config)
            return try VNCoreMLModel(for: model.model)
        } catch {
            fatalError("Failed to load Core ML model: \(error)")
        }
    }()
    
    func performImageAnalysis(image: UIImage?) {
        guard let image = image,
              let ciImage = CIImage(image: image) else {
            return
        }
        
        do {
            let request = VNCoreMLRequest(model: catClassifier) { request, error in
                if let error = error {
                    DispatchQueue.main.async {
                        resultText = "Error analyzing image: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let results = request.results as? [VNClassificationObservation],
                      let topResult = results.first else {
                    DispatchQueue.main.async {
                        resultText = "No results found"
                    }
                    return
                }
                
                let catName = topResult.identifier
                let confidence = topResult.confidence
                
                let resultString = "\(catName)"
                DispatchQueue.main.async {
                    resultText = resultString
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try handler.perform([request])
        } catch {
            DispatchQueue.main.async {
                resultText = "Error initializing VNCoreMLRequest: \(error.localizedDescription)"
            }
        }
    }

    
    var data: Data?
    var body: some View {
        VStack {
            if let data = data, let uiimage = UIImage(data: data){
                Image(uiImage: uiimage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 361, height: 361)
                
            }
            Button("Identify", action: {
                guard let data else {
                    print("Image not foound!")
                    return
                }
                performImageAnalysis(image: UIImage(data: data))
             
            })
                .buttonStyle(.borderedProminent)
            
            Text(resultText)
            
            
        }
    }
    
    
    
    
}

struct ImageSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectedView()
    }
}
