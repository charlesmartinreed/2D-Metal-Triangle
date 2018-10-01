//
//  Shaders.metal
//  HelloMetal
//
//  Created by Charles Martin Reed on 10/1/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

// vertex shaders must begin with they keyword 'vertex'
// 'float4' is the return type, a vector of 4 floats
// basic_vertex is the name of the vertex shader
vertex float4 basic_vertex(
    // parameter is a pointer to an array; a packed vector of 3 floats. Populated by the first buffer of data sent to vertex shader.
    const device packed_float3* vertex_array [[ buffer(0) ]],
    // second param, uses the vertex_id attr to fill in the returned vertex with the index of a particular vertex within the vertex array
    unsigned int vid [[ vertex_id ]]) {
        // returns the final position of the vertex by looking up the position of a vertex in vid position, converting the whole thing to a float4 with the final value of 1.0 for 3D math purposes.
        return float4(vertex_array[vid], 1.0);
}

// creating our fragment
fragment half4 basic_fragment() {
    // must at least return the final color of the fragment
    // half4 is a 4-component color value, RGBA, in this case (1,1,1,1) or white.
    // half4 is more memory efficient than float4 which is why we use it here. Writes to less GPU memory.
    return half4(1.0);
}



