
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

80003000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
80003000:	000011b7          	lui	gp,0x1
        addi    gp, gp, %lo(__global_pointer$)
80003004:	80018193          	addi	gp,gp,-2048 # 800 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80003008:	00081237          	lui	tp,0x81
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	b0020213          	addi	tp,tp,-1280 # 80b00 <__thread_pointer$>
        .option pop

        csrw    mstatus, zero
80003010:	30001073          	csrw	mstatus,zero
        csrw    mcause, zero
80003014:	34201073          	csrw	mcause,zero
    la t0, _stack_safe
    mv sp, t0
    call _init_ext_ram
#endif

        lui     t0,     %hi(__stack_end__)
80003018:	000a02b7          	lui	t0,0xa0
        addi    sp, t0, %lo(__stack_end__)
8000301c:	00028113          	mv	sp,t0

#ifdef CONFIG_NOT_ENABLE_ICACHE
        call    l1c_ic_disable
#else
        call    l1c_ic_enable
80003020:	2a6d                	jal	800031da <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003022:	2251                	jal	800031a6 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
80003024:	2471                	jal	800032b0 <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
80003026:	241d                	jal	8000324c <_init>

80003028 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003028:	80003437          	lui	s0,0x80003
8000302c:	30040413          	addi	s0,s0,768 # 80003300 <__fsymtab_end>

80003030 <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
80003030:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
80003032:	0411                	addi	s0,s0,4
        jalr    a0                              // Call initialization function
80003034:	9502                	jalr	a0
        j       L(RunInit)
80003036:	bfed                	j	80003030 <.L_start_RunInit>

80003038 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
80003038:	28b9                	jal	80003096 <_clean_up>

8000303a <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
8000303a:	80018293          	addi	t0,gp,-2048 # 0 <__AHB_SRAM_segment_used_size__>
    csrw mtvec, t0
8000303e:	30529073          	csrw	mtvec,t0

    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
80003042:	7d016073          	csrsi	0x7d0,2

80003046 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80003046:	2acd                	jal	80003238 <reset_handler>
        tail    exit
80003048:	a009                	j	8000304a <exit>

8000304a <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
8000304a:	a001                	j	8000304a <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
8000304c:	4501                	li	a0,0
        li      a1, 0
8000304e:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
80003050:	22e5                	jal	80003238 <reset_handler>
        tail    exit
80003052:	bfe5                	j	8000304a <exit>

Disassembly of section .text.main:

80003094 <main>:

#include "hpm_gpio_drv.h"

