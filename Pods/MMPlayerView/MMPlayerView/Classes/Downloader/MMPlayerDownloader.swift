//
//  MMPlayerDownloader.swift
//  Pods
//
//  Created by Millman YANG on 2017/9/2.
//
//

import UIKit
import AVFoundation
typealias DownloaderPath = (fullPath: URL, subPath: String)
private let videoExpireInterval = TimeInterval(60*60*12)
extension MMPlayerDownloader {
    public enum DownloadStatus {
        case none
        case downloadWillStart
        case downloading(value: Float)
        case completed(info: MMPlayerDownLoadVideoInfo)
        case failed(err: String)
        case cancelled
        case exist
    }
}

public class MMPlayerDownloader: NSObject {
    private var _downloadInfo = [MMPlayerDownLoadVideoInfo]()
    private let queue = DispatchQueue(label: "MMPlayerDownloader.Request")
    private let download: MMPlayerDownloadManager
    private var mapList = [URL: MMPlayerDownloadRequest]()
    private var plistPath: URL {
        return self.downloadPathInfo.fullPath.appendingPathComponent("Video")
    }

    let downloadObserverManager = MMPlayerMapObserverManager<URL,((DownloadStatus) -> Void)>()
    let downloadPathInfo: DownloaderPath

    public static let shared: MMPlayerDownloader = {
        let shared =  MMPlayerDownloader.init(subPath: "MMPlayerVideo/Share")
        return shared
    }()
    
    static public func cleanTmpFile() {
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory()) else {
            return
        }
        let pathURL = items.compactMap { $0.contains(".tmp") ? URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent($0, isDirectory: false) : nil }
        pathURL.forEach {
            try? FileManager.default.removeItem(at: $0)
        }
    }

    public private(set) var downloadInfo: [MMPlayerDownLoadVideoInfo] {
        set {
            let data = try? JSONEncoder().encode(newValue)
            try? data?.write(to: plistPath, options: .atomic)
            self._downloadInfo = newValue
        } get {
            return self._downloadInfo
        }
    }
    
    public init(subPath sub: String) {
        self.downloadPathInfo = (URL.init(fileURLWithPath: VideoBasePath).appendingPathComponent(sub), sub)
        self.download = MMPlayerDownloadManager(identifier: sub)
        super.init()
        self.create(path: self.downloadPathInfo.fullPath.path)
        self.createPlist(path: plistPath.path)
        if let info = try? Data.init(contentsOf: plistPath) {
            self._downloadInfo = info.decodeObject() ?? [MMPlayerDownLoadVideoInfo]()
        }
    }
    
    public func deleteVideo(_ videoInfo: MMPlayerDownLoadVideoInfo) {
        downloadInfo.removeAll { (info) -> Bool in
            if info == videoInfo {
                try? FileManager.default.removeItem(at: info.localURL)
                self.downloadObserverManager[info.url].forEach({ $0(.none) })
                return true
            }
            return false
        }
    }
    
    public func localFileFrom(url: URL) -> MMPlayerDownLoadVideoInfo? {
        return downloadInfo.first { (info) -> Bool in
            return info.url == url
        }
    }
    
    public func localFileFrom(name: String) -> MMPlayerDownLoadVideoInfo? {
        return downloadInfo.first { (info) -> Bool in
            return info.fileName == name
        }
    }
    
    public func observe(downloadURL: URL, status: @escaping ((_ status: MMPlayerDownloader.DownloadStatus) -> Void)) -> MMPlayerObservation {
        let value = self.downloadObserverManager.add(key: downloadURL, observer: status)
        if self.localFileFrom(url: downloadURL) != nil {
            self.downloadObserverManager[downloadURL].forEach({ $0(.exist) })
        }
        return value
    }
    
    public func download(url: URL, fileName: String? = nil, coverExist: Bool = false) {
        queue.async { [weak self] in
            guard let self = self else {return}
            if url.isFileURL {
                fatalError("Input fileURL are Invalid")
            }
            
            if !coverExist, let _ = self.localFileFrom(url: url) {
                self.downloadObserverManager[url].forEach({ $0(.exist) })
                return
            }
            
            if self.mapList[url] != nil { return }
            self.downloadInfo.removeAll { $0.url == url }
            self.mapList[url] = MMPlayerDownloadRequest(url: url,
                                                        pathInfo: self.downloadPathInfo,
                                                        fileName: fileName,
                                                        manager: self.download)
            self.mapList[url]?.start(status: { [weak self] (status) in
                guard let self = self else {return}
                self.downloadObserverManager[url].forEach({ $0(status) })
                switch status {
                case .completed(let info):
                    self.downloadInfo.append(info)
                    self.mapList[url] = nil
                case  .cancelled , .failed:
                    self.mapList[url] = nil
                default:
                    break
                }
            })
        }
    }
    
    private func create(path: String) {
        let manager = FileManager.default
        var dir: ObjCBool = false
        if !manager.fileExists(atPath: path, isDirectory: &dir) {
            do {
                try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error create Dire")
            }
        }
    }
    
    private func createPlist(path: String) {
        let manager = FileManager.default
        var dir: ObjCBool = false
        if !manager.fileExists(atPath: path, isDirectory: &dir) {
            manager.createFile(atPath: path, contents: nil, attributes: nil)
        }
    }
}

