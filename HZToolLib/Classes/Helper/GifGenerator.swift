//
//  GifGenerator.swift
//  ImageEditor
//
//  Created by quanhai on 2022/3/14.
//

import UIKit
import ImageIO
import MobileCoreServices
import AVFoundation


@objc public class GifGenerator: NSObject {
	
	var cmTimeArray:[NSValue] = []
	var framesArray:[UIImage] = []
	
	/**
	 Generate a GIF using a set of images
	 You can specify the loop count and the delays between the frames.
	 
	 :param: imagesArray an array of images
	 :param: repeatCount the repeat count, defaults to 0 which is infinity
	 :param: frameDelay an delay in seconds between each frame
	 :param: callback set a block that will get called when done, it'll return with data and error, both which can be nil
	 */
	public func generateGifFromImages(imagesArray: [UIImage],
									  repeatCount: Int = 0,
									  frameDelay: TimeInterval,
									  destinationURL: URL,
									  callback: @escaping (_ data: Data?, _ error: Error?) -> ()) {
		
		DispatchQueue.global(qos: .background).async { () -> Void in
			if let imageDestination = CGImageDestinationCreateWithURL(destinationURL as CFURL, "com.compuserve.gif" as CFString, imagesArray.count, nil) {
				
				let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: frameDelay]]
				let gifProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: repeatCount]]
				
				CGImageDestinationSetProperties(imageDestination, gifProperties as CFDictionary)
				for image in imagesArray {
					CGImageDestinationAddImage(imageDestination, image.cgImage!, frameProperties as CFDictionary)
				}
				
				if CGImageDestinationFinalize(imageDestination) {
					
					print("animated GIF file created at ", destinationURL)
					
					do {
						let attr = try FileManager.default.attributesOfItem(atPath: destinationURL.path) as NSDictionary
						let data = try Data(contentsOf: destinationURL)
						print("FILE SIZE: ", ByteCountFormatter.string(fromByteCount: Int64(attr.fileSize()), countStyle: .file))
                        DispatchQueue.main.async {
                            callback(data, nil)
                        }
					} catch {
						print("Error: \(error)")
                        DispatchQueue.main.async {
                            callback(nil, error)
                        }
					}
				} else {
                    DispatchQueue.main.async {
                        callback(nil, self.errorFromString(string: "Couldn't create the final image"))
                    }
				}
			}
		}
	}
	
	/**
	 Generate a GIF using a set of video file (NSURL)
	 You can specify the loop count and the delays between the frames.
	 
	 :param: videoURL an url where you video file is stored
	 :param: repeatCount the repeat count, defaults to 0 which is infinity
	 :param: frameDelay an delay in seconds between each frame
	 :param: callback set a block that will get called when done, it'll return with data and error, both which can be nil
	 */
	public func generateGifFromVideoURL(videoURL videoUrl: URL, repeatCount: Int = 0, framesInterval: Int, frameDelay: TimeInterval, destinationURL: URL, callback: @escaping (_ data: Data?, _ error: Error?) -> ()) {
		
		self.generateFrames(url: videoUrl, framesInterval: framesInterval) { (images) -> () in
			if let images = images {
				self.generateGifFromImages(imagesArray: images, repeatCount: repeatCount, frameDelay: frameDelay, destinationURL: destinationURL, callback: { (data, error) -> () in
					self.cmTimeArray = []
					self.framesArray = []
					callback(data, error)
				})
			}
		}
	}
	
	// MARK: THANKS TO: http://stackoverflow.com/questions/4001755/trying-to-understand-cmtime-and-cmtimemake
   private func generateFrames(url: URL, framesInterval: Int, callback: @escaping (_ images: [UIImage]?) -> ()) {
		
		DispatchQueue.global(qos: .background).async { () -> Void in
			self.generateCMTimesArrayOfFramesUsingAsset(framesInterval: framesInterval, asset: AVURLAsset(url: url as URL))
			
			var i = 0
			let test: AVAssetImageGeneratorCompletionHandler = { (tm: CMTime, im: CGImage? , time: CMTime, result: AVAssetImageGenerator.Result, error: Error?) in
				if(result == AVAssetImageGenerator.Result.succeeded) {
					print("Succeed")
					if let image = im {
						self.framesArray.append(UIImage(cgImage: image))
					}
				} else if (result == AVAssetImageGenerator.Result.failed) {
					print("Failed with error")
					callback(nil)
				} else if (result == AVAssetImageGenerator.Result.cancelled) {
					print("Canceled")
					callback(nil)
				}
				i += 1
				if(i == self.cmTimeArray.count) {
					callback(self.framesArray)
				}
			}
			let generator = AVAssetImageGenerator(asset: AVAsset(url: url as URL))
			generator.apertureMode = AVAssetImageGenerator.ApertureMode.cleanAperture;
			generator.appliesPreferredTrackTransform = true;
			generator.requestedTimeToleranceBefore = CMTime.zero;
			generator.requestedTimeToleranceAfter = CMTime.zero;
			generator.maximumSize = CGSize(width: 200, height: 200);
			
			generator.generateCGImagesAsynchronously(forTimes: self.cmTimeArray, completionHandler: test)
		}
	}
	
	private func generateCMTimesArrayOfAllFramesUsingAsset(asset:AVURLAsset) {
		if cmTimeArray.count > 0 {
			cmTimeArray.removeAll()
		}

		for time in 0 ..< asset.duration.value {
			let thumbTime = CMTime(seconds: Double(time), preferredTimescale: asset.duration.timescale)
			cmTimeArray.append(thumbTime as NSValue)
		}
	}
	
	private func generateCMTimesArrayOfFramesUsingAsset(framesInterval:Int, asset:AVURLAsset) {
		
		let videoDuration = Int(ceilf((Float(Int(asset.duration.value)/Int(asset.duration.timescale)))))
		
		if cmTimeArray.count > 0 {
			cmTimeArray.removeAll()
		}
		
		for t in 0 ..< videoDuration {
			let tempInt = Int64(t)
			let tempCMTime = CMTimeMake(value: tempInt, timescale: asset.duration.timescale)
			let interval = Int32(framesInterval)
			
			for j in 1 ..< framesInterval+1 {
				let newCMtime = CMTime(seconds: Double(j), preferredTimescale: interval)
				let addition = CMTimeAdd(tempCMTime, newCMtime)
				cmTimeArray.append(addition as NSValue)
			}
		}
	}

	private func errorFromString(string: String, code: Int = -1) -> NSError {
		let dict = [NSLocalizedDescriptionKey: string]
		return NSError(domain: "org.cocoapods.GIFGenerator", code: code, userInfo: dict)
	}
	
	
	public func saveGIF(destinationURL: URL, images: [UIImage]){
		guard images.count > 0, destinationURL.hasDirectoryPath else {
			return
		}
		
		let url = destinationURL as CFURL
        var destion: CGImageDestination?
        if #available(iOS 15.0, *){
            destion = CGImageDestinationCreateWithURL(url, UTType.gif as! CFString, images.count, nil)
        }else{
            destion = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil)
        }
        
		// 设置gif图片属性
        let propertiesDic: NSMutableDictionary = NSMutableDictionary()
        propertiesDic.setValue(kCGImagePropertyColorModelRGB, forKey: kCGImagePropertyColorModel as String)
        propertiesDic.setValue(16, forKey: kCGImagePropertyDepth as String)         // 设置图片的颜色深度
        propertiesDic.setValue(1, forKey: kCGImagePropertyGIFLoopCount as String)   // 设置Gif执行次数
        
        let gitDestDic = [kCGImagePropertyGIFDictionary as String:propertiesDic]    // 为gif图像设置属性
        CGImageDestinationSetProperties(destion!, gitDestDic as CFDictionary?)
        
		// 设置每帧之间播放的时间0.1
		let delayTime = [kCGImagePropertyGIFDelayTime as String:0.1]
		let destDic   = [kCGImagePropertyGIFDictionary as String:delayTime]
		// 依次为gif图像对象添加每一帧属性
		for image in images {
			CGImageDestinationAddImage(destion!, (image as AnyObject).cgImage!!, destDic as CFDictionary?)
		}
		
		CGImageDestinationFinalize(destion!)
	}
}

