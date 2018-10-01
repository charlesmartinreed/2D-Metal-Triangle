//
//  Vertex.swift
//  HelloMetal
//
//  Created by Charles Martin Reed on 10/1/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

struct Vertex{
    var x,y,z: Float // vertex position data
    var r,g,b,a: Float // color data
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
}
