module ldc.gccbuiltins_x86; 

import core.simd;

nothrow @nogc:

pragma(LDC_intrinsic, "llvm.x86.addcarry.u32")
    byte __builtin_ia32_addcarry_u32(byte, int, int, void*) pure;

pragma(LDC_intrinsic, "llvm.x86.addcarry.u64")
    byte __builtin_ia32_addcarry_u64(byte, long, long, void*) pure;

pragma(LDC_intrinsic, "llvm.x86.addcarryx.u32")
    byte __builtin_ia32_addcarryx_u32(byte, int, int, void*) pure;

pragma(LDC_intrinsic, "llvm.x86.addcarryx.u64")
    byte __builtin_ia32_addcarryx_u64(byte, long, long, void*) pure;

pragma(LDC_intrinsic, "llvm.x86.aesni.aesdec")
    long2 __builtin_ia32_aesdec128(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.aesni.aesdeclast")
    long2 __builtin_ia32_aesdeclast128(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.aesni.aesenc")
    long2 __builtin_ia32_aesenc128(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.aesni.aesenclast")
    long2 __builtin_ia32_aesenclast128(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.aesni.aesimc")
    long2 __builtin_ia32_aesimc128(long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.aesni.aeskeygenassist")
    long2 __builtin_ia32_aeskeygenassist128(long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.d.d")
    int4 __builtin_ia32_gatherd_d(int4, const void*, int4, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.d.d.256")
    int8 __builtin_ia32_gatherd_d256(int8, const void*, int8, int8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.d.pd")
    double2 __builtin_ia32_gatherd_pd(double2, const void*, int4, double2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.d.pd.256")
    double4 __builtin_ia32_gatherd_pd256(double4, const void*, int4, double4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.d.ps")
    float4 __builtin_ia32_gatherd_ps(float4, const void*, int4, float4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.d.ps.256")
    float8 __builtin_ia32_gatherd_ps256(float8, const void*, int8, float8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.d.q")
    long2 __builtin_ia32_gatherd_q(long2, const void*, int4, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.d.q.256")
    long4 __builtin_ia32_gatherd_q256(long4, const void*, int4, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.q.d")
    int4 __builtin_ia32_gatherq_d(int4, const void*, long2, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.q.d.256")
    int4 __builtin_ia32_gatherq_d256(int4, const void*, long4, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.q.pd")
    double2 __builtin_ia32_gatherq_pd(double2, const void*, long2, double2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.q.pd.256")
    double4 __builtin_ia32_gatherq_pd256(double4, const void*, long4, double4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.q.ps")
    float4 __builtin_ia32_gatherq_ps(float4, const void*, long2, float4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.q.ps.256")
    float4 __builtin_ia32_gatherq_ps256(float4, const void*, long4, float4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.q.q")
    long2 __builtin_ia32_gatherq_q(long2, const void*, long2, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.gather.q.q.256")
    long4 __builtin_ia32_gatherq_q256(long4, const void*, long4, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.maskload.d")
    int4 __builtin_ia32_maskloadd(const void*, int4) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.maskload.d.256")
    int8 __builtin_ia32_maskloadd256(const void*, int8) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.maskload.q")
    long2 __builtin_ia32_maskloadq(const void*, long2) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.maskload.q.256")
    long4 __builtin_ia32_maskloadq256(const void*, long4) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.maskstore.d")
    void __builtin_ia32_maskstored(void*, int4, int4) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.maskstore.d.256")
    void __builtin_ia32_maskstored256(void*, int8, int8) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.maskstore.q")
    void __builtin_ia32_maskstoreq(void*, long2, long2) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.maskstore.q.256")
    void __builtin_ia32_maskstoreq256(void*, long4, long4) pure;

pragma(LDC_intrinsic, "llvm.x86.avx2.movntdqa")
    long4 __builtin_ia32_movntdqa256(const void*);

pragma(LDC_intrinsic, "llvm.x86.avx2.mpsadbw")
    short16 __builtin_ia32_mpsadbw256(byte32, byte32, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pabs.b")
    byte32 __builtin_ia32_pabsb256(byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pabs.d")
    int8 __builtin_ia32_pabsd256(int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pabs.w")
    short16 __builtin_ia32_pabsw256(short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.packssdw")
    short16 __builtin_ia32_packssdw256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.packsswb")
    byte32 __builtin_ia32_packsswb256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.packusdw")
    short16 __builtin_ia32_packusdw256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.packuswb")
    byte32 __builtin_ia32_packuswb256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.padds.b")
    byte32 __builtin_ia32_paddsb256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.padds.w")
    short16 __builtin_ia32_paddsw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.paddus.b")
    byte32 __builtin_ia32_paddusb256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.paddus.w")
    short16 __builtin_ia32_paddusw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pavg.b")
    byte32 __builtin_ia32_pavgb256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pavg.w")
    short16 __builtin_ia32_pavgw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pblendvb")
    byte32 __builtin_ia32_pblendvb256(byte32, byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.permd")
    int8 __builtin_ia32_permvarsi256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.permps")
    float8 __builtin_ia32_permvarsf256(float8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.phadd.d")
    int8 __builtin_ia32_phaddd256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.phadd.sw")
    short16 __builtin_ia32_phaddsw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.phadd.w")
    short16 __builtin_ia32_phaddw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.phsub.d")
    int8 __builtin_ia32_phsubd256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.phsub.sw")
    short16 __builtin_ia32_phsubsw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.phsub.w")
    short16 __builtin_ia32_phsubw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmadd.ub.sw")
    short16 __builtin_ia32_pmaddubsw256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmadd.wd")
    int8 __builtin_ia32_pmaddwd256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmaxs.b")
    byte32 __builtin_ia32_pmaxsb256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmaxs.d")
    int8 __builtin_ia32_pmaxsd256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmaxs.w")
    short16 __builtin_ia32_pmaxsw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmaxu.b")
    byte32 __builtin_ia32_pmaxub256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmaxu.d")
    int8 __builtin_ia32_pmaxud256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmaxu.w")
    short16 __builtin_ia32_pmaxuw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmins.b")
    byte32 __builtin_ia32_pminsb256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmins.d")
    int8 __builtin_ia32_pminsd256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmins.w")
    short16 __builtin_ia32_pminsw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pminu.b")
    byte32 __builtin_ia32_pminub256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pminu.d")
    int8 __builtin_ia32_pminud256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pminu.w")
    short16 __builtin_ia32_pminuw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovmskb")
    int __builtin_ia32_pmovmskb256(byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovsxbd")
    int8 __builtin_ia32_pmovsxbd256(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovsxbq")
    long4 __builtin_ia32_pmovsxbq256(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovsxbw")
    short16 __builtin_ia32_pmovsxbw256(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovsxdq")
    long4 __builtin_ia32_pmovsxdq256(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovsxwd")
    int8 __builtin_ia32_pmovsxwd256(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovsxwq")
    long4 __builtin_ia32_pmovsxwq256(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovzxbd")
    int8 __builtin_ia32_pmovzxbd256(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovzxbq")
    long4 __builtin_ia32_pmovzxbq256(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovzxbw")
    short16 __builtin_ia32_pmovzxbw256(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovzxdq")
    long4 __builtin_ia32_pmovzxdq256(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovzxwd")
    int8 __builtin_ia32_pmovzxwd256(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmovzxwq")
    long4 __builtin_ia32_pmovzxwq256(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmul.dq")
    long4 __builtin_ia32_pmuldq256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmul.hr.sw")
    short16 __builtin_ia32_pmulhrsw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmulh.w")
    short16 __builtin_ia32_pmulhw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmulhu.w")
    short16 __builtin_ia32_pmulhuw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pmulu.dq")
    long4 __builtin_ia32_pmuludq256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psad.bw")
    long4 __builtin_ia32_psadbw256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pshuf.b")
    byte32 __builtin_ia32_pshufb256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psign.b")
    byte32 __builtin_ia32_psignb256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psign.d")
    int8 __builtin_ia32_psignd256(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psign.w")
    short16 __builtin_ia32_psignw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psll.d")
    int8 __builtin_ia32_pslld256(int8, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psll.q")
    long4 __builtin_ia32_psllq256(long4, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psll.w")
    short16 __builtin_ia32_psllw256(short16, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pslli.d")
    int8 __builtin_ia32_pslldi256(int8, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pslli.q")
    long4 __builtin_ia32_psllqi256(long4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.pslli.w")
    short16 __builtin_ia32_psllwi256(short16, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psllv.d")
    int4 __builtin_ia32_psllv4si(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psllv.d.256")
    int8 __builtin_ia32_psllv8si(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psllv.q")
    long2 __builtin_ia32_psllv2di(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psllv.q.256")
    long4 __builtin_ia32_psllv4di(long4, long4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psra.d")
    int8 __builtin_ia32_psrad256(int8, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psra.w")
    short16 __builtin_ia32_psraw256(short16, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrai.d")
    int8 __builtin_ia32_psradi256(int8, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrai.w")
    short16 __builtin_ia32_psrawi256(short16, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrav.d")
    int4 __builtin_ia32_psrav4si(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrav.d.256")
    int8 __builtin_ia32_psrav8si(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrl.d")
    int8 __builtin_ia32_psrld256(int8, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrl.q")
    long4 __builtin_ia32_psrlq256(long4, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrl.w")
    short16 __builtin_ia32_psrlw256(short16, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrli.d")
    int8 __builtin_ia32_psrldi256(int8, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrli.q")
    long4 __builtin_ia32_psrlqi256(long4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrli.w")
    short16 __builtin_ia32_psrlwi256(short16, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrlv.d")
    int4 __builtin_ia32_psrlv4si(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrlv.d.256")
    int8 __builtin_ia32_psrlv8si(int8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrlv.q")
    long2 __builtin_ia32_psrlv2di(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psrlv.q.256")
    long4 __builtin_ia32_psrlv4di(long4, long4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psubs.b")
    byte32 __builtin_ia32_psubsb256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psubs.w")
    short16 __builtin_ia32_psubsw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psubus.b")
    byte32 __builtin_ia32_psubusb256(byte32, byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.psubus.w")
    short16 __builtin_ia32_psubusw256(short16, short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx2.vperm2i128")
    long4 __builtin_ia32_permti256(long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.broadcastmb.128")
    long2 __builtin_ia32_broadcastmb128(byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.broadcastmb.256")
    long4 __builtin_ia32_broadcastmb256(byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.broadcastmw.128")
    int4 __builtin_ia32_broadcastmw128(short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.broadcastmw.256")
    int8 __builtin_ia32_broadcastmw256(short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtb2mask.128")
    short __builtin_ia32_cvtb2mask128(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtb2mask.256")
    int __builtin_ia32_cvtb2mask256(byte32) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtd2mask.128")
    byte __builtin_ia32_cvtd2mask128(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtd2mask.256")
    byte __builtin_ia32_cvtd2mask256(int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtmask2b.128")
    byte16 __builtin_ia32_cvtmask2b128(short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtmask2b.256")
    byte32 __builtin_ia32_cvtmask2b256(int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtmask2d.128")
    int4 __builtin_ia32_cvtmask2d128(byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtmask2d.256")
    int8 __builtin_ia32_cvtmask2d256(byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtmask2q.128")
    long2 __builtin_ia32_cvtmask2q128(byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtmask2q.256")
    long4 __builtin_ia32_cvtmask2q256(byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtmask2w.128")
    short8 __builtin_ia32_cvtmask2w128(byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtmask2w.256")
    short16 __builtin_ia32_cvtmask2w256(short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtq2mask.128")
    byte __builtin_ia32_cvtq2mask128(long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtq2mask.256")
    byte __builtin_ia32_cvtq2mask256(long4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtsd2usi")
    int __builtin_ia32_cvtsd2usi(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtsd2usi64")
    long __builtin_ia32_cvtsd2usi64(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtsi2sd32")
    double2 __builtin_ia32_cvtsi2sd32(double2, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtsi2sd64")
    double2 __builtin_ia32_cvtsi2sd64(double2, long, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtsi2ss32")
    float4 __builtin_ia32_cvtsi2ss32(float4, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtsi2ss64")
    float4 __builtin_ia32_cvtsi2ss64(float4, long, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtss2usi")
    int __builtin_ia32_cvtss2usi(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtss2usi64")
    long __builtin_ia32_cvtss2usi64(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvttsd2si")
    int __builtin_ia32_vcvttsd2si32(double2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvttsd2si64")
    long __builtin_ia32_vcvttsd2si64(double2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvttsd2usi")
    int __builtin_ia32_vcvttsd2usi32(double2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvttsd2usi64")
    long __builtin_ia32_vcvttsd2usi64(double2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvttss2si")
    int __builtin_ia32_vcvttss2si32(float4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvttss2si64")
    long __builtin_ia32_vcvttss2si64(float4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvttss2usi")
    int __builtin_ia32_vcvttss2usi32(float4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvttss2usi64")
    long __builtin_ia32_vcvttss2usi64(float4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtusi2sd")
    double2 __builtin_ia32_cvtusi2sd32(double2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtusi2ss")
    float4 __builtin_ia32_cvtusi2ss32(float4, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtusi642sd")
    double2 __builtin_ia32_cvtusi2sd64(double2, long, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtusi642ss")
    float4 __builtin_ia32_cvtusi2ss64(float4, long, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtw2mask.128")
    byte __builtin_ia32_cvtw2mask128(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.cvtw2mask.256")
    short __builtin_ia32_cvtw2mask256(short16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3div2.df")
    double2 __builtin_ia32_gather3div2df(double2, const void*, long2, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3div2.di")
    int4 __builtin_ia32_gather3div2di(long2, const void*, long2, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3div4.df")
    double4 __builtin_ia32_gather3div4df(double4, const void*, long4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3div4.di")
    int8 __builtin_ia32_gather3div4di(long4, const void*, long4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3div4.sf")
    float4 __builtin_ia32_gather3div4sf(float4, const void*, long2, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3div4.si")
    int4 __builtin_ia32_gather3div4si(int4, const void*, long2, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3div8.sf")
    float4 __builtin_ia32_gather3div8sf(float4, const void*, long4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3div8.si")
    int4 __builtin_ia32_gather3div8si(int4, const void*, long4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3siv2.df")
    double2 __builtin_ia32_gather3siv2df(double2, const void*, int4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3siv2.di")
    int4 __builtin_ia32_gather3siv2di(long2, const void*, int4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3siv4.df")
    double4 __builtin_ia32_gather3siv4df(double4, const void*, int4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3siv4.di")
    int8 __builtin_ia32_gather3siv4di(long4, const void*, int4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3siv4.sf")
    float4 __builtin_ia32_gather3siv4sf(float4, const void*, int4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3siv4.si")
    int4 __builtin_ia32_gather3siv4si(int4, const void*, int4, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3siv8.sf")
    float8 __builtin_ia32_gather3siv8sf(float8, const void*, int8, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gather3siv8.si")
    int8 __builtin_ia32_gather3siv8si(int8, const void*, int8, byte, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.gatherpf.dpd.512")
    void __builtin_ia32_gatherpfdpd(byte, int8, void*, int, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.kand.w")
    short __builtin_ia32_kandhi(short, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.kandn.w")
    short __builtin_ia32_kandnhi(short, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.knot.w")
    short __builtin_ia32_knothi(short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.kor.w")
    short __builtin_ia32_korhi(short, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.kortestc.w")
    int __builtin_ia32_kortestchi(short, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.kortestz.w")
    int __builtin_ia32_kortestzhi(short, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.kunpck.bw")
    short __builtin_ia32_kunpckhi(short, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.kunpck.dq")
    long __builtin_ia32_kunpckdi(long, long) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.kunpck.wd")
    int __builtin_ia32_kunpcksi(int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.kxnor.w")
    short __builtin_ia32_kxnorhi(short, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.kxor.w")
    short __builtin_ia32_kxorhi(short, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmadd.pd.128")
    double2 __builtin_ia32_vfmaddpd128_mask3(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmadd.pd.256")
    double4 __builtin_ia32_vfmaddpd256_mask3(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmadd.ps.128")
    float4 __builtin_ia32_vfmaddps128_mask3(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmadd.ps.256")
    float8 __builtin_ia32_vfmaddps256_mask3(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmaddsub.pd.128")
    double2 __builtin_ia32_vfmaddsubpd128_mask3(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmaddsub.pd.256")
    double4 __builtin_ia32_vfmaddsubpd256_mask3(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmaddsub.ps.128")
    float4 __builtin_ia32_vfmaddsubps128_mask3(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmaddsub.ps.256")
    float8 __builtin_ia32_vfmaddsubps256_mask3(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmsub.pd.128")
    double2 __builtin_ia32_vfmsubpd128_mask3(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmsub.pd.256")
    double4 __builtin_ia32_vfmsubpd256_mask3(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmsub.ps.128")
    float4 __builtin_ia32_vfmsubps128_mask3(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmsub.ps.256")
    float8 __builtin_ia32_vfmsubps256_mask3(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmsubadd.pd.128")
    double2 __builtin_ia32_vfmsubaddpd128_mask3(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmsubadd.pd.256")
    double4 __builtin_ia32_vfmsubaddpd256_mask3(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmsubadd.ps.128")
    float4 __builtin_ia32_vfmsubaddps128_mask3(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfmsubadd.ps.256")
    float8 __builtin_ia32_vfmsubaddps256_mask3(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfnmsub.pd.128")
    double2 __builtin_ia32_vfnmsubpd128_mask3(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfnmsub.pd.256")
    double4 __builtin_ia32_vfnmsubpd256_mask3(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfnmsub.ps.128")
    float4 __builtin_ia32_vfnmsubps128_mask3(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask3.vfnmsub.ps.256")
    float8 __builtin_ia32_vfnmsubps256_mask3(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.add.pd.128")
    double2 __builtin_ia32_addpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.add.pd.256")
    double4 __builtin_ia32_addpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.add.ps.128")
    float4 __builtin_ia32_addps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.add.ps.256")
    float8 __builtin_ia32_addps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.add.sd.round")
    double2 __builtin_ia32_addsd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.add.ss.round")
    float4 __builtin_ia32_addss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.and.pd.128")
    double2 __builtin_ia32_andpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.and.pd.256")
    double4 __builtin_ia32_andpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.and.ps.128")
    float4 __builtin_ia32_andps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.and.ps.256")
    float8 __builtin_ia32_andps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.andn.pd.128")
    double2 __builtin_ia32_andnpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.andn.pd.256")
    double4 __builtin_ia32_andnpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.andn.ps.128")
    float4 __builtin_ia32_andnps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.andn.ps.256")
    float8 __builtin_ia32_andnps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.b.128")
    byte16 __builtin_ia32_blendmb_128_mask(byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.b.256")
    byte32 __builtin_ia32_blendmb_256_mask(byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.d.128")
    int4 __builtin_ia32_blendmd_128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.d.256")
    int8 __builtin_ia32_blendmd_256_mask(int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.pd.128")
    double2 __builtin_ia32_blendmpd_128_mask(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.pd.256")
    double4 __builtin_ia32_blendmpd_256_mask(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.ps.128")
    float4 __builtin_ia32_blendmps_128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.ps.256")
    float8 __builtin_ia32_blendmps_256_mask(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.q.128")
    long2 __builtin_ia32_blendmq_128_mask(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.q.256")
    long4 __builtin_ia32_blendmq_256_mask(long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.w.128")
    short8 __builtin_ia32_blendmw_128_mask(short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.blend.w.256")
    short16 __builtin_ia32_blendmw_256_mask(short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcast.sd.pd.256")
    double4 __builtin_ia32_broadcastsd256_mask(double2, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcast.ss.ps.128")
    float4 __builtin_ia32_broadcastss128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcast.ss.ps.256")
    float8 __builtin_ia32_broadcastss256_mask(float4, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcastf32x2.256")
    float8 __builtin_ia32_broadcastf32x2_256_mask(float4, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcastf32x4.256")
    float8 __builtin_ia32_broadcastf32x4_256_mask(float4, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcastf64x2.256")
    double4 __builtin_ia32_broadcastf64x2_256_mask(double2, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcasti32x2.128")
    int4 __builtin_ia32_broadcasti32x2_128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcasti32x2.256")
    int8 __builtin_ia32_broadcasti32x2_256_mask(int4, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcasti32x4.256")
    int8 __builtin_ia32_broadcasti32x4_256_mask(int4, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.broadcasti64x2.256")
    long4 __builtin_ia32_broadcasti64x2_256_mask(long2, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.b.128")
    short __builtin_ia32_cmpb128_mask(byte16, byte16, int, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.b.256")
    int __builtin_ia32_cmpb256_mask(byte32, byte32, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.d.128")
    byte __builtin_ia32_cmpd128_mask(int4, int4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.d.256")
    byte __builtin_ia32_cmpd256_mask(int8, int8, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.pd.128")
    byte __builtin_ia32_cmppd128_mask(double2, double2, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.pd.256")
    byte __builtin_ia32_cmppd256_mask(double4, double4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.ps.128")
    byte __builtin_ia32_cmpps128_mask(float4, float4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.ps.256")
    byte __builtin_ia32_cmpps256_mask(float8, float8, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.q.128")
    byte __builtin_ia32_cmpq128_mask(long2, long2, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.q.256")
    byte __builtin_ia32_cmpq256_mask(long4, long4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.sd")
    byte __builtin_ia32_cmpsd_mask(double2, double2, int, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.ss")
    byte __builtin_ia32_cmpss_mask(float4, float4, int, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.w.128")
    byte __builtin_ia32_cmpw128_mask(short8, short8, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cmp.w.256")
    short __builtin_ia32_cmpw256_mask(short16, short16, int, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.d.128")
    int4 __builtin_ia32_compresssi128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.d.256")
    int8 __builtin_ia32_compresssi256_mask(int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.pd.128")
    double2 __builtin_ia32_compressdf128_mask(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.pd.256")
    double4 __builtin_ia32_compressdf256_mask(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.ps.128")
    float4 __builtin_ia32_compresssf128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.ps.256")
    float8 __builtin_ia32_compresssf256_mask(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.q.128")
    long2 __builtin_ia32_compressdi128_mask(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.q.256")
    long4 __builtin_ia32_compressdi256_mask(long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.store.d.128")
    void __builtin_ia32_compressstoresi128_mask(void*, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.store.d.256")
    void __builtin_ia32_compressstoresi256_mask(void*, int8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.store.pd.128")
    void __builtin_ia32_compressstoredf128_mask(void*, double2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.store.pd.256")
    void __builtin_ia32_compressstoredf256_mask(void*, double4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.store.ps.128")
    void __builtin_ia32_compressstoresf128_mask(void*, float4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.store.ps.256")
    void __builtin_ia32_compressstoresf256_mask(void*, float8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.store.q.128")
    void __builtin_ia32_compressstoredi128_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.compress.store.q.256")
    void __builtin_ia32_compressstoredi256_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.conflict.d.128")
    int4 __builtin_ia32_vpconflictsi_128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.conflict.d.256")
    int8 __builtin_ia32_vpconflictsi_256_mask(int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.conflict.q.128")
    long2 __builtin_ia32_vpconflictdi_128_mask(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.conflict.q.256")
    long4 __builtin_ia32_vpconflictdi_256_mask(long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtdq2pd.128")
    double2 __builtin_ia32_cvtdq2pd128_mask(int4, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtdq2pd.256")
    double4 __builtin_ia32_cvtdq2pd256_mask(int4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtdq2ps.128")
    float4 __builtin_ia32_cvtdq2ps128_mask(int4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtdq2ps.256")
    float8 __builtin_ia32_cvtdq2ps256_mask(int8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2dq.128")
    int4 __builtin_ia32_cvtpd2dq128_mask(double2, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2dq.256")
    int4 __builtin_ia32_cvtpd2dq256_mask(double4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2ps")
    float4 __builtin_ia32_cvtpd2ps_mask(double2, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2ps.256")
    float4 __builtin_ia32_cvtpd2ps256_mask(double4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2qq.128")
    long2 __builtin_ia32_cvtpd2qq128_mask(double2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2qq.256")
    long4 __builtin_ia32_cvtpd2qq256_mask(double4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2udq.128")
    int4 __builtin_ia32_cvtpd2udq128_mask(double2, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2udq.256")
    int4 __builtin_ia32_cvtpd2udq256_mask(double4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2uqq.128")
    long2 __builtin_ia32_cvtpd2uqq128_mask(double2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtpd2uqq.256")
    long4 __builtin_ia32_cvtpd2uqq256_mask(double4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2dq.128")
    int4 __builtin_ia32_cvtps2dq128_mask(float4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2dq.256")
    int8 __builtin_ia32_cvtps2dq256_mask(float8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2pd.128")
    double2 __builtin_ia32_cvtps2pd128_mask(float4, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2pd.256")
    double4 __builtin_ia32_cvtps2pd256_mask(float4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2qq.128")
    long2 __builtin_ia32_cvtps2qq128_mask(float4, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2qq.256")
    long4 __builtin_ia32_cvtps2qq256_mask(float4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2udq.128")
    int4 __builtin_ia32_cvtps2udq128_mask(float4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2udq.256")
    int8 __builtin_ia32_cvtps2udq256_mask(float8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2uqq.128")
    long2 __builtin_ia32_cvtps2uqq128_mask(float4, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtps2uqq.256")
    long4 __builtin_ia32_cvtps2uqq256_mask(float4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtqq2pd.128")
    double2 __builtin_ia32_cvtqq2pd128_mask(long2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtqq2pd.256")
    double4 __builtin_ia32_cvtqq2pd256_mask(long4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtqq2ps.128")
    float4 __builtin_ia32_cvtqq2ps128_mask(long2, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtqq2ps.256")
    float4 __builtin_ia32_cvtqq2ps256_mask(long4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtsd2ss.round")
    float4 __builtin_ia32_cvtsd2ss_round(double2, double2, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtss2sd.round")
    double2 __builtin_ia32_cvtss2sd_round(float4, float4, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttpd2dq.128")
    int4 __builtin_ia32_cvttpd2dq128_mask(double2, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttpd2dq.256")
    int4 __builtin_ia32_cvttpd2dq256_mask(double4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttpd2qq.128")
    long2 __builtin_ia32_cvttpd2qq128_mask(double2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttpd2qq.256")
    long4 __builtin_ia32_cvttpd2qq256_mask(double4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttpd2udq.128")
    int4 __builtin_ia32_cvttpd2udq128_mask(double2, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttpd2udq.256")
    int4 __builtin_ia32_cvttpd2udq256_mask(double4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttpd2uqq.128")
    long2 __builtin_ia32_cvttpd2uqq128_mask(double2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttpd2uqq.256")
    long4 __builtin_ia32_cvttpd2uqq256_mask(double4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttps2dq.128")
    int4 __builtin_ia32_cvttps2dq128_mask(float4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttps2dq.256")
    int8 __builtin_ia32_cvttps2dq256_mask(float8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttps2qq.128")
    long2 __builtin_ia32_cvttps2qq128_mask(float4, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttps2qq.256")
    long4 __builtin_ia32_cvttps2qq256_mask(float4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttps2udq.128")
    int4 __builtin_ia32_cvttps2udq128_mask(float4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttps2udq.256")
    int8 __builtin_ia32_cvttps2udq256_mask(float8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttps2uqq.128")
    long2 __builtin_ia32_cvttps2uqq128_mask(float4, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvttps2uqq.256")
    long4 __builtin_ia32_cvttps2uqq256_mask(float4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtudq2pd.128")
    double2 __builtin_ia32_cvtudq2pd128_mask(int4, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtudq2pd.256")
    double4 __builtin_ia32_cvtudq2pd256_mask(int4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtudq2ps.128")
    float4 __builtin_ia32_cvtudq2ps128_mask(int4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtudq2ps.256")
    float8 __builtin_ia32_cvtudq2ps256_mask(int8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtuqq2pd.128")
    double2 __builtin_ia32_cvtuqq2pd128_mask(long2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtuqq2pd.256")
    double4 __builtin_ia32_cvtuqq2pd256_mask(long4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtuqq2ps.128")
    float4 __builtin_ia32_cvtuqq2ps128_mask(long2, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.cvtuqq2ps.256")
    float4 __builtin_ia32_cvtuqq2ps256_mask(long4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.dbpsadbw.128")
    short8 __builtin_ia32_dbpsadbw128_mask(byte16, byte16, int, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.dbpsadbw.256")
    short16 __builtin_ia32_dbpsadbw256_mask(byte32, byte32, int, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.div.pd.128")
    double2 __builtin_ia32_divpd_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.div.pd.256")
    double4 __builtin_ia32_divpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.div.ps.128")
    float4 __builtin_ia32_divps_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.div.ps.256")
    float8 __builtin_ia32_divps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.div.sd.round")
    double2 __builtin_ia32_divsd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.div.ss.round")
    float4 __builtin_ia32_divss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.d.128")
    int4 __builtin_ia32_expandsi128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.d.256")
    int8 __builtin_ia32_expandsi256_mask(int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.load.d.128")
    int4 __builtin_ia32_expandloadsi128_mask(const void*, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.load.d.256")
    int8 __builtin_ia32_expandloadsi256_mask(const void*, int8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.load.pd.128")
    double2 __builtin_ia32_expandloaddf128_mask(const void*, double2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.load.pd.256")
    double4 __builtin_ia32_expandloaddf256_mask(const void*, double4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.load.ps.128")
    float4 __builtin_ia32_expandloadsf128_mask(const void*, float4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.load.ps.256")
    float8 __builtin_ia32_expandloadsf256_mask(const void*, float8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.load.q.128")
    long2 __builtin_ia32_expandloaddi128_mask(const void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.load.q.256")
    long4 __builtin_ia32_expandloaddi256_mask(const void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.pd.128")
    double2 __builtin_ia32_expanddf128_mask(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.pd.256")
    double4 __builtin_ia32_expanddf256_mask(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.ps.128")
    float4 __builtin_ia32_expandsf128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.ps.256")
    float8 __builtin_ia32_expandsf256_mask(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.q.128")
    long2 __builtin_ia32_expanddi128_mask(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.expand.q.256")
    long4 __builtin_ia32_expanddi256_mask(long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.fpclass.pd.128")
    byte __builtin_ia32_fpclasspd128_mask(double2, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.fpclass.pd.256")
    byte __builtin_ia32_fpclasspd256_mask(double4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.fpclass.ps.128")
    byte __builtin_ia32_fpclassps128_mask(float4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.fpclass.ps.256")
    byte __builtin_ia32_fpclassps256_mask(float8, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.fpclass.sd")
    byte __builtin_ia32_fpclasssd(double2, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.fpclass.ss")
    byte __builtin_ia32_fpclassss(float4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getexp.pd.128")
    double2 __builtin_ia32_getexppd128_mask(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getexp.pd.256")
    double4 __builtin_ia32_getexppd256_mask(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getexp.ps.128")
    float4 __builtin_ia32_getexpps128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getexp.ps.256")
    float8 __builtin_ia32_getexpps256_mask(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getexp.sd")
    double2 __builtin_ia32_getexpsd_mask(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getexp.ss")
    float4 __builtin_ia32_getexpss_mask(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getmant.pd.128")
    double2 __builtin_ia32_getmantpd128_mask(double2, int, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getmant.pd.256")
    double4 __builtin_ia32_getmantpd256_mask(double4, int, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getmant.ps.128")
    float4 __builtin_ia32_getmantps128_mask(float4, int, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getmant.ps.256")
    float8 __builtin_ia32_getmantps256_mask(float8, int, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getmant.sd")
    double2 __builtin_ia32_getmantsd_round(double2, double2, int, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.getmant.ss")
    float4 __builtin_ia32_getmantss_round(float4, float4, int, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.insertf32x4.256")
    float8 __builtin_ia32_insertf32x4_256_mask(float8, float4, int, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.insertf64x2.256")
    double4 __builtin_ia32_insertf64x2_256_mask(double4, double2, int, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.inserti32x4.256")
    int8 __builtin_ia32_inserti32x4_256_mask(int8, int4, int, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.inserti64x2.256")
    long4 __builtin_ia32_inserti64x2_256_mask(long4, long2, int, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.load.pd.128")
    double2 __builtin_ia32_loadapd128_mask(const void*, double2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.load.pd.256")
    double4 __builtin_ia32_loadapd256_mask(const void*, double4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.load.ps.128")
    float4 __builtin_ia32_loadaps128_mask(const void*, float4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.load.ps.256")
    float8 __builtin_ia32_loadaps256_mask(const void*, float8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.loadu.pd.128")
    double2 __builtin_ia32_loadupd128_mask(const void*, double2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.loadu.pd.256")
    double4 __builtin_ia32_loadupd256_mask(const void*, double4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.loadu.ps.128")
    float4 __builtin_ia32_loadups128_mask(const void*, float4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.loadu.ps.256")
    float8 __builtin_ia32_loadups256_mask(const void*, float8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.lzcnt.d.128")
    int4 __builtin_ia32_vplzcntd_128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.lzcnt.d.256")
    int8 __builtin_ia32_vplzcntd_256_mask(int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.lzcnt.q.128")
    long2 __builtin_ia32_vplzcntq_128_mask(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.lzcnt.q.256")
    long4 __builtin_ia32_vplzcntq_256_mask(long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.max.pd.128")
    double2 __builtin_ia32_maxpd_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.max.pd.256")
    double4 __builtin_ia32_maxpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.max.ps.128")
    float4 __builtin_ia32_maxps_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.max.ps.256")
    float8 __builtin_ia32_maxps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.max.sd.round")
    double2 __builtin_ia32_maxsd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.max.ss.round")
    float4 __builtin_ia32_maxss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.min.pd.128")
    double2 __builtin_ia32_minpd_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.min.pd.256")
    double4 __builtin_ia32_minpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.min.ps.128")
    float4 __builtin_ia32_minps_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.min.ps.256")
    float8 __builtin_ia32_minps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.min.sd.round")
    double2 __builtin_ia32_minsd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.min.ss.round")
    float4 __builtin_ia32_minss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.movddup.128")
    double2 __builtin_ia32_movddup128_mask(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.movddup.256")
    double4 __builtin_ia32_movddup256_mask(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.move.sd")
    double2 __builtin_ia32_movsd_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.move.ss")
    float4 __builtin_ia32_movss_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.movshdup.128")
    float4 __builtin_ia32_movshdup128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.movshdup.256")
    float8 __builtin_ia32_movshdup256_mask(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.movsldup.128")
    float4 __builtin_ia32_movsldup128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.movsldup.256")
    float8 __builtin_ia32_movsldup256_mask(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.mul.pd.128")
    double2 __builtin_ia32_mulpd_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.mul.pd.256")
    double4 __builtin_ia32_mulpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.mul.ps.128")
    float4 __builtin_ia32_mulps_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.mul.ps.256")
    float8 __builtin_ia32_mulps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.mul.sd.round")
    double2 __builtin_ia32_mulsd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.mul.ss.round")
    float4 __builtin_ia32_mulss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.or.pd.128")
    double2 __builtin_ia32_orpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.or.pd.256")
    double4 __builtin_ia32_orpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.or.ps.128")
    float4 __builtin_ia32_orps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.or.ps.256")
    float8 __builtin_ia32_orps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pabs.b.128")
    byte16 __builtin_ia32_pabsb128_mask(byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pabs.b.256")
    byte32 __builtin_ia32_pabsb256_mask(byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pabs.d.128")
    int4 __builtin_ia32_pabsd128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pabs.d.256")
    int8 __builtin_ia32_pabsd256_mask(int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pabs.q.128")
    long2 __builtin_ia32_pabsq128_mask(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pabs.q.256")
    long4 __builtin_ia32_pabsq256_mask(long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pabs.w.128")
    short8 __builtin_ia32_pabsw128_mask(short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pabs.w.256")
    short16 __builtin_ia32_pabsw256_mask(short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.packssdw.128")
    short8 __builtin_ia32_packssdw128_mask(int4, int4, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.packssdw.256")
    short16 __builtin_ia32_packssdw256_mask(int8, int8, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.packsswb.128")
    byte16 __builtin_ia32_packsswb128_mask(short8, short8, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.packsswb.256")
    byte32 __builtin_ia32_packsswb256_mask(short16, short16, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.packusdw.128")
    short8 __builtin_ia32_packusdw128_mask(int4, int4, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.packusdw.256")
    short16 __builtin_ia32_packusdw256_mask(int8, int8, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.packuswb.128")
    byte16 __builtin_ia32_packuswb128_mask(short8, short8, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.packuswb.256")
    byte32 __builtin_ia32_packuswb256_mask(short16, short16, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padd.b.128")
    byte16 __builtin_ia32_paddb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padd.b.256")
    byte32 __builtin_ia32_paddb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padd.d.128")
    int4 __builtin_ia32_paddd128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padd.d.256")
    int8 __builtin_ia32_paddd256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padd.q.128")
    long2 __builtin_ia32_paddq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padd.q.256")
    long4 __builtin_ia32_paddq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padd.w.128")
    short8 __builtin_ia32_paddw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padd.w.256")
    short16 __builtin_ia32_paddw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padds.b.128")
    byte16 __builtin_ia32_paddsb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padds.b.256")
    byte32 __builtin_ia32_paddsb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padds.w.128")
    short8 __builtin_ia32_paddsw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.padds.w.256")
    short16 __builtin_ia32_paddsw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.paddus.b.128")
    byte16 __builtin_ia32_paddusb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.paddus.b.256")
    byte32 __builtin_ia32_paddusb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.paddus.w.128")
    short8 __builtin_ia32_paddusw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.paddus.w.256")
    short16 __builtin_ia32_paddusw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.palignr.128")
    byte16 __builtin_ia32_palignr128_mask(byte16, byte16, int, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.palignr.256")
    byte32 __builtin_ia32_palignr256_mask(byte32, byte32, int, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pand.d.128")
    int4 __builtin_ia32_pandd128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pand.d.256")
    int8 __builtin_ia32_pandd256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pand.q.128")
    long2 __builtin_ia32_pandq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pand.q.256")
    long4 __builtin_ia32_pandq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pandn.d.128")
    int4 __builtin_ia32_pandnd128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pandn.d.256")
    int8 __builtin_ia32_pandnd256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pandn.q.128")
    long2 __builtin_ia32_pandnq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pandn.q.256")
    long4 __builtin_ia32_pandnq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pavg.b.128")
    byte16 __builtin_ia32_pavgb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pavg.b.256")
    byte32 __builtin_ia32_pavgb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pavg.w.128")
    short8 __builtin_ia32_pavgw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pavg.w.256")
    short16 __builtin_ia32_pavgw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpeq.b.128")
    short __builtin_ia32_pcmpeqb128_mask(byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpeq.b.256")
    int __builtin_ia32_pcmpeqb256_mask(byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpeq.d.128")
    byte __builtin_ia32_pcmpeqd128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpeq.d.256")
    byte __builtin_ia32_pcmpeqd256_mask(int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpeq.q.128")
    byte __builtin_ia32_pcmpeqq128_mask(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpeq.q.256")
    byte __builtin_ia32_pcmpeqq256_mask(long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpeq.w.128")
    byte __builtin_ia32_pcmpeqw128_mask(short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpeq.w.256")
    short __builtin_ia32_pcmpeqw256_mask(short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpgt.b.128")
    short __builtin_ia32_pcmpgtb128_mask(byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpgt.b.256")
    int __builtin_ia32_pcmpgtb256_mask(byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpgt.d.128")
    byte __builtin_ia32_pcmpgtd128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpgt.d.256")
    byte __builtin_ia32_pcmpgtd256_mask(int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpgt.q.128")
    byte __builtin_ia32_pcmpgtq128_mask(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpgt.q.256")
    byte __builtin_ia32_pcmpgtq256_mask(long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpgt.w.128")
    byte __builtin_ia32_pcmpgtw128_mask(short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pcmpgt.w.256")
    short __builtin_ia32_pcmpgtw256_mask(short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaddubs.w.128")
    short8 __builtin_ia32_pmaddubsw128_mask(byte16, byte16, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaddubs.w.256")
    short16 __builtin_ia32_pmaddubsw256_mask(byte32, byte32, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaddw.d.128")
    int4 __builtin_ia32_pmaddwd128_mask(short8, short8, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaddw.d.256")
    int8 __builtin_ia32_pmaddwd256_mask(short16, short16, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxs.b.128")
    byte16 __builtin_ia32_pmaxsb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxs.b.256")
    byte32 __builtin_ia32_pmaxsb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxs.d.128")
    int4 __builtin_ia32_pmaxsd128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxs.d.256")
    int8 __builtin_ia32_pmaxsd256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxs.q.128")
    long2 __builtin_ia32_pmaxsq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxs.q.256")
    long4 __builtin_ia32_pmaxsq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxs.w.128")
    short8 __builtin_ia32_pmaxsw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxs.w.256")
    short16 __builtin_ia32_pmaxsw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxu.b.128")
    byte16 __builtin_ia32_pmaxub128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxu.b.256")
    byte32 __builtin_ia32_pmaxub256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxu.d.128")
    int4 __builtin_ia32_pmaxud128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxu.d.256")
    int8 __builtin_ia32_pmaxud256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxu.q.128")
    long2 __builtin_ia32_pmaxuq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxu.q.256")
    long4 __builtin_ia32_pmaxuq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxu.w.128")
    short8 __builtin_ia32_pmaxuw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmaxu.w.256")
    short16 __builtin_ia32_pmaxuw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmins.b.128")
    byte16 __builtin_ia32_pminsb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmins.b.256")
    byte32 __builtin_ia32_pminsb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmins.d.128")
    int4 __builtin_ia32_pminsd128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmins.d.256")
    int8 __builtin_ia32_pminsd256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmins.q.128")
    long2 __builtin_ia32_pminsq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmins.q.256")
    long4 __builtin_ia32_pminsq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmins.w.128")
    short8 __builtin_ia32_pminsw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmins.w.256")
    short16 __builtin_ia32_pminsw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pminu.b.128")
    byte16 __builtin_ia32_pminub128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pminu.b.256")
    byte32 __builtin_ia32_pminub256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pminu.d.128")
    int4 __builtin_ia32_pminud128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pminu.d.256")
    int8 __builtin_ia32_pminud256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pminu.q.128")
    long2 __builtin_ia32_pminuq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pminu.q.256")
    long4 __builtin_ia32_pminuq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pminu.w.128")
    short8 __builtin_ia32_pminuw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pminu.w.256")
    short16 __builtin_ia32_pminuw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.db.128")
    byte16 __builtin_ia32_pmovdb128_mask(int4, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.db.256")
    byte16 __builtin_ia32_pmovdb256_mask(int8, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.db.mem.128")
    void __builtin_ia32_pmovdb128mem_mask(void*, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.db.mem.256")
    void __builtin_ia32_pmovdb256mem_mask(void*, int8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.dw.128")
    short8 __builtin_ia32_pmovdw128_mask(int4, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.dw.256")
    short8 __builtin_ia32_pmovdw256_mask(int8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.dw.mem.128")
    void __builtin_ia32_pmovdw128mem_mask(void*, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.dw.mem.256")
    void __builtin_ia32_pmovdw256mem_mask(void*, int8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qb.128")
    byte16 __builtin_ia32_pmovqb128_mask(long2, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qb.256")
    byte16 __builtin_ia32_pmovqb256_mask(long4, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qb.mem.128")
    void __builtin_ia32_pmovqb128mem_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qb.mem.256")
    void __builtin_ia32_pmovqb256mem_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qd.128")
    int4 __builtin_ia32_pmovqd128_mask(long2, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qd.256")
    int4 __builtin_ia32_pmovqd256_mask(long4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qd.mem.128")
    void __builtin_ia32_pmovqd128mem_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qd.mem.256")
    void __builtin_ia32_pmovqd256mem_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qw.128")
    short8 __builtin_ia32_pmovqw128_mask(long2, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qw.256")
    short8 __builtin_ia32_pmovqw256_mask(long4, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qw.mem.128")
    void __builtin_ia32_pmovqw128mem_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.qw.mem.256")
    void __builtin_ia32_pmovqw256mem_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.wb.128")
    byte16 __builtin_ia32_pmovwb128_mask(short8, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.wb.256")
    byte16 __builtin_ia32_pmovwb256_mask(short16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.wb.mem.128")
    void __builtin_ia32_pmovwb128mem_mask(void*, short8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmov.wb.mem.256")
    void __builtin_ia32_pmovwb256mem_mask(void*, short16, short) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.db.128")
    byte16 __builtin_ia32_pmovsdb128_mask(int4, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.db.256")
    byte16 __builtin_ia32_pmovsdb256_mask(int8, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.db.mem.128")
    void __builtin_ia32_pmovsdb128mem_mask(void*, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.db.mem.256")
    void __builtin_ia32_pmovsdb256mem_mask(void*, int8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.dw.128")
    short8 __builtin_ia32_pmovsdw128_mask(int4, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.dw.256")
    short8 __builtin_ia32_pmovsdw256_mask(int8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.dw.mem.128")
    void __builtin_ia32_pmovsdw128mem_mask(void*, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.dw.mem.256")
    void __builtin_ia32_pmovsdw256mem_mask(void*, int8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qb.128")
    byte16 __builtin_ia32_pmovsqb128_mask(long2, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qb.256")
    byte16 __builtin_ia32_pmovsqb256_mask(long4, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qb.mem.128")
    void __builtin_ia32_pmovsqb128mem_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qb.mem.256")
    void __builtin_ia32_pmovsqb256mem_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qd.128")
    int4 __builtin_ia32_pmovsqd128_mask(long2, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qd.256")
    int4 __builtin_ia32_pmovsqd256_mask(long4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qd.mem.128")
    void __builtin_ia32_pmovsqd128mem_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qd.mem.256")
    void __builtin_ia32_pmovsqd256mem_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qw.128")
    short8 __builtin_ia32_pmovsqw128_mask(long2, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qw.256")
    short8 __builtin_ia32_pmovsqw256_mask(long4, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qw.mem.128")
    void __builtin_ia32_pmovsqw128mem_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.qw.mem.256")
    void __builtin_ia32_pmovsqw256mem_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.wb.128")
    byte16 __builtin_ia32_pmovswb128_mask(short8, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.wb.256")
    byte16 __builtin_ia32_pmovswb256_mask(short16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.wb.mem.128")
    void __builtin_ia32_pmovswb128mem_mask(void*, short8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovs.wb.mem.256")
    void __builtin_ia32_pmovswb256mem_mask(void*, short16, short) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxb.d.128")
    int4 __builtin_ia32_pmovsxbd128_mask(byte16, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxb.d.256")
    int8 __builtin_ia32_pmovsxbd256_mask(byte16, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxb.q.128")
    long2 __builtin_ia32_pmovsxbq128_mask(byte16, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxb.q.256")
    long4 __builtin_ia32_pmovsxbq256_mask(byte16, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxb.w.128")
    short8 __builtin_ia32_pmovsxbw128_mask(byte16, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxb.w.256")
    short16 __builtin_ia32_pmovsxbw256_mask(byte16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxd.q.128")
    long2 __builtin_ia32_pmovsxdq128_mask(int4, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxd.q.256")
    long4 __builtin_ia32_pmovsxdq256_mask(int4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxw.d.128")
    int4 __builtin_ia32_pmovsxwd128_mask(short8, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxw.d.256")
    int8 __builtin_ia32_pmovsxwd256_mask(short8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxw.q.128")
    long2 __builtin_ia32_pmovsxwq128_mask(short8, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovsxw.q.256")
    long4 __builtin_ia32_pmovsxwq256_mask(short8, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.db.128")
    byte16 __builtin_ia32_pmovusdb128_mask(int4, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.db.256")
    byte16 __builtin_ia32_pmovusdb256_mask(int8, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.db.mem.128")
    void __builtin_ia32_pmovusdb128mem_mask(void*, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.db.mem.256")
    void __builtin_ia32_pmovusdb256mem_mask(void*, int8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.dw.128")
    short8 __builtin_ia32_pmovusdw128_mask(int4, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.dw.256")
    short8 __builtin_ia32_pmovusdw256_mask(int8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.dw.mem.128")
    void __builtin_ia32_pmovusdw128mem_mask(void*, int4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.dw.mem.256")
    void __builtin_ia32_pmovusdw256mem_mask(void*, int8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qb.128")
    byte16 __builtin_ia32_pmovusqb128_mask(long2, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qb.256")
    byte16 __builtin_ia32_pmovusqb256_mask(long4, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qb.mem.128")
    void __builtin_ia32_pmovusqb128mem_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qb.mem.256")
    void __builtin_ia32_pmovusqb256mem_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qd.128")
    int4 __builtin_ia32_pmovusqd128_mask(long2, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qd.256")
    int4 __builtin_ia32_pmovusqd256_mask(long4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qd.mem.128")
    void __builtin_ia32_pmovusqd128mem_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qd.mem.256")
    void __builtin_ia32_pmovusqd256mem_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qw.128")
    short8 __builtin_ia32_pmovusqw128_mask(long2, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qw.256")
    short8 __builtin_ia32_pmovusqw256_mask(long4, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qw.mem.128")
    void __builtin_ia32_pmovusqw128mem_mask(void*, long2, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.qw.mem.256")
    void __builtin_ia32_pmovusqw256mem_mask(void*, long4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.wb.128")
    byte16 __builtin_ia32_pmovuswb128_mask(short8, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.wb.256")
    byte16 __builtin_ia32_pmovuswb256_mask(short16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.wb.mem.128")
    void __builtin_ia32_pmovuswb128mem_mask(void*, short8, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovus.wb.mem.256")
    void __builtin_ia32_pmovuswb256mem_mask(void*, short16, short) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxb.d.128")
    int4 __builtin_ia32_pmovzxbd128_mask(byte16, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxb.d.256")
    int8 __builtin_ia32_pmovzxbd256_mask(byte16, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxb.q.128")
    long2 __builtin_ia32_pmovzxbq128_mask(byte16, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxb.q.256")
    long4 __builtin_ia32_pmovzxbq256_mask(byte16, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxb.w.128")
    short8 __builtin_ia32_pmovzxbw128_mask(byte16, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxb.w.256")
    short16 __builtin_ia32_pmovzxbw256_mask(byte16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxd.q.128")
    long2 __builtin_ia32_pmovzxdq128_mask(int4, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxd.q.256")
    long4 __builtin_ia32_pmovzxdq256_mask(int4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxw.d.128")
    int4 __builtin_ia32_pmovzxwd128_mask(short8, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxw.d.256")
    int8 __builtin_ia32_pmovzxwd256_mask(short8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxw.q.128")
    long2 __builtin_ia32_pmovzxwq128_mask(short8, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmovzxw.q.256")
    long4 __builtin_ia32_pmovzxwq256_mask(short8, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmul.dq.128")
    long2 __builtin_ia32_pmuldq128_mask(int4, int4, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmul.dq.256")
    long4 __builtin_ia32_pmuldq256_mask(int8, int8, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmul.hr.sw.128")
    short8 __builtin_ia32_pmulhrsw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmul.hr.sw.256")
    short16 __builtin_ia32_pmulhrsw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmulh.w.128")
    short8 __builtin_ia32_pmulhw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmulh.w.256")
    short16 __builtin_ia32_pmulhw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmulhu.w.128")
    short8 __builtin_ia32_pmulhuw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmulhu.w.256")
    short16 __builtin_ia32_pmulhuw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmull.d.128")
    int4 __builtin_ia32_pmulld128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmull.d.256")
    int8 __builtin_ia32_pmulld256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmull.q.128")
    long2 __builtin_ia32_pmullq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmull.q.256")
    long4 __builtin_ia32_pmullq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmull.w.128")
    short8 __builtin_ia32_pmullw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmull.w.256")
    short16 __builtin_ia32_pmullw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmulu.dq.128")
    long2 __builtin_ia32_pmuludq128_mask(int4, int4, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pmulu.dq.256")
    long4 __builtin_ia32_pmuludq256_mask(int8, int8, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.por.d.128")
    int4 __builtin_ia32_pord128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.por.d.256")
    int8 __builtin_ia32_pord256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.por.q.128")
    long2 __builtin_ia32_porq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.por.q.256")
    long4 __builtin_ia32_porq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prol.d.128")
    int4 __builtin_ia32_prold128_mask(int4, byte, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prol.d.256")
    int8 __builtin_ia32_prold256_mask(int8, byte, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prol.q.128")
    long2 __builtin_ia32_prolq128_mask(long2, byte, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prol.q.256")
    long4 __builtin_ia32_prolq256_mask(long4, byte, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prolv.d.128")
    int4 __builtin_ia32_prolvd128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prolv.d.256")
    int8 __builtin_ia32_prolvd256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prolv.q.128")
    long2 __builtin_ia32_prolvq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prolv.q.256")
    long4 __builtin_ia32_prolvq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pror.d.128")
    int4 __builtin_ia32_prord128_mask(int4, byte, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pror.d.256")
    int8 __builtin_ia32_prord256_mask(int8, byte, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pror.q.128")
    long2 __builtin_ia32_prorq128_mask(long2, byte, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pror.q.256")
    long4 __builtin_ia32_prorq256_mask(long4, byte, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prorv.d.128")
    int4 __builtin_ia32_prorvd128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prorv.d.256")
    int8 __builtin_ia32_prorvd256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prorv.q.128")
    long2 __builtin_ia32_prorvq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.prorv.q.256")
    long4 __builtin_ia32_prorvq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pshuf.b.128")
    byte16 __builtin_ia32_pshufb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pshuf.b.256")
    byte32 __builtin_ia32_pshufb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pshuf.d.128")
    int4 __builtin_ia32_pshufd128_mask(int4, short, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pshuf.d.256")
    int8 __builtin_ia32_pshufd256_mask(int8, short, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pshufh.w.128")
    short8 __builtin_ia32_pshufhw128_mask(short8, byte, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pshufh.w.256")
    short16 __builtin_ia32_pshufhw256_mask(short16, byte, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pshufl.w.128")
    short8 __builtin_ia32_pshuflw128_mask(short8, byte, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pshufl.w.256")
    short16 __builtin_ia32_pshuflw256_mask(short16, byte, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.d.128")
    int4 __builtin_ia32_pslld128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.d.256")
    int8 __builtin_ia32_pslld256_mask(int8, int4, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.di.128")
    int4 __builtin_ia32_pslldi128_mask(int4, byte, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.di.256")
    int8 __builtin_ia32_pslldi256_mask(int8, byte, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.q.128")
    long2 __builtin_ia32_psllq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.q.256")
    long4 __builtin_ia32_psllq256_mask(long4, long2, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.qi.128")
    long2 __builtin_ia32_psllqi128_mask(long2, byte, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.qi.256")
    long4 __builtin_ia32_psllqi256_mask(long4, byte, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.w.128")
    short8 __builtin_ia32_psllw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.w.256")
    short16 __builtin_ia32_psllw256_mask(short16, short8, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.wi.128")
    short8 __builtin_ia32_psllwi128_mask(short8, byte, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psll.wi.256")
    short16 __builtin_ia32_psllwi256_mask(short16, byte, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psllv16.hi")
    short16 __builtin_ia32_psllv16hi_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psllv2.di")
    long2 __builtin_ia32_psllv2di_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psllv4.di")
    long4 __builtin_ia32_psllv4di_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psllv4.si")
    int4 __builtin_ia32_psllv4si_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psllv8.hi")
    short8 __builtin_ia32_psllv8hi_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psllv8.si")
    int8 __builtin_ia32_psllv8si_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.d.128")
    int4 __builtin_ia32_psrad128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.d.256")
    int8 __builtin_ia32_psrad256_mask(int8, int4, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.di.128")
    int4 __builtin_ia32_psradi128_mask(int4, byte, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.di.256")
    int8 __builtin_ia32_psradi256_mask(int8, byte, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.q.128")
    long2 __builtin_ia32_psraq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.q.256")
    long4 __builtin_ia32_psraq256_mask(long4, long2, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.qi.128")
    long2 __builtin_ia32_psraqi128_mask(long2, byte, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.qi.256")
    long4 __builtin_ia32_psraqi256_mask(long4, byte, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.w.128")
    short8 __builtin_ia32_psraw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.w.256")
    short16 __builtin_ia32_psraw256_mask(short16, short8, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.wi.128")
    short8 __builtin_ia32_psrawi128_mask(short8, byte, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psra.wi.256")
    short16 __builtin_ia32_psrawi256_mask(short16, byte, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrav16.hi")
    short16 __builtin_ia32_psrav16hi_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrav4.si")
    int4 __builtin_ia32_psrav4si_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrav8.hi")
    short8 __builtin_ia32_psrav8hi_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrav8.si")
    int8 __builtin_ia32_psrav8si_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrav.q.128")
    long2 __builtin_ia32_psravq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrav.q.256")
    long4 __builtin_ia32_psravq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.d.128")
    int4 __builtin_ia32_psrld128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.d.256")
    int8 __builtin_ia32_psrld256_mask(int8, int4, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.di.128")
    int4 __builtin_ia32_psrldi128_mask(int4, byte, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.di.256")
    int8 __builtin_ia32_psrldi256_mask(int8, byte, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.q.128")
    long2 __builtin_ia32_psrlq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.q.256")
    long4 __builtin_ia32_psrlq256_mask(long4, long2, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.qi.128")
    long2 __builtin_ia32_psrlqi128_mask(long2, byte, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.qi.256")
    long4 __builtin_ia32_psrlqi256_mask(long4, byte, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.w.128")
    short8 __builtin_ia32_psrlw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.w.256")
    short16 __builtin_ia32_psrlw256_mask(short16, short8, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.wi.128")
    short8 __builtin_ia32_psrlwi128_mask(short8, byte, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrl.wi.256")
    short16 __builtin_ia32_psrlwi256_mask(short16, byte, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrlv16.hi")
    short16 __builtin_ia32_psrlv16hi_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrlv2.di")
    long2 __builtin_ia32_psrlv2di_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrlv4.di")
    long4 __builtin_ia32_psrlv4di_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrlv4.si")
    int4 __builtin_ia32_psrlv4si_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrlv8.hi")
    short8 __builtin_ia32_psrlv8hi_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psrlv8.si")
    int8 __builtin_ia32_psrlv8si_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psub.b.128")
    byte16 __builtin_ia32_psubb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psub.b.256")
    byte32 __builtin_ia32_psubb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psub.d.128")
    int4 __builtin_ia32_psubd128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psub.d.256")
    int8 __builtin_ia32_psubd256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psub.q.128")
    long2 __builtin_ia32_psubq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psub.q.256")
    long4 __builtin_ia32_psubq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psub.w.128")
    short8 __builtin_ia32_psubw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psub.w.256")
    short16 __builtin_ia32_psubw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psubs.b.128")
    byte16 __builtin_ia32_psubsb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psubs.b.256")
    byte32 __builtin_ia32_psubsb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psubs.w.128")
    short8 __builtin_ia32_psubsw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psubs.w.256")
    short16 __builtin_ia32_psubsw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psubus.b.128")
    byte16 __builtin_ia32_psubusb128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psubus.b.256")
    byte32 __builtin_ia32_psubusb256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psubus.w.128")
    short8 __builtin_ia32_psubusw128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.psubus.w.256")
    short16 __builtin_ia32_psubusw256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pternlog.d.128")
    int4 __builtin_ia32_pternlogd128_mask(int4, int4, int4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pternlog.d.256")
    int8 __builtin_ia32_pternlogd256_mask(int8, int8, int8, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pternlog.q.128")
    long2 __builtin_ia32_pternlogq128_mask(long2, long2, long2, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pternlog.q.256")
    long4 __builtin_ia32_pternlogq256_mask(long4, long4, long4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckhb.w.128")
    byte16 __builtin_ia32_punpckhbw128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckhb.w.256")
    byte32 __builtin_ia32_punpckhbw256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckhd.q.128")
    int4 __builtin_ia32_punpckhdq128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckhd.q.256")
    int8 __builtin_ia32_punpckhdq256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckhqd.q.128")
    long2 __builtin_ia32_punpckhqdq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckhqd.q.256")
    long4 __builtin_ia32_punpckhqdq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckhw.d.128")
    short8 __builtin_ia32_punpckhwd128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckhw.d.256")
    short16 __builtin_ia32_punpckhwd256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpcklb.w.128")
    byte16 __builtin_ia32_punpcklbw128_mask(byte16, byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpcklb.w.256")
    byte32 __builtin_ia32_punpcklbw256_mask(byte32, byte32, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckld.q.128")
    int4 __builtin_ia32_punpckldq128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpckld.q.256")
    int8 __builtin_ia32_punpckldq256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpcklqd.q.128")
    long2 __builtin_ia32_punpcklqdq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpcklqd.q.256")
    long4 __builtin_ia32_punpcklqdq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpcklw.d.128")
    short8 __builtin_ia32_punpcklwd128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.punpcklw.d.256")
    short16 __builtin_ia32_punpcklwd256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pxor.d.128")
    int4 __builtin_ia32_pxord128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pxor.d.256")
    int8 __builtin_ia32_pxord256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pxor.q.128")
    long2 __builtin_ia32_pxorq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.pxor.q.256")
    long4 __builtin_ia32_pxorq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.range.pd.128")
    double2 __builtin_ia32_rangepd128_mask(double2, double2, int, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.range.pd.256")
    double4 __builtin_ia32_rangepd256_mask(double4, double4, int, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.range.ps.128")
    float4 __builtin_ia32_rangeps128_mask(float4, float4, int, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.range.ps.256")
    float8 __builtin_ia32_rangeps256_mask(float8, float8, int, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.range.sd")
    double2 __builtin_ia32_rangesd128_round(double2, double2, double2, byte, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.range.ss")
    float4 __builtin_ia32_rangess128_round(float4, float4, float4, byte, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.reduce.pd.128")
    double2 __builtin_ia32_reducepd128_mask(double2, int, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.reduce.pd.256")
    double4 __builtin_ia32_reducepd256_mask(double4, int, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.reduce.ps.128")
    float4 __builtin_ia32_reduceps128_mask(float4, int, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.reduce.ps.256")
    float8 __builtin_ia32_reduceps256_mask(float8, int, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.reduce.sd")
    double2 __builtin_ia32_reducesd(double2, double2, double2, byte, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.reduce.ss")
    float4 __builtin_ia32_reducess(float4, float4, float4, byte, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.rndscale.pd.128")
    double2 __builtin_ia32_rndscalepd_128_mask(double2, int, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.rndscale.pd.256")
    double4 __builtin_ia32_rndscalepd_256_mask(double4, int, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.rndscale.ps.128")
    float4 __builtin_ia32_rndscaleps_128_mask(float4, int, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.rndscale.ps.256")
    float8 __builtin_ia32_rndscaleps_256_mask(float8, int, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.rndscale.sd")
    double2 __builtin_ia32_rndscalesd_round(double2, double2, double2, byte, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.rndscale.ss")
    float4 __builtin_ia32_rndscaless_round(float4, float4, float4, byte, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.scalef.pd.128")
    double2 __builtin_ia32_scalefpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.scalef.pd.256")
    double4 __builtin_ia32_scalefpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.scalef.ps.128")
    float4 __builtin_ia32_scalefps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.scalef.ps.256")
    float8 __builtin_ia32_scalefps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.scalef.sd")
    double2 __builtin_ia32_scalefsd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.scalef.ss")
    float4 __builtin_ia32_scalefss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.shuf.f32x4.256")
    float8 __builtin_ia32_shuf_f32x4_256_mask(float8, float8, int, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.shuf.f64x2.256")
    double4 __builtin_ia32_shuf_f64x2_256_mask(double4, double4, int, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.shuf.i32x4.256")
    int8 __builtin_ia32_shuf_i32x4_256_mask(int8, int8, int, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.shuf.i64x2.256")
    long4 __builtin_ia32_shuf_i64x2_256_mask(long4, long4, int, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.shuf.pd.128")
    double2 __builtin_ia32_shufpd128_mask(double2, double2, int, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.shuf.pd.256")
    double4 __builtin_ia32_shufpd256_mask(double4, double4, int, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.shuf.ps.128")
    float4 __builtin_ia32_shufps128_mask(float4, float4, int, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.shuf.ps.256")
    float8 __builtin_ia32_shufps256_mask(float8, float8, int, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sqrt.pd.128")
    double2 __builtin_ia32_sqrtpd128_mask(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sqrt.pd.256")
    double4 __builtin_ia32_sqrtpd256_mask(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sqrt.ps.128")
    float4 __builtin_ia32_sqrtps128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sqrt.ps.256")
    float8 __builtin_ia32_sqrtps256_mask(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sqrt.sd")
    double2 __builtin_ia32_sqrtsd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sqrt.ss")
    float4 __builtin_ia32_sqrtss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.store.ss")
    void __builtin_ia32_storess_mask(void*, float4, byte) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sub.pd.128")
    double2 __builtin_ia32_subpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sub.pd.256")
    double4 __builtin_ia32_subpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sub.ps.128")
    float4 __builtin_ia32_subps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sub.ps.256")
    float8 __builtin_ia32_subps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sub.sd.round")
    double2 __builtin_ia32_subsd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.sub.ss.round")
    float4 __builtin_ia32_subss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.ucmp.b.128")
    short __builtin_ia32_ucmpb128_mask(byte16, byte16, int, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.ucmp.b.256")
    int __builtin_ia32_ucmpb256_mask(byte32, byte32, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.ucmp.d.128")
    byte __builtin_ia32_ucmpd128_mask(int4, int4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.ucmp.d.256")
    byte __builtin_ia32_ucmpd256_mask(int8, int8, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.ucmp.q.128")
    byte __builtin_ia32_ucmpq128_mask(long2, long2, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.ucmp.q.256")
    byte __builtin_ia32_ucmpq256_mask(long4, long4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.ucmp.w.128")
    byte __builtin_ia32_ucmpw128_mask(short8, short8, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.ucmp.w.256")
    short __builtin_ia32_ucmpw256_mask(short16, short16, int, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.unpckh.pd.128")
    double2 __builtin_ia32_unpckhpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.unpckh.pd.256")
    double4 __builtin_ia32_unpckhpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.unpckh.ps.128")
    float4 __builtin_ia32_unpckhps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.unpckh.ps.256")
    float8 __builtin_ia32_unpckhps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.unpckl.pd.128")
    double2 __builtin_ia32_unpcklpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.unpckl.pd.256")
    double4 __builtin_ia32_unpcklpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.unpckl.ps.128")
    float4 __builtin_ia32_unpcklps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.unpckl.ps.256")
    float8 __builtin_ia32_unpcklps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.valign.d.128")
    int4 __builtin_ia32_alignd128_mask(int4, int4, int, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.valign.d.256")
    int8 __builtin_ia32_alignd256_mask(int8, int8, int, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.valign.q.128")
    long2 __builtin_ia32_alignq128_mask(long2, long2, int, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.valign.q.256")
    long4 __builtin_ia32_alignq256_mask(long4, long4, int, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vcvtph2ps.128")
    float4 __builtin_ia32_vcvtph2ps_mask(short8, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vcvtph2ps.256")
    float8 __builtin_ia32_vcvtph2ps256_mask(short8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vcvtps2ph.128")
    short8 __builtin_ia32_vcvtps2ph_mask(float4, int, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vcvtps2ph.256")
    short8 __builtin_ia32_vcvtps2ph256_mask(float8, int, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vextractf32x4.256")
    float4 __builtin_ia32_extractf32x4_256_mask(float8, int, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vextractf64x2.256")
    double2 __builtin_ia32_extractf64x2_256_mask(double4, int, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vextracti32x4.256")
    int4 __builtin_ia32_extracti32x4_256_mask(int8, int, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vextracti64x2.256")
    long2 __builtin_ia32_extracti64x2_256_mask(long4, int, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfmadd.pd.128")
    double2 __builtin_ia32_vfmaddpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfmadd.pd.256")
    double4 __builtin_ia32_vfmaddpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfmadd.ps.128")
    float4 __builtin_ia32_vfmaddps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfmadd.ps.256")
    float8 __builtin_ia32_vfmaddps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfmaddsub.pd.128")
    double2 __builtin_ia32_vfmaddsubpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfmaddsub.pd.256")
    double4 __builtin_ia32_vfmaddsubpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfmaddsub.ps.128")
    float4 __builtin_ia32_vfmaddsubps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfmaddsub.ps.256")
    float8 __builtin_ia32_vfmaddsubps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfnmadd.pd.128")
    double2 __builtin_ia32_vfnmaddpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfnmadd.pd.256")
    double4 __builtin_ia32_vfnmaddpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfnmadd.ps.128")
    float4 __builtin_ia32_vfnmaddps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfnmadd.ps.256")
    float8 __builtin_ia32_vfnmaddps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfnmsub.pd.128")
    double2 __builtin_ia32_vfnmsubpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfnmsub.pd.256")
    double4 __builtin_ia32_vfnmsubpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfnmsub.ps.128")
    float4 __builtin_ia32_vfnmsubps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vfnmsub.ps.256")
    float8 __builtin_ia32_vfnmsubps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.d.128")
    int4 __builtin_ia32_vpermi2vard128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.d.256")
    int8 __builtin_ia32_vpermi2vard256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.hi.128")
    short8 __builtin_ia32_vpermi2varhi128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.hi.256")
    short16 __builtin_ia32_vpermi2varhi256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.pd.128")
    double2 __builtin_ia32_vpermi2varpd128_mask(double2, long2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.pd.256")
    double4 __builtin_ia32_vpermi2varpd256_mask(double4, long4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.ps.128")
    float4 __builtin_ia32_vpermi2varps128_mask(float4, int4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.ps.256")
    float8 __builtin_ia32_vpermi2varps256_mask(float8, int8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.q.128")
    long2 __builtin_ia32_vpermi2varq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermi2var.q.256")
    long4 __builtin_ia32_vpermi2varq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermil.pd.128")
    double2 __builtin_ia32_vpermilpd_mask(double2, int, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermil.pd.256")
    double4 __builtin_ia32_vpermilpd256_mask(double4, int, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermil.ps.128")
    float4 __builtin_ia32_vpermilps_mask(float4, int, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermil.ps.256")
    float8 __builtin_ia32_vpermilps256_mask(float8, int, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermilvar.pd.128")
    double2 __builtin_ia32_vpermilvarpd_mask(double2, long2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermilvar.pd.256")
    double4 __builtin_ia32_vpermilvarpd256_mask(double4, long4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermilvar.ps.128")
    float4 __builtin_ia32_vpermilvarps_mask(float4, int4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermilvar.ps.256")
    float8 __builtin_ia32_vpermilvarps256_mask(float8, int8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.d.128")
    int4 __builtin_ia32_vpermt2vard128_mask(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.d.256")
    int8 __builtin_ia32_vpermt2vard256_mask(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.hi.128")
    short8 __builtin_ia32_vpermt2varhi128_mask(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.hi.256")
    short16 __builtin_ia32_vpermt2varhi256_mask(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.pd.128")
    double2 __builtin_ia32_vpermt2varpd128_mask(long2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.pd.256")
    double4 __builtin_ia32_vpermt2varpd256_mask(long4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.ps.128")
    float4 __builtin_ia32_vpermt2varps128_mask(int4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.ps.256")
    float8 __builtin_ia32_vpermt2varps256_mask(int8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.q.128")
    long2 __builtin_ia32_vpermt2varq128_mask(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.vpermt2var.q.256")
    long4 __builtin_ia32_vpermt2varq256_mask(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.xor.pd.128")
    double2 __builtin_ia32_xorpd128_mask(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.xor.pd.256")
    double4 __builtin_ia32_xorpd256_mask(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.xor.ps.128")
    float4 __builtin_ia32_xorps128_mask(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.mask.xor.ps.256")
    float8 __builtin_ia32_xorps256_mask(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.pternlog.d.128")
    int4 __builtin_ia32_pternlogd128_maskz(int4, int4, int4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.pternlog.d.256")
    int8 __builtin_ia32_pternlogd256_maskz(int8, int8, int8, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.pternlog.q.128")
    long2 __builtin_ia32_pternlogq128_maskz(long2, long2, long2, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.pternlog.q.256")
    long4 __builtin_ia32_pternlogq256_maskz(long4, long4, long4, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vfmadd.pd.128")
    double2 __builtin_ia32_vfmaddpd128_maskz(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vfmadd.pd.256")
    double4 __builtin_ia32_vfmaddpd256_maskz(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vfmadd.ps.128")
    float4 __builtin_ia32_vfmaddps128_maskz(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vfmadd.ps.256")
    float8 __builtin_ia32_vfmaddps256_maskz(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vfmaddsub.pd.128")
    double2 __builtin_ia32_vfmaddsubpd128_maskz(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vfmaddsub.pd.256")
    double4 __builtin_ia32_vfmaddsubpd256_maskz(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vfmaddsub.ps.128")
    float4 __builtin_ia32_vfmaddsubps128_maskz(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vfmaddsub.ps.256")
    float8 __builtin_ia32_vfmaddsubps256_maskz(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.d.128")
    int4 __builtin_ia32_vpermt2vard128_maskz(int4, int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.d.256")
    int8 __builtin_ia32_vpermt2vard256_maskz(int8, int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.hi.128")
    short8 __builtin_ia32_vpermt2varhi128_maskz(short8, short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.hi.256")
    short16 __builtin_ia32_vpermt2varhi256_maskz(short16, short16, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.pd.128")
    double2 __builtin_ia32_vpermt2varpd128_maskz(long2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.pd.256")
    double4 __builtin_ia32_vpermt2varpd256_maskz(long4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.ps.128")
    float4 __builtin_ia32_vpermt2varps128_maskz(int4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.ps.256")
    float8 __builtin_ia32_vpermt2varps256_maskz(int8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.q.128")
    long2 __builtin_ia32_vpermt2varq128_maskz(long2, long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.maskz.vpermt2var.q.256")
    long4 __builtin_ia32_vpermt2varq256_maskz(long4, long4, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.pbroadcastb.128")
    byte16 __builtin_ia32_pbroadcastb128_mask(byte16, byte16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.pbroadcastb.256")
    byte32 __builtin_ia32_pbroadcastb256_mask(byte16, byte32, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.pbroadcastd.128")
    int4 __builtin_ia32_pbroadcastd128_mask(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.pbroadcastd.256")
    int8 __builtin_ia32_pbroadcastd256_mask(int4, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.pbroadcastq.128")
    long2 __builtin_ia32_pbroadcastq128_mask(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.pbroadcastq.256")
    long4 __builtin_ia32_pbroadcastq256_mask(long2, long4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.pbroadcastw.128")
    short8 __builtin_ia32_pbroadcastw128_mask(short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.pbroadcastw.256")
    short16 __builtin_ia32_pbroadcastw256_mask(short8, short16, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rcp14.pd.128")
    double2 __builtin_ia32_rcp14pd128_mask(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rcp14.pd.256")
    double4 __builtin_ia32_rcp14pd256_mask(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rcp14.ps.128")
    float4 __builtin_ia32_rcp14ps128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rcp14.ps.256")
    float8 __builtin_ia32_rcp14ps256_mask(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rcp14.sd")
    double2 __builtin_ia32_rcp14sd(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rcp14.ss")
    float4 __builtin_ia32_rcp14ss(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rcp28.sd")
    double2 __builtin_ia32_rcp28sd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rcp28.ss")
    float4 __builtin_ia32_rcp28ss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rsqrt14.pd.128")
    double2 __builtin_ia32_rsqrt14pd128_mask(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rsqrt14.pd.256")
    double4 __builtin_ia32_rsqrt14pd256_mask(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rsqrt14.ps.128")
    float4 __builtin_ia32_rsqrt14ps128_mask(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rsqrt14.ps.256")
    float8 __builtin_ia32_rsqrt14ps256_mask(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rsqrt14.sd")
    double2 __builtin_ia32_rsqrt14sd(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rsqrt14.ss")
    float4 __builtin_ia32_rsqrt14ss(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rsqrt28.sd")
    double2 __builtin_ia32_rsqrt28sd_round(double2, double2, double2, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.rsqrt28.ss")
    float4 __builtin_ia32_rsqrt28ss_round(float4, float4, float4, byte, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.scatterdiv2.df")
    void __builtin_ia32_scatterdiv2df(void*, byte, long2, double2, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scatterdiv2.di")
    void __builtin_ia32_scatterdiv2di(void*, byte, long2, long2, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scatterdiv4.df")
    void __builtin_ia32_scatterdiv4df(void*, byte, long4, double4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scatterdiv4.di")
    void __builtin_ia32_scatterdiv4di(void*, byte, long4, long4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scatterdiv4.sf")
    void __builtin_ia32_scatterdiv4sf(void*, byte, long2, float4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scatterdiv4.si")
    void __builtin_ia32_scatterdiv4si(void*, byte, long2, int4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scatterdiv8.sf")
    void __builtin_ia32_scatterdiv8sf(void*, byte, long4, float4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scatterdiv8.si")
    void __builtin_ia32_scatterdiv8si(void*, byte, long4, int4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scatterpf.dpd.512")
    void __builtin_ia32_scatterpfdpd(byte, int8, void*, int, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scattersiv2.df")
    void __builtin_ia32_scattersiv2df(void*, byte, int4, double2, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scattersiv2.di")
    void __builtin_ia32_scattersiv2di(void*, byte, int4, long2, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scattersiv4.df")
    void __builtin_ia32_scattersiv4df(void*, byte, int4, double4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scattersiv4.di")
    void __builtin_ia32_scattersiv4di(void*, byte, int4, long4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scattersiv4.sf")
    void __builtin_ia32_scattersiv4sf(void*, byte, int4, float4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scattersiv4.si")
    void __builtin_ia32_scattersiv4si(void*, byte, int4, int4, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scattersiv8.sf")
    void __builtin_ia32_scattersiv8sf(void*, byte, int8, float8, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.scattersiv8.si")
    void __builtin_ia32_scattersiv8si(void*, byte, int8, int8, int) pure;

pragma(LDC_intrinsic, "llvm.x86.avx512.vcomi.sd")
    int __builtin_ia32_vcomisd(double2, double2, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx512.vcomi.ss")
    int __builtin_ia32_vcomiss(float4, float4, int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.addsub.pd.256")
    double4 __builtin_ia32_addsubpd256(double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.addsub.ps.256")
    float8 __builtin_ia32_addsubps256(float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.blendv.pd.256")
    double4 __builtin_ia32_blendvpd256(double4, double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.blendv.ps.256")
    float8 __builtin_ia32_blendvps256(float8, float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cmp.pd.256")
    double4 __builtin_ia32_cmppd256(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cmp.ps.256")
    float8 __builtin_ia32_cmpps256(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cvt.pd2.ps.256")
    float4 __builtin_ia32_cvtpd2ps256(double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cvt.pd2dq.256")
    int4 __builtin_ia32_cvtpd2dq256(double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cvt.ps2.pd.256")
    double4 __builtin_ia32_cvtps2pd256(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cvt.ps2dq.256")
    int8 __builtin_ia32_cvtps2dq256(float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cvtdq2.pd.256")
    double4 __builtin_ia32_cvtdq2pd256(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cvtdq2.ps.256")
    float8 __builtin_ia32_cvtdq2ps256(int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cvtt.pd2dq.256")
    int4 __builtin_ia32_cvttpd2dq256(double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.cvtt.ps2dq.256")
    int8 __builtin_ia32_cvttps2dq256(float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.dp.ps.256")
    float8 __builtin_ia32_dpps256(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.hadd.pd.256")
    double4 __builtin_ia32_haddpd256(double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.hadd.ps.256")
    float8 __builtin_ia32_haddps256(float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.hsub.pd.256")
    double4 __builtin_ia32_hsubpd256(double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.hsub.ps.256")
    float8 __builtin_ia32_hsubps256(float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.ldu.dq.256")
    byte32 __builtin_ia32_lddqu256(const void*);

pragma(LDC_intrinsic, "llvm.x86.avx.maskload.pd")
    double2 __builtin_ia32_maskloadpd(const void*, long2) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.maskload.pd.256")
    double4 __builtin_ia32_maskloadpd256(const void*, long4) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.maskload.ps")
    float4 __builtin_ia32_maskloadps(const void*, int4) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.maskload.ps.256")
    float8 __builtin_ia32_maskloadps256(const void*, int8) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.maskstore.pd")
    void __builtin_ia32_maskstorepd(void*, long2, double2) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.maskstore.pd.256")
    void __builtin_ia32_maskstorepd256(void*, long4, double4) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.maskstore.ps")
    void __builtin_ia32_maskstoreps(void*, int4, float4) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.maskstore.ps.256")
    void __builtin_ia32_maskstoreps256(void*, int8, float8) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.max.pd.256")
    double4 __builtin_ia32_maxpd256(double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.max.ps.256")
    float8 __builtin_ia32_maxps256(float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.min.pd.256")
    double4 __builtin_ia32_minpd256(double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.min.ps.256")
    float8 __builtin_ia32_minps256(float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.movmsk.pd.256")
    int __builtin_ia32_movmskpd256(double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.movmsk.ps.256")
    int __builtin_ia32_movmskps256(float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.ptestc.256")
    int __builtin_ia32_ptestc256(long4, long4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.ptestnzc.256")
    int __builtin_ia32_ptestnzc256(long4, long4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.ptestz.256")
    int __builtin_ia32_ptestz256(long4, long4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.rcp.ps.256")
    float8 __builtin_ia32_rcpps256(float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.round.pd.256")
    double4 __builtin_ia32_roundpd256(double4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.round.ps.256")
    float8 __builtin_ia32_roundps256(float8, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.rsqrt.ps.256")
    float8 __builtin_ia32_rsqrtps256(float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.sqrt.pd.256")
    double4 __builtin_ia32_sqrtpd256(double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.sqrt.ps.256")
    float8 __builtin_ia32_sqrtps256(float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.storeu.dq.256")
    void __builtin_ia32_storedqu256(void*, byte32) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.storeu.pd.256")
    void __builtin_ia32_storeupd256(void*, double4) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.storeu.ps.256")
    void __builtin_ia32_storeups256(void*, float8) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.vbroadcastf128.pd.256")
    double4 __builtin_ia32_vbroadcastf128_pd256(const void*) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.vbroadcastf128.ps.256")
    float8 __builtin_ia32_vbroadcastf128_ps256(const void*) pure;

pragma(LDC_intrinsic, "llvm.x86.avx.vperm2f128.pd.256")
    double4 __builtin_ia32_vperm2f128_pd256(double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vperm2f128.ps.256")
    float8 __builtin_ia32_vperm2f128_ps256(float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vperm2f128.si.256")
    int8 __builtin_ia32_vperm2f128_si256(int8, int8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vpermilvar.pd")
    double2 __builtin_ia32_vpermilvarpd(double2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vpermilvar.pd.256")
    double4 __builtin_ia32_vpermilvarpd256(double4, long4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vpermilvar.ps")
    float4 __builtin_ia32_vpermilvarps(float4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vpermilvar.ps.256")
    float8 __builtin_ia32_vpermilvarps256(float8, int8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestc.pd")
    int __builtin_ia32_vtestcpd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestc.pd.256")
    int __builtin_ia32_vtestcpd256(double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestc.ps")
    int __builtin_ia32_vtestcps(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestc.ps.256")
    int __builtin_ia32_vtestcps256(float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestnzc.pd")
    int __builtin_ia32_vtestnzcpd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestnzc.pd.256")
    int __builtin_ia32_vtestnzcpd256(double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestnzc.ps")
    int __builtin_ia32_vtestnzcps(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestnzc.ps.256")
    int __builtin_ia32_vtestnzcps256(float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestz.pd")
    int __builtin_ia32_vtestzpd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestz.pd.256")
    int __builtin_ia32_vtestzpd256(double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestz.ps")
    int __builtin_ia32_vtestzps(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vtestz.ps.256")
    int __builtin_ia32_vtestzps256(float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.avx.vzeroall")
    void __builtin_ia32_vzeroall();

pragma(LDC_intrinsic, "llvm.x86.avx.vzeroupper")
    void __builtin_ia32_vzeroupper();

pragma(LDC_intrinsic, "llvm.x86.bmi.bextr.32")
    int __builtin_ia32_bextr_u32(int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.bmi.bextr.64")
    long __builtin_ia32_bextr_u64(long, long) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.bmi.bzhi.32")
    int __builtin_ia32_bzhi_si(int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.bmi.bzhi.64")
    long __builtin_ia32_bzhi_di(long, long) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.bmi.pdep.32")
    int __builtin_ia32_pdep_si(int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.bmi.pdep.64")
    long __builtin_ia32_pdep_di(long, long) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.bmi.pext.32")
    int __builtin_ia32_pext_si(int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.bmi.pext.64")
    long __builtin_ia32_pext_di(long, long) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.flags.read.u32")
    int __builtin_ia32_readeflags_u32();

pragma(LDC_intrinsic, "llvm.x86.flags.read.u64")
    long __builtin_ia32_readeflags_u64();

pragma(LDC_intrinsic, "llvm.x86.flags.write.u32")
    void __builtin_ia32_writeeflags_u32(int);

pragma(LDC_intrinsic, "llvm.x86.flags.write.u64")
    void __builtin_ia32_writeeflags_u64(long);

pragma(LDC_intrinsic, "llvm.x86.fma.vfmadd.pd")
    double2 __builtin_ia32_vfmaddpd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmadd.pd.256")
    double4 __builtin_ia32_vfmaddpd256(double4, double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmadd.ps")
    float4 __builtin_ia32_vfmaddps(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmadd.ps.256")
    float8 __builtin_ia32_vfmaddps256(float8, float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmadd.sd")
    double2 __builtin_ia32_vfmaddsd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmadd.ss")
    float4 __builtin_ia32_vfmaddss(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmaddsub.pd")
    double2 __builtin_ia32_vfmaddsubpd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmaddsub.pd.256")
    double4 __builtin_ia32_vfmaddsubpd256(double4, double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmaddsub.ps")
    float4 __builtin_ia32_vfmaddsubps(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmaddsub.ps.256")
    float8 __builtin_ia32_vfmaddsubps256(float8, float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsub.pd")
    double2 __builtin_ia32_vfmsubpd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsub.pd.256")
    double4 __builtin_ia32_vfmsubpd256(double4, double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsub.ps")
    float4 __builtin_ia32_vfmsubps(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsub.ps.256")
    float8 __builtin_ia32_vfmsubps256(float8, float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsub.sd")
    double2 __builtin_ia32_vfmsubsd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsub.ss")
    float4 __builtin_ia32_vfmsubss(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsubadd.pd")
    double2 __builtin_ia32_vfmsubaddpd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsubadd.pd.256")
    double4 __builtin_ia32_vfmsubaddpd256(double4, double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsubadd.ps")
    float4 __builtin_ia32_vfmsubaddps(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfmsubadd.ps.256")
    float8 __builtin_ia32_vfmsubaddps256(float8, float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmadd.pd")
    double2 __builtin_ia32_vfnmaddpd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmadd.pd.256")
    double4 __builtin_ia32_vfnmaddpd256(double4, double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmadd.ps")
    float4 __builtin_ia32_vfnmaddps(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmadd.ps.256")
    float8 __builtin_ia32_vfnmaddps256(float8, float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmadd.sd")
    double2 __builtin_ia32_vfnmaddsd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmadd.ss")
    float4 __builtin_ia32_vfnmaddss(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmsub.pd")
    double2 __builtin_ia32_vfnmsubpd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmsub.pd.256")
    double4 __builtin_ia32_vfnmsubpd256(double4, double4, double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmsub.ps")
    float4 __builtin_ia32_vfnmsubps(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmsub.ps.256")
    float8 __builtin_ia32_vfnmsubps256(float8, float8, float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmsub.sd")
    double2 __builtin_ia32_vfnmsubsd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fma.vfnmsub.ss")
    float4 __builtin_ia32_vfnmsubss(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.fxrstor")
    void __builtin_ia32_fxrstor(void*);

pragma(LDC_intrinsic, "llvm.x86.fxrstor64")
    void __builtin_ia32_fxrstor64(void*);

pragma(LDC_intrinsic, "llvm.x86.fxsave")
    void __builtin_ia32_fxsave(void*);

pragma(LDC_intrinsic, "llvm.x86.fxsave64")
    void __builtin_ia32_fxsave64(void*);

pragma(LDC_intrinsic, "llvm.x86.mmx.emms")
    void __builtin_ia32_emms();

pragma(LDC_intrinsic, "llvm.x86.mmx.femms")
    void __builtin_ia32_femms();

pragma(LDC_intrinsic, "llvm.x86.pclmulqdq")
    long2 __builtin_ia32_pclmulqdq128(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.rdfsbase.32")
    int __builtin_ia32_rdfsbase32();

pragma(LDC_intrinsic, "llvm.x86.rdfsbase.64")
    long __builtin_ia32_rdfsbase64();

pragma(LDC_intrinsic, "llvm.x86.rdgsbase.32")
    int __builtin_ia32_rdgsbase32();

pragma(LDC_intrinsic, "llvm.x86.rdgsbase.64")
    long __builtin_ia32_rdgsbase64();

pragma(LDC_intrinsic, "llvm.x86.rdpkru")
    int __builtin_ia32_rdpkru();

pragma(LDC_intrinsic, "llvm.x86.rdpmc")
    long __builtin_ia32_rdpmc(int);

pragma(LDC_intrinsic, "llvm.x86.rdtsc")
    long __builtin_ia32_rdtsc();

pragma(LDC_intrinsic, "llvm.x86.rdtscp")
    long __builtin_ia32_rdtscp(void*) pure;

pragma(LDC_intrinsic, "llvm.x86.sha1msg1")
    int4 __builtin_ia32_sha1msg1(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sha1msg2")
    int4 __builtin_ia32_sha1msg2(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sha1nexte")
    int4 __builtin_ia32_sha1nexte(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sha1rnds4")
    int4 __builtin_ia32_sha1rnds4(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sha256msg1")
    int4 __builtin_ia32_sha256msg1(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sha256msg2")
    int4 __builtin_ia32_sha256msg2(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sha256rnds2")
    int4 __builtin_ia32_sha256rnds2(int4, int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.add.sd")
    double2 __builtin_ia32_addsd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.clflush")
    void __builtin_ia32_clflush(void*);

pragma(LDC_intrinsic, "llvm.x86.sse2.cmp.pd")
    double2 __builtin_ia32_cmppd(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cmp.sd")
    double2 __builtin_ia32_cmpsd(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.comieq.sd")
    int __builtin_ia32_comisdeq(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.comige.sd")
    int __builtin_ia32_comisdge(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.comigt.sd")
    int __builtin_ia32_comisdgt(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.comile.sd")
    int __builtin_ia32_comisdle(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.comilt.sd")
    int __builtin_ia32_comisdlt(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.comineq.sd")
    int __builtin_ia32_comisdneq(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtdq2pd")
    double2 __builtin_ia32_cvtdq2pd(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtdq2ps")
    float4 __builtin_ia32_cvtdq2ps(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtpd2dq")
    int4 __builtin_ia32_cvtpd2dq(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtpd2ps")
    float4 __builtin_ia32_cvtpd2ps(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtps2dq")
    int4 __builtin_ia32_cvtps2dq(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtps2pd")
    double2 __builtin_ia32_cvtps2pd(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtsd2si")
    int __builtin_ia32_cvtsd2si(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtsd2si64")
    long __builtin_ia32_cvtsd2si64(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtsd2ss")
    float4 __builtin_ia32_cvtsd2ss(float4, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtsi2sd")
    double2 __builtin_ia32_cvtsi2sd(double2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtsi642sd")
    double2 __builtin_ia32_cvtsi642sd(double2, long) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvtss2sd")
    double2 __builtin_ia32_cvtss2sd(double2, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvttpd2dq")
    int4 __builtin_ia32_cvttpd2dq(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvttps2dq")
    int4 __builtin_ia32_cvttps2dq(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvttsd2si")
    int __builtin_ia32_cvttsd2si(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.cvttsd2si64")
    long __builtin_ia32_cvttsd2si64(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.div.sd")
    double2 __builtin_ia32_divsd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.lfence")
    void __builtin_ia32_lfence();

pragma(LDC_intrinsic, "llvm.x86.sse2.maskmov.dqu")
    void __builtin_ia32_maskmovdqu(byte16, byte16, void*);

pragma(LDC_intrinsic, "llvm.x86.sse2.max.pd")
    double2 __builtin_ia32_maxpd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.max.sd")
    double2 __builtin_ia32_maxsd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.mfence")
    void __builtin_ia32_mfence();

pragma(LDC_intrinsic, "llvm.x86.sse2.min.pd")
    double2 __builtin_ia32_minpd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.min.sd")
    double2 __builtin_ia32_minsd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.movmsk.pd")
    int __builtin_ia32_movmskpd(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.mul.sd")
    double2 __builtin_ia32_mulsd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.packssdw.128")
    short8 __builtin_ia32_packssdw128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.packsswb.128")
    byte16 __builtin_ia32_packsswb128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.packuswb.128")
    byte16 __builtin_ia32_packuswb128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.padds.b")
    byte16 __builtin_ia32_paddsb128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.padds.w")
    short8 __builtin_ia32_paddsw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.paddus.b")
    byte16 __builtin_ia32_paddusb128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.paddus.w")
    short8 __builtin_ia32_paddusw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pause")
    void __builtin_ia32_pause();

pragma(LDC_intrinsic, "llvm.x86.sse2.pavg.b")
    byte16 __builtin_ia32_pavgb128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pavg.w")
    short8 __builtin_ia32_pavgw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pmadd.wd")
    int4 __builtin_ia32_pmaddwd128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pmaxs.w")
    short8 __builtin_ia32_pmaxsw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pmaxu.b")
    byte16 __builtin_ia32_pmaxub128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pmins.w")
    short8 __builtin_ia32_pminsw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pminu.b")
    byte16 __builtin_ia32_pminub128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pmovmskb.128")
    int __builtin_ia32_pmovmskb128(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pmulh.w")
    short8 __builtin_ia32_pmulhw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pmulhu.w")
    short8 __builtin_ia32_pmulhuw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pmulu.dq")
    long2 __builtin_ia32_pmuludq128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psad.bw")
    long2 __builtin_ia32_psadbw128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pshuf.d")
    int4 __builtin_ia32_pshufd(int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pshufh.w")
    short8 __builtin_ia32_pshufhw(short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pshufl.w")
    short8 __builtin_ia32_pshuflw(short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psll.d")
    int4 __builtin_ia32_pslld128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psll.q")
    long2 __builtin_ia32_psllq128(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psll.w")
    short8 __builtin_ia32_psllw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pslli.d")
    int4 __builtin_ia32_pslldi128(int4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pslli.q")
    long2 __builtin_ia32_psllqi128(long2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.pslli.w")
    short8 __builtin_ia32_psllwi128(short8, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psra.d")
    int4 __builtin_ia32_psrad128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psra.w")
    short8 __builtin_ia32_psraw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psrai.d")
    int4 __builtin_ia32_psradi128(int4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psrai.w")
    short8 __builtin_ia32_psrawi128(short8, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psrl.d")
    int4 __builtin_ia32_psrld128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psrl.q")
    long2 __builtin_ia32_psrlq128(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psrl.w")
    short8 __builtin_ia32_psrlw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psrli.d")
    int4 __builtin_ia32_psrldi128(int4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psrli.q")
    long2 __builtin_ia32_psrlqi128(long2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psrli.w")
    short8 __builtin_ia32_psrlwi128(short8, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psubs.b")
    byte16 __builtin_ia32_psubsb128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psubs.w")
    short8 __builtin_ia32_psubsw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psubus.b")
    byte16 __builtin_ia32_psubusb128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.psubus.w")
    short8 __builtin_ia32_psubusw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.sqrt.pd")
    double2 __builtin_ia32_sqrtpd(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.sqrt.sd")
    double2 __builtin_ia32_sqrtsd(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.storel.dq")
    void __builtin_ia32_storelv4si(void*, int4) pure;

pragma(LDC_intrinsic, "llvm.x86.sse2.storeu.dq")
    void __builtin_ia32_storedqu(void*, byte16) pure;

pragma(LDC_intrinsic, "llvm.x86.sse2.storeu.pd")
    void __builtin_ia32_storeupd(void*, double2) pure;

pragma(LDC_intrinsic, "llvm.x86.sse2.sub.sd")
    double2 __builtin_ia32_subsd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.ucomieq.sd")
    int __builtin_ia32_ucomisdeq(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.ucomige.sd")
    int __builtin_ia32_ucomisdge(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.ucomigt.sd")
    int __builtin_ia32_ucomisdgt(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.ucomile.sd")
    int __builtin_ia32_ucomisdle(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.ucomilt.sd")
    int __builtin_ia32_ucomisdlt(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse2.ucomineq.sd")
    int __builtin_ia32_ucomisdneq(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse3.addsub.pd")
    double2 __builtin_ia32_addsubpd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse3.addsub.ps")
    float4 __builtin_ia32_addsubps(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse3.hadd.pd")
    double2 __builtin_ia32_haddpd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse3.hadd.ps")
    float4 __builtin_ia32_haddps(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse3.hsub.pd")
    double2 __builtin_ia32_hsubpd(double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse3.hsub.ps")
    float4 __builtin_ia32_hsubps(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse3.ldu.dq")
    byte16 __builtin_ia32_lddqu(const void*);

pragma(LDC_intrinsic, "llvm.x86.sse3.monitor")
    void __builtin_ia32_monitor(void*, int, int);

pragma(LDC_intrinsic, "llvm.x86.sse3.mwait")
    void __builtin_ia32_mwait(int, int);

pragma(LDC_intrinsic, "llvm.x86.sse41.blendvpd")
    double2 __builtin_ia32_blendvpd(double2, double2, double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.blendvps")
    float4 __builtin_ia32_blendvps(float4, float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.dppd")
    double2 __builtin_ia32_dppd(double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.dpps")
    float4 __builtin_ia32_dpps(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.extractps")
    int __builtin_ia32_extractps128(float4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.insertps")
    float4 __builtin_ia32_insertps128(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.movntdqa")
    long2 __builtin_ia32_movntdqa(const void*);

pragma(LDC_intrinsic, "llvm.x86.sse41.mpsadbw")
    short8 __builtin_ia32_mpsadbw128(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.packusdw")
    short8 __builtin_ia32_packusdw128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pblendvb")
    byte16 __builtin_ia32_pblendvb128(byte16, byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.phminposuw")
    short8 __builtin_ia32_phminposuw128(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmaxsb")
    byte16 __builtin_ia32_pmaxsb128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmaxsd")
    int4 __builtin_ia32_pmaxsd128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmaxud")
    int4 __builtin_ia32_pmaxud128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmaxuw")
    short8 __builtin_ia32_pmaxuw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pminsb")
    byte16 __builtin_ia32_pminsb128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pminsd")
    int4 __builtin_ia32_pminsd128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pminud")
    int4 __builtin_ia32_pminud128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pminuw")
    short8 __builtin_ia32_pminuw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovsxbd")
    int4 __builtin_ia32_pmovsxbd128(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovsxbq")
    long2 __builtin_ia32_pmovsxbq128(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovsxbw")
    short8 __builtin_ia32_pmovsxbw128(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovsxdq")
    long2 __builtin_ia32_pmovsxdq128(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovsxwd")
    int4 __builtin_ia32_pmovsxwd128(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovsxwq")
    long2 __builtin_ia32_pmovsxwq128(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovzxbd")
    int4 __builtin_ia32_pmovzxbd128(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovzxbq")
    long2 __builtin_ia32_pmovzxbq128(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovzxbw")
    short8 __builtin_ia32_pmovzxbw128(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovzxdq")
    long2 __builtin_ia32_pmovzxdq128(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovzxwd")
    int4 __builtin_ia32_pmovzxwd128(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmovzxwq")
    long2 __builtin_ia32_pmovzxwq128(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.pmuldq")
    long2 __builtin_ia32_pmuldq128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.ptestc")
    int __builtin_ia32_ptestc128(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.ptestnzc")
    int __builtin_ia32_ptestnzc128(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.ptestz")
    int __builtin_ia32_ptestz128(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.round.pd")
    double2 __builtin_ia32_roundpd(double2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.round.ps")
    float4 __builtin_ia32_roundps(float4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.round.sd")
    double2 __builtin_ia32_roundsd(double2, double2, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse41.round.ss")
    float4 __builtin_ia32_roundss(float4, float4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.crc32.32.16")
    int __builtin_ia32_crc32hi(int, short) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.crc32.32.32")
    int __builtin_ia32_crc32si(int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.crc32.32.8")
    int __builtin_ia32_crc32qi(int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.crc32.64.64")
    long __builtin_ia32_crc32di(long, long) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpestri128")
    int __builtin_ia32_pcmpestri128(byte16, int, byte16, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpestria128")
    int __builtin_ia32_pcmpestria128(byte16, int, byte16, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpestric128")
    int __builtin_ia32_pcmpestric128(byte16, int, byte16, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpestrio128")
    int __builtin_ia32_pcmpestrio128(byte16, int, byte16, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpestris128")
    int __builtin_ia32_pcmpestris128(byte16, int, byte16, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpestriz128")
    int __builtin_ia32_pcmpestriz128(byte16, int, byte16, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpestrm128")
    byte16 __builtin_ia32_pcmpestrm128(byte16, int, byte16, int, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpistri128")
    int __builtin_ia32_pcmpistri128(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpistria128")
    int __builtin_ia32_pcmpistria128(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpistric128")
    int __builtin_ia32_pcmpistric128(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpistrio128")
    int __builtin_ia32_pcmpistrio128(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpistris128")
    int __builtin_ia32_pcmpistris128(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpistriz128")
    int __builtin_ia32_pcmpistriz128(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse42.pcmpistrm128")
    byte16 __builtin_ia32_pcmpistrm128(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse4a.extrq")
    long2 __builtin_ia32_extrq(long2, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse4a.extrqi")
    long2 __builtin_ia32_extrqi(long2, byte, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse4a.insertq")
    long2 __builtin_ia32_insertq(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse4a.insertqi")
    long2 __builtin_ia32_insertqi(long2, long2, byte, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse4a.movnt.sd")
    void __builtin_ia32_movntsd(void*, double2);

pragma(LDC_intrinsic, "llvm.x86.sse4a.movnt.ss")
    void __builtin_ia32_movntss(void*, float4);

pragma(LDC_intrinsic, "llvm.x86.sse.add.ss")
    float4 __builtin_ia32_addss(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.cmp.ps")
    float4 __builtin_ia32_cmpps(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.cmp.ss")
    float4 __builtin_ia32_cmpss(float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.comieq.ss")
    int __builtin_ia32_comieq(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.comige.ss")
    int __builtin_ia32_comige(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.comigt.ss")
    int __builtin_ia32_comigt(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.comile.ss")
    int __builtin_ia32_comile(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.comilt.ss")
    int __builtin_ia32_comilt(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.comineq.ss")
    int __builtin_ia32_comineq(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.cvtsi2ss")
    float4 __builtin_ia32_cvtsi2ss(float4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.cvtsi642ss")
    float4 __builtin_ia32_cvtsi642ss(float4, long) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.cvtss2si")
    int __builtin_ia32_cvtss2si(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.cvtss2si64")
    long __builtin_ia32_cvtss2si64(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.cvttss2si")
    int __builtin_ia32_cvttss2si(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.cvttss2si64")
    long __builtin_ia32_cvttss2si64(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.div.ss")
    float4 __builtin_ia32_divss(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.max.ps")
    float4 __builtin_ia32_maxps(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.max.ss")
    float4 __builtin_ia32_maxss(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.min.ps")
    float4 __builtin_ia32_minps(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.min.ss")
    float4 __builtin_ia32_minss(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.movmsk.ps")
    int __builtin_ia32_movmskps(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.mul.ss")
    float4 __builtin_ia32_mulss(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.rcp.ps")
    float4 __builtin_ia32_rcpps(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.rcp.ss")
    float4 __builtin_ia32_rcpss(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.rsqrt.ps")
    float4 __builtin_ia32_rsqrtps(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.rsqrt.ss")
    float4 __builtin_ia32_rsqrtss(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.sfence")
    void __builtin_ia32_sfence();

pragma(LDC_intrinsic, "llvm.x86.sse.sqrt.ps")
    float4 __builtin_ia32_sqrtps(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.sqrt.ss")
    float4 __builtin_ia32_sqrtss(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.storeu.ps")
    void __builtin_ia32_storeups(void*, float4) pure;

pragma(LDC_intrinsic, "llvm.x86.sse.sub.ss")
    float4 __builtin_ia32_subss(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.ucomieq.ss")
    int __builtin_ia32_ucomieq(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.ucomige.ss")
    int __builtin_ia32_ucomige(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.ucomigt.ss")
    int __builtin_ia32_ucomigt(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.ucomile.ss")
    int __builtin_ia32_ucomile(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.ucomilt.ss")
    int __builtin_ia32_ucomilt(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.sse.ucomineq.ss")
    int __builtin_ia32_ucomineq(float4, float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.pabs.b.128")
    byte16 __builtin_ia32_pabsb128(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.pabs.d.128")
    int4 __builtin_ia32_pabsd128(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.pabs.w.128")
    short8 __builtin_ia32_pabsw128(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.phadd.d.128")
    int4 __builtin_ia32_phaddd128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.phadd.sw.128")
    short8 __builtin_ia32_phaddsw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.phadd.w.128")
    short8 __builtin_ia32_phaddw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.phsub.d.128")
    int4 __builtin_ia32_phsubd128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.phsub.sw.128")
    short8 __builtin_ia32_phsubsw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.phsub.w.128")
    short8 __builtin_ia32_phsubw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.pmadd.ub.sw.128")
    short8 __builtin_ia32_pmaddubsw128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.pmul.hr.sw.128")
    short8 __builtin_ia32_pmulhrsw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.pshuf.b.128")
    byte16 __builtin_ia32_pshufb128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.psign.b.128")
    byte16 __builtin_ia32_psignb128(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.psign.d.128")
    int4 __builtin_ia32_psignd128(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.ssse3.psign.w.128")
    short8 __builtin_ia32_psignw128(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.subborrow.u32")
    byte __builtin_ia32_subborrow_u32(byte, int, int, void*) pure;

pragma(LDC_intrinsic, "llvm.x86.subborrow.u64")
    byte __builtin_ia32_subborrow_u64(byte, long, long, void*) pure;

pragma(LDC_intrinsic, "llvm.x86.tbm.bextri.u32")
    int __builtin_ia32_bextri_u32(int, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.tbm.bextri.u64")
    long __builtin_ia32_bextri_u64(long, long) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.vcvtph2ps.128")
    float4 __builtin_ia32_vcvtph2ps(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.vcvtph2ps.256")
    float8 __builtin_ia32_vcvtph2ps256(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.vcvtps2ph.128")
    short8 __builtin_ia32_vcvtps2ph(float4, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.vcvtps2ph.256")
    short8 __builtin_ia32_vcvtps2ph256(float8, int) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.wrfsbase.32")
    void __builtin_ia32_wrfsbase32(int);

pragma(LDC_intrinsic, "llvm.x86.wrfsbase.64")
    void __builtin_ia32_wrfsbase64(long);

pragma(LDC_intrinsic, "llvm.x86.wrgsbase.32")
    void __builtin_ia32_wrgsbase32(int);

pragma(LDC_intrinsic, "llvm.x86.wrgsbase.64")
    void __builtin_ia32_wrgsbase64(long);

pragma(LDC_intrinsic, "llvm.x86.wrpkru")
    void __builtin_ia32_wrpkru(int);

pragma(LDC_intrinsic, "llvm.x86.xabort")
    void __builtin_ia32_xabort(byte);

pragma(LDC_intrinsic, "llvm.x86.xbegin")
    int __builtin_ia32_xbegin();

pragma(LDC_intrinsic, "llvm.x86.xend")
    void __builtin_ia32_xend();

pragma(LDC_intrinsic, "llvm.x86.xop.vfrcz.pd")
    double2 __builtin_ia32_vfrczpd(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vfrcz.pd.256")
    double4 __builtin_ia32_vfrczpd256(double4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vfrcz.ps")
    float4 __builtin_ia32_vfrczps(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vfrcz.ps.256")
    float8 __builtin_ia32_vfrczps256(float8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vfrcz.sd")
    double2 __builtin_ia32_vfrczsd(double2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vfrcz.ss")
    float4 __builtin_ia32_vfrczss(float4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcmov")
    long2 __builtin_ia32_vpcmov(long2, long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcmov.256")
    long4 __builtin_ia32_vpcmov_256(long4, long4, long4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcomb")
    byte16 __builtin_ia32_vpcomb(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcomd")
    int4 __builtin_ia32_vpcomd(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcomq")
    long2 __builtin_ia32_vpcomq(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcomub")
    byte16 __builtin_ia32_vpcomub(byte16, byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcomud")
    int4 __builtin_ia32_vpcomud(int4, int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcomuq")
    long2 __builtin_ia32_vpcomuq(long2, long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcomuw")
    short8 __builtin_ia32_vpcomuw(short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpcomw")
    short8 __builtin_ia32_vpcomw(short8, short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpermil2pd")
    double2 __builtin_ia32_vpermil2pd(double2, double2, double2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpermil2pd.256")
    double4 __builtin_ia32_vpermil2pd256(double4, double4, double4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpermil2ps")
    float4 __builtin_ia32_vpermil2ps(float4, float4, float4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpermil2ps.256")
    float8 __builtin_ia32_vpermil2ps256(float8, float8, float8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphaddbd")
    int4 __builtin_ia32_vphaddbd(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphaddbq")
    long2 __builtin_ia32_vphaddbq(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphaddbw")
    short8 __builtin_ia32_vphaddbw(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphadddq")
    long2 __builtin_ia32_vphadddq(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphaddubd")
    int4 __builtin_ia32_vphaddubd(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphaddubq")
    long2 __builtin_ia32_vphaddubq(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphaddubw")
    short8 __builtin_ia32_vphaddubw(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphaddudq")
    long2 __builtin_ia32_vphaddudq(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphadduwd")
    int4 __builtin_ia32_vphadduwd(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphadduwq")
    long2 __builtin_ia32_vphadduwq(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphaddwd")
    int4 __builtin_ia32_vphaddwd(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphaddwq")
    long2 __builtin_ia32_vphaddwq(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphsubbw")
    short8 __builtin_ia32_vphsubbw(byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphsubdq")
    long2 __builtin_ia32_vphsubdq(int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vphsubwd")
    int4 __builtin_ia32_vphsubwd(short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacsdd")
    int4 __builtin_ia32_vpmacsdd(int4, int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacsdqh")
    long2 __builtin_ia32_vpmacsdqh(int4, int4, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacsdql")
    long2 __builtin_ia32_vpmacsdql(int4, int4, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacssdd")
    int4 __builtin_ia32_vpmacssdd(int4, int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacssdqh")
    long2 __builtin_ia32_vpmacssdqh(int4, int4, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacssdql")
    long2 __builtin_ia32_vpmacssdql(int4, int4, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacsswd")
    int4 __builtin_ia32_vpmacsswd(short8, short8, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacssww")
    short8 __builtin_ia32_vpmacssww(short8, short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacswd")
    int4 __builtin_ia32_vpmacswd(short8, short8, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmacsww")
    short8 __builtin_ia32_vpmacsww(short8, short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmadcsswd")
    int4 __builtin_ia32_vpmadcsswd(short8, short8, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpmadcswd")
    int4 __builtin_ia32_vpmadcswd(short8, short8, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpperm")
    byte16 __builtin_ia32_vpperm(byte16, byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vprotb")
    byte16 __builtin_ia32_vprotb(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vprotbi")
    byte16 __builtin_ia32_vprotbi(byte16, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vprotd")
    int4 __builtin_ia32_vprotd(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vprotdi")
    int4 __builtin_ia32_vprotdi(int4, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vprotq")
    long2 __builtin_ia32_vprotq(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vprotqi")
    long2 __builtin_ia32_vprotqi(long2, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vprotw")
    short8 __builtin_ia32_vprotw(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vprotwi")
    short8 __builtin_ia32_vprotwi(short8, byte) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpshab")
    byte16 __builtin_ia32_vpshab(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpshad")
    int4 __builtin_ia32_vpshad(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpshaq")
    long2 __builtin_ia32_vpshaq(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpshaw")
    short8 __builtin_ia32_vpshaw(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpshlb")
    byte16 __builtin_ia32_vpshlb(byte16, byte16) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpshld")
    int4 __builtin_ia32_vpshld(int4, int4) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpshlq")
    long2 __builtin_ia32_vpshlq(long2, long2) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xop.vpshlw")
    short8 __builtin_ia32_vpshlw(short8, short8) pure @safe;

pragma(LDC_intrinsic, "llvm.x86.xtest")
    int __builtin_ia32_xtest();