int main(void)
{
    while (1) {
80003094:	a001                	j	80003094 <main>

Disassembly of section .text._clean_up:

80003096 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
80003096:	7139                	addi	sp,sp,-64

80003098 <.LBB18>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003098:	28b01793          	bseti	a5,zero,0xb
8000309c:	3047b073          	csrc	mie,a5
}
800030a0:	0001                	nop
800030a2:	da02                	sw	zero,52(sp)
800030a4:	d802                	sw	zero,48(sp)
800030a6:	e40007b7          	lui	a5,0xe4000
800030aa:	d63e                	sw	a5,44(sp)
800030ac:	57d2                	lw	a5,52(sp)
800030ae:	d43e                	sw	a5,40(sp)
800030b0:	57c2                	lw	a5,48(sp)
800030b2:	d23e                	sw	a5,36(sp)

800030b4 <.LBB20>:
                                                           uint32_t target,
                                                           uint32_t threshold)
{
    volatile uint32_t *threshold_ptr = (volatile uint32_t *) (base +
                                                              HPM_PLIC_THRESHOLD_OFFSET +
                                                              (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
800030b4:	57a2                	lw	a5,40(sp)
800030b6:	00c79713          	slli	a4,a5,0xc
                                                              HPM_PLIC_THRESHOLD_OFFSET +
800030ba:	57b2                	lw	a5,44(sp)
800030bc:	973e                	add	a4,a4,a5
800030be:	002007b7          	lui	a5,0x200
800030c2:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *) (base +
800030c4:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
800030c6:	5782                	lw	a5,32(sp)
800030c8:	5712                	lw	a4,36(sp)
800030ca:	c398                	sw	a4,0(a5)
}
800030cc:	0001                	nop

800030ce <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
800030ce:	0001                	nop

800030d0 <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
800030d0:	de02                	sw	zero,60(sp)
800030d2:	a82d                	j	8000310c <.L2>

800030d4 <.L3>:
800030d4:	ce02                	sw	zero,28(sp)
800030d6:	57f2                	lw	a5,60(sp)
800030d8:	cc3e                	sw	a5,24(sp)
800030da:	e40007b7          	lui	a5,0xe4000
800030de:	ca3e                	sw	a5,20(sp)
800030e0:	47f2                	lw	a5,28(sp)
800030e2:	c83e                	sw	a5,16(sp)
800030e4:	47e2                	lw	a5,24(sp)
800030e6:	c63e                	sw	a5,12(sp)

800030e8 <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
                                                           HPM_PLIC_CLAIM_OFFSET +
                                                           (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
800030e8:	47c2                	lw	a5,16(sp)
800030ea:	00c79713          	slli	a4,a5,0xc
                                                           HPM_PLIC_CLAIM_OFFSET +
800030ee:	47d2                	lw	a5,20(sp)
800030f0:	973e                	add	a4,a4,a5
800030f2:	002007b7          	lui	a5,0x200
800030f6:	0791                	addi	a5,a5,4 # 200004 <_flash_size+0x100004>
800030f8:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
800030fa:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
800030fc:	47a2                	lw	a5,8(sp)
800030fe:	4732                	lw	a4,12(sp)
80003100:	c398                	sw	a4,0(a5)
}
80003102:	0001                	nop

80003104 <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
80003104:	0001                	nop

80003106 <.LBE25>:
80003106:	57f2                	lw	a5,60(sp)
80003108:	0785                	addi	a5,a5,1
8000310a:	de3e                	sw	a5,60(sp)

8000310c <.L2>:
8000310c:	5772                	lw	a4,60(sp)
8000310e:	07f00793          	li	a5,127
80003112:	fce7f1e3          	bgeu	a5,a4,800030d4 <.L3>

80003116 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
80003116:	dc02                	sw	zero,56(sp)
80003118:	a821                	j	80003130 <.L4>

8000311a <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
8000311a:	57e2                	lw	a5,56(sp)
8000311c:	00279713          	slli	a4,a5,0x2
80003120:	e40027b7          	lui	a5,0xe4002
80003124:	97ba                	add	a5,a5,a4
80003126:	0007a023          	sw	zero,0(a5) # e4002000 <__FLASH_segment_end__+0x63f02000>
    for (uint32_t i = 0; i < 4; i++) {
8000312a:	57e2                	lw	a5,56(sp)
8000312c:	0785                	addi	a5,a5,1
8000312e:	dc3e                	sw	a5,56(sp)

80003130 <.L4>:
80003130:	5762                	lw	a4,56(sp)
80003132:	478d                	li	a5,3
80003134:	fee7f3e3          	bgeu	a5,a4,8000311a <.L5>

80003138 <.LBE29>:
    }
}
80003138:	0001                	nop
8000313a:	0001                	nop
8000313c:	6121                	addi	sp,sp,64
8000313e:	8082                	ret

Disassembly of section .text.syscall_handler:

80003140 <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
80003140:	1101                	addi	sp,sp,-32
80003142:	ce2a                	sw	a0,28(sp)
80003144:	cc2e                	sw	a1,24(sp)
80003146:	ca32                	sw	a2,20(sp)
80003148:	c836                	sw	a3,16(sp)
8000314a:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
8000314c:	0001                	nop
8000314e:	6105                	addi	sp,sp,32
80003150:	8082                	ret

Disassembly of section .text.system_init:

80003152 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
80003152:	7179                	addi	sp,sp,-48
80003154:	d606                	sw	ra,44(sp)

80003156 <.LBB16>:
#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
80003156:	306027f3          	csrr	a5,mcounteren
8000315a:	ce3e                	sw	a5,28(sp)
8000315c:	47f2                	lw	a5,28(sp)

8000315e <.LBE16>:
8000315e:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80003160:	47e2                	lw	a5,24(sp)
80003162:	0017e793          	ori	a5,a5,1
80003166:	30679073          	csrw	mcounteren,a5
8000316a:	47a1                	li	a5,8
8000316c:	c83e                	sw	a5,16(sp)

8000316e <.LBB17>:
    return read_clear_csr(CSR_MSTATUS, mask);
8000316e:	c602                	sw	zero,12(sp)
80003170:	47c2                	lw	a5,16(sp)
80003172:	3007b7f3          	csrrc	a5,mstatus,a5
80003176:	c63e                	sw	a5,12(sp)
80003178:	47b2                	lw	a5,12(sp)

8000317a <.LBE19>:
8000317a:	0001                	nop

8000317c <.LBB20>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
8000317c:	28b01793          	bseti	a5,zero,0xb
80003180:	3047b073          	csrc	mie,a5
}
80003184:	0001                	nop

