/// Implementation of the RS232 driver for the x86 architecture
module hxi.cpu.rs232;

import kstdlib;
public import hxi.obj.serialport;

immutable ushort[4] StandardPCSerialPortIDs = [0x3F8, 0x2F8, 0x3E8, 0x2E8];
immutable ubyte[4] StandardPCSerialPortIRQs = [4,3,4,3];

enum ubyte PCSERIAL_OFFSET_DATA = 0;
enum ubyte PCSERIAL_OFFSET_INTERRUPTENABLE = 1;
enum ubyte PCSERIAL_OFFSET_INTERRUPTID_FIFO = 2;
enum ubyte PCSERIAL_OFFSET_LINECONTROL = 3;
enum ubyte PCSERIAL_OFFSET_MODEMCONTROL = 4;
enum ubyte PCSERIAL_OFFSET_LINESTATUS = 5;
enum ubyte PCSERIAL_OFFSET_MODEMSTATUS = 6;
enum ubyte PCSERIAL_OFFSET_SCRATCH = 7;
