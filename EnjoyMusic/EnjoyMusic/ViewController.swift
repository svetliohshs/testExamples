//
//  ViewController.swift
//  EnjoyMusic
//
//  Created by Svetoslav S. Bramchev on 12/20/16.
//  Copyright © 2016 musala. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate {

    var audioFilePlayer: AVAudioPlayerNode = AVAudioPlayerNode()
    var player:AVAudioPlayer = AVAudioPlayer()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var buffers:[AVAudioPCMBuffer] = []
    
    
    var engine = AVAudioEngine()
    var engine1 = AVAudioEngine()
    //var distortion = AVAudioUnitDistortion()
    var reverb = AVAudioUnitReverb()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup engine and node instances
        assert(engine.inputNode != nil)
        let input = engine.inputNode!
        let format = input.inputFormat(forBus: 0)
        
        input.installTap(onBus: 0, bufferSize: 8192, format: format, block: {(buffer, time) in
            //print(buffer)
            //let data = Data(buffer:buffer)
            //self.buffers.append(buffer)
            
            let data = self.toNSData(PCMBuffer: buffer)
            let buffer1 = self.toPCMBuffer(data: data)
           
            self.playBuffer(buffer:buffer)
            if(self.buffers.count > 25){
                input.removeTap(onBus: 0)
            }
        })
        
        
        // Start engine
        do {
            try engine.start()
        } catch {
            assertionFailure("AVAudioEngine start error: \(error)")
        }
        

    }
    
    
    func toNSData(PCMBuffer: AVAudioPCMBuffer) -> NSData {
        let channelCount = 1  // given PCMBuffer channel count is 1
        let channels = UnsafeBufferPointer(start: PCMBuffer.floatChannelData, count: channelCount)
        let ch0Data = NSData(bytes: channels[0], length:Int(PCMBuffer.frameCapacity * PCMBuffer.format.streamDescription.pointee.mBytesPerFrame))
        return ch0Data
    }
    
    func toPCMBuffer(data: NSData) -> AVAudioPCMBuffer {
        let audioFormat = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatFloat32, sampleRate: 8192, channels: 1, interleaved: false)  // given NSData audio format
        let PCMBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(data.length) / audioFormat.streamDescription.pointee.mBytesPerFrame)
        PCMBuffer.frameLength = PCMBuffer.frameCapacity
        let channels = UnsafeBufferPointer(start: PCMBuffer.floatChannelData, count: Int(PCMBuffer.format.channelCount))
        data.getBytes(UnsafeMutableRawPointer(channels[0]) , length: data.length)
        return PCMBuffer
    }
    
    
    
    
    var i = 0;
    
    func playBuffer(buffer:AVAudioPCMBuffer){
        
        i += 1
        var request = URLRequest(url: URL(string: "http://169.254.91.237:3000/post")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["newbuffer":self.toNSData(PCMBuffer: buffer).base64EncodedString()], options: [])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            print(data)
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
        
        
        self.engine1 = AVAudioEngine()
        let mainMixer = self.engine1.mainMixerNode
        self.engine1.attach(self.audioFilePlayer)
        self.engine1.connect(self.audioFilePlayer, to:mainMixer, format: buffer.format)
        do {
            try self.engine1.start()
        } catch {
            assertionFailure("AVAudioEngine start error: \(error)")
        }

        self.audioFilePlayer.play()
        self.audioFilePlayer.scheduleBuffer(buffer, completionHandler: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