80003186 <.LBE20>:
#endif

    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();

    enable_plic_feature();
80003186:	28fd                	jal	80003284 <enable_plic_feature>

80003188 <.LBB22>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003188:	28b01793          	bseti	a5,zero,0xb
8000318c:	3047a073          	csrs	mie,a5
}
80003190:	0001                	nop
80003192:	47a1                	li	a5,8
80003194:	ca3e                	sw	a5,20(sp)

80003196 <.LBB24>:
    set_csr(CSR_MSTATUS, mask);
80003196:	47d2                	lw	a5,20(sp)
80003198:	3007a073          	csrs	mstatus,a5
}
8000319c:	0001                	nop

8000319e <.LBE24>:
    enable_irq_from_intc();

#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif
}
8000319e:	0001                	nop
800031a0:	50b2                	lw	ra,44(sp)
800031a2:	6145                	addi	sp,sp,48
800031a4:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

800031a6 <l1c_dc_enable>:
    }
#endif
}

void l1c_dc_enable(void)
{
800031a6:	1101                	addi	sp,sp,-32
800031a8:	ce06                	sw	ra,28(sp)

800031aa <.LBB48>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
800031aa:	7ca027f3          	csrr	a5,0x7ca
800031ae:	c63e                	sw	a5,12(sp)
800031b0:	47b2                	lw	a5,12(sp)

800031b2 <.LBE52>:
800031b2:	0001                	nop

800031b4 <.LBE50>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
800031b4:	8b89                	andi	a5,a5,2
800031b6:	00f037b3          	snez	a5,a5
800031ba:	0ff7f793          	zext.b	a5,a5

800031be <.LBE48>:
    if (!l1c_dc_is_enabled()) {
800031be:	0017c793          	xori	a5,a5,1
800031c2:	0ff7f793          	zext.b	a5,a5
800031c6:	c791                	beqz	a5,800031d2 <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
800031c8:	2081                	jal	80003208 <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
800031ca:	40200793          	li	a5,1026
800031ce:	7ca7a073          	csrs	0x7ca,a5

800031d2 <.L11>:
    }
}
800031d2:	0001                	nop
800031d4:	40f2                	lw	ra,28(sp)
800031d6:	6105                	addi	sp,sp,32
800031d8:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

800031da <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
800031da:	1141                	addi	sp,sp,-16

800031dc <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
800031dc:	7ca027f3          	csrr	a5,0x7ca
800031e0:	c63e                	sw	a5,12(sp)
800031e2:	47b2                	lw	a5,12(sp)

800031e4 <.LBE62>:
800031e4:	0001                	nop

800031e6 <.LBE60>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
800031e6:	8b85                	andi	a5,a5,1
800031e8:	00f037b3          	snez	a5,a5
800031ec:	0ff7f793          	zext.b	a5,a5

800031f0 <.LBE58>:
    if (!l1c_ic_is_enabled()) {
800031f0:	0017c793          	xori	a5,a5,1
800031f4:	0ff7f793          	zext.b	a5,a5
800031f8:	c789                	beqz	a5,80003202 <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
800031fa:	30100793          	li	a5,769
800031fe:	7ca7a073          	csrs	0x7ca,a5

80003202 <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
80003202:	0001                	nop
80003204:	0141                	addi	sp,sp,16
80003206:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

80003208 <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
80003208:	6799                	lui	a5,0x6
8000320a:	7ca7a073          	csrs	0x7ca,a5
}
8000320e:	0001                	nop
80003210:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_heap:

