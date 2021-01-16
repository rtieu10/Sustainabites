//
//  DownloadImage.swift
//  Sustainabites
//
//  Created by Rachel Tieu on 12/3/20.
//  Copyright © 2020 Rachel Tieu. All rights reserved.
//

import Foundation
import UIKit

//@class: this class is responsible for downloading images from the URL that we pass to it 
extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    
    //saves downloaded image to a temporary file
    let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
        //gives the url to find the downloaded file
      if error == nil, let url = url,
        let data = try? Data(contentsOf: url),  //load file into a Data object & create image
        let image = UIImage(data: data) {
        
        //load the image into UIImage View (self)
        DispatchQueue.main.async {
          if let weakSelf = self {
            weakSelf.image = image
          }
        }
      }
    })
    //create the download task and start it by using .resume
    downloadTask.resume()
    return downloadTask
  }
}

