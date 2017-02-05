import std.algorithm, std.range, std.array, std.format, std.string;
import std.stdio, std.math, std.file, std.getopt, std.path;
import yaml;

immutable helpString = "Usage: %s [options] [inputfile] [outputfile], defaults to stdin/out";

enum OutputLang
{
	d
}

enum DataTypeAtom
{
	u8,
	i8,
	u16,
	i16,
	u32,
	i32,
	u64,
	i64,
	usz,
	isz,
	bool32,
	thistype,
	object,
	enumeration
}

enum Inoutness
{
	input,
	output,
	io
}

struct DataType
{
	DataTypeAtom type;
	string objectName;
	bool isArray;
}

struct Field
{
	int minVersion = 0;
	string name = "data";
	DataType type;
}

struct MethodArgument
{
	string name = "arg";
	DataType type;
	Inoutness io;
}

struct Method
{
	string name = "unknown";
	string docs = "Undocumented";
	int minVersion = 0;
	MethodArgument[] arguments;
}

struct Class
{
	string name = "Unknown";
	string docs = "Undocumented";
	int curVersion = 0;
	Field[] fields;
	Method[] methods;
}

struct EnumValue
{
	int minVersion = 0;
	string key;
	long value;
}

struct Enum
{
	string name = "UnknownEnum";
	string docs = "Undocumented";
	int curVersion = 0;
	DataType type;
	EnumValue[] evalues;
}

DataType parseType(string data)
{
	DataType result;
	string[] sdata = split(data);
	if (sdata.length == 2)
	{
		if (sdata[0] == "array")
		{
			result.isArray = true;
		}
		else
		{
			throw new Exception("Wrong multi-word datatype " ~ data);
		}
	}
	else if (sdata.length > 2)
	{
		throw new Exception("Wrong multi-word datatype " ~ data);
	}
	switch (sdata[$ - 1])
	{
	case "THIS":
		result.type = DataTypeAtom.thistype;
		break;
	case "u8":
		result.type = DataTypeAtom.u8;
		break;
	case "i8":
		result.type = DataTypeAtom.i8;
		break;
	case "u16":
		result.type = DataTypeAtom.u16;
		break;
	case "i16":
		result.type = DataTypeAtom.i16;
		break;
	case "u32":
		result.type = DataTypeAtom.u32;
		break;
	case "i32":
		result.type = DataTypeAtom.i32;
		break;
	case "u64":
		result.type = DataTypeAtom.u64;
		break;
	case "i64":
		result.type = DataTypeAtom.i64;
		break;
	case "bool32":
		result.type = DataTypeAtom.bool32;
		break;
	case "usz":
		result.type = DataTypeAtom.usz;
		break;
	case "isz":
		result.type = DataTypeAtom.isz;
		break;
	default:
		result.type = (sdata[$ - 1][$ - 1] == '#') ? DataTypeAtom.enumeration : DataTypeAtom.object;
		result.objectName = sdata[$ - 1].chomp("#");
		break;
	}
	return result;
}

Field[] parseFields(Node collection)
{
	Field[] results;
	int it = 0;
	foreach (ref int mVersion, ref Node froot; collection)
	{
		foreach (ref string fieldName, ref Node fieldType; froot)
		{
			Field fld;
			fld.minVersion = mVersion;
			fld.name = fieldName;
			fld.type = parseType(fieldType.as!string);
			results ~= fld;
		}
	}
	return results;
}

MethodArgument[] parseMArgs(Node collection)
{
	MethodArgument[] results;
	foreach (ref string argName, ref string argType; collection)
	{
		string ioness, type;
		auto res = findSplit(argType, " ");
		ioness = res[0];
		type = res[2];
		MethodArgument fld;
		fld.name = argName;
		switch (ioness)
		{
		case "in":
			fld.io = Inoutness.input;
			break;
		case "out":
			fld.io = Inoutness.output;
			break;
		case "inout":
			fld.io = Inoutness.io;
			break;
		default:
			throw new Exception("Wrong inoutness: " ~ ioness);
		}
		fld.type = parseType(type);
		results ~= fld;
	}
	return results;
}

Method[] parseMethods(Node collection)
{
	Method[] results;
	foreach (ref int mVersion, ref Node froot; collection)
	{
		foreach (ref string methodName, ref Node methodData; froot)
		{
			Method mth;
			mth.minVersion = mVersion;
			mth.name = methodName;
			if (methodData.containsKey("docs"))
				mth.docs = methodData["docs"].as!string;
			mth.arguments = parseMArgs(methodData["arguments"]);
			results ~= mth;
		}
	}
	return results;
}