80003212 <__SEGGER_init_heap>:
80003212:	00080537          	lui	a0,0x80
80003216:	30850513          	addi	a0,a0,776 # 80308 <__heap_start__>

8000321a <.Lpcrel_hi1>:
8000321a:	000845b7          	lui	a1,0x84
8000321e:	30858593          	addi	a1,a1,776 # 84308 <__heap_end__>
80003222:	8d89                	sub	a1,a1,a0
80003224:	a009                	j	80003226 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

80003226 <__SEGGER_RTL_init_heap>:
80003226:	4621                	li	a2,8
80003228:	00c5e763          	bltu	a1,a2,80003236 <__SEGGER_RTL_init_heap+0x10>
8000322c:	80a22223          	sw	a0,-2044(tp) # fffff804 <__AHB_SRAM_segment_end__+0xfbf7804>
80003230:	00052023          	sw	zero,0(a0)
80003234:	c14c                	sw	a1,4(a0)
80003236:	8082                	ret

Disassembly of section .text.reset_handler:

80003238 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
80003238:	1141                	addi	sp,sp,-16
8000323a:	c606                	sw	ra,12(sp)
    fencei();
8000323c:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
80003240:	3f09                	jal	80003152 <system_init>

    /* Entry function */
    MAIN_ENTRY();
80003242:	3d89                	jal	80003094 <main>
}
80003244:	0001                	nop
80003246:	40b2                	lw	ra,12(sp)
80003248:	0141                	addi	sp,sp,16
8000324a:	8082                	ret

Disassembly of section .text._init:

8000324c <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
8000324c:	0001                	nop
8000324e:	8082                	ret

Disassembly of section .text.mchtmr_isr:

80003250 <mchtmr_isr>:
}
80003250:	0001                	nop
80003252:	8082                	ret

Disassembly of section .text.swi_isr:

80003254 <swi_isr>:
}
80003254:	0001                	nop
80003256:	8082                	ret

Disassembly of section .text.exception_handler:

80003258 <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
80003258:	1141                	addi	sp,sp,-16
8000325a:	c62a                	sw	a0,12(sp)
8000325c:	c42e                	sw	a1,8(sp)
    switch (cause) {
8000325e:	4732                	lw	a4,12(sp)
80003260:	47bd                	li	a5,15
80003262:	00e7ec63          	bltu	a5,a4,8000327a <.L23>
80003266:	47b2                	lw	a5,12(sp)
80003268:	00279713          	slli	a4,a5,0x2
8000326c:	800037b7          	lui	a5,0x80003
80003270:	05478793          	addi	a5,a5,84 # 80003054 <.L7>
80003274:	97ba                	add	a5,a5,a4
80003276:	439c                	lw	a5,0(a5)
80003278:	8782                	jr	a5

8000327a <.L23>:
    case MCAUSE_LOAD_PAGE_FAULT:
        break;
    case MCAUSE_STORE_AMO_PAGE_FAULT:
        break;
    default:
        break;
8000327a:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
8000327c:	47a2                	lw	a5,8(sp)
}
8000327e:	853e                	mv	a0,a5
80003280:	0141                	addi	sp,sp,16
80003282:	8082                	ret

Disassembly of section .text.enable_plic_feature:

80003284 <enable_plic_feature>:
{
80003284:	1141                	addi	sp,sp,-16
    uint32_t plic_feature = 0;
80003286:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
80003288:	47b2                	lw	a5,12(sp)
8000328a:	0027e793          	ori	a5,a5,2
8000328e:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
80003290:	47b2                	lw	a5,12(sp)
80003292:	0017e793          	ori	a5,a5,1
80003296:	c63e                	sw	a5,12(sp)
80003298:	e40007b7          	lui	a5,0xe4000
8000329c:	c43e                	sw	a5,8(sp)
8000329e:	47b2                	lw	a5,12(sp)
800032a0:	c23e                	sw	a5,4(sp)

800032a2 <.LBB14>:
    *(volatile uint32_t *) (base + HPM_PLIC_FEATURE_OFFSET) = feature;
800032a2:	47a2                	lw	a5,8(sp)
800032a4:	4712                	lw	a4,4(sp)
800032a6:	c398                	sw	a4,0(a5)
}
800032a8:	0001                	nop

