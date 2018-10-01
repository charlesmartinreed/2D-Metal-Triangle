//
//  Node.swift
//  HelloMetal
//
//  Created by Charles Martin Reed on 10/1/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import Foundation
import Metal
import QuartzCore

class Node {
    
    //MARK:- Transformation properties
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var scale: Float = 1.0
    
    let device: MTLDevice
    let name: String
    var vertexCount: Int
    var vertexBuffer: MTLBuffer! // is force unwrapping going to cause a crash here?
    
    init(name: String, vertices: Array<Vertex>, device: MTLDevice) {
        
        // go through each vertex and form a single buffer of Floats, stuffed into an array
        var vertexData = Array<Float>()
        for vertex in vertices {
            vertexData += vertex.floatBuffer() //[x,y,z,r,g,b,a , x,y,z,r,g,b,a , ...]
        }
        
        // create a vertex buffer using the created float buffer
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])
        
        // set your instance variables
        self.name = name
        self.device = device
        vertexCount = vertices.count
    }
    
    //MARK:- Rendring code
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, projectionMatrix: Matrix4, clearColor: MTLClearColor?) {
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // passing vertex data to the shaders as UNIFORM DATA
        let nodeModelMatrix = self.modelMatrix()
        
        let uniformBuffer = device.makeBuffer(length: MemoryLayout<Float>.size * Matrix4.numberOfElements() * 2, options: [])! // create buffer using shared CPU/GPU memory
        
        let bufferPointer = uniformBuffer.contents() // contents() returns a memory address, i.e, raw pointer
        memcpy(bufferPointer, nodeModelMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements()) // copy matrix data into the buffer
        memcpy(bufferPointer + MemoryLayout<Float>.size * Matrix4.numberOfElements(), projectionMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())
        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1) // send the uniformBuffer off to the vertex shader
        
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount/3)
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
    //MARK: Model matrix creation method
    func modelMatrix() -> Matrix4 {
        let matrix = Matrix4()
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        return matrix
    }
}
