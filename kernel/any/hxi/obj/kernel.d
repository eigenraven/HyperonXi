module hxi.obj.kernel;
public import hxioutils;
/++
The main kernel object coordinating execution
++/
@CurrentVersion(1)
struct Kernel
{
	/// The method dispatch table reference
	VTable* vtable;
	@MinimumVersion(1)
	ushort versionMajor;
	@MinimumVersion(1)
	ushort versionMinor;
	@MinimumVersion(1)
	ushort versionRevision;
	@MinimumVersion(1)
	ushort versionBuild;

	static struct VTable
	{
		extern(C) nothrow @nogc
		{
		/++ First initialization function, filling in the fields of this object. +/
		@MinimumVersion(1) //
		alias InitializeEarlyFPtr = ErrorCode function(Kernel* this_);
/++ Sample impl:
---
private extern(C) nothrow @nogc//
ErrorCode Kernel_InitializeEarly(Kernel* this_)
{
with(this_){
	// TODO: Fill with code
	return ErrorCode.NotImplemented;
}}
---
++/
		InitializeEarlyFPtr InitializeEarly;
		}
	}
}

