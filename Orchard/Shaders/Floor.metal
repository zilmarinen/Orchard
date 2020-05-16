//
//  Floor.metal
//  Meadow
//
//  Created by Zack Brown on 06/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include <SceneKit/scn_metal>

struct NodeBuffer {
    
    float4x4 modelTransform;
    float4x4 inverseModelTransform;
    float4x4 modelViewTransform;
    float4x4 inverseModelViewTransform;
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
    float4x4 inverseModelViewProjectionTransform;
};

struct Plane {
    
    float3 position;
    float3 normal;
};

struct Ray {
    
    float3 origin;
    float3 direction;
};

struct RayHitTest {
    
    bool hit;
    float3 vector;
    float distance;
};

struct Uniform {
    
    float4 backgroundColor;
    float4 gridColor;
    
    bool rendersGridLines;
};

typedef struct {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    
} Vertex;

struct Fragment {
    
    float4 position [[position]];
    float3 coordinate;
    
    bool hit;
    
    half4 backgroundColor;
    half4 gridColor;
    
    bool rendersGridLines;
};

constant float epsilon = 0.0001;
constant Plane plane = Plane { .position =  float3(0.0, -5.0, 0.0), .normal = float3(0.0, 1.0, 0.0) };

RayHitTest intersect(Plane plane, Ray ray) {
    
    float denominator = dot(plane.normal, ray.direction);
    
    if (fabs(denominator) > epsilon) {
        
        float3 difference = normalize(plane.position - ray.origin);
        
        float distance = dot(difference, plane.normal) / denominator;
        
        if (distance > epsilon) {
            
            return RayHitTest { .hit = true, .distance = distance, .vector = ray.origin + (ray.direction * distance) };
        }
    }
    
    return RayHitTest { .hit = false };
}

vertex Fragment floor_vertex(Vertex v [[ stage_in ]], constant SCNSceneBuffer& scn_frame [[buffer(0)]], constant NodeBuffer& scn_node [[buffer(1)]], constant Uniform& uniform [[buffer(2)]]) {
    
    //float4 vector = float4(-v.position.x, 0.0, v.position.y, 1.0);
    float4 vector = float4(v.position, 1.0);
    
    float3 position = (scn_node.modelViewTransform * vector).xyz;
    
    float3 camera = (float4(float3(0.0), 1.0)).xyz;
    
    float3 direction = (position - camera);
    
    Ray ray = Ray { .origin = camera, .direction = direction };
    
    RayHitTest hitTest = intersect(plane, ray);
    
    Fragment f;
    
    f.position = float4(v.position, 1.0);
    f.coordinate = hitTest.vector;
    f.hit = hitTest.hit;
    f.backgroundColor = half4(uniform.backgroundColor);
    f.gridColor = half4(uniform.gridColor);
    f.rendersGridLines = uniform.rendersGridLines;
    
    return f;
}

fragment half4 floor_fragment(Fragment f [[stage_in]]) {
    
    if (!f.rendersGridLines || !f.hit) {
        
        //return f.backgroundColor;
    }
    
    float2 position = f.coordinate.xz;
    float2 fractional  = abs(fract(position + 0.5));
    float2 partial = fwidth(position);
    
    float2 point = smoothstep(-partial, partial, fractional);
    
    float saturation = 1.0 - saturate(point.x * point.y);
    
    return half4(mix(f.backgroundColor.rgb, f.gridColor.rgb, saturation), 1.0);
}
