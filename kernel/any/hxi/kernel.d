module hxi.kernel;

import kstdlib;
import hxi.obj.kernel;

private extern (C) nothrow @nogc //
ErrorCode Kernel_InitializeEarly(Kernel* this_)
{
	with (this_)
	{
		versionMajor = 1;
		versionMinor = 0;
		versionRevision = 0;
		versionBuild = 0;
		return ErrorCode.NoError;
	}
}

__gshared Kernel.VTable KernelVTable = Kernel.VTable( //
		&Kernel_InitializeEarly, //
		);

__gshared Kernel TheKernel = Kernel(&KernelVTable);
