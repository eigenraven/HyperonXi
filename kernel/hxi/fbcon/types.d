module hxi.fbcon.types;

import barec;

/// Monochromatic bitmap
struct FbMonoBitmap
{
    /// Dimensions in pixels (== bits)
    /// Width must be aligned to 8-bit boundary
    ushort w, h;
    /// Row-major bit array
    const(ubyte)[] bytes;
}

/// Grayscale bitmap
struct FbGrayBitmap
{
    /// Dimensions in pixels
    ushort w, h;
    /// Row-major pixel brightness values
    const(ubyte)[] bytes;
}

/// Grayscale bitmap
struct FbRGBBitmap
{
    /// Dimensions in pixels
    ushort w, h;
    /// Row-major pixel color values (in R,G,B order)
    const(ubyte)[] bytes;
}
