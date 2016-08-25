
section .multiboot
bits 32

extern multiboot_start
extern multiboot_end
extern text_start
extern text_end
extern data_start
extern data_end
extern bss_start
extern bss_end
extern kernel_end
extern kmain

KERNEL_VMA equ 0xFFFF800000000000
STACK_SIZE equ 0x8000 ; 32 KiB

; The multiboot 2 header
	HEADER_START equ $
	dd 0xe85250d6	; magic
	dd 0			; arch
	dd HEADER_LENGTH ; length
	dd 0x100000000-(0xe85250d6 + HEADER_LENGTH) ; checksum
	; tags
	; TAG 1
	dw 2 ; addresses
		dw 0
		dd 24
		dd multiboot_start
		dd multiboot_start
		dd (kernel_end - KERNEL_VMA)
		dd (bss_end - KERNEL_VMA)
	; TAG 2
	dw 3 ; entry address
		dw 0
		dd 16
		dd pstubentry
		dd 0
	; TAG 3
	dw 1 ; information req.
		dw 0
		dd 40
		dd 1
		dd 2
		dd 3
		dd 4
		dd 6
		dd 8
		dd 9
		dd 15
	; TAG 4
	dw 5 ; framebuffer
		dw 0
		dd 24
		dd 1024	;width
		dd 768	;height
		dd 24	;depth
		dd 0
	; END TAG
	dw 0
		dw 0
		dd 8
	HEADER_END equ $
	HEADER_LENGTH equ HEADER_END - HEADER_START

	global pstubentry
	pstubentry:
		; Store multiboot arguments
		mov esi, ebx
		mov edi, eax
		
		; Enable SSE
		mov eax, cr0
		and ax, 0xFFFB  ;clear coprocessor emulation CR0.EM
		or ax, 0x2       ;set coprocessor monitoring  CR0.MP
		mov cr0, eax
		mov eax, cr4
		or ax, 3 << 9   ;set CR4.OSFXSR and CR4.OSXMMEXCPT at the same time
		mov cr4, eax
		
		; Long mode initialisation
		cli
		
		mov eax, cr4 ; Enable long paging
		bts eax, 5
		mov cr4, eax
		
		mov eax, p4_base ; Load the page table
		mov cr3, eax
		
		mov ecx, 0xC0000080 ; Enable SYSCALL/SYSRET & long mode
		rdmsr
		bts eax, 8
		bts eax, 0
		wrmsr
		
		lgdt [pGDT32]
		
		mov eax, cr0 ; Enable long mode by paging
		bts eax, 31
		mov cr0, eax
		
		jmp 0x10:(entry64_lo-KERNEL_VMA) ; 64-bit jump

section .text
bits 64
	
	entry64_lo:
		; setup segment registers
		;mov rax, 0x18
		;mov ds, ax
		;mov es, ax
		;mov fs, ax
		;mov gs, ax
		;mov ss, ax
		; setup stack
		mov rsp, kstack - KERNEL_VMA + STACK_SIZE
		mov rbp, rsp
		; return
		push 0x10
		mov rax, KERNEL_VMA >> 32
		shl rax, 32
		or rax, entry64_hi - (KERNEL_VMA & 0xffffffff00000000)
		push rax
		
		ret
	entry64_hi:
		; setup virtual stack
		mov rax, KERNEL_VMA >> 32
		shl rax, 32
		or rax, kstack + STACK_SIZE - (KERNEL_VMA & 0xffffffff00000000)
		mov rsp, rax
		xor rbp, rbp
		; set cpu flags
		push 0
		lss eax, [rsp]
		popf
		; IOPL = 3
		pushf
		pop rax
		or rax, 0x3000
		push rax
		popf
		; Push multiboot parameters
		mov rax, 0xfffffffffffffff0
		and rsp, rax
		mov rbp, rsp
		push rsi
		push rdi
		; Call kmain
		call kmain
		.deadloop: ; Should be unreachable
			cli
			hlt
			jmp .deadloop
			nop
			nop

global reload_gdt

reload_gdt:
	mov RAX, 0x8
	push RAX ; Return CS
	mov RAX, QWORD reloadCS
	push RAX ; Return RIP
	o64 retf
reloadCS:
	mov AX, 0x10
	mov SS, AX
	mov DS, AX
	mov ES, AX
	mov FS, AX
	mov GS, AX
	mov AX, 0x30
	ltr AX
	ret

section .multiboot
bits 64
	; Data structures
	align 4096
	pGDT32:
		dw GDT.End - GDT - 1
		dq GDT
	; GDT
	GDT:
		.Null:	dq 0x0000000000000000	; Null Descriptor
		.KC32:	dq 0x00cf9a000000ffff	; CS_KERNEL32
		.KC64:	dq 0x00af9a000000ffff,0	; CS_KERNEL
		.KD:	dq 0x00af93000000ffff,0	; DS_KERNEL
		.UC:	dq 0x00affa000000ffff,0	; CS_USER
		.UD:	dq 0x00aff3000000ffff,0	; DS_USER
				dq 0,0					;
				dq 0,0					;
				dq 0,0					;
				dq 0,0					;

		.TLS:	dq 0,0,0				; Three TLS descriptors
				dq 0x0000f40000000000	;
		.End:
	
	; Temporary page tables
	
	; P4
	align 4096
	p4_base:
		dq (p3_base + 0x7)
		times 255 dq 0
		dq (p3_base + 0x7)
		times 253 dq 0
		dq (p4_base + 0x17)
		dq 0
	; P3
	align 4096
	p3_base:
		dq (p2_base + 0x7)
		times 511 dq 0
	; P2
	align 4096
	p2_base:
		%assign i 0
		%rep 25
		dq ((i<<21) + 0xC7)
		%assign i i+1
		%endrep
		times (512-25) dq 0
;	align 4096
;	p1_base:
;		%assign i 0
;		%rep 512*25
;		dq (i << 12) | 0x087
;		%assign i i+1
;		%endrep

section .bss
	kstack:
	resb STACK_SIZE
