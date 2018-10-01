//
//  Shaders.metal
//  HelloMetal
//
//  Created by Charles Martin Reed on 10/1/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

// because we're now sending color data with our vertex, we need to disambiguate between what is color info and what is positional info.
struct VertexIn{
    packed_float3 position;
    packed_float4 color;
};

struct VertexOut{
    // because Vertex Shaders must always return positional information, we use the special qualifer [[ position ]] to get to the position component in a vertex.
    float4 position [[ position ]];
    float4 color;
};

// vertex shaders must begin with they keyword 'vertex'
// 'VertexOut' is the return type, a vector of 4 floats for position and 4 floats for color information (rgba)
// basic_vertex is the name of the vertex shader
vertex VertexOut basic_vertex(
    // parameter is a pointer to an array; a packed vector of 3 floats. Populated by the first buffer of data sent to vertex shader.
    const device VertexIn* vertex_array [[ buffer(0) ]],
    // second param, uses the vertex_id attr to fill in the returned vertex with the index of a particular vertex within the vertex array
    unsigned int vid [[ vertex_id ]]) {
    
    VertexIn VertexIn = vertex_array[vid]; // get the current vertex from array
    
    VertexOut VertexOut; // create VertexOut and pass data from VertexIn to VertexOut
    VertexOut.position = float4(VertexIn.position, 1);
    VertexOut.color = VertexIn.color;
    
    return VertexOut;
}

// creating our fragment
fragment half4 basic_fragment(VertexOut interpolated [[ stage_in ]]) {
    // must at least return the final color of the fragment
    // half4 is a 4-component color value, RGBA, in this case (1,1,1,1) or white.
    // half4 is more memory efficient than float4 which is why we use it here. Writes to less GPU memory.
    //color will be interpolated based on position of fragment you're rendering
    return half4(interpolated.color[0], interpolated.color[1], interpolated.color[2], interpolated.color[3]);
}



