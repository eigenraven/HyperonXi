module hxi.fbcon.font_import;

/// Unit for char width
enum int confont_charwidth = 8;
/// Unit for char height
enum int confont_charheight = 16;

extern (C)
{
    /// Bitarray of char data
    extern immutable(ubyte[1713536]) confont_bitmap;
    /// Array of pairs( size (0/1/2 wide), index into confont_bitmap )
    extern immutable(uint[131072]) confont_chars;
}

enum int confont_charcount = cast(int)(confont_chars.length / 2);
