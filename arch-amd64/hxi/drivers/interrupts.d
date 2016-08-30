module hxi.drivers.interrupts;

import barec;
import hxi.drivers.cpudt;
import hxi.output;

nothrow:
@nogc:

struct InterruptRegisterState
{
    ulong interruptNumber;
    ulong rax, rbx, rcx, rdx, rsi, rdi, rbp, r8, r9, r10, r11, r12, r13, r14, r15;
    ulong errorCode;
    ulong rip;
    ulong cs;
    ulong rflags;
    ulong rsp;
    ulong ss;
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

    static void mvPrint(TextFramebuffer* tfb, int y, int x, wstring text) nothrow @nogc
    {
        tfb.curX = x;
        tfb.curY = y;
        tfb.printStringAttr(text);
    }

    mvPrint(tfb, 1, 1, "\u2755 The system crashed (#"w);
    tfb.printULong(state.interruptNumber);
    tfb.printStringAttr(" E:");
    tfb.printULong(state.errorCode);
    tfb.printChar(')');
    mvPrint(tfb, 2, 2, "Crash at RIP=");
    tfb.printULong(state.rip);
    mvPrint(tfb, 3, 1, "Registers:"w);
    mvPrint(tfb, 4, 1, "RAX → "w);
    tfb.printULong(state.rax);
    mvPrint(tfb, 5, 1, "RBX → "w);
    tfb.printULong(state.rbx);
    mvPrint(tfb, 6, 1, "RCX → "w);
    tfb.printULong(state.rcx);
    mvPrint(tfb, 7, 1, "RDX → "w);
    tfb.printULong(state.rdx);
    mvPrint(tfb, 8, 1, "RSI → "w);
    tfb.printULong(state.rsi);
    mvPrint(tfb, 9, 1, "RDI → "w);
    tfb.printULong(state.rdi);
    mvPrint(tfb, 10, 1, "RBP → "w);
    tfb.printULong(state.rbp);
    mvPrint(tfb, 11, 1, "RSP → "w);
    tfb.printULong(state.rsp);
    mvPrint(tfb, 4, 29, "R8  → "w);
    tfb.printULong(state.r8);
    mvPrint(tfb, 5, 29, "R9  → "w);
    tfb.printULong(state.r9);
    mvPrint(tfb, 6, 29, "R10 → "w);
    tfb.printULong(state.r10);
    mvPrint(tfb, 7, 29, "R11 → "w);
    tfb.printULong(state.r11);
    mvPrint(tfb, 8, 29, "R12 → "w);
    tfb.printULong(state.r12);
    mvPrint(tfb, 9, 29, "R13 → "w);
    tfb.printULong(state.r13);
    mvPrint(tfb, 10, 29, "R14 → "w);
    tfb.printULong(state.r14);
    mvPrint(tfb, 11, 29, "R15 → "w);
    tfb.printULong(state.r15);
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
            push 0;
        }
    }
    asm nothrow @nogc
    {
        push R15;
        push R14;
        push R13;
        push R12;
        push R11;
        push R10;
        push R9;
        push R8;
        push RBP;
        push RDI;
        push RSI;
        push RDX;
        push RCX;
        push RBX;
        push RAX;
        mov RAX, number;
        push number;

        call handler;

        add RSP, 8; // drop number

        pop RAX;
        pop RBX;
        pop RCX;
        pop RDX;
        pop RSI;
        pop RDI;
        pop RBP;
        pop R8;
        pop R9;
        pop R10;
        pop R11;
        pop R12;
        pop R13;
        pop R14;
        pop R15;
    }
    asm nothrow @nogc
    {
        add RSP, 8; // drop exception code
        iretq;
    }
}
