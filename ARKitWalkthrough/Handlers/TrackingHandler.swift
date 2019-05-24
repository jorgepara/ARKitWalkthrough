//
//  TrackingHandler.swift
//  ARKitWalkthrough
//
//  Copyright © 2019-present Para Molina, Jorge. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import ARKit

/// AR handler for showcase of tracking of an image
internal class TrackingHandler: ARHandler {

    lazy var configuration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "cognizant", bundle: nil) else {
            fatalError("Missing reference images")
        }
        configuration.detectionImages = referenceImages
        return configuration
    }()

    var sessionOptions: ARSession.RunOptions = [.removeExistingAnchors]
    var debugOptions: ARSCNDebugOptions = []
    var sceneUpdateQueue: DispatchQueue? = nil

    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }

        sceneUpdateQueue?.async { [weak self] in
            guard let self = self else { return }
            let nodeAndPlayer = self.createVideo(forReferenceImage: imageAnchor.referenceImage, withVideoName: "How Digital Can Bring Buildings To Life  Cognizant.mp4")
            nodeAndPlayer.videoPlayer.play()
            node.addChildNode(nodeAndPlayer.videoNode)
        }
    }

    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode) {}

    /// Creates a SKVideoNode for the image received as a parameter and the content
    /// specified by videoName
    ///
    /// - Parameters:
    ///   - referenceImage: the image that will be covered with the video
    ///   - videoName: the name of the video to play
    /// - Returns: a tuple with the node and the video player
    private func createVideo(forReferenceImage referenceImage: ARReferenceImage, withVideoName videoName: String) -> (videoNode: SCNNode, videoPlayer: SKVideoNode) {

        let width = CGFloat(referenceImage.physicalSize.width)
        let height = CGFloat(referenceImage.physicalSize.height)

        let video = SCNNode(geometry: SCNPlane(width: width, height: height))
        video.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)

        let videoPlayer = SKVideoNode(fileNamed: videoName)
        videoPlayer.yScale = -1
        let spriteKitScene = SKScene(size: CGSize(width: 600, height: 300))
        spriteKitScene.scaleMode = .aspectFit
        videoPlayer.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        videoPlayer.size = spriteKitScene.size
        spriteKitScene.addChild(videoPlayer)

        video.geometry?.firstMaterial?.diffuse.contents = spriteKitScene

        return (video, videoPlayer)
    }

}
