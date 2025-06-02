import Foundation
import CoreML

@objc class ModelRunner: NSObject {

    @objc static func runModels() -> String {
        do {
            // Load both Core ML models
            guard let model1URL = Bundle.main.url(forResource: "Model1", withExtension: "mlpackage"),
                  let model2URL = Bundle.main.url(forResource: "Model2", withExtension: "mlpackage") else {
                return "Model files not found."
            }

            let model1 = try MLModel(contentsOf: model1URL)
            let model2 = try MLModel(contentsOf: model2URL)

            // Dummy input tensors matching your Python script
            // Adjust dimensions and values as needed
            let image = try MLMultiArray(shape: [3, 256, 256], dataType: .float32)
            let input_ids = try MLMultiArray(shape: [1, 12], dataType: .int64)
            let attention_mask = try MLMultiArray(shape: [1, 12], dataType: .int64)

            // Fill with dummy values (e.g., 0.5 for image, 0 for input_ids, 1 for attention_mask)
            for i in 0..<image.count {
                image[i] = 0.5
            }
            for i in 0..<input_ids.count {
                input_ids[i] = 0
            }
            for i in 0..<attention_mask.count {
                attention_mask[i] = 1
            }

            // Build input dictionary
            let inputDict: [String: Any] = [
                "image": image,
                "input_ids": input_ids,
                "attention_mask": attention_mask
            ]

            let inputProvider = try MLDictionaryFeatureProvider(dictionary: inputDict)

            let start1 = DispatchTime.now()
            _ = try model1.prediction(from: inputProvider)
            let end1 = DispatchTime.now()

            let start2 = DispatchTime.now()
            _ = try model2.prediction(from: inputProvider)
            let end2 = DispatchTime.now()

            let time1 = Double(end1.uptimeNanoseconds - start1.uptimeNanoseconds) / 1_000_000
            let time2 = Double(end2.uptimeNanoseconds - start2.uptimeNanoseconds) / 1_000_000

            return "Model 1: \(time1) ms\nModel 2: \(time2) ms"

        } catch {
            return "Error running models: \(error.localizedDescription)"
        }
    }
}

