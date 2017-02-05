/// Various utility functions
module hxi.util;

import kstdlib;

nothrow:
@nogc:

/// Returns: true if data is a valid UTF-8 string
pure bool validUTF8(in ubyte[] data)
{
	for (size_t i = 0; i < data.length; i++)
	{
		// 1-byte
		if (data[i] < 0x80)
		{
			continue;
		}
		// 2-byte
		else if ((data[i] & 0xE0) == 0xC0)
		{
			if ((i + 1) >= data.length) // out of bounds
				return false;
			if ((data[i + 1] & 0xC0) != 0x80)
				return false;
			i += 1;
			continue;
		}
		// 3-byte
		else if ((data[i] & 0xF0) == 0xE0)
		{
			if ((i + 2) >= data.length) // out of bounds
				return false;
			if ((data[i + 1] & 0xC0) != 0x80)
				return false;
			if ((data[i + 2] & 0xC0) != 0x80)
				return false;
			i += 2;
			continue;
		}
		// 4-byte
		else if ((data[i] & 0xF8) == 0xF0)
		{
			if ((i + 3) >= data.length) // out of bounds
				return false;
			if ((data[i + 1] & 0xC0) != 0x80)
				return false;
			if ((data[i + 2] & 0xC0) != 0x80)
				return false;
			if ((data[i + 3] & 0xC0) != 0x80)
				return false;
			i += 3;
			continue;
		}
		// unknown
		else
		{
			return false;
		}
	}
	return true;
}

private bool isEnumContiguous(alias Enum)()
{
	long pval = cast(long)(Enum.min);
	foreach (m; EnumMembers!Enum)
	{
		if (cast(long)(m) == pval)
		{
			pval++;
		}
		else
		{
			return false;
		}
	}
	return true;
}

/// Returns: true if value is a part of the Enum.
pure bool validEnumValue(alias Enum)(Enum value)
{
	bool inr = inRange(cast(long) value, cast(long) Enum.min, cast(long) Enum.max);
	static if (isEnumContiguous!Enum)
	{
		return inr;
	}
	else
	{
		if (!inr)
			return false;
		foreach (m; EnumMembers!Enum)
		{
			if (m == value)
				return true;
		}
		return false;
	}
}
