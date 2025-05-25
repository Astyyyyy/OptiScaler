cbuffer Params : register(b0)
{
    uint width;
    uint height;
    uint offset;
    uint velocity;
};

// Input texture
Texture2D<float3> SourceTexture : register(t0);

// Output texture
RWTexture2D<float3> DestinationTexture : register(u0);

// Compute shader thread group size
[numthreads(16, 16, 1)]
void CSMain(uint3 dispatchThreadID : SV_DispatchThreadID)
{
    if (dispatchThreadID.y < offset || dispatchThreadID.y > (height + offset))
        return;

    uint2 pixelCoord = uint2(dispatchThreadID.x, height - dispatchThreadID.y - offset);
    
    if (velocity == 0)
    {
        DestinationTexture[pixelCoord] = SourceTexture[dispatchThreadID.xy];
        return;
    }
    
    float3 srcColor = SourceTexture.Load(int3(dispatchThreadID.xy, 0));
    DestinationTexture[pixelCoord] = float3(srcColor.r, -srcColor.g, 0);
}