Class[] parseClasses(Node root)
{
	Class[] results;
	foreach (ref string className, ref Node classNode; root)
	{
		if (className.endsWith("#")) // is an enum
			continue;
		Class cls;
		cls.name = className;
		if (classNode.containsKey("docs"))
			cls.docs = classNode["docs"].as!string;
		cls.curVersion = classNode["version"].as!int();
		if (classNode.containsKey("fields"))
			cls.fields = parseFields(classNode["fields"]);
		if (classNode.containsKey("methods"))
			cls.methods = parseMethods(classNode["methods"]);
		results ~= cls;
	}
	return results;
}

Enum[] parseEnums(Node root)
{
	Enum[] results;
	foreach (ref string enumName, ref Node enumNode; root)
	{
		if (!enumName.endsWith("#")) // is a class
			continue;
		Enum enm;
		enm.name = enumName;
		if (enumNode.containsKey("docs"))
			enm.docs = enumNode["docs"].as!string;
		enm.curVersion = enumNode["version"].as!int();
		enm.type = parseType(enumNode["type"].as!string);
		long eval = -1;
		foreach (ref int version_, ref Node valset; enumNode["values"])
			foreach (ref string key, ref Node value; valset)
			{
				EnumValue v;
				v.key = key;
				v.minVersion = version_;
				if (value.isNull)
					eval++;
				else
					eval = value.as!long;
				v.value = eval;
				enm.evalues ~= v;
			}
		results ~= enm;
	}
	return results;
}

char[1024 * 1024] inBuffer;
OutputLang outputLanguage = OutputLang.d;
File inputFile;
File outputFile;
bool outputStubs = false;

void main(string[] args)
{
	// dfmt off
	auto gor = getopt(args,
		"f|output-lang", &outputLanguage,
		"s|stubs", &outputStubs);
	// dfmt on
	if (gor.helpWanted)
	{
		defaultGetoptPrinter(helpString.format(args[0]), gor.options);
	}
	string mod_ = "hxi.obj.objects";
	string[] imports;
	inputFile = args.length > 1 ? File(args[1], "rb") : stdin;
	if (args.length > 2)
	{
		outputFile = File(args[2], "wb");
		mod_ = "hxi.obj." ~ baseName(args[2], ".d");
	}
	else
	{
		outputFile = stdout;
	}
	char[] inbuf = inBuffer[];
	inbuf = inputFile.rawRead(inbuf);
	enum string MODDECL = "# module: ";
	if (inbuf.startsWith(MODDECL))
	{
		mod_ = findSplit(inbuf[MODDECL.length .. $], "\n")[0].idup;
	}
	else
	{
		writefln("Warning: input file %s doesn't start with a module declaration (%s)",
				args.length > 1 ? args[1] : "stdin", MODDECL);
	}
	foreach (line; inbuf.lineSplitter)
	{
		enum string IMPDECL = "# import: ";
		if (line.startsWith(IMPDECL))
		{
			imports ~= strip(line[IMPDECL.length .. $].idup);
		}
	}
	Node rootNode = Loader.fromString(inbuf).load();
	Enum[] enums = parseEnums(rootNode);
	Class[] classes = parseClasses(rootNode);
	final switch (outputLanguage)
	{
	case OutputLang.d:
		outputFile.writefln("module %s;", mod_);
		outputFile.writeln("public import hxioutils;");
		foreach (imp; imports)
		{
			outputFile.writefln("public import %s;", imp);
		}
		foreach (enm; enums)
		{
			printDEnum(enm);
			outputFile.writeln();
		}
		foreach (cls; classes)
		{
			printDClass(cls);
			outputFile.writeln();
		}
		break;
	}
}

immutable string[DataTypeAtom] atomToDMappings;

shared static this()
{
	atomToDMappings = [//dfmt off
		DataTypeAtom.u8: "ubyte",
		DataTypeAtom.i8:  "byte",
		DataTypeAtom.u16:"ushort",
		DataTypeAtom.i16: "short",
		DataTypeAtom.u32:"uint",
		DataTypeAtom.i32: "int",
		DataTypeAtom.u64:"ulong",
		DataTypeAtom.i64: "long",
		DataTypeAtom.bool32: "bool32",
		DataTypeAtom.usz:"usized",
		DataTypeAtom.isz:"isized",
		// dfmt on
	];
}

string t2d(const DataType T, string ThisName, bool forceptr = false,
		bool const_ = false, bool addSecondPtr = false)
{
	string rtype;
	bool reft = forceptr;
	if (T.type == DataTypeAtom.object)
	{
		rtype = T.objectName;
		reft = true;
	}
	else if (T.type == DataTypeAtom.enumeration)
	{
		rtype = T.objectName;
	}
	else if (T.type == DataTypeAtom.thistype)
	{
		rtype = ThisName;
		reft = true;
	}
	else
	{
		rtype = atomToDMappings[T.type];
		addSecondPtr = false;
	}
	if (const_)
	{
		return format("const(%s)%s%s", rtype, reft ? "*" : "", addSecondPtr ? "*" : "");
	}
	else
	{
		return format("%s%s%s", rtype, reft ? "*" : "", addSecondPtr ? "*" : "");
	}
}

