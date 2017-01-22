module hxi.fbcon.gfxfont;

import hxi.fbcon.types;
import hxi.fbcon.font_import;
import kstdlib;

nothrow:
@nogc:

FbMonoBitmap getCharBitmap(dchar ch)
{
    if (ch > confont_charcount)
    {
        ch = 0;
    }
    short dimx = cast(short)(confont_chars[ch * 2] * confont_charwidth);
    short dimy = cast(short) confont_charheight;
    size_t offset = confont_chars[ch * 2 + 1];
    size_t len = dimx * dimy / 8;
    return FbMonoBitmap(dimx, dimy, confont_bitmap[offset .. offset + len]);
}
