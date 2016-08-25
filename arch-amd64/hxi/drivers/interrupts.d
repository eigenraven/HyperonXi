module hxi.drivers.interrupts;

import barec;
import hxi.drivers.cpudt;
import hxi.output;

nothrow:
@nogc:

struct InterruptRegisterState
{
    ulong orax;
    ulong errorCode;
    ulong rax, rbx, rcx, rdx, rsi, rdi, rbp, r8, r9, r10, r11, r12, r13, r14, r15;
    ulong interruptNumber;
}

void initializeInterrupts()
{
    for (int i = 0; i < 255; i++)
    {
        kernelIDT[i].selector = SegmentSelector.KernelCode;
        kernelIDT[i].ist = 0;
        kernelIDT[i].type = SystemSegmentType.InterruptGate;
        kernelIDT[i].dpl = 0;
    }
    kernelIDT[0x00].offset = cast(ulong)(&interruptHandler!(0x00, false, hxintDivideByZero));
    kernelIDT[0x00].present = 1;

    kernelIDT[0x01].offset = cast(ulong)(&interruptHandler!(0x01, false, hxintNMI));
    kernelIDT[0x01].present = 1;

    kernelIDT[0x03].offset = cast(ulong)(&interruptHandler!(0x03, false, hxintBreakpoint));
    kernelIDT[0x03].present = 1;

    kernelIDT[0x80].offset = cast(ulong)(&interruptHandler!(0x80, false, hxint80h));
    kernelIDT[0x80].present = 1;

    log(LogLevel.Info, "Reloading IDT");
    lidt(kernelIDT.ptr, kernelIDT.sizeof);
}

void drawMagentascreen(InterruptRegisterState state)
{
    import hxi.fbcon.framebuffer;
    import hxi.fbcon.textbuffer;

    TextFramebuffer* tfb = getLoggingOutputFramebuffer();
    Framebuffer* fb = tfb.driver;
    fb.clear(0xEF00EF);
    foreach (i; 0 .. tfb.textBuffer.length)
    {
        tfb.textBuffer[i].txt = '\0';
    }
    tfb.curX = 1;
    tfb.curY = 1;
    tfb.printChar('\u2639');
    tfb.printStringAttr(" The system crashed");
}

extern (C) void nullHandler(InterruptRegisterState state)
{
    log(LogLevel.Error, "Unhandled interrupt");
}

extern (C) void hxintDivideByZero(InterruptRegisterState state)
{
    log(LogLevel.Error, "Division by zero!!!");
    drawMagentascreen(state);
    asm nothrow @nogc
    {
    deadloop:
        cli;
        hlt;
        jmp deadloop;
    }
}

extern (C) void hxintNMI(InterruptRegisterState state)
{
    log(LogLevel.Warn, "Unhandled NMI");
}

extern (C) void hxintBreakpoint(InterruptRegisterState state)
{
    log(LogLevel.Warn, "Unhandled breakpoint");
}

extern (C) void hxint80h(InterruptRegisterState state)
{
    log(LogLevel.Info, "0x80 Interrupt");
}

void interruptHandler(int number, bool hasECode = false, alias handler)() nothrow @nogc
{
    asm nothrow @nogc
    {
        naked;
    }
    static if (!hasECode)
    {
        asm nothrow @nogc
        {
            push RAX;
        }
    }
    asm nothrow @nogc
    {
        push RAX;
        push RBX;
        push RCX;
        push RDX;
        push RSI;
        push RDI;
        push RBP;
        push R8;
        push R9;
        push R10;
        push R11;
        push R12;
        push R13;
        push R14;
        push R15;
        mov RAX, number;
        push number;

        call handler;

        add RSP, 8; // drop number

        pop R15;
        pop R14;
        pop R13;
        pop R12;
        pop R11;
        pop R10;
        pop R9;
        pop R8;
        pop RBP;
        pop RDI;
        pop RSI;
        pop RDX;
        pop RCX;
        pop RBX;
        pop RAX;
    }
    asm nothrow @nogc
    {
        add RSP, 8; // drop exception code
        iretq;
    }
}