800032aa <.LBE14>:
}
800032aa:	0001                	nop
800032ac:	0141                	addi	sp,sp,16
800032ae:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

800032b0 <l1c_dc_invalidate_all>:
{
800032b0:	1141                	addi	sp,sp,-16
800032b2:	47dd                	li	a5,23
800032b4:	00f107a3          	sb	a5,15(sp)

800032b8 <.LBB68>:
}

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
800032b8:	00f14783          	lbu	a5,15(sp)
800032bc:	7cc79073          	csrw	0x7cc,a5
}
800032c0:	0001                	nop

800032c2 <.LBE68>:
}
800032c2:	0001                	nop
800032c4:	0141                	addi	sp,sp,16
800032c6:	8082                	ret

Disassembly of section .text.gptmr_check_status:

800032c8 <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
800032c8:	1141                	addi	sp,sp,-16
800032ca:	c62a                	sw	a0,12(sp)
800032cc:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
800032ce:	47b2                	lw	a5,12(sp)
800032d0:	2007a703          	lw	a4,512(a5) # e4000200 <__FLASH_segment_end__+0x63f00200>
800032d4:	47a2                	lw	a5,8(sp)
800032d6:	8ff9                	and	a5,a5,a4
800032d8:	4722                	lw	a4,8(sp)
800032da:	40f707b3          	sub	a5,a4,a5
800032de:	0017b793          	seqz	a5,a5
800032e2:	0ff7f793          	zext.b	a5,a5
}
800032e6:	853e                	mv	a0,a5
800032e8:	0141                	addi	sp,sp,16
800032ea:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

800032ec <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
800032ec:	1141                	addi	sp,sp,-16
800032ee:	c62a                	sw	a0,12(sp)
800032f0:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
800032f2:	47b2                	lw	a5,12(sp)
800032f4:	4722                	lw	a4,8(sp)
800032f6:	20e7a023          	sw	a4,512(a5)
}
800032fa:	0001                	nop
800032fc:	0141                	addi	sp,sp,16
800032fe:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

80003684 <__SEGGER_init_zero>:
80003684:	4008                	lw	a0,0(s0)
80003686:	404c                	lw	a1,4(s0)
80003688:	0421                	addi	s0,s0,8
8000368a:	c591                	beqz	a1,80003696 <.L__SEGGER_init_zero_Done>

8000368c <.L__SEGGER_init_zero_Loop>:
8000368c:	00050023          	sb	zero,0(a0)
80003690:	0505                	addi	a0,a0,1
80003692:	15fd                	addi	a1,a1,-1
80003694:	fde5                	bnez	a1,8000368c <.L__SEGGER_init_zero_Loop>

80003696 <.L__SEGGER_init_zero_Done>:
80003696:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

80003698 <__SEGGER_init_copy>:
80003698:	4008                	lw	a0,0(s0)
8000369a:	404c                	lw	a1,4(s0)
8000369c:	4410                	lw	a2,8(s0)
8000369e:	0431                	addi	s0,s0,12
800036a0:	ca09                	beqz	a2,800036b2 <.L__SEGGER_init_copy_Done>

800036a2 <.L__SEGGER_init_copy_Loop>:
800036a2:	00058683          	lb	a3,0(a1)
800036a6:	00d50023          	sb	a3,0(a0)
800036aa:	0505                	addi	a0,a0,1
800036ac:	0585                	addi	a1,a1,1
800036ae:	167d                	addi	a2,a2,-1
800036b0:	fa6d                	bnez	a2,800036a2 <.L__SEGGER_init_copy_Loop>

800036b2 <.L__SEGGER_init_copy_Done>:
800036b2:	8082                	ret