void printDEnum(const Enum enm)
{
	outputFile.writeln("/++");
	outputFile.writeln(enm.docs);
	outputFile.writeln("++/");
	outputFile.writefln("@CurrentVersion(%d)", enm.curVersion);
	outputFile.writefln("enum %s : %s", enm.name[0 .. $ - 1], t2d(enm.type, enm.name));
	outputFile.writeln("{");
	foreach (const EnumValue val; enm.evalues)
	{
		outputFile.writefln("\t/// Minimum version: %d", val.minVersion);
		outputFile.writefln("\t%-30s = %s0x%04X,", val.key, val.value < 0
				? '-' : ' ', abs(val.value));
	}
	outputFile.writeln("}");
}

void printDClass(const Class cls)
{
	outputFile.writeln("/++");
	outputFile.writeln(cls.docs);
	outputFile.writeln("++/");
	outputFile.writefln("@CurrentVersion(%d)", cls.curVersion);
	outputFile.writefln("struct %s", cls.name);
	outputFile.writeln("{");
	outputFile.writeln("\t/// The method dispatch table reference");
	outputFile.writeln("\tVTable* vtable;");
	//fields
	foreach (const Field fld; cls.fields)
	{
		if (fld.type.isArray)
		{
			outputFile.writefln("\t@MinimumVersion(%d)", fld.minVersion);
			outputFile.writefln("\t%s %s;", atomToDMappings[DataTypeAtom.usz], fld.name ~ "Len");
			outputFile.writefln("\t@MinimumVersion(%d)", fld.minVersion);
			outputFile.writefln("\t%s %s;", t2d(fld.type, cls.name, true,
					false, true), fld.name ~ "Data");
		}
		else
		{
			outputFile.writefln("\t@MinimumVersion(%d)", fld.minVersion);
			outputFile.writefln("\t%s %s;", t2d(fld.type, cls.name), fld.name);
		}
	}
	outputFile.writeln();
	//methods
	outputFile.writeln("\tstatic struct VTable\n\t{");
	outputFile.writeln("\t\textern(C) nothrow @nogc\n\t\t{");
	foreach (const Method mth; cls.methods)
	{
		string argstr = "";
		outputFile.writefln("\t\t/++ %s +/", mth.docs);
		outputFile.writefln("\t\t@MinimumVersion(%d) //", mth.minVersion);
		outputFile.writef("\t\talias %sFPtr = ErrorCode function(", mth.name);
		foreach (const MethodArgument arg; mth.arguments)
		{
			bool const_ = (arg.io == Inoutness.input);
			string argname = arg.name;
			if (argname == "this")
			{
				argname = "this_";
			}
			else if (argname == "return")
			{
				argname = "return_";
			}
			else if (argname == "align")
			{
				argname = "align_";
			}
			if (arg.type.isArray)
			{
				// emit two arguments
				argstr ~= format("%s %sLen, ", atomToDMappings[DataTypeAtom.usz], argname);
				argstr ~= format("%s %sData, ", t2d(arg.type, cls.name, true,
						const_, true), argname);
			}
			else
			{
				argstr ~= format("%s %s, ", t2d(arg.type, cls.name, !const_, const_), argname);
			}
		}
		argstr = argstr.chomp(", ");
		outputFile.write(argstr);
		outputFile.writeln(");");
		if (outputStubs)
		{
			outputFile.writeln("/++ Sample impl:\n---\nprivate extern(C) nothrow @nogc//");
			outputFile.writefln("ErrorCode %s_%s(%s)", cls.name, mth.name, argstr);
			outputFile.writeln("{");
			bool uthis = false;
			foreach (const MethodArgument arg; mth.arguments)
			{
				if (arg.name == "this")
				{
					uthis = true;
					outputFile.writeln("with(this_){");
				}
				if (arg.type.isArray)
				{
					bool const_ = (arg.io == Inoutness.input);
					outputFile.writefln("\t%s[] %s = %sData[0..%sLen];", t2d(arg.type,
							cls.name, true, const_, true)[0 .. $ - 1], arg.name, arg.name, arg.name);
				}
			}
			outputFile.writeln("\t// TODO: Fill with code");
			outputFile.writeln("\treturn ErrorCode.NotImplemented;");
			outputFile.writefln("%s}\n---\n++/", uthis ? "}" : "");
		}
		outputFile.writefln("\t\t%sFPtr %s;", mth.name, mth.name);
	}
	outputFile.writeln("\t\t}\n\t}\n}");
}
