/// Implements the basic framework for the object system used in HyperonXi
module hxioutils;

struct MinimumVersion
{
	int revision;
}

struct CurrentVersion
{
	int revision;
}

enum ErrorCode : int
{
	NoError = 0,
	NullPointer = 1,
	NotImplemented = int.max
}

static if ((void*).sizeof > int.sizeof)
{
	alias isized = long;
	alias usized = ulong;
}
else
{
	alias isized = int;
	alias usized = uint;
}
