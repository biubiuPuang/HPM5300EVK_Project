
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

80003000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
80003000:	800041b7          	lui	gp,0x80004
        addi    gp, gp, %lo(__global_pointer$)
80003004:	89018193          	addi	gp,gp,-1904 # 80003890 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80003008:	80008237          	lui	tp,0x80008
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	44e20213          	addi	tp,tp,1102 # 8000844e <__thread_pointer$>
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
80003020:	66d000ef          	jal	80003e8c <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003024:	635000ef          	jal	80003e58 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
80003028:	306030ef          	jal	8000632e <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
8000302c:	591020ef          	jal	80005dbc <_init>

80003030 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003030:	80008437          	lui	s0,0x80008
80003034:	ec440413          	addi	s0,s0,-316 # 80007ec4 <__SEGGER_RTL_ascii_ctype_map+0x82>

80003038 <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
80003038:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
8000303a:	0411                	addi	s0,s0,4
        jalr    a0                              // Call initialization function
8000303c:	9502                	jalr	a0
        j       L(RunInit)
8000303e:	bfed                	j	80003038 <.L_start_RunInit>

80003040 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
80003040:	27d1                	jal	80003804 <_clean_up>

80003042 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
80003042:	000002b7          	lui	t0,0x0
80003046:	00028293          	mv	t0,t0
    csrw mtvec, t0
8000304a:	30529073          	csrw	mtvec,t0

    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
8000304e:	7d016073          	csrsi	0x7d0,2

80003052 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80003052:	555020ef          	jal	80005da6 <reset_handler>
        tail    exit
80003056:	a009                	j	80003058 <exit>

80003058 <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
80003058:	a001                	j	80003058 <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
8000305a:	4501                	li	a0,0
        li      a1, 0
8000305c:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
8000305e:	549020ef          	jal	80005da6 <reset_handler>
        tail    exit
80003062:	bfdd                	j	80003058 <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>:
80003066:	8082                	ret

Disassembly of section .text._clean_up:

80003804 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
80003804:	7139                	addi	sp,sp,-64

80003806 <.LBB18>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003806:	28b01793          	bseti	a5,zero,0xb
8000380a:	3047b073          	csrc	mie,a5
}
8000380e:	0001                	nop
80003810:	da02                	sw	zero,52(sp)
80003812:	d802                	sw	zero,48(sp)
80003814:	e40007b7          	lui	a5,0xe4000
80003818:	d63e                	sw	a5,44(sp)
8000381a:	57d2                	lw	a5,52(sp)
8000381c:	d43e                	sw	a5,40(sp)
8000381e:	57c2                	lw	a5,48(sp)
80003820:	d23e                	sw	a5,36(sp)

80003822 <.LBB20>:
                                                           uint32_t target,
                                                           uint32_t threshold)
{
    volatile uint32_t *threshold_ptr = (volatile uint32_t *) (base +
                                                              HPM_PLIC_THRESHOLD_OFFSET +
                                                              (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
80003822:	57a2                	lw	a5,40(sp)
80003824:	00c79713          	slli	a4,a5,0xc
                                                              HPM_PLIC_THRESHOLD_OFFSET +
80003828:	57b2                	lw	a5,44(sp)
8000382a:	973e                	add	a4,a4,a5
8000382c:	002007b7          	lui	a5,0x200
80003830:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *) (base +
80003832:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
80003834:	5782                	lw	a5,32(sp)
80003836:	5712                	lw	a4,36(sp)
80003838:	c398                	sw	a4,0(a5)
}
8000383a:	0001                	nop

8000383c <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
8000383c:	0001                	nop

8000383e <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
8000383e:	de02                	sw	zero,60(sp)
80003840:	a82d                	j	8000387a <.L2>

80003842 <.L3>:
80003842:	ce02                	sw	zero,28(sp)
80003844:	57f2                	lw	a5,60(sp)
80003846:	cc3e                	sw	a5,24(sp)
80003848:	e40007b7          	lui	a5,0xe4000
8000384c:	ca3e                	sw	a5,20(sp)
8000384e:	47f2                	lw	a5,28(sp)
80003850:	c83e                	sw	a5,16(sp)
80003852:	47e2                	lw	a5,24(sp)
80003854:	c63e                	sw	a5,12(sp)

80003856 <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
                                                           HPM_PLIC_CLAIM_OFFSET +
                                                           (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
80003856:	47c2                	lw	a5,16(sp)
80003858:	00c79713          	slli	a4,a5,0xc
                                                           HPM_PLIC_CLAIM_OFFSET +
8000385c:	47d2                	lw	a5,20(sp)
8000385e:	973e                	add	a4,a4,a5
80003860:	002007b7          	lui	a5,0x200
80003864:	0791                	addi	a5,a5,4 # 200004 <_flash_size+0x100004>
80003866:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
80003868:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
8000386a:	47a2                	lw	a5,8(sp)
8000386c:	4732                	lw	a4,12(sp)
8000386e:	c398                	sw	a4,0(a5)
}
80003870:	0001                	nop

80003872 <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
80003872:	0001                	nop

80003874 <.LBE25>:
80003874:	57f2                	lw	a5,60(sp)
80003876:	0785                	addi	a5,a5,1
80003878:	de3e                	sw	a5,60(sp)

8000387a <.L2>:
8000387a:	5772                	lw	a4,60(sp)
8000387c:	07f00793          	li	a5,127
80003880:	fce7f1e3          	bgeu	a5,a4,80003842 <.L3>

80003884 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
80003884:	dc02                	sw	zero,56(sp)
80003886:	a821                	j	8000389e <.L4>

80003888 <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
80003888:	57e2                	lw	a5,56(sp)
8000388a:	00279713          	slli	a4,a5,0x2
8000388e:	e40027b7          	lui	a5,0xe4002
80003892:	97ba                	add	a5,a5,a4
80003894:	0007a023          	sw	zero,0(a5) # e4002000 <__FLASH_segment_end__+0x63f02000>
    for (uint32_t i = 0; i < 4; i++) {
80003898:	57e2                	lw	a5,56(sp)
8000389a:	0785                	addi	a5,a5,1
8000389c:	dc3e                	sw	a5,56(sp)

8000389e <.L4>:
8000389e:	5762                	lw	a4,56(sp)
800038a0:	478d                	li	a5,3
800038a2:	fee7f3e3          	bgeu	a5,a4,80003888 <.L5>

800038a6 <.LBE29>:
    }
}
800038a6:	0001                	nop
800038a8:	0001                	nop
800038aa:	6121                	addi	sp,sp,64
800038ac:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

800038ae <__SEGGER_RTL_SIGNAL_SIG_ERR>:
800038ae:	8082                	ret

Disassembly of section .text.syscall_handler:

800038b2 <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
800038b2:	1101                	addi	sp,sp,-32
800038b4:	ce2a                	sw	a0,28(sp)
800038b6:	cc2e                	sw	a1,24(sp)
800038b8:	ca32                	sw	a2,20(sp)
800038ba:	c836                	sw	a3,16(sp)
800038bc:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
800038be:	0001                	nop
800038c0:	6105                	addi	sp,sp,32
800038c2:	8082                	ret

Disassembly of section .text.system_init:

80003958 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
80003958:	7179                	addi	sp,sp,-48
8000395a:	d606                	sw	ra,44(sp)

8000395c <.LBB16>:
#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
8000395c:	306027f3          	csrr	a5,mcounteren
80003960:	ce3e                	sw	a5,28(sp)
80003962:	47f2                	lw	a5,28(sp)

80003964 <.LBE16>:
80003964:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80003966:	47e2                	lw	a5,24(sp)
80003968:	0017e793          	ori	a5,a5,1
8000396c:	30679073          	csrw	mcounteren,a5
80003970:	47a1                	li	a5,8
80003972:	c83e                	sw	a5,16(sp)

80003974 <.LBB17>:
    return read_clear_csr(CSR_MSTATUS, mask);
80003974:	c602                	sw	zero,12(sp)
80003976:	47c2                	lw	a5,16(sp)
80003978:	3007b7f3          	csrrc	a5,mstatus,a5
8000397c:	c63e                	sw	a5,12(sp)
8000397e:	47b2                	lw	a5,12(sp)

80003980 <.LBE19>:
80003980:	0001                	nop

80003982 <.LBB20>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003982:	28b01793          	bseti	a5,zero,0xb
80003986:	3047b073          	csrc	mie,a5
}
8000398a:	0001                	nop

8000398c <.LBE20>:
#endif

    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();

    enable_plic_feature();
8000398c:	464020ef          	jal	80005df0 <enable_plic_feature>

80003990 <.LBB22>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003990:	28b01793          	bseti	a5,zero,0xb
80003994:	3047a073          	csrs	mie,a5
}
80003998:	0001                	nop
8000399a:	47a1                	li	a5,8
8000399c:	ca3e                	sw	a5,20(sp)

8000399e <.LBB24>:
    set_csr(CSR_MSTATUS, mask);
8000399e:	47d2                	lw	a5,20(sp)
800039a0:	3007a073          	csrs	mstatus,a5
}
800039a4:	0001                	nop

800039a6 <.LBE24>:
    enable_irq_from_intc();

#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif
}
800039a6:	0001                	nop
800039a8:	50b2                	lw	ra,44(sp)
800039aa:	6145                	addi	sp,sp,48
800039ac:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

800039ae <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
800039ae:	1141                	addi	sp,sp,-16
800039b0:	c62a                	sw	a0,12(sp)
800039b2:	87ae                	mv	a5,a1
800039b4:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
800039b8:	00a15783          	lhu	a5,10(sp)
800039bc:	4732                	lw	a4,12(sp)
800039be:	078a                	slli	a5,a5,0x2
800039c0:	97ba                	add	a5,a5,a4
800039c2:	4398                	lw	a4,0(a5)
800039c4:	400007b7          	lui	a5,0x40000
800039c8:	8ff9                	and	a5,a5,a4
800039ca:	00f037b3          	snez	a5,a5
800039ce:	0ff7f793          	zext.b	a5,a5
}
800039d2:	853e                	mv	a0,a5
800039d4:	0141                	addi	sp,sp,16
800039d6:	8082                	ret

Disassembly of section .text.sysctl_cpu_clock_any_is_busy:

800039d8 <sysctl_cpu_clock_any_is_busy>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @return true if any clock is busy
 */
static inline bool sysctl_cpu_clock_any_is_busy(SYSCTL_Type *ptr)
{
800039d8:	1141                	addi	sp,sp,-16
800039da:	c62a                	sw	a0,12(sp)
    return ptr->CLOCK_CPU[0] & SYSCTL_CLOCK_CPU_GLB_BUSY_MASK;
800039dc:	4732                	lw	a4,12(sp)
800039de:	6789                	lui	a5,0x2
800039e0:	97ba                	add	a5,a5,a4
800039e2:	8007a703          	lw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
800039e6:	800007b7          	lui	a5,0x80000
800039ea:	8ff9                	and	a5,a5,a4
800039ec:	00f037b3          	snez	a5,a5
800039f0:	0ff7f793          	zext.b	a5,a5
}
800039f4:	853e                	mv	a0,a5
800039f6:	0141                	addi	sp,sp,16
800039f8:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

800039fa <sysctl_clock_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr, clock_node_t clock)
{
800039fa:	1141                	addi	sp,sp,-16
800039fc:	c62a                	sw	a0,12(sp)
800039fe:	87ae                	mv	a5,a1
80003a00:	00f105a3          	sb	a5,11(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
80003a04:	00b14783          	lbu	a5,11(sp)
80003a08:	4732                	lw	a4,12(sp)
80003a0a:	60078793          	addi	a5,a5,1536 # 80000600 <__NOR_CFG_OPTION_segment_used_end__+0x1f0>
80003a0e:	078a                	slli	a5,a5,0x2
80003a10:	97ba                	add	a5,a5,a4
80003a12:	43d8                	lw	a4,4(a5)
80003a14:	400007b7          	lui	a5,0x40000
80003a18:	8ff9                	and	a5,a5,a4
80003a1a:	00f037b3          	snez	a5,a5
80003a1e:	0ff7f793          	zext.b	a5,a5
}
80003a22:	853e                	mv	a0,a5
80003a24:	0141                	addi	sp,sp,16
80003a26:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

80003a28 <sysctl_config_clock>:
    }
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node, clock_source_t source, uint32_t divide_by)
{
80003a28:	1101                	addi	sp,sp,-32
80003a2a:	ce06                	sw	ra,28(sp)
80003a2c:	c62a                	sw	a0,12(sp)
80003a2e:	87ae                	mv	a5,a1
80003a30:	8732                	mv	a4,a2
80003a32:	c236                	sw	a3,4(sp)
80003a34:	00f105a3          	sb	a5,11(sp)
80003a38:	87ba                	mv	a5,a4
80003a3a:	00f10523          	sb	a5,10(sp)
    if (node >= clock_node_adc_start) {
80003a3e:	00b14703          	lbu	a4,11(sp)
80003a42:	02300793          	li	a5,35
80003a46:	00e7f463          	bgeu	a5,a4,80003a4e <.L81>
        return status_invalid_argument;
80003a4a:	4789                	li	a5,2
80003a4c:	a8b1                	j	80003aa8 <.L82>

80003a4e <.L81>:
    }

    if (source >= clock_source_general_source_end) {
80003a4e:	00a14703          	lbu	a4,10(sp)
80003a52:	479d                	li	a5,7
80003a54:	00e7f463          	bgeu	a5,a4,80003a5c <.L83>
        return status_invalid_argument;
80003a58:	4789                	li	a5,2
80003a5a:	a0b9                	j	80003aa8 <.L82>

80003a5c <.L83>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80003a5c:	00b14783          	lbu	a5,11(sp)
80003a60:	4732                	lw	a4,12(sp)
80003a62:	60078793          	addi	a5,a5,1536 # 40000600 <_flash_size+0x3ff00600>
80003a66:	078a                	slli	a5,a5,0x2
80003a68:	97ba                	add	a5,a5,a4
80003a6a:	43dc                	lw	a5,4(a5)
80003a6c:	8007f693          	andi	a3,a5,-2048
        (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80003a70:	00a14783          	lbu	a5,10(sp)
80003a74:	07a2                	slli	a5,a5,0x8
80003a76:	7007f713          	andi	a4,a5,1792
80003a7a:	4792                	lw	a5,4(sp)
80003a7c:	17fd                	addi	a5,a5,-1
80003a7e:	0ff7f793          	zext.b	a5,a5
80003a82:	8f5d                	or	a4,a4,a5
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80003a84:	00b14783          	lbu	a5,11(sp)
80003a88:	8f55                	or	a4,a4,a3
80003a8a:	46b2                	lw	a3,12(sp)
80003a8c:	60078793          	addi	a5,a5,1536
80003a90:	078a                	slli	a5,a5,0x2
80003a92:	97b6                	add	a5,a5,a3
80003a94:	c3d8                	sw	a4,4(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
80003a96:	0001                	nop

80003a98 <.L84>:
80003a98:	00b14783          	lbu	a5,11(sp)
80003a9c:	85be                	mv	a1,a5
80003a9e:	4532                	lw	a0,12(sp)
80003aa0:	3fa9                	jal	800039fa <sysctl_clock_target_is_busy>
80003aa2:	87aa                	mv	a5,a0
80003aa4:	fbf5                	bnez	a5,80003a98 <.L84>
    }
    return status_success;
80003aa6:	4781                	li	a5,0

80003aa8 <.L82>:
}
80003aa8:	853e                	mv	a0,a5
80003aaa:	40f2                	lw	ra,28(sp)
80003aac:	6105                	addi	sp,sp,32
80003aae:	8082                	ret

Disassembly of section .text.hpm_csr_get_core_cycle:

80003ab0 <hpm_csr_get_core_cycle>:
 *          - in user mode if the device supports M/U mode
 *
 * @return CSR cycle value in 64-bit
 */
static inline uint64_t hpm_csr_get_core_cycle(void)
{
80003ab0:	7179                	addi	sp,sp,-48

80003ab2 <.LBB2>:
    uint64_t result;
    uint32_t resultl_first = read_csr(CSR_CYCLE);
80003ab2:	c0002f73          	rdcycle	t5
80003ab6:	d27a                	sw	t5,36(sp)
80003ab8:	5f12                	lw	t5,36(sp)

80003aba <.LBE2>:
80003aba:	d07a                	sw	t5,32(sp)

80003abc <.LBB3>:
    uint32_t resulth = read_csr(CSR_CYCLEH);
80003abc:	c8002f73          	rdcycleh	t5
80003ac0:	ce7a                	sw	t5,28(sp)
80003ac2:	4f72                	lw	t5,28(sp)

80003ac4 <.LBE3>:
80003ac4:	cc7a                	sw	t5,24(sp)

80003ac6 <.LBB4>:
    uint32_t resultl_second = read_csr(CSR_CYCLE);
80003ac6:	c0002f73          	rdcycle	t5
80003aca:	ca7a                	sw	t5,20(sp)
80003acc:	4f52                	lw	t5,20(sp)

80003ace <.LBE4>:
80003ace:	c87a                	sw	t5,16(sp)
    if (resultl_first < resultl_second) {
80003ad0:	5f82                	lw	t6,32(sp)
80003ad2:	4f42                	lw	t5,16(sp)
80003ad4:	03eff263          	bgeu	t6,t5,80003af8 <.L2>
        result = ((uint64_t)resulth << 32) | resultl_first; /* if CYCLE didn't roll over, return the value directly */
80003ad8:	47e2                	lw	a5,24(sp)
80003ada:	8e3e                	mv	t3,a5
80003adc:	4e81                	li	t4,0
80003ade:	000e1693          	slli	a3,t3,0x0
80003ae2:	4601                	li	a2,0
80003ae4:	5782                	lw	a5,32(sp)
80003ae6:	883e                	mv	a6,a5
80003ae8:	4881                	li	a7,0
80003aea:	010667b3          	or	a5,a2,a6
80003aee:	d43e                	sw	a5,40(sp)
80003af0:	0116e7b3          	or	a5,a3,a7
80003af4:	d63e                	sw	a5,44(sp)
80003af6:	a025                	j	80003b1e <.L3>

80003af8 <.L2>:
    } else {
        resulth = read_csr(CSR_CYCLEH);
80003af8:	c80026f3          	rdcycleh	a3
80003afc:	c636                	sw	a3,12(sp)
80003afe:	46b2                	lw	a3,12(sp)

80003b00 <.LBE5>:
80003b00:	cc36                	sw	a3,24(sp)
        result = ((uint64_t)resulth << 32) | resultl_second; /* if CYCLE rolled over, need to get the CYCLEH again */
80003b02:	46e2                	lw	a3,24(sp)
80003b04:	8336                	mv	t1,a3
80003b06:	4381                	li	t2,0
80003b08:	00031793          	slli	a5,t1,0x0
80003b0c:	4701                	li	a4,0
80003b0e:	46c2                	lw	a3,16(sp)
80003b10:	8536                	mv	a0,a3
80003b12:	4581                	li	a1,0
80003b14:	00a766b3          	or	a3,a4,a0
80003b18:	d436                	sw	a3,40(sp)
80003b1a:	8fcd                	or	a5,a5,a1
80003b1c:	d63e                	sw	a5,44(sp)

80003b1e <.L3>:
    }
    return result;
80003b1e:	5722                	lw	a4,40(sp)
80003b20:	57b2                	lw	a5,44(sp)
 }
80003b22:	853a                	mv	a0,a4
80003b24:	85be                	mv	a1,a5
80003b26:	6145                	addi	sp,sp,48
80003b28:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

80003b2a <get_frequency_for_source>:
    }
    return clk_freq;
}

uint32_t get_frequency_for_source(clock_source_t source)
{
80003b2a:	7179                	addi	sp,sp,-48
80003b2c:	d606                	sw	ra,44(sp)
80003b2e:	87aa                	mv	a5,a0
80003b30:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80003b34:	ce02                	sw	zero,28(sp)
    switch (source) {
80003b36:	00f14783          	lbu	a5,15(sp)
80003b3a:	471d                	li	a4,7
80003b3c:	08f76763          	bltu	a4,a5,80003bca <.L30>
80003b40:	00279713          	slli	a4,a5,0x2
80003b44:	8f018793          	addi	a5,gp,-1808 # 80003180 <.L32>
80003b48:	97ba                	add	a5,a5,a4
80003b4a:	439c                	lw	a5,0(a5)
80003b4c:	8782                	jr	a5

80003b4e <.L39>:
    case clock_source_osc0_clk0:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80003b4e:	016e37b7          	lui	a5,0x16e3
80003b52:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80003b56:	ce3e                	sw	a5,28(sp)
        break;
80003b58:	a89d                	j	80003bce <.L40>

80003b5a <.L38>:
    case clock_source_pll0_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0);
80003b5a:	4601                	li	a2,0
80003b5c:	4581                	li	a1,0
80003b5e:	f40c0537          	lui	a0,0xf40c0
80003b62:	67f020ef          	jal	800069e0 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b66:	ce2a                	sw	a0,28(sp)
        break;
80003b68:	a09d                	j	80003bce <.L40>

80003b6a <.L37>:
    case clock_source_pll0_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1);
80003b6a:	4605                	li	a2,1
80003b6c:	4581                	li	a1,0
80003b6e:	f40c0537          	lui	a0,0xf40c0
80003b72:	66f020ef          	jal	800069e0 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b76:	ce2a                	sw	a0,28(sp)
        break;
80003b78:	a899                	j	80003bce <.L40>

80003b7a <.L36>:
    case clock_source_pll0_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk2);
80003b7a:	4609                	li	a2,2
80003b7c:	4581                	li	a1,0
80003b7e:	f40c0537          	lui	a0,0xf40c0
80003b82:	65f020ef          	jal	800069e0 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b86:	ce2a                	sw	a0,28(sp)
        break;
80003b88:	a099                	j	80003bce <.L40>

80003b8a <.L35>:
    case clock_source_pll1_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk0);
80003b8a:	4601                	li	a2,0
80003b8c:	4585                	li	a1,1
80003b8e:	f40c0537          	lui	a0,0xf40c0
80003b92:	64f020ef          	jal	800069e0 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b96:	ce2a                	sw	a0,28(sp)
        break;
80003b98:	a81d                	j	80003bce <.L40>

80003b9a <.L34>:
    case clock_source_pll1_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk1);
80003b9a:	4605                	li	a2,1
80003b9c:	4585                	li	a1,1
80003b9e:	f40c0537          	lui	a0,0xf40c0
80003ba2:	63f020ef          	jal	800069e0 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003ba6:	ce2a                	sw	a0,28(sp)
        break;
80003ba8:	a01d                	j	80003bce <.L40>

80003baa <.L33>:
    case clock_source_pll1_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk2);
80003baa:	4609                	li	a2,2
80003bac:	4585                	li	a1,1
80003bae:	f40c0537          	lui	a0,0xf40c0
80003bb2:	62f020ef          	jal	800069e0 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003bb6:	ce2a                	sw	a0,28(sp)
        break;
80003bb8:	a819                	j	80003bce <.L40>

80003bba <.L31>:
    case clock_source_pll1_clk3:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk3);
80003bba:	460d                	li	a2,3
80003bbc:	4585                	li	a1,1
80003bbe:	f40c0537          	lui	a0,0xf40c0
80003bc2:	61f020ef          	jal	800069e0 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003bc6:	ce2a                	sw	a0,28(sp)
        break;
80003bc8:	a019                	j	80003bce <.L40>

80003bca <.L30>:
    default:
        clk_freq = 0UL;
80003bca:	ce02                	sw	zero,28(sp)
        break;
80003bcc:	0001                	nop

80003bce <.L40>:
    }

    return clk_freq;
80003bce:	47f2                	lw	a5,28(sp)
}
80003bd0:	853e                	mv	a0,a5
80003bd2:	50b2                	lw	ra,44(sp)
80003bd4:	6145                	addi	sp,sp,48
80003bd6:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

80003bd8 <get_frequency_for_ip_in_common_group>:

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
80003bd8:	7139                	addi	sp,sp,-64
80003bda:	de06                	sw	ra,60(sp)
80003bdc:	87aa                	mv	a5,a0
80003bde:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80003be2:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
80003be4:	00f14783          	lbu	a5,15(sp)
80003be8:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
80003bea:	5722                	lw	a4,40(sp)
80003bec:	02700793          	li	a5,39
80003bf0:	04e7e563          	bltu	a5,a4,80003c3a <.L43>

80003bf4 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
80003bf4:	57a2                	lw	a5,40(sp)
80003bf6:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
80003bf8:	f4000737          	lui	a4,0xf4000
80003bfc:	5792                	lw	a5,36(sp)
80003bfe:	60078793          	addi	a5,a5,1536
80003c02:	078a                	slli	a5,a5,0x2
80003c04:	97ba                	add	a5,a5,a4
80003c06:	43dc                	lw	a5,4(a5)
80003c08:	0ff7f793          	zext.b	a5,a5
80003c0c:	0785                	addi	a5,a5,1
80003c0e:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
80003c10:	f4000737          	lui	a4,0xf4000
80003c14:	5792                	lw	a5,36(sp)
80003c16:	60078793          	addi	a5,a5,1536
80003c1a:	078a                	slli	a5,a5,0x2
80003c1c:	97ba                	add	a5,a5,a4
80003c1e:	43dc                	lw	a5,4(a5)
80003c20:	83a1                	srli	a5,a5,0x8
80003c22:	8b9d                	andi	a5,a5,7
80003c24:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
80003c28:	01f14783          	lbu	a5,31(sp)
80003c2c:	853e                	mv	a0,a5
80003c2e:	3df5                	jal	80003b2a <get_frequency_for_source>
80003c30:	872a                	mv	a4,a0
80003c32:	5782                	lw	a5,32(sp)
80003c34:	02f757b3          	divu	a5,a4,a5
80003c38:	d63e                	sw	a5,44(sp)

80003c3a <.L43>:
    }
    return clk_freq;
80003c3a:	57b2                	lw	a5,44(sp)
}
80003c3c:	853e                	mv	a0,a5
80003c3e:	50f2                	lw	ra,60(sp)
80003c40:	6121                	addi	sp,sp,64
80003c42:	8082                	ret

Disassembly of section .text.get_frequency_for_adc:

80003c44 <get_frequency_for_adc>:

static uint32_t get_frequency_for_adc(uint32_t clk_src_type, uint32_t instance)
{
80003c44:	7179                	addi	sp,sp,-48
80003c46:	d606                	sw	ra,44(sp)
80003c48:	c62a                	sw	a0,12(sp)
80003c4a:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
80003c4c:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
80003c4e:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
80003c52:	02800793          	li	a5,40
80003c56:	00f10d23          	sb	a5,26(sp)
    uint32_t adc_index = instance;
80003c5a:	47a2                	lw	a5,8(sp)
80003c5c:	ca3e                	sw	a5,20(sp)

    (void) clk_src_type;

    if (adc_index < ADC_INSTANCE_NUM) {
80003c5e:	4752                	lw	a4,20(sp)
80003c60:	4785                	li	a5,1
80003c62:	02e7ee63          	bltu	a5,a4,80003c9e <.L46>

80003c66 <.LBB7>:
        uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
80003c66:	f4000737          	lui	a4,0xf4000
80003c6a:	47d2                	lw	a5,20(sp)
80003c6c:	70078793          	addi	a5,a5,1792
80003c70:	078a                	slli	a5,a5,0x2
80003c72:	97ba                	add	a5,a5,a4
80003c74:	439c                	lw	a5,0(a5)
80003c76:	83a1                	srli	a5,a5,0x8
80003c78:	8b85                	andi	a5,a5,1
80003c7a:	c83e                	sw	a5,16(sp)
        if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
80003c7c:	4742                	lw	a4,16(sp)
80003c7e:	4785                	li	a5,1
80003c80:	00e7ef63          	bltu	a5,a4,80003c9e <.L46>
            node = s_adc_clk_mux_node[mux_in_reg];
80003c84:	800037b7          	lui	a5,0x80003
80003c88:	06478713          	addi	a4,a5,100 # 80003064 <s_adc_clk_mux_node>
80003c8c:	47c2                	lw	a5,16(sp)
80003c8e:	97ba                	add	a5,a5,a4
80003c90:	0007c783          	lbu	a5,0(a5)
80003c94:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
80003c98:	4785                	li	a5,1
80003c9a:	00f10da3          	sb	a5,27(sp)

80003c9e <.L46>:
        }
    }

    if (is_mux_valid) {
80003c9e:	01b14783          	lbu	a5,27(sp)
80003ca2:	cb85                	beqz	a5,80003cd2 <.L47>
        if (node != clock_node_ahb) {
80003ca4:	01a14703          	lbu	a4,26(sp)
80003ca8:	0fe00793          	li	a5,254
80003cac:	02f70063          	beq	a4,a5,80003ccc <.L48>
            node += instance;
80003cb0:	47a2                	lw	a5,8(sp)
80003cb2:	0ff7f793          	zext.b	a5,a5
80003cb6:	01a14703          	lbu	a4,26(sp)
80003cba:	97ba                	add	a5,a5,a4
80003cbc:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
80003cc0:	01a14783          	lbu	a5,26(sp)
80003cc4:	853e                	mv	a0,a5
80003cc6:	3f09                	jal	80003bd8 <get_frequency_for_ip_in_common_group>
80003cc8:	ce2a                	sw	a0,28(sp)
80003cca:	a021                	j	80003cd2 <.L47>

80003ccc <.L48>:
        } else {
            clk_freq = get_frequency_for_ahb();
80003ccc:	492020ef          	jal	8000615e <get_frequency_for_ahb>
80003cd0:	ce2a                	sw	a0,28(sp)

80003cd2 <.L47>:
        }
    }
    return clk_freq;
80003cd2:	47f2                	lw	a5,28(sp)
}
80003cd4:	853e                	mv	a0,a5
80003cd6:	50b2                	lw	ra,44(sp)
80003cd8:	6145                	addi	sp,sp,48
80003cda:	8082                	ret

Disassembly of section .text.get_frequency_for_ewdg:

80003cdc <get_frequency_for_ewdg>:

    return clk_freq;
}

static uint32_t get_frequency_for_ewdg(uint32_t instance)
{
80003cdc:	7179                	addi	sp,sp,-48
80003cde:	d606                	sw	ra,44(sp)
80003ce0:	c62a                	sw	a0,12(sp)
    uint32_t freq_in_hz;
    if (EWDG_CTRL0_CLK_SEL_GET(s_wdgs[instance]->CTRL0) == 0) {
80003ce2:	8b818713          	addi	a4,gp,-1864 # 80003148 <s_wdgs>
80003ce6:	47b2                	lw	a5,12(sp)
80003ce8:	078a                	slli	a5,a5,0x2
80003cea:	97ba                	add	a5,a5,a4
80003cec:	439c                	lw	a5,0(a5)
80003cee:	4398                	lw	a4,0(a5)
80003cf0:	200007b7          	lui	a5,0x20000
80003cf4:	8ff9                	and	a5,a5,a4
80003cf6:	e789                	bnez	a5,80003d00 <.L56>
        freq_in_hz = get_frequency_for_ahb();
80003cf8:	466020ef          	jal	8000615e <get_frequency_for_ahb>
80003cfc:	ce2a                	sw	a0,28(sp)
80003cfe:	a019                	j	80003d04 <.L57>

80003d00 <.L56>:
    } else {
        freq_in_hz = FREQ_32KHz;
80003d00:	67a1                	lui	a5,0x8
80003d02:	ce3e                	sw	a5,28(sp)

80003d04 <.L57>:
    }

    return freq_in_hz;
80003d04:	47f2                	lw	a5,28(sp)
}
80003d06:	853e                	mv	a0,a5
80003d08:	50b2                	lw	ra,44(sp)
80003d0a:	6145                	addi	sp,sp,48
80003d0c:	8082                	ret

Disassembly of section .text.get_frequency_for_cpu:

80003d0e <get_frequency_for_cpu>:

    return freq_in_hz;
}

static uint32_t get_frequency_for_cpu(void)
{
80003d0e:	1101                	addi	sp,sp,-32
80003d10:	ce06                	sw	ra,28(sp)
    uint32_t mux = SYSCTL_CLOCK_CPU_MUX_GET(HPM_SYSCTL->CLOCK_CPU[0]);
80003d12:	f4000737          	lui	a4,0xf4000
80003d16:	6789                	lui	a5,0x2
80003d18:	97ba                	add	a5,a5,a4
80003d1a:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003d1e:	83a1                	srli	a5,a5,0x8
80003d20:	8b9d                	andi	a5,a5,7
80003d22:	c63e                	sw	a5,12(sp)
    uint32_t div = SYSCTL_CLOCK_CPU_DIV_GET(HPM_SYSCTL->CLOCK_CPU[0]) + 1U;
80003d24:	f4000737          	lui	a4,0xf4000
80003d28:	6789                	lui	a5,0x2
80003d2a:	97ba                	add	a5,a5,a4
80003d2c:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003d30:	0ff7f793          	zext.b	a5,a5
80003d34:	0785                	addi	a5,a5,1
80003d36:	c43e                	sw	a5,8(sp)
    return (get_frequency_for_source(mux) / div);
80003d38:	47b2                	lw	a5,12(sp)
80003d3a:	0ff7f793          	zext.b	a5,a5
80003d3e:	853e                	mv	a0,a5
80003d40:	33ed                	jal	80003b2a <get_frequency_for_source>
80003d42:	872a                	mv	a4,a0
80003d44:	47a2                	lw	a5,8(sp)
80003d46:	02f757b3          	divu	a5,a4,a5
}
80003d4a:	853e                	mv	a0,a5
80003d4c:	40f2                	lw	ra,28(sp)
80003d4e:	6105                	addi	sp,sp,32
80003d50:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80003d52 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80003d52:	7179                	addi	sp,sp,-48
80003d54:	d606                	sw	ra,44(sp)
80003d56:	c62a                	sw	a0,12(sp)
80003d58:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80003d5a:	47b2                	lw	a5,12(sp)
80003d5c:	83c1                	srli	a5,a5,0x10
80003d5e:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80003d60:	4772                	lw	a4,28(sp)
80003d62:	13600793          	li	a5,310
80003d66:	00e7ef63          	bltu	a5,a4,80003d84 <.L155>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
80003d6a:	47a2                	lw	a5,8(sp)
80003d6c:	0ff7f793          	zext.b	a5,a5
80003d70:	4772                	lw	a4,28(sp)
80003d72:	08074733          	zext.h	a4,a4
80003d76:	4685                	li	a3,1
80003d78:	863a                	mv	a2,a4
80003d7a:	85be                	mv	a1,a5
80003d7c:	f4000537          	lui	a0,0xf4000
80003d80:	09c020ef          	jal	80005e1c <sysctl_enable_group_resource>

80003d84 <.L155>:
    }
}
80003d84:	0001                	nop
80003d86:	50b2                	lw	ra,44(sp)
80003d88:	6145                	addi	sp,sp,48
80003d8a:	8082                	ret

Disassembly of section .text.clock_remove_from_group:

80003d8c <clock_remove_from_group>:

void clock_remove_from_group(clock_name_t clock_name, uint32_t group)
{
80003d8c:	7179                	addi	sp,sp,-48
80003d8e:	d606                	sw	ra,44(sp)
80003d90:	c62a                	sw	a0,12(sp)
80003d92:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80003d94:	47b2                	lw	a5,12(sp)
80003d96:	83c1                	srli	a5,a5,0x10
80003d98:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80003d9a:	4772                	lw	a4,28(sp)
80003d9c:	13600793          	li	a5,310
80003da0:	00e7ef63          	bltu	a5,a4,80003dbe <.L158>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, false);
80003da4:	47a2                	lw	a5,8(sp)
80003da6:	0ff7f793          	zext.b	a5,a5
80003daa:	4772                	lw	a4,28(sp)
80003dac:	08074733          	zext.h	a4,a4
80003db0:	4681                	li	a3,0
80003db2:	863a                	mv	a2,a4
80003db4:	85be                	mv	a1,a5
80003db6:	f4000537          	lui	a0,0xf4000
80003dba:	062020ef          	jal	80005e1c <sysctl_enable_group_resource>

80003dbe <.L158>:
    }
}
80003dbe:	0001                	nop
80003dc0:	50b2                	lw	ra,44(sp)
80003dc2:	6145                	addi	sp,sp,48
80003dc4:	8082                	ret

Disassembly of section .text.clock_cpu_delay_ms:

80003dc6 <clock_cpu_delay_ms>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_cpu_delay_ms(uint32_t ms)
{
80003dc6:	715d                	addi	sp,sp,-80
80003dc8:	c686                	sw	ra,76(sp)
80003dca:	c4a2                	sw	s0,72(sp)
80003dcc:	c2a6                	sw	s1,68(sp)
80003dce:	c0ca                	sw	s2,64(sp)
80003dd0:	de4e                	sw	s3,60(sp)
80003dd2:	dc52                	sw	s4,56(sp)
80003dd4:	da56                	sw	s5,52(sp)
80003dd6:	d85a                	sw	s6,48(sp)
80003dd8:	d65e                	sw	s7,44(sp)
80003dda:	c62a                	sw	a0,12(sp)
    uint64_t expected_ticks = hpm_csr_get_core_cycle() + (uint64_t)clock_get_core_clock_ticks_per_ms() * (uint64_t)ms;
80003ddc:	39d1                	jal	80003ab0 <hpm_csr_get_core_cycle>
80003dde:	8b2a                	mv	s6,a0
80003de0:	8bae                	mv	s7,a1
80003de2:	4fc020ef          	jal	800062de <clock_get_core_clock_ticks_per_ms>
80003de6:	87aa                	mv	a5,a0
80003de8:	8a3e                	mv	s4,a5
80003dea:	4a81                	li	s5,0
80003dec:	47b2                	lw	a5,12(sp)
80003dee:	893e                	mv	s2,a5
80003df0:	4981                	li	s3,0
80003df2:	032a8733          	mul	a4,s5,s2
80003df6:	034987b3          	mul	a5,s3,s4
80003dfa:	97ba                	add	a5,a5,a4
80003dfc:	032a0733          	mul	a4,s4,s2
80003e00:	032a34b3          	mulhu	s1,s4,s2
80003e04:	843a                	mv	s0,a4
80003e06:	97a6                	add	a5,a5,s1
80003e08:	84be                	mv	s1,a5
80003e0a:	008b0733          	add	a4,s6,s0
80003e0e:	86ba                	mv	a3,a4
80003e10:	0166b6b3          	sltu	a3,a3,s6
80003e14:	009b87b3          	add	a5,s7,s1
80003e18:	96be                	add	a3,a3,a5
80003e1a:	87b6                	mv	a5,a3
80003e1c:	cc3a                	sw	a4,24(sp)
80003e1e:	ce3e                	sw	a5,28(sp)
    while (hpm_csr_get_core_cycle() < expected_ticks) {
80003e20:	0001                	nop

80003e22 <.L178>:
80003e22:	3179                	jal	80003ab0 <hpm_csr_get_core_cycle>
80003e24:	872a                	mv	a4,a0
80003e26:	87ae                	mv	a5,a1
80003e28:	46f2                	lw	a3,28(sp)
80003e2a:	863e                	mv	a2,a5
80003e2c:	fed66be3          	bltu	a2,a3,80003e22 <.L178>
80003e30:	46f2                	lw	a3,28(sp)
80003e32:	863e                	mv	a2,a5
80003e34:	00c69663          	bne	a3,a2,80003e40 <.L180>
80003e38:	46e2                	lw	a3,24(sp)
80003e3a:	87ba                	mv	a5,a4
80003e3c:	fed7e3e3          	bltu	a5,a3,80003e22 <.L178>

80003e40 <.L180>:
    }
}
80003e40:	0001                	nop
80003e42:	40b6                	lw	ra,76(sp)
80003e44:	4426                	lw	s0,72(sp)
80003e46:	4496                	lw	s1,68(sp)
80003e48:	4906                	lw	s2,64(sp)
80003e4a:	59f2                	lw	s3,60(sp)
80003e4c:	5a62                	lw	s4,56(sp)
80003e4e:	5ad2                	lw	s5,52(sp)
80003e50:	5b42                	lw	s6,48(sp)
80003e52:	5bb2                	lw	s7,44(sp)
80003e54:	6161                	addi	sp,sp,80
80003e56:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

80003e58 <l1c_dc_enable>:
    }
#endif
}

void l1c_dc_enable(void)
{
80003e58:	1101                	addi	sp,sp,-32
80003e5a:	ce06                	sw	ra,28(sp)

80003e5c <.LBB48>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
80003e5c:	7ca027f3          	csrr	a5,0x7ca
80003e60:	c63e                	sw	a5,12(sp)
80003e62:	47b2                	lw	a5,12(sp)

80003e64 <.LBE52>:
80003e64:	0001                	nop

80003e66 <.LBE50>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
80003e66:	8b89                	andi	a5,a5,2
80003e68:	00f037b3          	snez	a5,a5
80003e6c:	0ff7f793          	zext.b	a5,a5

80003e70 <.LBE48>:
    if (!l1c_dc_is_enabled()) {
80003e70:	0017c793          	xori	a5,a5,1
80003e74:	0ff7f793          	zext.b	a5,a5
80003e78:	c791                	beqz	a5,80003e84 <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
80003e7a:	2081                	jal	80003eba <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
80003e7c:	40200793          	li	a5,1026
80003e80:	7ca7a073          	csrs	0x7ca,a5

80003e84 <.L11>:
    }
}
80003e84:	0001                	nop
80003e86:	40f2                	lw	ra,28(sp)
80003e88:	6105                	addi	sp,sp,32
80003e8a:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

80003e8c <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
80003e8c:	1141                	addi	sp,sp,-16

80003e8e <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
80003e8e:	7ca027f3          	csrr	a5,0x7ca
80003e92:	c63e                	sw	a5,12(sp)
80003e94:	47b2                	lw	a5,12(sp)

80003e96 <.LBE62>:
80003e96:	0001                	nop

80003e98 <.LBE60>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
80003e98:	8b85                	andi	a5,a5,1
80003e9a:	00f037b3          	snez	a5,a5
80003e9e:	0ff7f793          	zext.b	a5,a5

80003ea2 <.LBE58>:
    if (!l1c_ic_is_enabled()) {
80003ea2:	0017c793          	xori	a5,a5,1
80003ea6:	0ff7f793          	zext.b	a5,a5
80003eaa:	c789                	beqz	a5,80003eb4 <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
80003eac:	30100793          	li	a5,769
80003eb0:	7ca7a073          	csrs	0x7ca,a5

80003eb4 <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
80003eb4:	0001                	nop
80003eb6:	0141                	addi	sp,sp,16
80003eb8:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

80003eba <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
80003eba:	6799                	lui	a5,0x6
80003ebc:	7ca7a073          	csrs	0x7ca,a5
}
80003ec0:	0001                	nop
80003ec2:	8082                	ret

Disassembly of section .text.init_uart2_pins:

80003ec4 <init_uart2_pins>:
    HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
}

void init_uart2_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PB08].FUNC_CTL = IOC_PB08_FUNC_CTL_UART2_TXD;
80003ec4:	f40407b7          	lui	a5,0xf4040
80003ec8:	4709                	li	a4,2
80003eca:	14e7a023          	sw	a4,320(a5) # f4040140 <__AHB_SRAM_segment_end__+0x3c38140>

    HPM_IOC->PAD[IOC_PAD_PB09].FUNC_CTL = IOC_PB09_FUNC_CTL_UART2_RXD;
80003ece:	f40407b7          	lui	a5,0xf4040
80003ed2:	4709                	li	a4,2
80003ed4:	14e7a423          	sw	a4,328(a5) # f4040148 <__AHB_SRAM_segment_end__+0x3c38148>

    HPM_IOC->PAD[IOC_PAD_PB10].FUNC_CTL = IOC_PB10_FUNC_CTL_UART2_DE;
80003ed8:	f40407b7          	lui	a5,0xf4040
80003edc:	4709                	li	a4,2
80003ede:	14e7a823          	sw	a4,336(a5) # f4040150 <__AHB_SRAM_segment_end__+0x3c38150>
}
80003ee2:	0001                	nop
80003ee4:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

80003ee6 <sysctl_resource_target_is_busy>:
{
80003ee6:	1141                	addi	sp,sp,-16
80003ee8:	c62a                	sw	a0,12(sp)
80003eea:	87ae                	mv	a5,a1
80003eec:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
80003ef0:	00a15783          	lhu	a5,10(sp)
80003ef4:	4732                	lw	a4,12(sp)
80003ef6:	078a                	slli	a5,a5,0x2
80003ef8:	97ba                	add	a5,a5,a4
80003efa:	4398                	lw	a4,0(a5)
80003efc:	400007b7          	lui	a5,0x40000
80003f00:	8ff9                	and	a5,a5,a4
80003f02:	00f037b3          	snez	a5,a5
80003f06:	0ff7f793          	zext.b	a5,a5
}
80003f0a:	853e                	mv	a0,a5
80003f0c:	0141                	addi	sp,sp,16
80003f0e:	8082                	ret

Disassembly of section .text.sysctl_resource_target_set_mode:

80003f10 <sysctl_resource_target_set_mode>:
{
80003f10:	1141                	addi	sp,sp,-16
80003f12:	c62a                	sw	a0,12(sp)
80003f14:	87ae                	mv	a5,a1
80003f16:	8732                	mv	a4,a2
80003f18:	00f11523          	sh	a5,10(sp)
80003f1c:	87ba                	mv	a5,a4
80003f1e:	00f104a3          	sb	a5,9(sp)
        (ptr->RESOURCE[resource] & ~SYSCTL_RESOURCE_MODE_MASK) |
80003f22:	00a15783          	lhu	a5,10(sp)
80003f26:	4732                	lw	a4,12(sp)
80003f28:	078a                	slli	a5,a5,0x2
80003f2a:	97ba                	add	a5,a5,a4
80003f2c:	439c                	lw	a5,0(a5)
80003f2e:	ffc7f693          	andi	a3,a5,-4
        SYSCTL_RESOURCE_MODE_SET(mode);
80003f32:	00914783          	lbu	a5,9(sp)
80003f36:	0037f713          	andi	a4,a5,3
    ptr->RESOURCE[resource] =
80003f3a:	00a15783          	lhu	a5,10(sp)
        (ptr->RESOURCE[resource] & ~SYSCTL_RESOURCE_MODE_MASK) |
80003f3e:	8f55                	or	a4,a4,a3
    ptr->RESOURCE[resource] =
80003f40:	46b2                	lw	a3,12(sp)
80003f42:	078a                	slli	a5,a5,0x2
80003f44:	97b6                	add	a5,a5,a3
80003f46:	c398                	sw	a4,0(a5)
}
80003f48:	0001                	nop
80003f4a:	0141                	addi	sp,sp,16
80003f4c:	8082                	ret

Disassembly of section .text.sysctl_resource_target_get_mode:

80003f4e <sysctl_resource_target_get_mode>:
{
80003f4e:	1141                	addi	sp,sp,-16
80003f50:	c62a                	sw	a0,12(sp)
80003f52:	87ae                	mv	a5,a1
80003f54:	00f11523          	sh	a5,10(sp)
    return SYSCTL_RESOURCE_MODE_GET(ptr->RESOURCE[resource]);
80003f58:	00a15783          	lhu	a5,10(sp)
80003f5c:	4732                	lw	a4,12(sp)
80003f5e:	078a                	slli	a5,a5,0x2
80003f60:	97ba                	add	a5,a5,a4
80003f62:	439c                	lw	a5,0(a5)
80003f64:	0ff7f793          	zext.b	a5,a5
80003f68:	8b8d                	andi	a5,a5,3
80003f6a:	0ff7f793          	zext.b	a5,a5
}
80003f6e:	853e                	mv	a0,a5
80003f70:	0141                	addi	sp,sp,16
80003f72:	8082                	ret

Disassembly of section .text.sysctl_clock_set_preset:

80003f74 <sysctl_clock_set_preset>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] preset preset
 */
static inline void sysctl_clock_set_preset(SYSCTL_Type *ptr, sysctl_preset_t preset)
{
80003f74:	1141                	addi	sp,sp,-16
80003f76:	c62a                	sw	a0,12(sp)
80003f78:	87ae                	mv	a5,a1
80003f7a:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_MUX_MASK) | SYSCTL_GLOBAL00_MUX_SET(preset);
80003f7e:	4732                	lw	a4,12(sp)
80003f80:	6789                	lui	a5,0x2
80003f82:	97ba                	add	a5,a5,a4
80003f84:	439c                	lw	a5,0(a5)
80003f86:	f007f713          	andi	a4,a5,-256
80003f8a:	00b14783          	lbu	a5,11(sp)
80003f8e:	8f5d                	or	a4,a4,a5
80003f90:	46b2                	lw	a3,12(sp)
80003f92:	6789                	lui	a5,0x2
80003f94:	97b6                	add	a5,a5,a3
80003f96:	c398                	sw	a4,0(a5)
}
80003f98:	0001                	nop
80003f9a:	0141                	addi	sp,sp,16
80003f9c:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_is_stable:

80003f9e <pllctlv2_xtal_is_stable>:
 * @brief Checks the stability status of the external crystal oscillator
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @return true if the external crystal oscillator is stable and ready for use
 */
static inline bool pllctlv2_xtal_is_stable(PLLCTLV2_Type *ptr)
{
80003f9e:	1101                	addi	sp,sp,-32
80003fa0:	c62a                	sw	a0,12(sp)
    uint32_t status = ptr->XTAL;
80003fa2:	47b2                	lw	a5,12(sp)
80003fa4:	439c                	lw	a5,0(a5)
80003fa6:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_XTAL_ENABLE_MASK)
80003fa8:	4772                	lw	a4,28(sp)
80003faa:	100007b7          	lui	a5,0x10000
80003fae:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_XTAL_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_XTAL_RESPONSE_MASK)));
80003fb0:	cb89                	beqz	a5,80003fc2 <.L30>
80003fb2:	47f2                	lw	a5,28(sp)
80003fb4:	0007c963          	bltz	a5,80003fc6 <.L31>
80003fb8:	4772                	lw	a4,28(sp)
80003fba:	200007b7          	lui	a5,0x20000
80003fbe:	8ff9                	and	a5,a5,a4
80003fc0:	c399                	beqz	a5,80003fc6 <.L31>

80003fc2 <.L30>:
80003fc2:	4785                	li	a5,1
80003fc4:	a011                	j	80003fc8 <.L32>

80003fc6 <.L31>:
80003fc6:	4781                	li	a5,0

80003fc8 <.L32>:
80003fc8:	8b85                	andi	a5,a5,1
80003fca:	0ff7f793          	zext.b	a5,a5
}
80003fce:	853e                	mv	a0,a5
80003fd0:	6105                	addi	sp,sp,32
80003fd2:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_set_rampup_time:

80003fd4 <pllctlv2_xtal_set_rampup_time>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] rc24m_cycles Number of RC24M clock cycles for the ramp-up period
 * @note The ramp-up time affects how quickly the crystal oscillator reaches stable operation
 */
static inline void pllctlv2_xtal_set_rampup_time(PLLCTLV2_Type *ptr, uint32_t rc24m_cycles)
{
80003fd4:	1141                	addi	sp,sp,-16
80003fd6:	c62a                	sw	a0,12(sp)
80003fd8:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTLV2_XTAL_RAMP_TIME_MASK) | PLLCTLV2_XTAL_RAMP_TIME_SET(rc24m_cycles);
80003fda:	47b2                	lw	a5,12(sp)
80003fdc:	4398                	lw	a4,0(a5)
80003fde:	fff007b7          	lui	a5,0xfff00
80003fe2:	8f7d                	and	a4,a4,a5
80003fe4:	46a2                	lw	a3,8(sp)
80003fe6:	001007b7          	lui	a5,0x100
80003fea:	17fd                	addi	a5,a5,-1 # fffff <__FLASH_segment_size__+0x2fff>
80003fec:	8ff5                	and	a5,a5,a3
80003fee:	8f5d                	or	a4,a4,a5
80003ff0:	47b2                	lw	a5,12(sp)
80003ff2:	c398                	sw	a4,0(a5)
}
80003ff4:	0001                	nop
80003ff6:	0141                	addi	sp,sp,16
80003ff8:	8082                	ret

Disassembly of section .text.board_print_banner:

80003ffa <board_print_banner>:
#endif
#endif
}

void board_print_banner(void)
{
80003ffa:	d8010113          	addi	sp,sp,-640
80003ffe:	26112e23          	sw	ra,636(sp)
    const uint8_t banner[] = "\n"
80004002:	95c18713          	addi	a4,gp,-1700 # 800031ec <.LC0>
80004006:	878a                	mv	a5,sp
80004008:	86ba                	mv	a3,a4
8000400a:	26f00713          	li	a4,623
8000400e:	863a                	mv	a2,a4
80004010:	85b6                	mv	a1,a3
80004012:	853e                	mv	a0,a5
80004014:	3fb000ef          	jal	80004c0e <memcpy>
"$$ |  $$ |$$ |      $$ |\\$  /$$ |$$ |$$ |      $$ |      $$ |  $$ |\n"
"$$ |  $$ |$$ |      $$ | \\_/ $$ |$$ |\\$$$$$$$\\ $$ |      \\$$$$$$  |\n"
"\\__|  \\__|\\__|      \\__|     \\__|\\__| \\_______|\\__|       \\______/\n"
"----------------------------------------------------------------------\n";
#ifdef SDK_VERSION_STRING
    printf("hpm_sdk: %s\n", SDK_VERSION_STRING);
80004018:	94018593          	addi	a1,gp,-1728 # 800031d0 <.LC1>
8000401c:	94818513          	addi	a0,gp,-1720 # 800031d8 <.LC2>
80004020:	6c1000ef          	jal	80004ee0 <printf>
#endif
    printf("%s", banner);
80004024:	878a                	mv	a5,sp
80004026:	85be                	mv	a1,a5
80004028:	95818513          	addi	a0,gp,-1704 # 800031e8 <.LC3>
8000402c:	6b5000ef          	jal	80004ee0 <printf>
}
80004030:	0001                	nop
80004032:	27c12083          	lw	ra,636(sp)
80004036:	28010113          	addi	sp,sp,640
8000403a:	8082                	ret

Disassembly of section .text.board_print_clock_freq:

8000403c <board_print_clock_freq>:

void board_print_clock_freq(void)
{
8000403c:	1141                	addi	sp,sp,-16
8000403e:	c606                	sw	ra,12(sp)
    printf("==============================\n");
80004040:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
80004044:	69d000ef          	jal	80004ee0 <printf>
    printf(" %s clock summary\n", BOARD_NAME);
80004048:	bec18593          	addi	a1,gp,-1044 # 8000347c <.LC5>
8000404c:	bf818513          	addi	a0,gp,-1032 # 80003488 <.LC6>
80004050:	691000ef          	jal	80004ee0 <printf>
    printf("==============================\n");
80004054:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
80004058:	689000ef          	jal	80004ee0 <printf>
    printf("cpu0:\t\t %luHz\n", clock_get_frequency(clock_cpu0));
8000405c:	6785                	lui	a5,0x1
8000405e:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x6a6>
80004062:	7a9010ef          	jal	8000600a <clock_get_frequency>
80004066:	87aa                	mv	a5,a0
80004068:	85be                	mv	a1,a5
8000406a:	c0c18513          	addi	a0,gp,-1012 # 8000349c <.LC7>
8000406e:	673000ef          	jal	80004ee0 <printf>
    printf("ahb:\t\t %luHz\n", clock_get_frequency(clock_ahb));
80004072:	fffd07b7          	lui	a5,0xfffd0
80004076:	5fe78513          	addi	a0,a5,1534 # fffd05fe <__AHB_SRAM_segment_end__+0xfbc85fe>
8000407a:	791010ef          	jal	8000600a <clock_get_frequency>
8000407e:	87aa                	mv	a5,a0
80004080:	85be                	mv	a1,a5
80004082:	c1c18513          	addi	a0,gp,-996 # 800034ac <.LC8>
80004086:	65b000ef          	jal	80004ee0 <printf>
    printf("mchtmr0:\t %luHz\n", clock_get_frequency(clock_mchtmr0));
8000408a:	01020537          	lui	a0,0x1020
8000408e:	77d010ef          	jal	8000600a <clock_get_frequency>
80004092:	87aa                	mv	a5,a0
80004094:	85be                	mv	a1,a5
80004096:	c2c18513          	addi	a0,gp,-980 # 800034bc <.LC9>
8000409a:	647000ef          	jal	80004ee0 <printf>
    printf("xpi0:\t\t %luHz\n", clock_get_frequency(clock_xpi0));
8000409e:	013307b7          	lui	a5,0x1330
800040a2:	01d78513          	addi	a0,a5,29 # 133001d <_flash_size+0x123001d>
800040a6:	765010ef          	jal	8000600a <clock_get_frequency>
800040aa:	87aa                	mv	a5,a0
800040ac:	85be                	mv	a1,a5
800040ae:	c4018513          	addi	a0,gp,-960 # 800034d0 <.LC10>
800040b2:	62f000ef          	jal	80004ee0 <printf>
    printf("==============================\n");
800040b6:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
800040ba:	627000ef          	jal	80004ee0 <printf>
}
800040be:	0001                	nop
800040c0:	40b2                	lw	ra,12(sp)
800040c2:	0141                	addi	sp,sp,16
800040c4:	8082                	ret

Disassembly of section .text.board_init_usb_dp_dm_pins:

800040c6 <board_init_usb_dp_dm_pins>:
    board_print_banner();
#endif
}

void board_init_usb_dp_dm_pins(void)
{
800040c6:	1101                	addi	sp,sp,-32
800040c8:	ce06                	sw	ra,28(sp)
    /* Disconnect usb dp/dm pins pull down 45ohm resistance */

    while (sysctl_resource_any_is_busy(HPM_SYSCTL)) {
800040ca:	0001                	nop

800040cc <.L50>:
800040cc:	f4000537          	lui	a0,0xf4000
800040d0:	2ea020ef          	jal	800063ba <sysctl_resource_any_is_busy>
800040d4:	87aa                	mv	a5,a0
800040d6:	fbfd                	bnez	a5,800040cc <.L50>
        ;
    }
    if (pllctlv2_xtal_is_stable(HPM_PLLCTLV2) && pllctlv2_xtal_is_enabled(HPM_PLLCTLV2)) {
800040d8:	f40c0537          	lui	a0,0xf40c0
800040dc:	35c9                	jal	80003f9e <pllctlv2_xtal_is_stable>
800040de:	87aa                	mv	a5,a0
800040e0:	c7b1                	beqz	a5,8000412c <.L51>
800040e2:	f40c0537          	lui	a0,0xf40c0
800040e6:	348020ef          	jal	8000642e <pllctlv2_xtal_is_enabled>
800040ea:	87aa                	mv	a5,a0
800040ec:	c3a1                	beqz	a5,8000412c <.L51>
        if (clock_check_in_group(clock_usb0, 0)) {
800040ee:	4581                	li	a1,0
800040f0:	013407b7          	lui	a5,0x1340
800040f4:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
800040f8:	190020ef          	jal	80006288 <clock_check_in_group>
800040fc:	87aa                	mv	a5,a0
800040fe:	c791                	beqz	a5,8000410a <.L52>
            usb_phy_disable_dp_dm_pulldown(HPM_USB0);
80004100:	f300c537          	lui	a0,0xf300c
80004104:	30a020ef          	jal	8000640e <usb_phy_disable_dp_dm_pulldown>
        if (clock_check_in_group(clock_usb0, 0)) {
80004108:	a049                	j	8000418a <.L54>

8000410a <.L52>:
        } else {
            clock_add_to_group(clock_usb0, 0);
8000410a:	4581                	li	a1,0
8000410c:	013407b7          	lui	a5,0x1340
80004110:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004114:	393d                	jal	80003d52 <clock_add_to_group>
            usb_phy_disable_dp_dm_pulldown(HPM_USB0);
80004116:	f300c537          	lui	a0,0xf300c
8000411a:	2f4020ef          	jal	8000640e <usb_phy_disable_dp_dm_pulldown>
            clock_remove_from_group(clock_usb0, 0);
8000411e:	4581                	li	a1,0
80004120:	013407b7          	lui	a5,0x1340
80004124:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004128:	3195                	jal	80003d8c <clock_remove_from_group>
        if (clock_check_in_group(clock_usb0, 0)) {
8000412a:	a085                	j	8000418a <.L54>

8000412c <.L51>:
        }
    } else {
        uint8_t tmp;
        tmp = sysctl_resource_target_get_mode(HPM_SYSCTL, sysctl_resource_xtal);
8000412c:	02000593          	li	a1,32
80004130:	f4000537          	lui	a0,0xf4000
80004134:	3d29                	jal	80003f4e <sysctl_resource_target_get_mode>
80004136:	87aa                	mv	a5,a0
80004138:	00f107a3          	sb	a5,15(sp)
        sysctl_resource_target_set_mode(HPM_SYSCTL, sysctl_resource_xtal, 0x03);    /* NOLINT */
8000413c:	460d                	li	a2,3
8000413e:	02000593          	li	a1,32
80004142:	f4000537          	lui	a0,0xf4000
80004146:	33e9                	jal	80003f10 <sysctl_resource_target_set_mode>
        clock_add_to_group(clock_usb0, 0);
80004148:	4581                	li	a1,0
8000414a:	013407b7          	lui	a5,0x1340
8000414e:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004152:	3101                	jal	80003d52 <clock_add_to_group>
        usb_phy_disable_dp_dm_pulldown(HPM_USB0);
80004154:	f300c537          	lui	a0,0xf300c
80004158:	2b6020ef          	jal	8000640e <usb_phy_disable_dp_dm_pulldown>
        clock_remove_from_group(clock_usb0, 0);
8000415c:	4581                	li	a1,0
8000415e:	013407b7          	lui	a5,0x1340
80004162:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004166:	311d                	jal	80003d8c <clock_remove_from_group>
        while (sysctl_resource_target_is_busy(HPM_SYSCTL, sysctl_resource_usb0)) {
80004168:	0001                	nop

8000416a <.L55>:
8000416a:	13400593          	li	a1,308
8000416e:	f4000537          	lui	a0,0xf4000
80004172:	3b95                	jal	80003ee6 <sysctl_resource_target_is_busy>
80004174:	87aa                	mv	a5,a0
80004176:	fbf5                	bnez	a5,8000416a <.L55>
            ;
        }
        sysctl_resource_target_set_mode(HPM_SYSCTL, sysctl_resource_xtal, tmp);
80004178:	00f14783          	lbu	a5,15(sp)
8000417c:	863e                	mv	a2,a5
8000417e:	02000593          	li	a1,32
80004182:	f4000537          	lui	a0,0xf4000
80004186:	3369                	jal	80003f10 <sysctl_resource_target_set_mode>

80004188 <.LBE14>:
    }
}
80004188:	0001                	nop

8000418a <.L54>:
8000418a:	0001                	nop
8000418c:	40f2                	lw	ra,28(sp)
8000418e:	6105                	addi	sp,sp,32
80004190:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

80004192 <uart_calculate_baudrate>:
    config->rx_enable = true;
#endif
}

static bool uart_calculate_baudrate(uint32_t freq, uint32_t baudrate, uint16_t *div_out, uint8_t *osc_out)
{
80004192:	711d                	addi	sp,sp,-96
80004194:	ce86                	sw	ra,92(sp)
80004196:	cca2                	sw	s0,88(sp)
80004198:	caa6                	sw	s1,84(sp)
8000419a:	c8ca                	sw	s2,80(sp)
8000419c:	c6ce                	sw	s3,76(sp)
8000419e:	c4d2                	sw	s4,72(sp)
800041a0:	c2d6                	sw	s5,68(sp)
800041a2:	c0da                	sw	s6,64(sp)
800041a4:	de5e                	sw	s7,60(sp)
800041a6:	dc62                	sw	s8,56(sp)
800041a8:	da66                	sw	s9,52(sp)
800041aa:	c62a                	sw	a0,12(sp)
800041ac:	c42e                	sw	a1,8(sp)
800041ae:	c232                	sw	a2,4(sp)
800041b0:	c036                	sw	a3,0(sp)
    uint32_t div, osc, delta;
    uint64_t tmp;
    if ((div_out == NULL) || (!freq) || (!baudrate)
800041b2:	4692                	lw	a3,4(sp)
800041b4:	ca9d                	beqz	a3,800041ea <.L6>
800041b6:	46b2                	lw	a3,12(sp)
800041b8:	ca8d                	beqz	a3,800041ea <.L6>
800041ba:	46a2                	lw	a3,8(sp)
800041bc:	c69d                	beqz	a3,800041ea <.L6>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
800041be:	4622                	lw	a2,8(sp)
800041c0:	0c700693          	li	a3,199
800041c4:	02c6f363          	bgeu	a3,a2,800041ea <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
800041c8:	46a2                	lw	a3,8(sp)
800041ca:	068e                	slli	a3,a3,0x3
800041cc:	4632                	lw	a2,12(sp)
800041ce:	00d66e63          	bltu	a2,a3,800041ea <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
800041d2:	4632                	lw	a2,12(sp)
800041d4:	800086b7          	lui	a3,0x80008
800041d8:	0685                	addi	a3,a3,1 # 80008001 <__SEGGER_init_data__+0xe9>
800041da:	02d636b3          	mulhu	a3,a2,a3
800041de:	00f6d613          	srli	a2,a3,0xf
800041e2:	46a2                	lw	a3,8(sp)
800041e4:	0696                	slli	a3,a3,0x5
800041e6:	00c6f463          	bgeu	a3,a2,800041ee <.L7>

800041ea <.L6>:
        return 0;
800041ea:	4781                	li	a5,0
800041ec:	a2f5                	j	800043d8 <.L8>

800041ee <.L7>:
    }

    tmp = ((uint64_t)freq * HPM_UART_BAUDRATE_SCALE) / baudrate;
800041ee:	46b2                	lw	a3,12(sp)
800041f0:	8736                	mv	a4,a3
800041f2:	4781                	li	a5,0
800041f4:	3e800693          	li	a3,1000
800041f8:	02d78633          	mul	a2,a5,a3
800041fc:	4681                	li	a3,0
800041fe:	02d706b3          	mul	a3,a4,a3
80004202:	9636                	add	a2,a2,a3
80004204:	3e800693          	li	a3,1000
80004208:	02d705b3          	mul	a1,a4,a3
8000420c:	02d738b3          	mulhu	a7,a4,a3
80004210:	882e                	mv	a6,a1
80004212:	011607b3          	add	a5,a2,a7
80004216:	88be                	mv	a7,a5
80004218:	47a2                	lw	a5,8(sp)
8000421a:	833e                	mv	t1,a5
8000421c:	4381                	li	t2,0
8000421e:	861a                	mv	a2,t1
80004220:	869e                	mv	a3,t2
80004222:	8542                	mv	a0,a6
80004224:	85c6                	mv	a1,a7
80004226:	7eb020ef          	jal	80007210 <__udivdi3>
8000422a:	872a                	mv	a4,a0
8000422c:	87ae                	mv	a5,a1
8000422e:	d03a                	sw	a4,32(sp)
80004230:	d23e                	sw	a5,36(sp)

    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80004232:	47a1                	li	a5,8
80004234:	d63e                	sw	a5,44(sp)
80004236:	aa61                	j	800043ce <.L9>

80004238 <.L21>:
        /* osc range: HPM_UART_OSC_MIN - UART_SOC_OVERSAMPLE_MAX, even number */
        delta = 0;
80004238:	d402                	sw	zero,40(sp)
        /* Calculate divider with rounding */
        div = (uint32_t)((tmp + osc * (HPM_UART_BAUDRATE_SCALE / 2)) / (osc * HPM_UART_BAUDRATE_SCALE));
8000423a:	5732                	lw	a4,44(sp)
8000423c:	87ba                	mv	a5,a4
8000423e:	078a                	slli	a5,a5,0x2
80004240:	97ba                	add	a5,a5,a4
80004242:	00279713          	slli	a4,a5,0x2
80004246:	97ba                	add	a5,a5,a4
80004248:	00279713          	slli	a4,a5,0x2
8000424c:	97ba                	add	a5,a5,a4
8000424e:	078a                	slli	a5,a5,0x2
80004250:	843e                	mv	s0,a5
80004252:	4481                	li	s1,0
80004254:	5602                	lw	a2,32(sp)
80004256:	5692                	lw	a3,36(sp)
80004258:	00c40733          	add	a4,s0,a2
8000425c:	85ba                	mv	a1,a4
8000425e:	0085b5b3          	sltu	a1,a1,s0
80004262:	00d487b3          	add	a5,s1,a3
80004266:	00f586b3          	add	a3,a1,a5
8000426a:	87b6                	mv	a5,a3
8000426c:	853a                	mv	a0,a4
8000426e:	85be                	mv	a1,a5
80004270:	5732                	lw	a4,44(sp)
80004272:	87ba                	mv	a5,a4
80004274:	078a                	slli	a5,a5,0x2
80004276:	97ba                	add	a5,a5,a4
80004278:	00279713          	slli	a4,a5,0x2
8000427c:	97ba                	add	a5,a5,a4
8000427e:	00279713          	slli	a4,a5,0x2
80004282:	97ba                	add	a5,a5,a4
80004284:	078e                	slli	a5,a5,0x3
80004286:	8b3e                	mv	s6,a5
80004288:	4b81                	li	s7,0
8000428a:	865a                	mv	a2,s6
8000428c:	86de                	mv	a3,s7
8000428e:	783020ef          	jal	80007210 <__udivdi3>
80004292:	872a                	mv	a4,a0
80004294:	87ae                	mv	a5,a1
80004296:	ce3a                	sw	a4,28(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN || div > HPM_UART_BAUDRATE_DIV_MAX) {
80004298:	47f2                	lw	a5,28(sp)
8000429a:	12078463          	beqz	a5,800043c2 <.L24>
8000429e:	4772                	lw	a4,28(sp)
800042a0:	67c1                	lui	a5,0x10
800042a2:	12f77063          	bgeu	a4,a5,800043c2 <.L24>
            /* invalid div */
            continue;
        }
        if ((div * osc * HPM_UART_BAUDRATE_SCALE) > tmp) {
800042a6:	4772                	lw	a4,28(sp)
800042a8:	57b2                	lw	a5,44(sp)
800042aa:	02f70733          	mul	a4,a4,a5
800042ae:	87ba                	mv	a5,a4
800042b0:	078a                	slli	a5,a5,0x2
800042b2:	97ba                	add	a5,a5,a4
800042b4:	00279713          	slli	a4,a5,0x2
800042b8:	97ba                	add	a5,a5,a4
800042ba:	00279713          	slli	a4,a5,0x2
800042be:	97ba                	add	a5,a5,a4
800042c0:	078e                	slli	a5,a5,0x3
800042c2:	893e                	mv	s2,a5
800042c4:	4981                	li	s3,0
800042c6:	5792                	lw	a5,36(sp)
800042c8:	874e                	mv	a4,s3
800042ca:	00e7ea63          	bltu	a5,a4,800042de <.L22>
800042ce:	5792                	lw	a5,36(sp)
800042d0:	874e                	mv	a4,s3
800042d2:	02e79a63          	bne	a5,a4,80004306 <.L13>
800042d6:	5782                	lw	a5,32(sp)
800042d8:	874a                	mv	a4,s2
800042da:	02e7f663          	bgeu	a5,a4,80004306 <.L13>

800042de <.L22>:
            delta = (uint32_t)((div * osc * HPM_UART_BAUDRATE_SCALE) - tmp);
800042de:	4772                	lw	a4,28(sp)
800042e0:	57b2                	lw	a5,44(sp)
800042e2:	02f70733          	mul	a4,a4,a5
800042e6:	87ba                	mv	a5,a4
800042e8:	078a                	slli	a5,a5,0x2
800042ea:	97ba                	add	a5,a5,a4
800042ec:	00279713          	slli	a4,a5,0x2
800042f0:	97ba                	add	a5,a5,a4
800042f2:	00279713          	slli	a4,a5,0x2
800042f6:	97ba                	add	a5,a5,a4
800042f8:	078e                	slli	a5,a5,0x3
800042fa:	873e                	mv	a4,a5
800042fc:	5782                	lw	a5,32(sp)
800042fe:	40f707b3          	sub	a5,a4,a5
80004302:	d43e                	sw	a5,40(sp)
80004304:	a8b9                	j	80004362 <.L15>

80004306 <.L13>:
        } else if ((div * osc * HPM_UART_BAUDRATE_SCALE) < tmp) {
80004306:	4772                	lw	a4,28(sp)
80004308:	57b2                	lw	a5,44(sp)
8000430a:	02f70733          	mul	a4,a4,a5
8000430e:	87ba                	mv	a5,a4
80004310:	078a                	slli	a5,a5,0x2
80004312:	97ba                	add	a5,a5,a4
80004314:	00279713          	slli	a4,a5,0x2
80004318:	97ba                	add	a5,a5,a4
8000431a:	00279713          	slli	a4,a5,0x2
8000431e:	97ba                	add	a5,a5,a4
80004320:	078e                	slli	a5,a5,0x3
80004322:	8a3e                	mv	s4,a5
80004324:	4a81                	li	s5,0
80004326:	5792                	lw	a5,36(sp)
80004328:	8756                	mv	a4,s5
8000432a:	00f76a63          	bltu	a4,a5,8000433e <.L23>
8000432e:	5792                	lw	a5,36(sp)
80004330:	8756                	mv	a4,s5
80004332:	02e79863          	bne	a5,a4,80004362 <.L15>
80004336:	5782                	lw	a5,32(sp)
80004338:	8752                	mv	a4,s4
8000433a:	02f77463          	bgeu	a4,a5,80004362 <.L15>

8000433e <.L23>:
            delta = (uint32_t)(tmp - (div * osc * HPM_UART_BAUDRATE_SCALE));
8000433e:	5682                	lw	a3,32(sp)
80004340:	4772                	lw	a4,28(sp)
80004342:	57b2                	lw	a5,44(sp)
80004344:	02f70733          	mul	a4,a4,a5
80004348:	87ba                	mv	a5,a4
8000434a:	078a                	slli	a5,a5,0x2
8000434c:	97ba                	add	a5,a5,a4
8000434e:	00279713          	slli	a4,a5,0x2
80004352:	97ba                	add	a5,a5,a4
80004354:	00279713          	slli	a4,a5,0x2
80004358:	97ba                	add	a5,a5,a4
8000435a:	078e                	slli	a5,a5,0x3
8000435c:	40f687b3          	sub	a5,a3,a5
80004360:	d43e                	sw	a5,40(sp)

80004362 <.L15>:
        }
        if (delta && (((delta * 100) / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
80004362:	57a2                	lw	a5,40(sp)
80004364:	cb95                	beqz	a5,80004398 <.L17>
80004366:	5722                	lw	a4,40(sp)
80004368:	87ba                	mv	a5,a4
8000436a:	078a                	slli	a5,a5,0x2
8000436c:	97ba                	add	a5,a5,a4
8000436e:	00279713          	slli	a4,a5,0x2
80004372:	97ba                	add	a5,a5,a4
80004374:	078a                	slli	a5,a5,0x2
80004376:	8c3e                	mv	s8,a5
80004378:	4c81                	li	s9,0
8000437a:	5602                	lw	a2,32(sp)
8000437c:	5692                	lw	a3,36(sp)
8000437e:	8562                	mv	a0,s8
80004380:	85e6                	mv	a1,s9
80004382:	68f020ef          	jal	80007210 <__udivdi3>
80004386:	872a                	mv	a4,a0
80004388:	87ae                	mv	a5,a1
8000438a:	86be                	mv	a3,a5
8000438c:	ee8d                	bnez	a3,800043c6 <.L25>
8000438e:	86be                	mv	a3,a5
80004390:	e681                	bnez	a3,80004398 <.L17>
80004392:	478d                	li	a5,3
80004394:	02e7e963          	bltu	a5,a4,800043c6 <.L25>

80004398 <.L17>:
            continue;
        } else {
            *div_out = div;
80004398:	47f2                	lw	a5,28(sp)
8000439a:	0807c733          	zext.h	a4,a5
8000439e:	4792                	lw	a5,4(sp)
800043a0:	00e79023          	sh	a4,0(a5) # 10000 <__AHB_SRAM_segment_size__+0x8000>
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
800043a4:	5732                	lw	a4,44(sp)
800043a6:	02000793          	li	a5,32
800043aa:	00f70663          	beq	a4,a5,800043b6 <.L19>
800043ae:	57b2                	lw	a5,44(sp)
800043b0:	0ff7f793          	zext.b	a5,a5
800043b4:	a011                	j	800043b8 <.L20>

800043b6 <.L19>:
800043b6:	4781                	li	a5,0

800043b8 <.L20>:
800043b8:	4702                	lw	a4,0(sp)
800043ba:	00f70023          	sb	a5,0(a4) # f4000000 <__AHB_SRAM_segment_end__+0x3bf8000>
            return true;
800043be:	4785                	li	a5,1
800043c0:	a821                	j	800043d8 <.L8>

800043c2 <.L24>:
            continue;
800043c2:	0001                	nop
800043c4:	a011                	j	800043c8 <.L12>

800043c6 <.L25>:
            continue;
800043c6:	0001                	nop

800043c8 <.L12>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
800043c8:	57b2                	lw	a5,44(sp)
800043ca:	0789                	addi	a5,a5,2
800043cc:	d63e                	sw	a5,44(sp)

800043ce <.L9>:
800043ce:	5732                	lw	a4,44(sp)
800043d0:	47f9                	li	a5,30
800043d2:	e6e7f3e3          	bgeu	a5,a4,80004238 <.L21>
        }
    }
    return false;
800043d6:	4781                	li	a5,0

800043d8 <.L8>:
}
800043d8:	853e                	mv	a0,a5
800043da:	40f6                	lw	ra,92(sp)
800043dc:	4466                	lw	s0,88(sp)
800043de:	44d6                	lw	s1,84(sp)
800043e0:	4946                	lw	s2,80(sp)
800043e2:	49b6                	lw	s3,76(sp)
800043e4:	4a26                	lw	s4,72(sp)
800043e6:	4a96                	lw	s5,68(sp)
800043e8:	4b06                	lw	s6,64(sp)
800043ea:	5bf2                	lw	s7,60(sp)
800043ec:	5c62                	lw	s8,56(sp)
800043ee:	5cd2                	lw	s9,52(sp)
800043f0:	6125                	addi	sp,sp,96
800043f2:	8082                	ret

Disassembly of section .text.uart_init:

800043f4 <uart_init>:

hpm_stat_t uart_init(UART_Type *ptr, uart_config_t *config)
{
800043f4:	7179                	addi	sp,sp,-48
800043f6:	d606                	sw	ra,44(sp)
800043f8:	c62a                	sw	a0,12(sp)
800043fa:	c42e                	sw	a1,8(sp)
    uint32_t tmp;
    uint8_t osc;
    uint16_t div;

    /* disable all interrupts */
    ptr->IER = 0;
800043fc:	47b2                	lw	a5,12(sp)
800043fe:	0207a223          	sw	zero,36(a5)
    /* Set DLAB to 1 */
    ptr->LCR |= UART_LCR_DLAB_MASK;
80004402:	47b2                	lw	a5,12(sp)
80004404:	57dc                	lw	a5,44(a5)
80004406:	0807e713          	ori	a4,a5,128
8000440a:	47b2                	lw	a5,12(sp)
8000440c:	d7d8                	sw	a4,44(a5)

    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
8000440e:	47a2                	lw	a5,8(sp)
80004410:	4398                	lw	a4,0(a5)
80004412:	47a2                	lw	a5,8(sp)
80004414:	43dc                	lw	a5,4(a5)
80004416:	01b10693          	addi	a3,sp,27
8000441a:	0830                	addi	a2,sp,24
8000441c:	85be                	mv	a1,a5
8000441e:	853a                	mv	a0,a4
80004420:	3b8d                	jal	80004192 <uart_calculate_baudrate>
80004422:	87aa                	mv	a5,a0
80004424:	0017c793          	xori	a5,a5,1
80004428:	0ff7f793          	zext.b	a5,a5
8000442c:	c781                	beqz	a5,80004434 <.L27>
        return status_uart_no_suitable_baudrate_parameter_found;
8000442e:	3e900793          	li	a5,1001
80004432:	a251                	j	800045b6 <.L44>

80004434 <.L27>:
    }
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80004434:	47b2                	lw	a5,12(sp)
80004436:	4bdc                	lw	a5,20(a5)
80004438:	fe07f713          	andi	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
8000443c:	01b14783          	lbu	a5,27(sp)
80004440:	8bfd                	andi	a5,a5,31
80004442:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80004444:	47b2                	lw	a5,12(sp)
80004446:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
80004448:	01815783          	lhu	a5,24(sp)
8000444c:	0ff7f713          	zext.b	a4,a5
80004450:	47b2                	lw	a5,12(sp)
80004452:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
80004454:	01815783          	lhu	a5,24(sp)
80004458:	83a1                	srli	a5,a5,0x8
8000445a:	0807c7b3          	zext.h	a5,a5
8000445e:	0ff7f713          	zext.b	a4,a5
80004462:	47b2                	lw	a5,12(sp)
80004464:	d3d8                	sw	a4,36(a5)

    /* DLAB bit needs to be cleared once baudrate is configured */
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
80004466:	47b2                	lw	a5,12(sp)
80004468:	57dc                	lw	a5,44(a5)
8000446a:	f7f7f793          	andi	a5,a5,-129
8000446e:	ce3e                	sw	a5,28(sp)

    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
80004470:	47f2                	lw	a5,28(sp)
80004472:	fc77f793          	andi	a5,a5,-57
80004476:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
80004478:	47a2                	lw	a5,8(sp)
8000447a:	00a7c783          	lbu	a5,10(a5)
8000447e:	4711                	li	a4,4
80004480:	02f76d63          	bltu	a4,a5,800044ba <.L29>
80004484:	00279713          	slli	a4,a5,0x2
80004488:	cec18793          	addi	a5,gp,-788 # 8000357c <.L31>
8000448c:	97ba                	add	a5,a5,a4
8000448e:	439c                	lw	a5,0(a5)
80004490:	8782                	jr	a5

80004492 <.L34>:
    case parity_none:
        break;
    case parity_odd:
        tmp |= UART_LCR_PEN_MASK;
80004492:	47f2                	lw	a5,28(sp)
80004494:	0087e793          	ori	a5,a5,8
80004498:	ce3e                	sw	a5,28(sp)
        break;
8000449a:	a01d                	j	800044c0 <.L36>

8000449c <.L33>:
    case parity_even:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
8000449c:	47f2                	lw	a5,28(sp)
8000449e:	0187e793          	ori	a5,a5,24
800044a2:	ce3e                	sw	a5,28(sp)
        break;
800044a4:	a831                	j	800044c0 <.L36>

800044a6 <.L32>:
    case parity_always_1:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
800044a6:	47f2                	lw	a5,28(sp)
800044a8:	0287e793          	ori	a5,a5,40
800044ac:	ce3e                	sw	a5,28(sp)
        break;
800044ae:	a809                	j	800044c0 <.L36>

800044b0 <.L30>:
    case parity_always_0:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
800044b0:	47f2                	lw	a5,28(sp)
800044b2:	0387e793          	ori	a5,a5,56
800044b6:	ce3e                	sw	a5,28(sp)
            | UART_LCR_SPS_MASK;
        break;
800044b8:	a021                	j	800044c0 <.L36>

800044ba <.L29>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
800044ba:	4789                	li	a5,2
800044bc:	a8ed                	j	800045b6 <.L44>

800044be <.L45>:
        break;
800044be:	0001                	nop

800044c0 <.L36>:
    }

    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
800044c0:	47f2                	lw	a5,28(sp)
800044c2:	9be1                	andi	a5,a5,-8
800044c4:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
800044c6:	47a2                	lw	a5,8(sp)
800044c8:	0087c783          	lbu	a5,8(a5)
800044cc:	4709                	li	a4,2
800044ce:	00e78e63          	beq	a5,a4,800044ea <.L37>
800044d2:	4709                	li	a4,2
800044d4:	02f74663          	blt	a4,a5,80004500 <.L38>
800044d8:	c795                	beqz	a5,80004504 <.L46>
800044da:	4705                	li	a4,1
800044dc:	02e79263          	bne	a5,a4,80004500 <.L38>
    case stop_bits_1:
        break;
    case stop_bits_1_5:
        tmp |= UART_LCR_STB_MASK;
800044e0:	47f2                	lw	a5,28(sp)
800044e2:	0047e793          	ori	a5,a5,4
800044e6:	ce3e                	sw	a5,28(sp)
        break;
800044e8:	a839                	j	80004506 <.L41>

800044ea <.L37>:
    case stop_bits_2:
        if (config->word_length < word_length_6_bits) {
800044ea:	47a2                	lw	a5,8(sp)
800044ec:	0097c783          	lbu	a5,9(a5)
800044f0:	e399                	bnez	a5,800044f6 <.L42>
            /* invalid configuration */
            return status_invalid_argument;
800044f2:	4789                	li	a5,2
800044f4:	a0c9                	j	800045b6 <.L44>

800044f6 <.L42>:
        }
        tmp |= UART_LCR_STB_MASK;
800044f6:	47f2                	lw	a5,28(sp)
800044f8:	0047e793          	ori	a5,a5,4
800044fc:	ce3e                	sw	a5,28(sp)
        break;
800044fe:	a021                	j	80004506 <.L41>

80004500 <.L38>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
80004500:	4789                	li	a5,2
80004502:	a855                	j	800045b6 <.L44>

80004504 <.L46>:
        break;
80004504:	0001                	nop

80004506 <.L41>:
    }

    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
80004506:	47a2                	lw	a5,8(sp)
80004508:	0097c783          	lbu	a5,9(a5)
8000450c:	0037f713          	andi	a4,a5,3
80004510:	47f2                	lw	a5,28(sp)
80004512:	8f5d                	or	a4,a4,a5
80004514:	47b2                	lw	a5,12(sp)
80004516:	d7d8                	sw	a4,44(a5)

#if defined(HPM_IP_FEATURE_UART_FINE_FIFO_THRLD) && (HPM_IP_FEATURE_UART_FINE_FIFO_THRLD == 1)
    /* reset TX and RX fifo */
    ptr->FCRR = UART_FCRR_TFIFORST_MASK | UART_FCRR_RFIFORST_MASK;
80004518:	47b2                	lw	a5,12(sp)
8000451a:	4719                	li	a4,6
8000451c:	cf98                	sw	a4,24(a5)
    /* Enable FIFO */
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
        | UART_FCRR_FIFOE_SET(config->fifo_enable)
8000451e:	47a2                	lw	a5,8(sp)
80004520:	00e7c783          	lbu	a5,14(a5)
80004524:	86be                	mv	a3,a5
        | UART_FCRR_TFIFOT4_SET(config->tx_fifo_level)
80004526:	47a2                	lw	a5,8(sp)
80004528:	00b7c783          	lbu	a5,11(a5)
8000452c:	01079713          	slli	a4,a5,0x10
80004530:	001f07b7          	lui	a5,0x1f0
80004534:	8ff9                	and	a5,a5,a4
80004536:	00f6e733          	or	a4,a3,a5
        | UART_FCRR_RFIFOT4_SET(config->rx_fifo_level)
8000453a:	47a2                	lw	a5,8(sp)
8000453c:	00c7c783          	lbu	a5,12(a5) # 1f000c <_flash_size+0xf000c>
80004540:	00879693          	slli	a3,a5,0x8
80004544:	6789                	lui	a5,0x2
80004546:	f0078793          	addi	a5,a5,-256 # 1f00 <__NOR_CFG_OPTION_segment_size__+0x1300>
8000454a:	8ff5                	and	a5,a5,a3
8000454c:	8f5d                	or	a4,a4,a5
#if defined(HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT) && (HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT == 1)
        | UART_FCRR_TMOUT_RXDMA_DIS_MASK /**< disable RX timeout trigger dma */
#endif
        | UART_FCRR_DMAE_SET(config->dma_enable);
8000454e:	47a2                	lw	a5,8(sp)
80004550:	00d7c783          	lbu	a5,13(a5)
80004554:	078e                	slli	a5,a5,0x3
80004556:	8ba1                	andi	a5,a5,8
80004558:	8f5d                	or	a4,a4,a5
8000455a:	008007b7          	lui	a5,0x800
8000455e:	8f5d                	or	a4,a4,a5
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
80004560:	47b2                	lw	a5,12(sp)
80004562:	cf98                	sw	a4,24(a5)
    ptr->FCR = tmp;
    /* store FCR register value */
    ptr->GPR = tmp;
#endif

    uart_modem_config(ptr, &config->modem_config);
80004564:	47a2                	lw	a5,8(sp)
80004566:	07bd                	addi	a5,a5,15 # 80000f <_flash_size+0x70000f>
80004568:	85be                	mv	a1,a5
8000456a:	4532                	lw	a0,12(sp)
8000456c:	0a2020ef          	jal	8000660e <uart_modem_config>

#if defined(HPM_IP_FEATURE_UART_RX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_RX_IDLE_DETECT == 1)
    uart_init_rxline_idle_detection(ptr, config->rxidle_config);
80004570:	47a2                	lw	a5,8(sp)
80004572:	0127d703          	lhu	a4,18(a5)
80004576:	0147d783          	lhu	a5,20(a5)
8000457a:	07c2                	slli	a5,a5,0x10
8000457c:	8fd9                	or	a5,a5,a4
8000457e:	873e                	mv	a4,a5
80004580:	85ba                	mv	a1,a4
80004582:	4532                	lw	a0,12(sp)
80004584:	1ce020ef          	jal	80006752 <uart_init_rxline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
    uart_init_txline_idle_detection(ptr, config->txidle_config);
80004588:	47a2                	lw	a5,8(sp)
8000458a:	0167d703          	lhu	a4,22(a5)
8000458e:	0187d783          	lhu	a5,24(a5)
80004592:	07c2                	slli	a5,a5,0x10
80004594:	8fd9                	or	a5,a5,a4
80004596:	873e                	mv	a4,a5
80004598:	85ba                	mv	a1,a4
8000459a:	4532                	lw	a0,12(sp)
8000459c:	2885                	jal	8000460c <uart_init_txline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    if (config->rx_enable) {
8000459e:	47a2                	lw	a5,8(sp)
800045a0:	01a7c783          	lbu	a5,26(a5)
800045a4:	cb81                	beqz	a5,800045b4 <.L43>
        ptr->IDLE_CFG |= UART_IDLE_CFG_RXEN_MASK;
800045a6:	47b2                	lw	a5,12(sp)
800045a8:	43d8                	lw	a4,4(a5)
800045aa:	28b01793          	bseti	a5,zero,0xb
800045ae:	8f5d                	or	a4,a4,a5
800045b0:	47b2                	lw	a5,12(sp)
800045b2:	c3d8                	sw	a4,4(a5)

800045b4 <.L43>:
    }
#endif
    return status_success;
800045b4:	4781                	li	a5,0

800045b6 <.L44>:
}
800045b6:	853e                	mv	a0,a5
800045b8:	50b2                	lw	ra,44(sp)
800045ba:	6145                	addi	sp,sp,48
800045bc:	8082                	ret

Disassembly of section .text.uart_send_byte:

800045be <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
800045be:	1101                	addi	sp,sp,-32
800045c0:	c62a                	sw	a0,12(sp)
800045c2:	87ae                	mv	a5,a1
800045c4:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
800045c8:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
800045ca:	a811                	j	800045de <.L52>

800045cc <.L55>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
800045cc:	4772                	lw	a4,28(sp)
800045ce:	6785                	lui	a5,0x1
800045d0:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800045d4:	00e7eb63          	bltu	a5,a4,800045ea <.L58>
            break;
        }
        retry++;
800045d8:	47f2                	lw	a5,28(sp)
800045da:	0785                	addi	a5,a5,1
800045dc:	ce3e                	sw	a5,28(sp)

800045de <.L52>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
800045de:	47b2                	lw	a5,12(sp)
800045e0:	5bdc                	lw	a5,52(a5)
800045e2:	0207f793          	andi	a5,a5,32
800045e6:	d3fd                	beqz	a5,800045cc <.L55>
800045e8:	a011                	j	800045ec <.L54>

800045ea <.L58>:
            break;
800045ea:	0001                	nop

800045ec <.L54>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
800045ec:	4772                	lw	a4,28(sp)
800045ee:	6785                	lui	a5,0x1
800045f0:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800045f4:	00e7f463          	bgeu	a5,a4,800045fc <.L56>
        return status_timeout;
800045f8:	478d                	li	a5,3
800045fa:	a031                	j	80004606 <.L57>

800045fc <.L56>:
    }

    ptr->THR = UART_THR_THR_SET(c);
800045fc:	00b14703          	lbu	a4,11(sp)
80004600:	47b2                	lw	a5,12(sp)
80004602:	d398                	sw	a4,32(a5)
    return status_success;
80004604:	4781                	li	a5,0

80004606 <.L57>:
}
80004606:	853e                	mv	a0,a5
80004608:	6105                	addi	sp,sp,32
8000460a:	8082                	ret

Disassembly of section .text.uart_init_txline_idle_detection:

8000460c <uart_init_txline_idle_detection>:
}
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
hpm_stat_t uart_init_txline_idle_detection(UART_Type *ptr, uart_rxline_idle_config_t txidle_config)
{
8000460c:	1101                	addi	sp,sp,-32
8000460e:	ce06                	sw	ra,28(sp)
80004610:	c62a                	sw	a0,12(sp)
80004612:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_TX_IDLE_EN_MASK
80004614:	47b2                	lw	a5,12(sp)
80004616:	43d8                	lw	a4,4(a5)
80004618:	fc0107b7          	lui	a5,0xfc010
8000461c:	17fd                	addi	a5,a5,-1 # fc00ffff <__AHB_SRAM_segment_end__+0xbc07fff>
8000461e:	8f7d                	and	a4,a4,a5
80004620:	47b2                	lw	a5,12(sp)
80004622:	c3d8                	sw	a4,4(a5)
                    | UART_IDLE_CFG_TX_IDLE_THR_MASK
                    | UART_IDLE_CFG_TX_IDLE_COND_MASK);
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
80004624:	47b2                	lw	a5,12(sp)
80004626:	43d8                	lw	a4,4(a5)
80004628:	00814783          	lbu	a5,8(sp)
8000462c:	01879693          	slli	a3,a5,0x18
80004630:	010007b7          	lui	a5,0x1000
80004634:	8efd                	and	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_THR_SET(txidle_config.threshold)
80004636:	00b14783          	lbu	a5,11(sp)
8000463a:	01079613          	slli	a2,a5,0x10
8000463e:	00ff07b7          	lui	a5,0xff0
80004642:	8ff1                	and	a5,a5,a2
80004644:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_COND_SET(txidle_config.idle_cond);
80004646:	00a14783          	lbu	a5,10(sp)
8000464a:	01979613          	slli	a2,a5,0x19
8000464e:	020007b7          	lui	a5,0x2000
80004652:	8ff1                	and	a5,a5,a2
80004654:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
80004656:	8f5d                	or	a4,a4,a5
80004658:	47b2                	lw	a5,12(sp)
8000465a:	c3d8                	sw	a4,4(a5)

    if (txidle_config.detect_irq_enable) {
8000465c:	00914783          	lbu	a5,9(sp)
80004660:	c799                	beqz	a5,8000466e <.L97>
        uart_enable_irq(ptr, uart_intr_tx_line_idle);
80004662:	400005b7          	lui	a1,0x40000
80004666:	4532                	lw	a0,12(sp)
80004668:	7ff010ef          	jal	80006666 <uart_enable_irq>
8000466c:	a031                	j	80004678 <.L98>

8000466e <.L97>:
    } else {
        uart_disable_irq(ptr, uart_intr_tx_line_idle);
8000466e:	400005b7          	lui	a1,0x40000
80004672:	4532                	lw	a0,12(sp)
80004674:	7d7010ef          	jal	8000664a <uart_disable_irq>

80004678 <.L98>:
    }

    return status_success;
80004678:	4781                	li	a5,0
}
8000467a:	853e                	mv	a0,a5
8000467c:	40f2                	lw	ra,28(sp)
8000467e:	6105                	addi	sp,sp,32
80004680:	8082                	ret

Disassembly of section .text.pllctlv2_pll_is_stable:

80004682 <pllctlv2_pll_is_stable>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @return true if the PLL is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
80004682:	1101                	addi	sp,sp,-32
80004684:	c62a                	sw	a0,12(sp)
80004686:	87ae                	mv	a5,a1
80004688:	00f105a3          	sb	a5,11(sp)
    uint32_t status = ptr->PLL[pll].MFI;
8000468c:	00b14783          	lbu	a5,11(sp)
80004690:	4732                	lw	a4,12(sp)
80004692:	0785                	addi	a5,a5,1 # 2000001 <_flash_size+0x1f00001>
80004694:	079e                	slli	a5,a5,0x7
80004696:	97ba                	add	a5,a5,a4
80004698:	439c                	lw	a5,0(a5)
8000469a:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_ENABLE_MASK)
8000469c:	4772                	lw	a4,28(sp)
8000469e:	100007b7          	lui	a5,0x10000
800046a2:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_MFI_RESPONSE_MASK)));
800046a4:	cb89                	beqz	a5,800046b6 <.L2>
800046a6:	47f2                	lw	a5,28(sp)
800046a8:	0007c963          	bltz	a5,800046ba <.L3>
800046ac:	4772                	lw	a4,28(sp)
800046ae:	200007b7          	lui	a5,0x20000
800046b2:	8ff9                	and	a5,a5,a4
800046b4:	c399                	beqz	a5,800046ba <.L3>

800046b6 <.L2>:
800046b6:	4785                	li	a5,1
800046b8:	a011                	j	800046bc <.L4>

800046ba <.L3>:
800046ba:	4781                	li	a5,0

800046bc <.L4>:
800046bc:	8b85                	andi	a5,a5,1
800046be:	0ff7f793          	zext.b	a5,a5
}
800046c2:	853e                	mv	a0,a5
800046c4:	6105                	addi	sp,sp,32
800046c6:	8082                	ret

Disassembly of section .text.pllctlv2_init_pll_with_freq:

800046c8 <pllctlv2_init_pll_with_freq>:
    }
    return status;
}

hpm_stat_t pllctlv2_init_pll_with_freq(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, uint32_t freq_in_hz)
{
800046c8:	7179                	addi	sp,sp,-48
800046ca:	d606                	sw	ra,44(sp)
800046cc:	c62a                	sw	a0,12(sp)
800046ce:	87ae                	mv	a5,a1
800046d0:	c232                	sw	a2,4(sp)
800046d2:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status;
    if ((ptr == NULL) || (freq_in_hz < PLLCTLV2_PLL_FREQ_MIN) || (freq_in_hz > PLLCTLV2_PLL_FREQ_MAX) ||
800046d6:	47b2                	lw	a5,12(sp)
800046d8:	c395                	beqz	a5,800046fc <.L19>
800046da:	4712                	lw	a4,4(sp)
800046dc:	16e367b7          	lui	a5,0x16e36
800046e0:	00f76e63          	bltu	a4,a5,800046fc <.L19>
800046e4:	4712                	lw	a4,4(sp)
800046e6:	3d8317b7          	lui	a5,0x3d831
800046ea:	20078793          	addi	a5,a5,512 # 3d831200 <_flash_size+0x3d731200>
800046ee:	00e7e763          	bltu	a5,a4,800046fc <.L19>
800046f2:	00b14703          	lbu	a4,11(sp)
800046f6:	4785                	li	a5,1
800046f8:	00e7f563          	bgeu	a5,a4,80004702 <.L20>

800046fc <.L19>:
        (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
        status = status_invalid_argument;
800046fc:	4789                	li	a5,2
800046fe:	ce3e                	sw	a5,28(sp)
80004700:	a8bd                	j	8000477e <.L21>

80004702 <.L20>:
    } else {
        uint32_t mfn = freq_in_hz % PLLCTLV2_PLL_XTAL_FREQ;
80004702:	4792                	lw	a5,4(sp)
80004704:	165ea737          	lui	a4,0x165ea
80004708:	f8170713          	addi	a4,a4,-127 # 165e9f81 <_flash_size+0x164e9f81>
8000470c:	02e7b733          	mulhu	a4,a5,a4
80004710:	01575693          	srli	a3,a4,0x15
80004714:	016e3737          	lui	a4,0x16e3
80004718:	60070713          	addi	a4,a4,1536 # 16e3600 <_flash_size+0x15e3600>
8000471c:	02e68733          	mul	a4,a3,a4
80004720:	8f99                	sub	a5,a5,a4
80004722:	cc3e                	sw	a5,24(sp)
        uint32_t mfi = freq_in_hz / PLLCTLV2_PLL_XTAL_FREQ;
80004724:	4712                	lw	a4,4(sp)
80004726:	165ea7b7          	lui	a5,0x165ea
8000472a:	f8178793          	addi	a5,a5,-127 # 165e9f81 <_flash_size+0x164e9f81>
8000472e:	02f737b3          	mulhu	a5,a4,a5
80004732:	83d5                	srli	a5,a5,0x15
80004734:	ca3e                	sw	a5,20(sp)

        /*
         * NOTE: Default MFD value is 240M
         */
        ptr->PLL[pll].MFN = mfn * PLLCTLV2_PLL_MFN_FACTOR;
80004736:	00b14683          	lbu	a3,11(sp)
8000473a:	4762                	lw	a4,24(sp)
8000473c:	87ba                	mv	a5,a4
8000473e:	078a                	slli	a5,a5,0x2
80004740:	97ba                	add	a5,a5,a4
80004742:	0786                	slli	a5,a5,0x1
80004744:	863e                	mv	a2,a5
80004746:	4732                	lw	a4,12(sp)
80004748:	00168793          	addi	a5,a3,1
8000474c:	079e                	slli	a5,a5,0x7
8000474e:	97ba                	add	a5,a5,a4
80004750:	c3d0                	sw	a2,4(a5)
        ptr->PLL[pll].MFI = mfi;
80004752:	00b14783          	lbu	a5,11(sp)
80004756:	4732                	lw	a4,12(sp)
80004758:	0785                	addi	a5,a5,1
8000475a:	079e                	slli	a5,a5,0x7
8000475c:	97ba                	add	a5,a5,a4
8000475e:	4752                	lw	a4,20(sp)
80004760:	c398                	sw	a4,0(a5)


        while (!pllctlv2_pll_is_stable(ptr, pll)) {
80004762:	a011                	j	80004766 <.L22>

80004764 <.L23>:
            NOP();
80004764:	0001                	nop

80004766 <.L22>:
        while (!pllctlv2_pll_is_stable(ptr, pll)) {
80004766:	00b14783          	lbu	a5,11(sp)
8000476a:	85be                	mv	a1,a5
8000476c:	4532                	lw	a0,12(sp)
8000476e:	3f11                	jal	80004682 <pllctlv2_pll_is_stable>
80004770:	87aa                	mv	a5,a0
80004772:	0017c793          	xori	a5,a5,1
80004776:	0ff7f793          	zext.b	a5,a5
8000477a:	f7ed                	bnez	a5,80004764 <.L23>
        }

        status = status_success;
8000477c:	ce02                	sw	zero,28(sp)

8000477e <.L21>:
    }
    return status;
8000477e:	47f2                	lw	a5,28(sp)
}
80004780:	853e                	mv	a0,a5
80004782:	50b2                	lw	ra,44(sp)
80004784:	6145                	addi	sp,sp,48
80004786:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

80004788 <__SEGGER_RTL_xtoa>:
80004788:	882e                	mv	a6,a1
8000478a:	ca91                	beqz	a3,8000479e <__SEGGER_RTL_xtoa+0x16>
8000478c:	00180693          	addi	a3,a6,1
80004790:	02d00593          	li	a1,45
80004794:	00b80023          	sb	a1,0(a6)
80004798:	40a00533          	neg	a0,a0
8000479c:	a011                	j	800047a0 <__SEGGER_RTL_xtoa+0x18>
8000479e:	86c2                	mv	a3,a6
800047a0:	ffe68713          	addi	a4,a3,-2
800047a4:	48a5                	li	a7,9
800047a6:	85aa                	mv	a1,a0
800047a8:	02c55533          	divu	a0,a0,a2
800047ac:	02c507b3          	mul	a5,a0,a2
800047b0:	40f587b3          	sub	a5,a1,a5
800047b4:	00f8e563          	bltu	a7,a5,800047be <__SEGGER_RTL_xtoa+0x36>
800047b8:	03078793          	addi	a5,a5,48
800047bc:	a019                	j	800047c2 <__SEGGER_RTL_xtoa+0x3a>
800047be:	05778793          	addi	a5,a5,87
800047c2:	00f70123          	sb	a5,2(a4)
800047c6:	0705                	addi	a4,a4,1
800047c8:	fcc5ffe3          	bgeu	a1,a2,800047a6 <__SEGGER_RTL_xtoa+0x1e>
800047cc:	00070123          	sb	zero,2(a4)
800047d0:	0006c503          	lbu	a0,0(a3)
800047d4:	85ba                	mv	a1,a4
800047d6:	00174603          	lbu	a2,1(a4)
800047da:	00a700a3          	sb	a0,1(a4)
800047de:	00168513          	addi	a0,a3,1
800047e2:	00c68023          	sb	a2,0(a3)
800047e6:	177d                	addi	a4,a4,-1
800047e8:	86aa                	mv	a3,a0
800047ea:	feb563e3          	bltu	a0,a1,800047d0 <__SEGGER_RTL_xtoa+0x48>
800047ee:	8542                	mv	a0,a6
800047f0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

800047f2 <__SEGGER_RTL_X_assert>:
800047f2:	1101                	addi	sp,sp,-32
800047f4:	ce06                	sw	ra,28(sp)
800047f6:	cc22                	sw	s0,24(sp)
800047f8:	ca26                	sw	s1,20(sp)
800047fa:	86b2                	mv	a3,a2
800047fc:	842e                	mv	s0,a1
800047fe:	84aa                	mv	s1,a0
80004800:	004c                	addi	a1,sp,4
80004802:	4629                	li	a2,10
80004804:	8536                	mv	a0,a3
80004806:	428020ef          	jal	80006c2e <itoa>
8000480a:	8522                	mv	a0,s0
8000480c:	4ac020ef          	jal	80006cb8 <__SEGGER_RTL_puts_no_nl>
80004810:	80008537          	lui	a0,0x80008
80004814:	d4150513          	addi	a0,a0,-703 # 80007d41 <.L.str>
80004818:	4a0020ef          	jal	80006cb8 <__SEGGER_RTL_puts_no_nl>
8000481c:	0048                	addi	a0,sp,4
8000481e:	49a020ef          	jal	80006cb8 <__SEGGER_RTL_puts_no_nl>
80004822:	80008537          	lui	a0,0x80008
80004826:	d8350513          	addi	a0,a0,-637 # 80007d83 <.L.str.1>
8000482a:	48e020ef          	jal	80006cb8 <__SEGGER_RTL_puts_no_nl>
8000482e:	8526                	mv	a0,s1
80004830:	488020ef          	jal	80006cb8 <__SEGGER_RTL_puts_no_nl>
80004834:	80008537          	lui	a0,0x80008
80004838:	d4350513          	addi	a0,a0,-701 # 80007d43 <.L.str.2>
8000483c:	47c020ef          	jal	80006cb8 <__SEGGER_RTL_puts_no_nl>
80004840:	41a020ef          	jal	80006c5a <abort>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

80004844 <__SEGGER_RTL_SIGNAL_SIG_IGN>:
80004844:	8082                	ret

Disassembly of section .text.libc.__subsf3:

80004846 <__subsf3>:
80004846:	80000637          	lui	a2,0x80000
8000484a:	8db1                	xor	a1,a1,a2
8000484c:	a009                	j	8000484e <__addsf3>

Disassembly of section .text.libc.__addsf3:

8000484e <__addsf3>:
8000484e:	80000637          	lui	a2,0x80000
80004852:	00b546b3          	xor	a3,a0,a1
80004856:	0806ca63          	bltz	a3,800048ea <.L__addsf3_subtract>
8000485a:	00b57563          	bgeu	a0,a1,80004864 <.L__addsf3_add_already_ordered>
8000485e:	86aa                	mv	a3,a0
80004860:	852e                	mv	a0,a1
80004862:	85b6                	mv	a1,a3

80004864 <.L__addsf3_add_already_ordered>:
80004864:	00151713          	slli	a4,a0,0x1
80004868:	8361                	srli	a4,a4,0x18
8000486a:	00159693          	slli	a3,a1,0x1
8000486e:	82e1                	srli	a3,a3,0x18
80004870:	0ff00293          	li	t0,255
80004874:	06570563          	beq	a4,t0,800048de <.L__addsf3_add_inf_or_nan>
80004878:	c325                	beqz	a4,800048d8 <.L__addsf3_zero>
8000487a:	ceb1                	beqz	a3,800048d6 <.L__addsf3_add_done>
8000487c:	40d706b3          	sub	a3,a4,a3
80004880:	42e1                	li	t0,24
80004882:	04d2ca63          	blt	t0,a3,800048d6 <.L__addsf3_add_done>
80004886:	05a2                	slli	a1,a1,0x8
80004888:	8dd1                	or	a1,a1,a2
8000488a:	01755713          	srli	a4,a0,0x17
8000488e:	0522                	slli	a0,a0,0x8
80004890:	8d51                	or	a0,a0,a2
80004892:	47e5                	li	a5,25
80004894:	8f95                	sub	a5,a5,a3
80004896:	00f59633          	sll	a2,a1,a5
8000489a:	821d                	srli	a2,a2,0x7
8000489c:	00d5d5b3          	srl	a1,a1,a3
800048a0:	00b507b3          	add	a5,a0,a1
800048a4:	00a7f463          	bgeu	a5,a0,800048ac <.L__addsf3_add_no_normalization>
800048a8:	8385                	srli	a5,a5,0x1
800048aa:	0709                	addi	a4,a4,2

800048ac <.L__addsf3_add_no_normalization>:
800048ac:	177d                	addi	a4,a4,-1
800048ae:	0ff77593          	zext.b	a1,a4
800048b2:	f0158593          	addi	a1,a1,-255 # 3fffff01 <_flash_size+0x3fefff01>
800048b6:	cd91                	beqz	a1,800048d2 <.L__addsf3_inf>
800048b8:	075e                	slli	a4,a4,0x17
800048ba:	0087d513          	srli	a0,a5,0x8
800048be:	07e2                	slli	a5,a5,0x18
800048c0:	8fd1                	or	a5,a5,a2
800048c2:	0007d663          	bgez	a5,800048ce <.L__addsf3_no_tie>
800048c6:	0786                	slli	a5,a5,0x1
800048c8:	0505                	addi	a0,a0,1
800048ca:	e391                	bnez	a5,800048ce <.L__addsf3_no_tie>
800048cc:	9979                	andi	a0,a0,-2

800048ce <.L__addsf3_no_tie>:
800048ce:	953a                	add	a0,a0,a4
800048d0:	8082                	ret

800048d2 <.L__addsf3_inf>:
800048d2:	01771513          	slli	a0,a4,0x17

800048d6 <.L__addsf3_add_done>:
800048d6:	8082                	ret

800048d8 <.L__addsf3_zero>:
800048d8:	817d                	srli	a0,a0,0x1f
800048da:	057e                	slli	a0,a0,0x1f
800048dc:	8082                	ret

800048de <.L__addsf3_add_inf_or_nan>:
800048de:	00951613          	slli	a2,a0,0x9
800048e2:	da75                	beqz	a2,800048d6 <.L__addsf3_add_done>

800048e4 <.L__addsf3_return_nan>:
800048e4:	7fc00537          	lui	a0,0x7fc00
800048e8:	8082                	ret

800048ea <.L__addsf3_subtract>:
800048ea:	8db1                	xor	a1,a1,a2
800048ec:	40b506b3          	sub	a3,a0,a1
800048f0:	00b57563          	bgeu	a0,a1,800048fa <.L__addsf3_sub_already_ordered>
800048f4:	8eb1                	xor	a3,a3,a2
800048f6:	8d15                	sub	a0,a0,a3
800048f8:	95b6                	add	a1,a1,a3

800048fa <.L__addsf3_sub_already_ordered>:
800048fa:	00159693          	slli	a3,a1,0x1
800048fe:	82e1                	srli	a3,a3,0x18
80004900:	00151713          	slli	a4,a0,0x1
80004904:	8361                	srli	a4,a4,0x18
80004906:	05a2                	slli	a1,a1,0x8
80004908:	8dd1                	or	a1,a1,a2
8000490a:	0ff00293          	li	t0,255
8000490e:	0c570c63          	beq	a4,t0,800049e6 <.L__addsf3_sub_inf_or_nan>
80004912:	c2f5                	beqz	a3,800049f6 <.L__addsf3_sub_zero>
80004914:	40d706b3          	sub	a3,a4,a3
80004918:	c695                	beqz	a3,80004944 <.L__addsf3_exponents_equal>
8000491a:	4285                	li	t0,1
8000491c:	08569063          	bne	a3,t0,8000499c <.L__addsf3_exponents_differ_by_more_than_1>
80004920:	01755693          	srli	a3,a0,0x17
80004924:	0526                	slli	a0,a0,0x9
80004926:	00b532b3          	sltu	t0,a0,a1
8000492a:	8d0d                	sub	a0,a0,a1
8000492c:	02029263          	bnez	t0,80004950 <.L__addsf3_normalization_steps>
80004930:	06de                	slli	a3,a3,0x17
80004932:	01751593          	slli	a1,a0,0x17
80004936:	8125                	srli	a0,a0,0x9
80004938:	0005d463          	bgez	a1,80004940 <.L__addsf3_sub_no_tie_single>
8000493c:	0505                	addi	a0,a0,1 # 7fc00001 <_flash_size+0x7fb00001>
8000493e:	9979                	andi	a0,a0,-2

80004940 <.L__addsf3_sub_no_tie_single>:
80004940:	9536                	add	a0,a0,a3

80004942 <.L__addsf3_sub_done>:
80004942:	8082                	ret

80004944 <.L__addsf3_exponents_equal>:
80004944:	01755693          	srli	a3,a0,0x17
80004948:	0526                	slli	a0,a0,0x9
8000494a:	0586                	slli	a1,a1,0x1
8000494c:	8d0d                	sub	a0,a0,a1
8000494e:	d975                	beqz	a0,80004942 <.L__addsf3_sub_done>

80004950 <.L__addsf3_normalization_steps>:
80004950:	4581                	li	a1,0
80004952:	01055793          	srli	a5,a0,0x10
80004956:	e399                	bnez	a5,8000495c <.Ltmp0>
80004958:	0542                	slli	a0,a0,0x10
8000495a:	05c1                	addi	a1,a1,16

8000495c <.Ltmp0>:
8000495c:	01855793          	srli	a5,a0,0x18
80004960:	e399                	bnez	a5,80004966 <.Ltmp1>
80004962:	0522                	slli	a0,a0,0x8
80004964:	05a1                	addi	a1,a1,8

80004966 <.Ltmp1>:
80004966:	01c55793          	srli	a5,a0,0x1c
8000496a:	e399                	bnez	a5,80004970 <.Ltmp2>
8000496c:	0512                	slli	a0,a0,0x4
8000496e:	0591                	addi	a1,a1,4

80004970 <.Ltmp2>:
80004970:	01e55793          	srli	a5,a0,0x1e
80004974:	e399                	bnez	a5,8000497a <.Ltmp3>
80004976:	050a                	slli	a0,a0,0x2
80004978:	0589                	addi	a1,a1,2

8000497a <.Ltmp3>:
8000497a:	00054463          	bltz	a0,80004982 <.Ltmp4>
8000497e:	0506                	slli	a0,a0,0x1
80004980:	0585                	addi	a1,a1,1

80004982 <.Ltmp4>:
80004982:	0585                	addi	a1,a1,1
80004984:	0506                	slli	a0,a0,0x1
80004986:	00e5f763          	bgeu	a1,a4,80004994 <.L__addsf3_underflow>
8000498a:	8e8d                	sub	a3,a3,a1
8000498c:	06de                	slli	a3,a3,0x17
8000498e:	8125                	srli	a0,a0,0x9
80004990:	9536                	add	a0,a0,a3
80004992:	8082                	ret

80004994 <.L__addsf3_underflow>:
80004994:	0086d513          	srli	a0,a3,0x8
80004998:	057e                	slli	a0,a0,0x1f
8000499a:	8082                	ret

8000499c <.L__addsf3_exponents_differ_by_more_than_1>:
8000499c:	42e5                	li	t0,25
8000499e:	fad2e2e3          	bltu	t0,a3,80004942 <.L__addsf3_sub_done>
800049a2:	0685                	addi	a3,a3,1
800049a4:	40d00733          	neg	a4,a3
800049a8:	00e59733          	sll	a4,a1,a4
800049ac:	00d5d5b3          	srl	a1,a1,a3
800049b0:	00e03733          	snez	a4,a4
800049b4:	95ae                	add	a1,a1,a1
800049b6:	95ba                	add	a1,a1,a4
800049b8:	01755693          	srli	a3,a0,0x17
800049bc:	0522                	slli	a0,a0,0x8
800049be:	8d51                	or	a0,a0,a2
800049c0:	40b50733          	sub	a4,a0,a1
800049c4:	00074463          	bltz	a4,800049cc <.L__addsf3_sub_already_normalized>
800049c8:	070a                	slli	a4,a4,0x2
800049ca:	8305                	srli	a4,a4,0x1

800049cc <.L__addsf3_sub_already_normalized>:
800049cc:	16fd                	addi	a3,a3,-1
800049ce:	06de                	slli	a3,a3,0x17
800049d0:	00875513          	srli	a0,a4,0x8
800049d4:	0762                	slli	a4,a4,0x18
800049d6:	00075663          	bgez	a4,800049e2 <.L__addsf3_sub_no_tie>
800049da:	0706                	slli	a4,a4,0x1
800049dc:	0505                	addi	a0,a0,1
800049de:	e311                	bnez	a4,800049e2 <.L__addsf3_sub_no_tie>
800049e0:	9979                	andi	a0,a0,-2

800049e2 <.L__addsf3_sub_no_tie>:
800049e2:	9536                	add	a0,a0,a3
800049e4:	8082                	ret

800049e6 <.L__addsf3_sub_inf_or_nan>:
800049e6:	0ff00293          	li	t0,255
800049ea:	ee568de3          	beq	a3,t0,800048e4 <.L__addsf3_return_nan>
800049ee:	00951593          	slli	a1,a0,0x9
800049f2:	d9a1                	beqz	a1,80004942 <.L__addsf3_sub_done>
800049f4:	bdc5                	j	800048e4 <.L__addsf3_return_nan>

800049f6 <.L__addsf3_sub_zero>:
800049f6:	f731                	bnez	a4,80004942 <.L__addsf3_sub_done>
800049f8:	4501                	li	a0,0
800049fa:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

800049fc <__ltsf2>:
800049fc:	ff000637          	lui	a2,0xff000
80004a00:	00151693          	slli	a3,a0,0x1
80004a04:	02d66763          	bltu	a2,a3,80004a32 <.L__ltsf2_zero>
80004a08:	00159693          	slli	a3,a1,0x1
80004a0c:	02d66363          	bltu	a2,a3,80004a32 <.L__ltsf2_zero>
80004a10:	00b56633          	or	a2,a0,a1
80004a14:	00161693          	slli	a3,a2,0x1
80004a18:	ce89                	beqz	a3,80004a32 <.L__ltsf2_zero>
80004a1a:	00064763          	bltz	a2,80004a28 <.L__ltsf2_negative>
80004a1e:	00b53533          	sltu	a0,a0,a1
80004a22:	40a00533          	neg	a0,a0
80004a26:	8082                	ret

80004a28 <.L__ltsf2_negative>:
80004a28:	00a5b533          	sltu	a0,a1,a0
80004a2c:	40a00533          	neg	a0,a0
80004a30:	8082                	ret

80004a32 <.L__ltsf2_zero>:
80004a32:	4501                	li	a0,0
80004a34:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

80004a36 <__gtsf2>:
80004a36:	ff000637          	lui	a2,0xff000
80004a3a:	00151693          	slli	a3,a0,0x1
80004a3e:	02d66363          	bltu	a2,a3,80004a64 <.L__gtsf2_zero>
80004a42:	00159693          	slli	a3,a1,0x1
80004a46:	00d66f63          	bltu	a2,a3,80004a64 <.L__gtsf2_zero>
80004a4a:	00b56633          	or	a2,a0,a1
80004a4e:	00161693          	slli	a3,a2,0x1
80004a52:	ca89                	beqz	a3,80004a64 <.L__gtsf2_zero>
80004a54:	00064563          	bltz	a2,80004a5e <.L__gtsf2_negative>
80004a58:	00a5b533          	sltu	a0,a1,a0
80004a5c:	8082                	ret

80004a5e <.L__gtsf2_negative>:
80004a5e:	00b53533          	sltu	a0,a0,a1
80004a62:	8082                	ret

80004a64 <.L__gtsf2_zero>:
80004a64:	4501                	li	a0,0
80004a66:	8082                	ret

Disassembly of section .text.libc.__gesf2:

80004a68 <__gesf2>:
80004a68:	ff000637          	lui	a2,0xff000
80004a6c:	00151693          	slli	a3,a0,0x1
80004a70:	02d66763          	bltu	a2,a3,80004a9e <.L__gesf2_nan>
80004a74:	00159693          	slli	a3,a1,0x1
80004a78:	02d66363          	bltu	a2,a3,80004a9e <.L__gesf2_nan>
80004a7c:	00b56633          	or	a2,a0,a1
80004a80:	00161693          	slli	a3,a2,0x1
80004a84:	ce99                	beqz	a3,80004aa2 <.L__gesf2_zero>
80004a86:	00064763          	bltz	a2,80004a94 <.L__gesf2_negative>
80004a8a:	00b53533          	sltu	a0,a0,a1
80004a8e:	40a00533          	neg	a0,a0
80004a92:	8082                	ret

80004a94 <.L__gesf2_negative>:
80004a94:	00a5b533          	sltu	a0,a1,a0
80004a98:	40a00533          	neg	a0,a0
80004a9c:	8082                	ret

80004a9e <.L__gesf2_nan>:
80004a9e:	557d                	li	a0,-1
80004aa0:	8082                	ret

80004aa2 <.L__gesf2_zero>:
80004aa2:	4501                	li	a0,0
80004aa4:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

80004aa6 <__floatundisf>:
80004aa6:	c5bd                	beqz	a1,80004b14 <.L__floatundisf_high_word_zero>
80004aa8:	4701                	li	a4,0
80004aaa:	0105d693          	srli	a3,a1,0x10
80004aae:	e299                	bnez	a3,80004ab4 <.Ltmp45>
80004ab0:	0741                	addi	a4,a4,16
80004ab2:	05c2                	slli	a1,a1,0x10

80004ab4 <.Ltmp45>:
80004ab4:	0185d693          	srli	a3,a1,0x18
80004ab8:	e299                	bnez	a3,80004abe <.Ltmp46>
80004aba:	0721                	addi	a4,a4,8
80004abc:	05a2                	slli	a1,a1,0x8

80004abe <.Ltmp46>:
80004abe:	01c5d693          	srli	a3,a1,0x1c
80004ac2:	e299                	bnez	a3,80004ac8 <.Ltmp47>
80004ac4:	0711                	addi	a4,a4,4
80004ac6:	0592                	slli	a1,a1,0x4

80004ac8 <.Ltmp47>:
80004ac8:	01e5d693          	srli	a3,a1,0x1e
80004acc:	e299                	bnez	a3,80004ad2 <.Ltmp48>
80004ace:	0709                	addi	a4,a4,2
80004ad0:	058a                	slli	a1,a1,0x2

80004ad2 <.Ltmp48>:
80004ad2:	0005c463          	bltz	a1,80004ada <.Ltmp49>
80004ad6:	0705                	addi	a4,a4,1
80004ad8:	0586                	slli	a1,a1,0x1

80004ada <.Ltmp49>:
80004ada:	fff74613          	not	a2,a4
80004ade:	00c556b3          	srl	a3,a0,a2
80004ae2:	8285                	srli	a3,a3,0x1
80004ae4:	8dd5                	or	a1,a1,a3
80004ae6:	00e51533          	sll	a0,a0,a4
80004aea:	0be60613          	addi	a2,a2,190 # ff0000be <__AHB_SRAM_segment_end__+0xebf80be>
80004aee:	00a03533          	snez	a0,a0
80004af2:	8dc9                	or	a1,a1,a0

80004af4 <.L__floatundisf_round_and_pack>:
80004af4:	065e                	slli	a2,a2,0x17
80004af6:	0085d513          	srli	a0,a1,0x8
80004afa:	05de                	slli	a1,a1,0x17
80004afc:	0005a333          	sltz	t1,a1
80004b00:	95ae                	add	a1,a1,a1
80004b02:	959a                	add	a1,a1,t1
80004b04:	0005d663          	bgez	a1,80004b10 <.L__floatundisf_round_down>
80004b08:	95ae                	add	a1,a1,a1
80004b0a:	00b035b3          	snez	a1,a1
80004b0e:	952e                	add	a0,a0,a1

80004b10 <.L__floatundisf_round_down>:
80004b10:	9532                	add	a0,a0,a2

80004b12 <.L__floatundisf_done>:
80004b12:	8082                	ret

80004b14 <.L__floatundisf_high_word_zero>:
80004b14:	dd7d                	beqz	a0,80004b12 <.L__floatundisf_done>
80004b16:	09d00613          	li	a2,157
80004b1a:	01055693          	srli	a3,a0,0x10
80004b1e:	e299                	bnez	a3,80004b24 <.Ltmp50>
80004b20:	0542                	slli	a0,a0,0x10
80004b22:	1641                	addi	a2,a2,-16

80004b24 <.Ltmp50>:
80004b24:	01855693          	srli	a3,a0,0x18
80004b28:	e299                	bnez	a3,80004b2e <.Ltmp51>
80004b2a:	0522                	slli	a0,a0,0x8
80004b2c:	1661                	addi	a2,a2,-8

80004b2e <.Ltmp51>:
80004b2e:	01c55693          	srli	a3,a0,0x1c
80004b32:	e299                	bnez	a3,80004b38 <.Ltmp52>
80004b34:	0512                	slli	a0,a0,0x4
80004b36:	1671                	addi	a2,a2,-4

80004b38 <.Ltmp52>:
80004b38:	01e55693          	srli	a3,a0,0x1e
80004b3c:	e299                	bnez	a3,80004b42 <.Ltmp53>
80004b3e:	050a                	slli	a0,a0,0x2
80004b40:	1679                	addi	a2,a2,-2

80004b42 <.Ltmp53>:
80004b42:	00054463          	bltz	a0,80004b4a <.Ltmp54>
80004b46:	0506                	slli	a0,a0,0x1
80004b48:	167d                	addi	a2,a2,-1

80004b4a <.Ltmp54>:
80004b4a:	85aa                	mv	a1,a0
80004b4c:	4501                	li	a0,0
80004b4e:	b75d                	j	80004af4 <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

80004b50 <__truncdfsf2>:
80004b50:	00159693          	slli	a3,a1,0x1
80004b54:	82d5                	srli	a3,a3,0x15
80004b56:	7ff00613          	li	a2,2047
80004b5a:	04c68663          	beq	a3,a2,80004ba6 <.L__truncdfsf2_inf_nan>
80004b5e:	c8068693          	addi	a3,a3,-896
80004b62:	02d05e63          	blez	a3,80004b9e <.L__truncdfsf2_underflow>
80004b66:	0ff00613          	li	a2,255
80004b6a:	04c6f263          	bgeu	a3,a2,80004bae <.L__truncdfsf2_inf>
80004b6e:	06de                	slli	a3,a3,0x17
80004b70:	01f5d613          	srli	a2,a1,0x1f
80004b74:	067e                	slli	a2,a2,0x1f
80004b76:	8ed1                	or	a3,a3,a2
80004b78:	05b2                	slli	a1,a1,0xc
80004b7a:	01455613          	srli	a2,a0,0x14
80004b7e:	8dd1                	or	a1,a1,a2
80004b80:	81a5                	srli	a1,a1,0x9
80004b82:	00251613          	slli	a2,a0,0x2
80004b86:	00062733          	sltz	a4,a2
80004b8a:	9632                	add	a2,a2,a2
80004b8c:	000627b3          	sltz	a5,a2
80004b90:	9632                	add	a2,a2,a2
80004b92:	963a                	add	a2,a2,a4
80004b94:	c211                	beqz	a2,80004b98 <.L__truncdfsf2_no_round_tie>
80004b96:	95be                	add	a1,a1,a5

80004b98 <.L__truncdfsf2_no_round_tie>:
80004b98:	00d58533          	add	a0,a1,a3
80004b9c:	8082                	ret

80004b9e <.L__truncdfsf2_underflow>:
80004b9e:	01f5d513          	srli	a0,a1,0x1f
80004ba2:	057e                	slli	a0,a0,0x1f
80004ba4:	8082                	ret

80004ba6 <.L__truncdfsf2_inf_nan>:
80004ba6:	00c59693          	slli	a3,a1,0xc
80004baa:	8ec9                	or	a3,a3,a0
80004bac:	ea81                	bnez	a3,80004bbc <.L__truncdfsf2_nan>

80004bae <.L__truncdfsf2_inf>:
80004bae:	81fd                	srli	a1,a1,0x1f
80004bb0:	05fe                	slli	a1,a1,0x1f
80004bb2:	7f800537          	lui	a0,0x7f800
80004bb6:	8d4d                	or	a0,a0,a1
80004bb8:	4581                	li	a1,0
80004bba:	8082                	ret

80004bbc <.L__truncdfsf2_nan>:
80004bbc:	800006b7          	lui	a3,0x80000
80004bc0:	00d5f633          	and	a2,a1,a3
80004bc4:	058e                	slli	a1,a1,0x3
80004bc6:	8175                	srli	a0,a0,0x1d
80004bc8:	8d4d                	or	a0,a0,a1
80004bca:	0506                	slli	a0,a0,0x1
80004bcc:	8105                	srli	a0,a0,0x1
80004bce:	8d51                	or	a0,a0,a2
80004bd0:	82a5                	srli	a3,a3,0x9
80004bd2:	8d55                	or	a0,a0,a3
80004bd4:	8082                	ret

Disassembly of section .text.libc.frexpf:

80004bd6 <frexpf>:
80004bd6:	01755613          	srli	a2,a0,0x17
80004bda:	0ff67613          	zext.b	a2,a2
80004bde:	0ff00693          	li	a3,255
80004be2:	00d60363          	beq	a2,a3,80004be8 <frexpf+0x12>
80004be6:	e601                	bnez	a2,80004bee <frexpf+0x18>
80004be8:	0005a023          	sw	zero,0(a1)
80004bec:	8082                	ret
80004bee:	f8260613          	addi	a2,a2,-126
80004bf2:	c190                	sw	a2,0(a1)
80004bf4:	808005b7          	lui	a1,0x80800
80004bf8:	15fd                	addi	a1,a1,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
80004bfa:	8d6d                	and	a0,a0,a1
80004bfc:	3f0005b7          	lui	a1,0x3f000
80004c00:	8d4d                	or	a0,a0,a1
80004c02:	8082                	ret

Disassembly of section .text.libc.abs:

80004c04 <abs>:
80004c04:	41f55593          	srai	a1,a0,0x1f
80004c08:	8d2d                	xor	a0,a0,a1
80004c0a:	8d0d                	sub	a0,a0,a1
80004c0c:	8082                	ret

Disassembly of section .text.libc.memcpy:

80004c0e <memcpy>:
80004c0e:	c251                	beqz	a2,80004c92 <.Lmemcpy_done>
80004c10:	87aa                	mv	a5,a0
80004c12:	00b546b3          	xor	a3,a0,a1
80004c16:	06fa                	slli	a3,a3,0x1e
80004c18:	e2bd                	bnez	a3,80004c7e <.Lmemcpy_byte_copy>
80004c1a:	01e51693          	slli	a3,a0,0x1e
80004c1e:	ce81                	beqz	a3,80004c36 <.Lmemcpy_aligned>

80004c20 <.Lmemcpy_word_align>:
80004c20:	00058683          	lb	a3,0(a1) # 3f000000 <_flash_size+0x3ef00000>
80004c24:	00d50023          	sb	a3,0(a0) # 7f800000 <_flash_size+0x7f700000>
80004c28:	0585                	addi	a1,a1,1
80004c2a:	0505                	addi	a0,a0,1
80004c2c:	167d                	addi	a2,a2,-1
80004c2e:	c22d                	beqz	a2,80004c90 <.Lmemcpy_memcpy_end>
80004c30:	01e51693          	slli	a3,a0,0x1e
80004c34:	f6f5                	bnez	a3,80004c20 <.Lmemcpy_word_align>

80004c36 <.Lmemcpy_aligned>:
80004c36:	02000693          	li	a3,32
80004c3a:	02d66763          	bltu	a2,a3,80004c68 <.Lmemcpy_word_copy>

80004c3e <.Lmemcpy_aligned_block_copy_loop>:
80004c3e:	4198                	lw	a4,0(a1)
80004c40:	c118                	sw	a4,0(a0)
80004c42:	41d8                	lw	a4,4(a1)
80004c44:	c158                	sw	a4,4(a0)
80004c46:	4598                	lw	a4,8(a1)
80004c48:	c518                	sw	a4,8(a0)
80004c4a:	45d8                	lw	a4,12(a1)
80004c4c:	c558                	sw	a4,12(a0)
80004c4e:	4998                	lw	a4,16(a1)
80004c50:	c918                	sw	a4,16(a0)
80004c52:	49d8                	lw	a4,20(a1)
80004c54:	c958                	sw	a4,20(a0)
80004c56:	4d98                	lw	a4,24(a1)
80004c58:	cd18                	sw	a4,24(a0)
80004c5a:	4dd8                	lw	a4,28(a1)
80004c5c:	cd58                	sw	a4,28(a0)
80004c5e:	9536                	add	a0,a0,a3
80004c60:	95b6                	add	a1,a1,a3
80004c62:	8e15                	sub	a2,a2,a3
80004c64:	fcd67de3          	bgeu	a2,a3,80004c3e <.Lmemcpy_aligned_block_copy_loop>

80004c68 <.Lmemcpy_word_copy>:
80004c68:	c605                	beqz	a2,80004c90 <.Lmemcpy_memcpy_end>
80004c6a:	4691                	li	a3,4
80004c6c:	00d66963          	bltu	a2,a3,80004c7e <.Lmemcpy_byte_copy>

80004c70 <.Lmemcpy_word_copy_loop>:
80004c70:	4198                	lw	a4,0(a1)
80004c72:	c118                	sw	a4,0(a0)
80004c74:	9536                	add	a0,a0,a3
80004c76:	95b6                	add	a1,a1,a3
80004c78:	8e15                	sub	a2,a2,a3
80004c7a:	fed67be3          	bgeu	a2,a3,80004c70 <.Lmemcpy_word_copy_loop>

80004c7e <.Lmemcpy_byte_copy>:
80004c7e:	ca09                	beqz	a2,80004c90 <.Lmemcpy_memcpy_end>

80004c80 <.Lmemcpy_byte_copy_loop>:
80004c80:	00058703          	lb	a4,0(a1)
80004c84:	00e50023          	sb	a4,0(a0)
80004c88:	0585                	addi	a1,a1,1
80004c8a:	0505                	addi	a0,a0,1
80004c8c:	167d                	addi	a2,a2,-1
80004c8e:	fa6d                	bnez	a2,80004c80 <.Lmemcpy_byte_copy_loop>

80004c90 <.Lmemcpy_memcpy_end>:
80004c90:	853e                	mv	a0,a5

80004c92 <.Lmemcpy_done>:
80004c92:	8082                	ret

Disassembly of section .text.libc.strnlen:

80004c94 <strnlen>:
80004c94:	cda9                	beqz	a1,80004cee <strnlen+0x5a>
80004c96:	00054603          	lbu	a2,0(a0)
80004c9a:	ca31                	beqz	a2,80004cee <strnlen+0x5a>
80004c9c:	ffc57713          	andi	a4,a0,-4
80004ca0:	00357613          	andi	a2,a0,3
80004ca4:	00351693          	slli	a3,a0,0x3
80004ca8:	95b2                	add	a1,a1,a2
80004caa:	4310                	lw	a2,0(a4)
80004cac:	57fd                	li	a5,-1
80004cae:	00d796b3          	sll	a3,a5,a3
80004cb2:	fff6c693          	not	a3,a3
80004cb6:	4791                	li	a5,4
80004cb8:	8ed1                	or	a3,a3,a2
80004cba:	02f5ed63          	bltu	a1,a5,80004cf4 <strnlen+0x60>
80004cbe:	01010637          	lui	a2,0x1010
80004cc2:	808087b7          	lui	a5,0x80808
80004cc6:	10060893          	addi	a7,a2,256 # 1010100 <_flash_size+0xf10100>
80004cca:	08078793          	addi	a5,a5,128 # 80808080 <__FLASH_segment_end__+0x708080>
80004cce:	480d                	li	a6,3
80004cd0:	863a                	mv	a2,a4
80004cd2:	40d88733          	sub	a4,a7,a3
80004cd6:	8f55                	or	a4,a4,a3
80004cd8:	8f7d                	and	a4,a4,a5
80004cda:	00f71c63          	bne	a4,a5,80004cf2 <strnlen+0x5e>
80004cde:	4254                	lw	a3,4(a2)
80004ce0:	00460713          	addi	a4,a2,4
80004ce4:	15f1                	addi	a1,a1,-4
80004ce6:	863a                	mv	a2,a4
80004ce8:	feb865e3          	bltu	a6,a1,80004cd2 <strnlen+0x3e>
80004cec:	a021                	j	80004cf4 <strnlen+0x60>
80004cee:	4501                	li	a0,0
80004cf0:	8082                	ret
80004cf2:	8732                	mv	a4,a2
80004cf4:	0ff6f613          	zext.b	a2,a3
80004cf8:	c215                	beqz	a2,80004d1c <strnlen+0x88>
80004cfa:	6641                	lui	a2,0x10
80004cfc:	f0060613          	addi	a2,a2,-256 # ff00 <__AHB_SRAM_segment_size__+0x7f00>
80004d00:	8e75                	and	a2,a2,a3
80004d02:	ce01                	beqz	a2,80004d1a <strnlen+0x86>
80004d04:	00ff0637          	lui	a2,0xff0
80004d08:	8e75                	and	a2,a2,a3
80004d0a:	c205                	beqz	a2,80004d2a <strnlen+0x96>
80004d0c:	82e1                	srli	a3,a3,0x18
80004d0e:	00d03633          	snez	a2,a3
80004d12:	060d                	addi	a2,a2,3 # ff0003 <_flash_size+0xef0003>
80004d14:	00b67663          	bgeu	a2,a1,80004d20 <strnlen+0x8c>
80004d18:	a029                	j	80004d22 <strnlen+0x8e>
80004d1a:	4605                	li	a2,1
80004d1c:	00b66363          	bltu	a2,a1,80004d22 <strnlen+0x8e>
80004d20:	862e                	mv	a2,a1
80004d22:	40a70533          	sub	a0,a4,a0
80004d26:	9532                	add	a0,a0,a2
80004d28:	8082                	ret
80004d2a:	4609                	li	a2,2
80004d2c:	feb67ae3          	bgeu	a2,a1,80004d20 <strnlen+0x8c>
80004d30:	bfcd                	j	80004d22 <strnlen+0x8e>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

80004d32 <__SEGGER_RTL_putc>:
80004d32:	1141                	addi	sp,sp,-16
80004d34:	c606                	sw	ra,12(sp)
80004d36:	c422                	sw	s0,8(sp)
80004d38:	842a                	mv	s0,a0
80004d3a:	4908                	lw	a0,16(a0)
80004d3c:	00b103a3          	sb	a1,7(sp)
80004d40:	c11d                	beqz	a0,80004d66 <__SEGGER_RTL_putc+0x34>
80004d42:	4010                	lw	a2,0(s0)
80004d44:	4054                	lw	a3,4(s0)
80004d46:	06d67f63          	bgeu	a2,a3,80004dc4 <__SEGGER_RTL_putc+0x92>
80004d4a:	4850                	lw	a2,20(s0)
80004d4c:	00160693          	addi	a3,a2,1
80004d50:	9532                	add	a0,a0,a2
80004d52:	c854                	sw	a3,20(s0)
80004d54:	00b50023          	sb	a1,0(a0)
80004d58:	4848                	lw	a0,20(s0)
80004d5a:	4c0c                	lw	a1,24(s0)
80004d5c:	06b51463          	bne	a0,a1,80004dc4 <__SEGGER_RTL_putc+0x92>
80004d60:	8522                	mv	a0,s0
80004d62:	2885                	jal	80004dd2 <__SEGGER_RTL_prin_flush>
80004d64:	a085                	j	80004dc4 <__SEGGER_RTL_putc+0x92>
80004d66:	4448                	lw	a0,12(s0)
80004d68:	c105                	beqz	a0,80004d88 <__SEGGER_RTL_putc+0x56>
80004d6a:	4010                	lw	a2,0(s0)
80004d6c:	4054                	lw	a3,4(s0)
80004d6e:	04d67b63          	bgeu	a2,a3,80004dc4 <__SEGGER_RTL_putc+0x92>
80004d72:	00160713          	addi	a4,a2,1
80004d76:	8eb9                	xor	a3,a3,a4
80004d78:	0016b693          	seqz	a3,a3
80004d7c:	16fd                	addi	a3,a3,-1 # 7fffffff <_flash_size+0x7fefffff>
80004d7e:	8df5                	and	a1,a1,a3
80004d80:	9532                	add	a0,a0,a2
80004d82:	00b50023          	sb	a1,0(a0)
80004d86:	a83d                	j	80004dc4 <__SEGGER_RTL_putc+0x92>
80004d88:	4408                	lw	a0,8(s0)
80004d8a:	c115                	beqz	a0,80004dae <__SEGGER_RTL_putc+0x7c>
80004d8c:	4010                	lw	a2,0(s0)
80004d8e:	4054                	lw	a3,4(s0)
80004d90:	02d67a63          	bgeu	a2,a3,80004dc4 <__SEGGER_RTL_putc+0x92>
80004d94:	00160713          	addi	a4,a2,1
80004d98:	060a                	slli	a2,a2,0x2
80004d9a:	8eb9                	xor	a3,a3,a4
80004d9c:	0016b693          	seqz	a3,a3
80004da0:	16fd                	addi	a3,a3,-1
80004da2:	8df5                	and	a1,a1,a3
80004da4:	0ff5f593          	zext.b	a1,a1
80004da8:	9532                	add	a0,a0,a2
80004daa:	c10c                	sw	a1,0(a0)
80004dac:	a821                	j	80004dc4 <__SEGGER_RTL_putc+0x92>
80004dae:	5014                	lw	a3,32(s0)
80004db0:	ca91                	beqz	a3,80004dc4 <__SEGGER_RTL_putc+0x92>
80004db2:	4008                	lw	a0,0(s0)
80004db4:	404c                	lw	a1,4(s0)
80004db6:	00b57763          	bgeu	a0,a1,80004dc4 <__SEGGER_RTL_putc+0x92>
80004dba:	00710593          	addi	a1,sp,7
80004dbe:	4605                	li	a2,1
80004dc0:	8522                	mv	a0,s0
80004dc2:	9682                	jalr	a3
80004dc4:	4008                	lw	a0,0(s0)
80004dc6:	0505                	addi	a0,a0,1
80004dc8:	c008                	sw	a0,0(s0)
80004dca:	40b2                	lw	ra,12(sp)
80004dcc:	4422                	lw	s0,8(sp)
80004dce:	0141                	addi	sp,sp,16
80004dd0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

80004dd2 <__SEGGER_RTL_prin_flush>:
80004dd2:	4950                	lw	a2,20(a0)
80004dd4:	ce19                	beqz	a2,80004df2 <__SEGGER_RTL_prin_flush+0x20>
80004dd6:	1141                	addi	sp,sp,-16
80004dd8:	c606                	sw	ra,12(sp)
80004dda:	c422                	sw	s0,8(sp)
80004ddc:	842a                	mv	s0,a0
80004dde:	5114                	lw	a3,32(a0)
80004de0:	c681                	beqz	a3,80004de8 <__SEGGER_RTL_prin_flush+0x16>
80004de2:	480c                	lw	a1,16(s0)
80004de4:	8522                	mv	a0,s0
80004de6:	9682                	jalr	a3
80004de8:	00042a23          	sw	zero,20(s0)
80004dec:	40b2                	lw	ra,12(sp)
80004dee:	4422                	lw	s0,8(sp)
80004df0:	0141                	addi	sp,sp,16
80004df2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

80004df4 <__SEGGER_RTL_print_padding>:
80004df4:	02c05963          	blez	a2,80004e26 <__SEGGER_RTL_print_padding+0x32>
80004df8:	1101                	addi	sp,sp,-32
80004dfa:	ce06                	sw	ra,28(sp)
80004dfc:	cc22                	sw	s0,24(sp)
80004dfe:	ca26                	sw	s1,20(sp)
80004e00:	c84a                	sw	s2,16(sp)
80004e02:	c64e                	sw	s3,12(sp)
80004e04:	892e                	mv	s2,a1
80004e06:	84aa                	mv	s1,a0
80004e08:	00160413          	addi	s0,a2,1
80004e0c:	4985                	li	s3,1
80004e0e:	8526                	mv	a0,s1
80004e10:	85ca                	mv	a1,s2
80004e12:	3705                	jal	80004d32 <__SEGGER_RTL_putc>
80004e14:	147d                	addi	s0,s0,-1
80004e16:	fe89ece3          	bltu	s3,s0,80004e0e <__SEGGER_RTL_print_padding+0x1a>
80004e1a:	40f2                	lw	ra,28(sp)
80004e1c:	4462                	lw	s0,24(sp)
80004e1e:	44d2                	lw	s1,20(sp)
80004e20:	4942                	lw	s2,16(sp)
80004e22:	49b2                	lw	s3,12(sp)
80004e24:	6105                	addi	sp,sp,32
80004e26:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

80004e28 <__SEGGER_RTL_pre_padding>:
80004e28:	0105f693          	andi	a3,a1,16
80004e2c:	e699                	bnez	a3,80004e3a <__SEGGER_RTL_pre_padding+0x12>
80004e2e:	2005f593          	andi	a1,a1,512
80004e32:	c589                	beqz	a1,80004e3c <__SEGGER_RTL_pre_padding+0x14>
80004e34:	03000593          	li	a1,48
80004e38:	bf75                	j	80004df4 <__SEGGER_RTL_print_padding>
80004e3a:	8082                	ret
80004e3c:	02000593          	li	a1,32
80004e40:	bf55                	j	80004df4 <__SEGGER_RTL_print_padding>

Disassembly of section .text.libc.vfprintf:

80004e42 <vfprintf>:
80004e42:	1141                	addi	sp,sp,-16
80004e44:	c606                	sw	ra,12(sp)
80004e46:	c422                	sw	s0,8(sp)
80004e48:	c226                	sw	s1,4(sp)
80004e4a:	c04a                	sw	s2,0(sp)
80004e4c:	8932                	mv	s2,a2
80004e4e:	84ae                	mv	s1,a1
80004e50:	842a                	mv	s0,a0
80004e52:	5d7020ef          	jal	80007c28 <__SEGGER_RTL_current_locale>
80004e56:	85aa                	mv	a1,a0
80004e58:	8522                	mv	a0,s0
80004e5a:	8626                	mv	a2,s1
80004e5c:	86ca                	mv	a3,s2
80004e5e:	40b2                	lw	ra,12(sp)
80004e60:	4422                	lw	s0,8(sp)
80004e62:	4492                	lw	s1,4(sp)
80004e64:	4902                	lw	s2,0(sp)
80004e66:	0141                	addi	sp,sp,16
80004e68:	a009                	j	80004e6a <vfprintf_l>

Disassembly of section .text.libc.vfprintf_l:

80004e6a <vfprintf_l>:
80004e6a:	579012ef          	jal	t0,80006be2 <__riscv_save_10>
80004e6e:	7179                	addi	sp,sp,-48
80004e70:	1080                	addi	s0,sp,96
80004e72:	8936                	mv	s2,a3
80004e74:	89b2                	mv	s3,a2
80004e76:	8a2e                	mv	s4,a1
80004e78:	8aaa                	mv	s5,a0
80004e7a:	555010ef          	jal	80006bce <__SEGGER_RTL_X_file_bufsize>
80004e7e:	8baa                	mv	s7,a0
80004e80:	8b0a                	mv	s6,sp
80004e82:	053d                	addi	a0,a0,15
80004e84:	9941                	andi	a0,a0,-16
80004e86:	40a104b3          	sub	s1,sp,a0
80004e8a:	8126                	mv	sp,s1
80004e8c:	fa840513          	addi	a0,s0,-88
80004e90:	02400613          	li	a2,36
80004e94:	4581                	li	a1,0
80004e96:	467020ef          	jal	80007afc <memset>
80004e9a:	80000537          	lui	a0,0x80000
80004e9e:	800055b7          	lui	a1,0x80005
80004ea2:	ed658593          	addi	a1,a1,-298 # 80004ed6 <__SEGGER_RTL_stream_write>
80004ea6:	157d                	addi	a0,a0,-1 # 7fffffff <_flash_size+0x7fefffff>
80004ea8:	faa42623          	sw	a0,-84(s0)
80004eac:	fa942c23          	sw	s1,-72(s0)
80004eb0:	fd742023          	sw	s7,-64(s0)
80004eb4:	fd442223          	sw	s4,-60(s0)
80004eb8:	fcb42423          	sw	a1,-56(s0)
80004ebc:	fd542623          	sw	s5,-52(s0)
80004ec0:	fa840513          	addi	a0,s0,-88
80004ec4:	85ce                	mv	a1,s3
80004ec6:	864a                	mv	a2,s2
80004ec8:	2091                	jal	80004f0c <__SEGGER_RTL_vfprintf>
80004eca:	815a                	mv	sp,s6
80004ecc:	fa040113          	addi	sp,s0,-96
80004ed0:	6145                	addi	sp,sp,48
80004ed2:	5430106f          	j	80006c14 <__riscv_restore_8>

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

80004ed6 <__SEGGER_RTL_stream_write>:
80004ed6:	5154                	lw	a3,36(a0)
80004ed8:	852e                	mv	a0,a1
80004eda:	4585                	li	a1,1
80004edc:	6030106f          	j	80006cde <fwrite>

Disassembly of section .text.libc.printf:

80004ee0 <printf>:
80004ee0:	7179                	addi	sp,sp,-48
80004ee2:	c606                	sw	ra,12(sp)
80004ee4:	82aa                	mv	t0,a0
80004ee6:	d23e                	sw	a5,36(sp)
80004ee8:	d442                	sw	a6,40(sp)
80004eea:	d646                	sw	a7,44(sp)
80004eec:	00080537          	lui	a0,0x80
80004ef0:	34c52503          	lw	a0,844(a0) # 8034c <stdout>
80004ef4:	ca2e                	sw	a1,20(sp)
80004ef6:	cc32                	sw	a2,24(sp)
80004ef8:	ce36                	sw	a3,28(sp)
80004efa:	d03a                	sw	a4,32(sp)
80004efc:	084c                	addi	a1,sp,20
80004efe:	c42e                	sw	a1,8(sp)
80004f00:	0850                	addi	a2,sp,20
80004f02:	8596                	mv	a1,t0
80004f04:	3f3d                	jal	80004e42 <vfprintf>
80004f06:	40b2                	lw	ra,12(sp)
80004f08:	6145                	addi	sp,sp,48
80004f0a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

80004f0c <__SEGGER_RTL_vfprintf>:
80004f0c:	4cf012ef          	jal	t0,80006bda <__riscv_save_12>
80004f10:	711d                	addi	sp,sp,-96
80004f12:	8d2e                	mv	s10,a1
80004f14:	8a2a                	mv	s4,a0
80004f16:	448d                	li	s1,3
80004f18:	00052023          	sw	zero,0(a0)
80004f1c:	02500c93          	li	s9,37
80004f20:	4dc1                	li	s11,16
80004f22:	49a9                	li	s3,10
80004f24:	66666537          	lui	a0,0x66666
80004f28:	7e9675b7          	lui	a1,0x7e967
80004f2c:	747d                	lui	s0,0xfffff
80004f2e:	555556b7          	lui	a3,0x55555
80004f32:	51eb8737          	lui	a4,0x51eb8
80004f36:	000207b7          	lui	a5,0x20
80004f3a:	66750513          	addi	a0,a0,1639 # 66666667 <_flash_size+0x66566667>
80004f3e:	cc2a                	sw	a0,24(sp)
80004f40:	69958513          	addi	a0,a1,1689 # 7e967699 <_flash_size+0x7e867699>
80004f44:	c62a                	sw	a0,12(sp)
80004f46:	7ff40513          	addi	a0,s0,2047 # fffff7ff <__AHB_SRAM_segment_end__+0xfbf77ff>
80004f4a:	c82a                	sw	a0,16(sp)
80004f4c:	55668513          	addi	a0,a3,1366 # 55555556 <_flash_size+0x55455556>
80004f50:	c02a                	sw	a0,0(sp)
80004f52:	51f70513          	addi	a0,a4,1311 # 51eb851f <_flash_size+0x51db851f>
80004f56:	c42a                	sw	a0,8(sp)
80004f58:	02178513          	addi	a0,a5,33 # 20021 <__ILM_segment_end__+0x21>
80004f5c:	ce2a                	sw	a0,28(sp)
80004f5e:	4505                	li	a0,1
80004f60:	04aa                	slli	s1,s1,0xa
80004f62:	d026                	sw	s1,32(sp)
80004f64:	84b2                	mv	s1,a2
80004f66:	052e                	slli	a0,a0,0xb
80004f68:	c22a                	sw	a0,4(sp)
80004f6a:	e1818913          	addi	s2,gp,-488 # 800036a8 <.LJTI0_0>
80004f6e:	000d4583          	lbu	a1,0(s10)
80004f72:	01958863          	beq	a1,s9,80004f82 <__SEGGER_RTL_vfprintf+0x76>
80004f76:	56058de3          	beqz	a1,80005cf0 <__SEGGER_RTL_vfprintf+0xde4>
80004f7a:	0d05                	addi	s10,s10,1
80004f7c:	8552                	mv	a0,s4
80004f7e:	3b55                	jal	80004d32 <__SEGGER_RTL_putc>
80004f80:	b7fd                	j	80004f6e <__SEGGER_RTL_vfprintf+0x62>
80004f82:	4b81                	li	s7,0
80004f84:	0d0d                	addi	s10,s10,3
80004f86:	05e00693          	li	a3,94
80004f8a:	ffed4503          	lbu	a0,-2(s10)
80004f8e:	fe050593          	addi	a1,a0,-32
80004f92:	00bdeb63          	bltu	s11,a1,80004fa8 <__SEGGER_RTL_vfprintf+0x9c>
80004f96:	058a                	slli	a1,a1,0x2
80004f98:	95ca                	add	a1,a1,s2
80004f9a:	4190                	lw	a2,0(a1)
80004f9c:	08000593          	li	a1,128
80004fa0:	8602                	jr	a2
80004fa2:	04000593          	li	a1,64
80004fa6:	a831                	j	80004fc2 <__SEGGER_RTL_vfprintf+0xb6>
80004fa8:	02d51163          	bne	a0,a3,80004fca <__SEGGER_RTL_vfprintf+0xbe>
80004fac:	6585                	lui	a1,0x1
80004fae:	a811                	j	80004fc2 <__SEGGER_RTL_vfprintf+0xb6>
80004fb0:	45c1                	li	a1,16
80004fb2:	a801                	j	80004fc2 <__SEGGER_RTL_vfprintf+0xb6>
80004fb4:	20000593          	li	a1,512
80004fb8:	a029                	j	80004fc2 <__SEGGER_RTL_vfprintf+0xb6>
80004fba:	65a1                	lui	a1,0x8
80004fbc:	a019                	j	80004fc2 <__SEGGER_RTL_vfprintf+0xb6>
80004fbe:	02000593          	li	a1,32
80004fc2:	00bbebb3          	or	s7,s7,a1
80004fc6:	0d05                	addi	s10,s10,1
80004fc8:	b7c9                	j	80004f8a <__SEGGER_RTL_vfprintf+0x7e>
80004fca:	fd050593          	addi	a1,a0,-48
80004fce:	0ff5f593          	zext.b	a1,a1
80004fd2:	1d7d                	addi	s10,s10,-1
80004fd4:	4625                	li	a2,9
80004fd6:	04b66263          	bltu	a2,a1,8000501a <__SEGGER_RTL_vfprintf+0x10e>
80004fda:	4581                	li	a1,0
80004fdc:	0ff57613          	zext.b	a2,a0
80004fe0:	000d4503          	lbu	a0,0(s10)
80004fe4:	033585b3          	mul	a1,a1,s3
80004fe8:	95b2                	add	a1,a1,a2
80004fea:	fd058593          	addi	a1,a1,-48 # 7fd0 <__FLASH_segment_used_size__+0x2d18>
80004fee:	fd050613          	addi	a2,a0,-48
80004ff2:	0ff67613          	zext.b	a2,a2
80004ff6:	0d05                	addi	s10,s10,1
80004ff8:	ff3662e3          	bltu	a2,s3,80004fdc <__SEGGER_RTL_vfprintf+0xd0>
80004ffc:	a005                	j	8000501c <__SEGGER_RTL_vfprintf+0x110>
80004ffe:	408c                	lw	a1,0(s1)
80005000:	0491                	addi	s1,s1,4
80005002:	fffd4503          	lbu	a0,-1(s10)
80005006:	01b5d693          	srli	a3,a1,0x1b
8000500a:	8ac1                	andi	a3,a3,16
8000500c:	0176ebb3          	or	s7,a3,s7
80005010:	41f5d693          	srai	a3,a1,0x1f
80005014:	8db5                	xor	a1,a1,a3
80005016:	8d95                	sub	a1,a1,a3
80005018:	a011                	j	8000501c <__SEGGER_RTL_vfprintf+0x110>
8000501a:	4581                	li	a1,0
8000501c:	02e00613          	li	a2,46
80005020:	00c51f63          	bne	a0,a2,8000503e <__SEGGER_RTL_vfprintf+0x132>
80005024:	000d4503          	lbu	a0,0(s10)
80005028:	02a00613          	li	a2,42
8000502c:	00c51b63          	bne	a0,a2,80005042 <__SEGGER_RTL_vfprintf+0x136>
80005030:	0004ab03          	lw	s6,0(s1)
80005034:	001d4503          	lbu	a0,1(s10)
80005038:	0491                	addi	s1,s1,4
8000503a:	0d09                	addi	s10,s10,2
8000503c:	a825                	j	80005074 <__SEGGER_RTL_vfprintf+0x168>
8000503e:	4b01                	li	s6,0
80005040:	a099                	j	80005086 <__SEGGER_RTL_vfprintf+0x17a>
80005042:	fd050613          	addi	a2,a0,-48
80005046:	0ff67613          	zext.b	a2,a2
8000504a:	0d05                	addi	s10,s10,1
8000504c:	4b01                	li	s6,0
8000504e:	46a5                	li	a3,9
80005050:	02c6e963          	bltu	a3,a2,80005082 <__SEGGER_RTL_vfprintf+0x176>
80005054:	0ff57613          	zext.b	a2,a0
80005058:	000d4503          	lbu	a0,0(s10)
8000505c:	033b06b3          	mul	a3,s6,s3
80005060:	9636                	add	a2,a2,a3
80005062:	fd060b13          	addi	s6,a2,-48
80005066:	fd050613          	addi	a2,a0,-48
8000506a:	0ff67613          	zext.b	a2,a2
8000506e:	0d05                	addi	s10,s10,1
80005070:	ff3662e3          	bltu	a2,s3,80005054 <__SEGGER_RTL_vfprintf+0x148>
80005074:	fffb4613          	not	a2,s6
80005078:	827d                	srli	a2,a2,0x1f
8000507a:	0622                	slli	a2,a2,0x8
8000507c:	00cbebb3          	or	s7,s7,a2
80005080:	a019                	j	80005086 <__SEGGER_RTL_vfprintf+0x17a>
80005082:	100beb93          	ori	s7,s7,256
80005086:	f9850613          	addi	a2,a0,-104
8000508a:	00761693          	slli	a3,a2,0x7
8000508e:	0662                	slli	a2,a2,0x18
80005090:	8265                	srli	a2,a2,0x19
80005092:	8e55                	or	a2,a2,a3
80005094:	0ff67613          	zext.b	a2,a2
80005098:	46a5                	li	a3,9
8000509a:	04c6ef63          	bltu	a3,a2,800050f8 <__SEGGER_RTL_vfprintf+0x1ec>
8000509e:	060a                	slli	a2,a2,0x2
800050a0:	e5c18693          	addi	a3,gp,-420 # 800036ec <.LJTI0_1>
800050a4:	9636                	add	a2,a2,a3
800050a6:	4210                	lw	a2,0(a2)
800050a8:	8602                	jr	a2
800050aa:	000d4503          	lbu	a0,0(s10)
800050ae:	0d05                	addi	s10,s10,1
800050b0:	a0a1                	j	800050f8 <__SEGGER_RTL_vfprintf+0x1ec>
800050b2:	000d4503          	lbu	a0,0(s10)
800050b6:	06c00613          	li	a2,108
800050ba:	02c51863          	bne	a0,a2,800050ea <__SEGGER_RTL_vfprintf+0x1de>
800050be:	001d4503          	lbu	a0,1(s10)
800050c2:	0d09                	addi	s10,s10,2
800050c4:	a005                	j	800050e4 <__SEGGER_RTL_vfprintf+0x1d8>
800050c6:	000d4503          	lbu	a0,0(s10)
800050ca:	06800613          	li	a2,104
800050ce:	02c51263          	bne	a0,a2,800050f2 <__SEGGER_RTL_vfprintf+0x1e6>
800050d2:	001d4503          	lbu	a0,1(s10)
800050d6:	0d09                	addi	s10,s10,2
800050d8:	008beb93          	ori	s7,s7,8
800050dc:	a831                	j	800050f8 <__SEGGER_RTL_vfprintf+0x1ec>
800050de:	000d4503          	lbu	a0,0(s10)
800050e2:	0d05                	addi	s10,s10,1
800050e4:	002beb93          	ori	s7,s7,2
800050e8:	a801                	j	800050f8 <__SEGGER_RTL_vfprintf+0x1ec>
800050ea:	0d05                	addi	s10,s10,1
800050ec:	001beb93          	ori	s7,s7,1
800050f0:	a021                	j	800050f8 <__SEGGER_RTL_vfprintf+0x1ec>
800050f2:	0d05                	addi	s10,s10,1
800050f4:	004beb93          	ori	s7,s7,4
800050f8:	00b02633          	sgtz	a2,a1
800050fc:	40c00633          	neg	a2,a2
80005100:	00b67ab3          	and	s5,a2,a1
80005104:	04600593          	li	a1,70
80005108:	02a5d363          	bge	a1,a0,8000512e <__SEGGER_RTL_vfprintf+0x222>
8000510c:	f9d50593          	addi	a1,a0,-99
80005110:	4655                	li	a2,21
80005112:	04b66663          	bltu	a2,a1,8000515e <__SEGGER_RTL_vfprintf+0x252>
80005116:	058a                	slli	a1,a1,0x2
80005118:	e8418613          	addi	a2,gp,-380 # 80003714 <.LJTI0_2>
8000511c:	95b2                	add	a1,a1,a2
8000511e:	418c                	lw	a1,0(a1)
80005120:	8582                	jr	a1
80005122:	d456                	sw	s5,40(sp)
80005124:	d202                	sw	zero,36(sp)
80005126:	6591                	lui	a1,0x4
80005128:	00bbeab3          	or	s5,s7,a1
8000512c:	a219                	j	80005232 <__SEGGER_RTL_vfprintf+0x326>
8000512e:	04400593          	li	a1,68
80005132:	02a5d163          	bge	a1,a0,80005154 <__SEGGER_RTL_vfprintf+0x248>
80005136:	04500593          	li	a1,69
8000513a:	04b50663          	beq	a0,a1,80005186 <__SEGGER_RTL_vfprintf+0x27a>
8000513e:	04600593          	li	a1,70
80005142:	e2b516e3          	bne	a0,a1,80004f6e <__SEGGER_RTL_vfprintf+0x62>
80005146:	6509                	lui	a0,0x2
80005148:	00abebb3          	or	s7,s7,a0
8000514c:	5502                	lw	a0,32(sp)
8000514e:	c0050513          	addi	a0,a0,-1024 # 1c00 <__NOR_CFG_OPTION_segment_size__+0x1000>
80005152:	a4fd                	j	80005440 <__SEGGER_RTL_vfprintf+0x534>
80005154:	5b951f63          	bne	a0,s9,80005712 <__SEGGER_RTL_vfprintf+0x806>
80005158:	02500593          	li	a1,37
8000515c:	b505                	j	80004f7c <__SEGGER_RTL_vfprintf+0x70>
8000515e:	04700593          	li	a1,71
80005162:	2cb50b63          	beq	a0,a1,80005438 <__SEGGER_RTL_vfprintf+0x52c>
80005166:	05800593          	li	a1,88
8000516a:	e0b512e3          	bne	a0,a1,80004f6e <__SEGGER_RTL_vfprintf+0x62>
8000516e:	6589                	lui	a1,0x2
80005170:	00bbebb3          	or	s7,s7,a1
80005174:	07800593          	li	a1,120
80005178:	d456                	sw	s5,40(sp)
8000517a:	08b50e63          	beq	a0,a1,80005216 <__SEGGER_RTL_vfprintf+0x30a>
8000517e:	658d                	lui	a1,0x3
80005180:	05858593          	addi	a1,a1,88 # 3058 <__BOOT_HEADER_segment_size__+0x1058>
80005184:	a861                	j	8000521c <__SEGGER_RTL_vfprintf+0x310>
80005186:	6509                	lui	a0,0x2
80005188:	00abebb3          	or	s7,s7,a0
8000518c:	400bec93          	ori	s9,s7,1024
80005190:	ac55                	j	80005444 <__SEGGER_RTL_vfprintf+0x538>
80005192:	100bf593          	andi	a1,s7,256
80005196:	d456                	sw	s5,40(sp)
80005198:	c199                	beqz	a1,8000519e <__SEGGER_RTL_vfprintf+0x292>
8000519a:	dffbfb93          	andi	s7,s7,-513
8000519e:	d202                	sw	zero,36(sp)
800051a0:	8ade                	mv	s5,s7
800051a2:	a841                	j	80005232 <__SEGGER_RTL_vfprintf+0x326>
800051a4:	d456                	sw	s5,40(sp)
800051a6:	4c01                	li	s8,0
800051a8:	0004ac83          	lw	s9,0(s1)
800051ac:	0491                	addi	s1,s1,4
800051ae:	018b9593          	slli	a1,s7,0x18
800051b2:	85fd                	srai	a1,a1,0x1f
800051b4:	0235f413          	andi	s0,a1,35
800051b8:	100bea93          	ori	s5,s7,256
800051bc:	4b21                	li	s6,8
800051be:	ac39                	j	800053dc <__SEGGER_RTL_vfprintf+0x4d0>
800051c0:	8b26                	mv	s6,s1
800051c2:	0004c483          	lbu	s1,0(s1)
800051c6:	0b11                	addi	s6,s6,4
800051c8:	1afd                	addi	s5,s5,-1
800051ca:	8552                	mv	a0,s4
800051cc:	85de                	mv	a1,s7
800051ce:	8656                	mv	a2,s5
800051d0:	39a1                	jal	80004e28 <__SEGGER_RTL_pre_padding>
800051d2:	8552                	mv	a0,s4
800051d4:	85a6                	mv	a1,s1
800051d6:	3eb1                	jal	80004d32 <__SEGGER_RTL_putc>
800051d8:	84da                	mv	s1,s6
800051da:	a641                	j	8000555a <__SEGGER_RTL_vfprintf+0x64e>
800051dc:	4088                	lw	a0,0(s1)
800051de:	008bf593          	andi	a1,s7,8
800051e2:	52059b63          	bnez	a1,80005718 <__SEGGER_RTL_vfprintf+0x80c>
800051e6:	000a2583          	lw	a1,0(s4)
800051ea:	002bf413          	andi	s0,s7,2
800051ee:	58041263          	bnez	s0,80005772 <__SEGGER_RTL_vfprintf+0x866>
800051f2:	c10c                	sw	a1,0(a0)
800051f4:	a351                	j	80005778 <__SEGGER_RTL_vfprintf+0x86c>
800051f6:	4088                	lw	a0,0(s1)
800051f8:	0491                	addi	s1,s1,4
800051fa:	ae09                	j	8000550c <__SEGGER_RTL_vfprintf+0x600>
800051fc:	d456                	sw	s5,40(sp)
800051fe:	100bf593          	andi	a1,s7,256
80005202:	8ade                	mv	s5,s7
80005204:	c199                	beqz	a1,8000520a <__SEGGER_RTL_vfprintf+0x2fe>
80005206:	dffbfa93          	andi	s5,s7,-513
8000520a:	0be2                	slli	s7,s7,0x18
8000520c:	405bd593          	srai	a1,s7,0x5
80005210:	81f9                	srli	a1,a1,0x1e
80005212:	0592                	slli	a1,a1,0x4
80005214:	a831                	j	80005230 <__SEGGER_RTL_vfprintf+0x324>
80005216:	658d                	lui	a1,0x3
80005218:	07858593          	addi	a1,a1,120 # 3078 <__BOOT_HEADER_segment_size__+0x1078>
8000521c:	100bf613          	andi	a2,s7,256
80005220:	8ade                	mv	s5,s7
80005222:	c219                	beqz	a2,80005228 <__SEGGER_RTL_vfprintf+0x31c>
80005224:	dffbfa93          	andi	s5,s7,-513
80005228:	0be2                	slli	s7,s7,0x18
8000522a:	41fbd613          	srai	a2,s7,0x1f
8000522e:	8df1                	and	a1,a1,a2
80005230:	d22e                	sw	a1,36(sp)
80005232:	002af613          	andi	a2,s5,2
80005236:	011a9693          	slli	a3,s5,0x11
8000523a:	004af593          	andi	a1,s5,4
8000523e:	0006c663          	bltz	a3,8000524a <__SEGGER_RTL_vfprintf+0x33e>
80005242:	e20d                	bnez	a2,80005264 <__SEGGER_RTL_vfprintf+0x358>
80005244:	00448693          	addi	a3,s1,4
80005248:	a02d                	j	80005272 <__SEGGER_RTL_vfprintf+0x366>
8000524a:	e229                	bnez	a2,8000528c <__SEGGER_RTL_vfprintf+0x380>
8000524c:	0004ac83          	lw	s9,0(s1)
80005250:	00448693          	addi	a3,s1,4
80005254:	41fcdc13          	srai	s8,s9,0x1f
80005258:	c5a1                	beqz	a1,800052a0 <__SEGGER_RTL_vfprintf+0x394>
8000525a:	010c9593          	slli	a1,s9,0x10
8000525e:	4105dc93          	srai	s9,a1,0x10
80005262:	a0b1                	j	800052ae <__SEGGER_RTL_vfprintf+0x3a2>
80005264:	00748613          	addi	a2,s1,7
80005268:	ff867493          	andi	s1,a2,-8
8000526c:	40d0                	lw	a2,4(s1)
8000526e:	00848693          	addi	a3,s1,8
80005272:	0004ac83          	lw	s9,0(s1)
80005276:	e9a9                	bnez	a1,800052c8 <__SEGGER_RTL_vfprintf+0x3bc>
80005278:	008af593          	andi	a1,s5,8
8000527c:	c199                	beqz	a1,80005282 <__SEGGER_RTL_vfprintf+0x376>
8000527e:	0ffcfc93          	zext.b	s9,s9
80005282:	818d                	srli	a1,a1,0x3
80005284:	15fd                	addi	a1,a1,-1
80005286:	00c5fc33          	and	s8,a1,a2
8000528a:	a095                	j	800052ee <__SEGGER_RTL_vfprintf+0x3e2>
8000528c:	00748613          	addi	a2,s1,7
80005290:	9a61                	andi	a2,a2,-8
80005292:	00062c83          	lw	s9,0(a2)
80005296:	00462c03          	lw	s8,4(a2)
8000529a:	00860693          	addi	a3,a2,8
8000529e:	fdd5                	bnez	a1,8000525a <__SEGGER_RTL_vfprintf+0x34e>
800052a0:	008af593          	andi	a1,s5,8
800052a4:	c599                	beqz	a1,800052b2 <__SEGGER_RTL_vfprintf+0x3a6>
800052a6:	018c9593          	slli	a1,s9,0x18
800052aa:	4185dc93          	srai	s9,a1,0x18
800052ae:	41f5dc13          	srai	s8,a1,0x1f
800052b2:	020c4063          	bltz	s8,800052d2 <__SEGGER_RTL_vfprintf+0x3c6>
800052b6:	020af593          	andi	a1,s5,32
800052ba:	e59d                	bnez	a1,800052e8 <__SEGGER_RTL_vfprintf+0x3dc>
800052bc:	040af593          	andi	a1,s5,64
800052c0:	c59d                	beqz	a1,800052ee <__SEGGER_RTL_vfprintf+0x3e2>
800052c2:	02000593          	li	a1,32
800052c6:	a01d                	j	800052ec <__SEGGER_RTL_vfprintf+0x3e0>
800052c8:	4c01                	li	s8,0
800052ca:	0cc2                	slli	s9,s9,0x10
800052cc:	010cdc93          	srli	s9,s9,0x10
800052d0:	a839                	j	800052ee <__SEGGER_RTL_vfprintf+0x3e2>
800052d2:	019035b3          	snez	a1,s9
800052d6:	41900cb3          	neg	s9,s9
800052da:	41800633          	neg	a2,s8
800052de:	40b60c33          	sub	s8,a2,a1
800052e2:	02d00593          	li	a1,45
800052e6:	a019                	j	800052ec <__SEGGER_RTL_vfprintf+0x3e0>
800052e8:	02b00593          	li	a1,43
800052ec:	d22e                	sw	a1,36(sp)
800052ee:	100af593          	andi	a1,s5,256
800052f2:	c199                	beqz	a1,800052f8 <__SEGGER_RTL_vfprintf+0x3ec>
800052f4:	dffafa93          	andi	s5,s5,-513
800052f8:	100af593          	andi	a1,s5,256
800052fc:	e191                	bnez	a1,80005300 <__SEGGER_RTL_vfprintf+0x3f4>
800052fe:	4b05                	li	s6,1
80005300:	f9c50593          	addi	a1,a0,-100 # 1f9c <__NOR_CFG_OPTION_segment_size__+0x139c>
80005304:	4651                	li	a2,20
80005306:	0cb66563          	bltu	a2,a1,800053d0 <__SEGGER_RTL_vfprintf+0x4c4>
8000530a:	4672                	lw	a2,28(sp)
8000530c:	00b65633          	srl	a2,a2,a1
80005310:	8a05                	andi	a2,a2,1
80005312:	ea31                	bnez	a2,80005366 <__SEGGER_RTL_vfprintf+0x45a>
80005314:	00101637          	lui	a2,0x101
80005318:	00b65633          	srl	a2,a2,a1
8000531c:	8a05                	andi	a2,a2,1
8000531e:	ee4d                	bnez	a2,800053d8 <__SEGGER_RTL_vfprintf+0x4cc>
80005320:	462d                	li	a2,11
80005322:	0ac59763          	bne	a1,a2,800053d0 <__SEGGER_RTL_vfprintf+0x4c4>
80005326:	8736                	mv	a4,a3
80005328:	4b81                	li	s7,0
8000532a:	018ce533          	or	a0,s9,s8
8000532e:	c915                	beqz	a0,80005362 <__SEGGER_RTL_vfprintf+0x456>
80005330:	003cd513          	srli	a0,s9,0x3
80005334:	01dc1593          	slli	a1,s8,0x1d
80005338:	8dc9                	or	a1,a1,a0
8000533a:	04610513          	addi	a0,sp,70
8000533e:	007cf613          	andi	a2,s9,7
80005342:	8cae                	mv	s9,a1
80005344:	0b85                	addi	s7,s7,1
80005346:	003c5c13          	srli	s8,s8,0x3
8000534a:	818d                	srli	a1,a1,0x3
8000534c:	03060613          	addi	a2,a2,48 # 101030 <_flash_size+0x1030>
80005350:	018ce6b3          	or	a3,s9,s8
80005354:	00c50023          	sb	a2,0(a0)
80005358:	01dc1613          	slli	a2,s8,0x1d
8000535c:	8dd1                	or	a1,a1,a2
8000535e:	0505                	addi	a0,a0,1
80005360:	fef9                	bnez	a3,8000533e <__SEGGER_RTL_vfprintf+0x432>
80005362:	d63a                	sw	a4,44(sp)
80005364:	acbd                	j	800055e2 <__SEGGER_RTL_vfprintf+0x6d6>
80005366:	d636                	sw	a3,44(sp)
80005368:	4b81                	li	s7,0
8000536a:	018ce533          	or	a0,s9,s8
8000536e:	26050a63          	beqz	a0,800055e2 <__SEGGER_RTL_vfprintf+0x6d6>
80005372:	6521                	lui	a0,0x8
80005374:	00aaf4b3          	and	s1,s5,a0
80005378:	c085                	beqz	s1,80005398 <__SEGGER_RTL_vfprintf+0x48c>
8000537a:	003bf513          	andi	a0,s7,3
8000537e:	458d                	li	a1,3
80005380:	00b51c63          	bne	a0,a1,80005398 <__SEGGER_RTL_vfprintf+0x48c>
80005384:	04610413          	addi	s0,sp,70
80005388:	01740533          	add	a0,s0,s7
8000538c:	02c00593          	li	a1,44
80005390:	00b50023          	sb	a1,0(a0) # 8000 <__AHB_SRAM_segment_size__>
80005394:	0b85                	addi	s7,s7,1
80005396:	a019                	j	8000539c <__SEGGER_RTL_vfprintf+0x490>
80005398:	04610413          	addi	s0,sp,70
8000539c:	4629                	li	a2,10
8000539e:	8566                	mv	a0,s9
800053a0:	85e2                	mv	a1,s8
800053a2:	4681                	li	a3,0
800053a4:	66d010ef          	jal	80007210 <__udivdi3>
800053a8:	001c3613          	seqz	a2,s8
800053ac:	033506b3          	mul	a3,a0,s3
800053b0:	01740733          	add	a4,s0,s7
800053b4:	40dc86b3          	sub	a3,s9,a3
800053b8:	00acb793          	sltiu	a5,s9,10
800053bc:	8e7d                	and	a2,a2,a5
800053be:	0306e693          	ori	a3,a3,48
800053c2:	00d70023          	sb	a3,0(a4)
800053c6:	0b85                	addi	s7,s7,1
800053c8:	8caa                	mv	s9,a0
800053ca:	8c2e                	mv	s8,a1
800053cc:	d655                	beqz	a2,80005378 <__SEGGER_RTL_vfprintf+0x46c>
800053ce:	ac11                	j	800055e2 <__SEGGER_RTL_vfprintf+0x6d6>
800053d0:	05800593          	li	a1,88
800053d4:	20b51563          	bne	a0,a1,800055de <__SEGGER_RTL_vfprintf+0x6d2>
800053d8:	84b6                	mv	s1,a3
800053da:	5412                	lw	s0,36(sp)
800053dc:	018ce533          	or	a0,s9,s8
800053e0:	d626                	sw	s1,44(sp)
800053e2:	c929                	beqz	a0,80005434 <__SEGGER_RTL_vfprintf+0x528>
800053e4:	012a9593          	slli	a1,s5,0x12
800053e8:	80008537          	lui	a0,0x80008
800053ec:	e2a50513          	addi	a0,a0,-470 # 80007e2a <__SEGGER_RTL_hex_lc>
800053f0:	0005d663          	bgez	a1,800053fc <__SEGGER_RTL_vfprintf+0x4f0>
800053f4:	80008537          	lui	a0,0x80008
800053f8:	e1a50513          	addi	a0,a0,-486 # 80007e1a <__SEGGER_RTL_hex_uc>
800053fc:	4b81                	li	s7,0
800053fe:	004cd593          	srli	a1,s9,0x4
80005402:	01cc1613          	slli	a2,s8,0x1c
80005406:	8e4d                	or	a2,a2,a1
80005408:	04610593          	addi	a1,sp,70
8000540c:	00fcf693          	andi	a3,s9,15
80005410:	8cb2                	mv	s9,a2
80005412:	004c5c13          	srli	s8,s8,0x4
80005416:	8211                	srli	a2,a2,0x4
80005418:	96aa                	add	a3,a3,a0
8000541a:	018ce733          	or	a4,s9,s8
8000541e:	0006c683          	lbu	a3,0(a3)
80005422:	01cc1793          	slli	a5,s8,0x1c
80005426:	8e5d                	or	a2,a2,a5
80005428:	0b85                	addi	s7,s7,1
8000542a:	00d58023          	sb	a3,0(a1)
8000542e:	0585                	addi	a1,a1,1
80005430:	ff71                	bnez	a4,8000540c <__SEGGER_RTL_vfprintf+0x500>
80005432:	aa4d                	j	800055e4 <__SEGGER_RTL_vfprintf+0x6d8>
80005434:	4b81                	li	s7,0
80005436:	a27d                	j	800055e4 <__SEGGER_RTL_vfprintf+0x6d8>
80005438:	6509                	lui	a0,0x2
8000543a:	00abebb3          	or	s7,s7,a0
8000543e:	5502                	lw	a0,32(sp)
80005440:	00abecb3          	or	s9,s7,a0
80005444:	002cf513          	andi	a0,s9,2
80005448:	ed01                	bnez	a0,80005460 <__SEGGER_RTL_vfprintf+0x554>
8000544a:	00748513          	addi	a0,s1,7
8000544e:	ff857613          	andi	a2,a0,-8
80005452:	4208                	lw	a0,0(a2)
80005454:	424c                	lw	a1,4(a2)
80005456:	00860493          	addi	s1,a2,8
8000545a:	ef6ff0ef          	jal	80004b50 <__truncdfsf2>
8000545e:	a831                	j	8000547a <__SEGGER_RTL_vfprintf+0x56e>
80005460:	4088                	lw	a0,0(s1)
80005462:	410c                	lw	a1,0(a0)
80005464:	4150                	lw	a2,4(a0)
80005466:	4514                	lw	a3,8(a0)
80005468:	4558                	lw	a4,12(a0)
8000546a:	0491                	addi	s1,s1,4
8000546c:	1808                	addi	a0,sp,48
8000546e:	d82e                	sw	a1,48(sp)
80005470:	da32                	sw	a2,52(sp)
80005472:	dc36                	sw	a3,56(sp)
80005474:	de3a                	sw	a4,60(sp)
80005476:	351010ef          	jal	80006fc6 <__trunctfsf2>
8000547a:	842a                	mv	s0,a0
8000547c:	100cf513          	andi	a0,s9,256
80005480:	e111                	bnez	a0,80005484 <__SEGGER_RTL_vfprintf+0x578>
80005482:	4b19                	li	s6,6
80005484:	000b1863          	bnez	s6,80005494 <__SEGGER_RTL_vfprintf+0x588>
80005488:	5582                	lw	a1,32(sp)
8000548a:	00bcf533          	and	a0,s9,a1
8000548e:	8d2d                	xor	a0,a0,a1
80005490:	00153b13          	seqz	s6,a0
80005494:	8522                	mv	a0,s0
80005496:	357010ef          	jal	80006fec <__SEGGER_RTL_float32_isinf>
8000549a:	c505                	beqz	a0,800054c2 <__SEGGER_RTL_vfprintf+0x5b6>
8000549c:	8522                	mv	a0,s0
8000549e:	4581                	li	a1,0
800054a0:	d5cff0ef          	jal	800049fc <__ltsf2>
800054a4:	6589                	lui	a1,0x2
800054a6:	00bcf5b3          	and	a1,s9,a1
800054aa:	02055d63          	bgez	a0,800054e4 <__SEGGER_RTL_vfprintf+0x5d8>
800054ae:	80008537          	lui	a0,0x80008
800054b2:	d9d50513          	addi	a0,a0,-611 # 80007d9d <.L.str.2>
800054b6:	c5b9                	beqz	a1,80005504 <__SEGGER_RTL_vfprintf+0x5f8>
800054b8:	80008537          	lui	a0,0x80008
800054bc:	d9850513          	addi	a0,a0,-616 # 80007d98 <.L.str.1>
800054c0:	a091                	j	80005504 <__SEGGER_RTL_vfprintf+0x5f8>
800054c2:	8522                	mv	a0,s0
800054c4:	31d010ef          	jal	80006fe0 <__SEGGER_RTL_float32_isnan>
800054c8:	c15d                	beqz	a0,8000556e <__SEGGER_RTL_vfprintf+0x662>
800054ca:	012c9593          	slli	a1,s9,0x12
800054ce:	80008537          	lui	a0,0x80008
800054d2:	e3e50513          	addi	a0,a0,-450 # 80007e3e <.L.str.6>
800054d6:	0205d763          	bgez	a1,80005504 <__SEGGER_RTL_vfprintf+0x5f8>
800054da:	80008537          	lui	a0,0x80008
800054de:	e3a50513          	addi	a0,a0,-454 # 80007e3a <.L.str.5>
800054e2:	a00d                	j	80005504 <__SEGGER_RTL_vfprintf+0x5f8>
800054e4:	c591                	beqz	a1,800054f0 <__SEGGER_RTL_vfprintf+0x5e4>
800054e6:	800085b7          	lui	a1,0x80008
800054ea:	da258593          	addi	a1,a1,-606 # 80007da2 <.L.str.3>
800054ee:	a029                	j	800054f8 <__SEGGER_RTL_vfprintf+0x5ec>
800054f0:	800085b7          	lui	a1,0x80008
800054f4:	da758593          	addi	a1,a1,-601 # 80007da7 <.L.str.4>
800054f8:	00158513          	addi	a0,a1,1
800054fc:	020cf613          	andi	a2,s9,32
80005500:	c211                	beqz	a2,80005504 <__SEGGER_RTL_vfprintf+0x5f8>
80005502:	852e                	mv	a0,a1
80005504:	effcfb93          	andi	s7,s9,-257
80005508:	02500c93          	li	s9,37
8000550c:	0c118413          	addi	s0,gp,193 # 80003951 <.L.str>
80005510:	c111                	beqz	a0,80005514 <__SEGGER_RTL_vfprintf+0x608>
80005512:	842a                	mv	s0,a0
80005514:	100bf513          	andi	a0,s7,256
80005518:	e509                	bnez	a0,80005522 <__SEGGER_RTL_vfprintf+0x616>
8000551a:	8522                	mv	a0,s0
8000551c:	648020ef          	jal	80007b64 <strlen>
80005520:	a029                	j	8000552a <__SEGGER_RTL_vfprintf+0x61e>
80005522:	8522                	mv	a0,s0
80005524:	85da                	mv	a1,s6
80005526:	f6eff0ef          	jal	80004c94 <strnlen>
8000552a:	8b2a                	mv	s6,a0
8000552c:	dffbfb93          	andi	s7,s7,-513
80005530:	40aa8ab3          	sub	s5,s5,a0
80005534:	8552                	mv	a0,s4
80005536:	85de                	mv	a1,s7
80005538:	8656                	mv	a2,s5
8000553a:	30fd                	jal	80004e28 <__SEGGER_RTL_pre_padding>
8000553c:	000b0f63          	beqz	s6,8000555a <__SEGGER_RTL_vfprintf+0x64e>
80005540:	8c26                	mv	s8,s1
80005542:	9b22                	add	s6,s6,s0
80005544:	00044583          	lbu	a1,0(s0)
80005548:	00140493          	addi	s1,s0,1
8000554c:	8552                	mv	a0,s4
8000554e:	fe4ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005552:	8426                	mv	s0,s1
80005554:	ff6498e3          	bne	s1,s6,80005544 <__SEGGER_RTL_vfprintf+0x638>
80005558:	84e2                	mv	s1,s8
8000555a:	010bf413          	andi	s0,s7,16
8000555e:	a00408e3          	beqz	s0,80004f6e <__SEGGER_RTL_vfprintf+0x62>
80005562:	02000593          	li	a1,32
80005566:	8552                	mv	a0,s4
80005568:	8656                	mv	a2,s5
8000556a:	3069                	jal	80004df4 <__SEGGER_RTL_print_padding>
8000556c:	b409                	j	80004f6e <__SEGGER_RTL_vfprintf+0x62>
8000556e:	d456                	sw	s5,40(sp)
80005570:	8522                	mv	a0,s0
80005572:	28b010ef          	jal	80006ffc <__SEGGER_RTL_float32_isnormal>
80005576:	00153513          	seqz	a0,a0
8000557a:	157d                	addi	a0,a0,-1
8000557c:	00857bb3          	and	s7,a0,s0
80005580:	855e                	mv	a0,s7
80005582:	293010ef          	jal	80007014 <__SEGGER_RTL_float32_signbit>
80005586:	8aaa                	mv	s5,a0
80005588:	00a03533          	snez	a0,a0
8000558c:	057e                	slli	a0,a0,0x1f
8000558e:	00abc433          	xor	s0,s7,a0
80005592:	08ec                	addi	a1,sp,92
80005594:	8522                	mv	a0,s0
80005596:	e40ff0ef          	jal	80004bd6 <frexpf>
8000559a:	4576                	lw	a0,92(sp)
8000559c:	00151593          	slli	a1,a0,0x1
800055a0:	952e                	add	a0,a0,a1
800055a2:	45e2                	lw	a1,24(sp)
800055a4:	02b51533          	mulh	a0,a0,a1
800055a8:	01f55c13          	srli	s8,a0,0x1f
800055ac:	8509                	srai	a0,a0,0x2
800055ae:	9c2a                	add	s8,s8,a0
800055b0:	cee2                	sw	s8,92(sp)
800055b2:	855e                	mv	a0,s7
800055b4:	4581                	li	a1,0
800055b6:	11d010ef          	jal	80006ed2 <__eqsf2>
800055ba:	0e050963          	beqz	a0,800056ac <__SEGGER_RTL_vfprintf+0x7a0>
800055be:	001c0513          	addi	a0,s8,1
800055c2:	60a020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
800055c6:	85aa                	mv	a1,a0
800055c8:	8522                	mv	a0,s0
800055ca:	c6cff0ef          	jal	80004a36 <__gtsf2>
800055ce:	0ca05263          	blez	a0,80005692 <__SEGGER_RTL_vfprintf+0x786>
800055d2:	4576                	lw	a0,92(sp)
800055d4:	00150593          	addi	a1,a0,1
800055d8:	ceae                	sw	a1,92(sp)
800055da:	0509                	addi	a0,a0,2
800055dc:	b7dd                	j	800055c2 <__SEGGER_RTL_vfprintf+0x6b6>
800055de:	4b81                	li	s7,0
800055e0:	d636                	sw	a3,44(sp)
800055e2:	5412                	lw	s0,36(sp)
800055e4:	417b0533          	sub	a0,s6,s7
800055e8:	10043593          	sltiu	a1,s0,256
800055ec:	8ca2                	mv	s9,s0
800055ee:	00143613          	seqz	a2,s0
800055f2:	15f9                	addi	a1,a1,-2
800055f4:	167d                	addi	a2,a2,-1
800055f6:	8df1                	and	a1,a1,a2
800055f8:	00a02633          	sgtz	a2,a0
800055fc:	40c004b3          	neg	s1,a2
80005600:	8ce9                	and	s1,s1,a0
80005602:	009b8533          	add	a0,s7,s1
80005606:	5422                	lw	s0,40(sp)
80005608:	8c09                	sub	s0,s0,a0
8000560a:	200af513          	andi	a0,s5,512
8000560e:	00b40b33          	add	s6,s0,a1
80005612:	4c05                	li	s8,1
80005614:	e511                	bnez	a0,80005620 <__SEGGER_RTL_vfprintf+0x714>
80005616:	8552                	mv	a0,s4
80005618:	85d6                	mv	a1,s5
8000561a:	865a                	mv	a2,s6
8000561c:	3031                	jal	80004e28 <__SEGGER_RTL_pre_padding>
8000561e:	4b01                	li	s6,0
80005620:	04510413          	addi	s0,sp,69
80005624:	10000513          	li	a0,256
80005628:	00ace963          	bltu	s9,a0,8000563a <__SEGGER_RTL_vfprintf+0x72e>
8000562c:	008cd593          	srli	a1,s9,0x8
80005630:	8552                	mv	a0,s4
80005632:	f00ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005636:	85e6                	mv	a1,s9
80005638:	a021                	j	80005640 <__SEGGER_RTL_vfprintf+0x734>
8000563a:	85e6                	mv	a1,s9
8000563c:	000c8563          	beqz	s9,80005646 <__SEGGER_RTL_vfprintf+0x73a>
80005640:	8552                	mv	a0,s4
80005642:	ef0ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005646:	8552                	mv	a0,s4
80005648:	85d6                	mv	a1,s5
8000564a:	865a                	mv	a2,s6
8000564c:	fdcff0ef          	jal	80004e28 <__SEGGER_RTL_pre_padding>
80005650:	03000593          	li	a1,48
80005654:	8552                	mv	a0,s4
80005656:	8626                	mv	a2,s1
80005658:	f9cff0ef          	jal	80004df4 <__SEGGER_RTL_print_padding>
8000565c:	01705d63          	blez	s7,80005676 <__SEGGER_RTL_vfprintf+0x76a>
80005660:	84de                	mv	s1,s7
80005662:	01740533          	add	a0,s0,s7
80005666:	00054583          	lbu	a1,0(a0)
8000566a:	1bfd                	addi	s7,s7,-1
8000566c:	8552                	mv	a0,s4
8000566e:	ec4ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005672:	fe9c67e3          	bltu	s8,s1,80005660 <__SEGGER_RTL_vfprintf+0x754>
80005676:	010af513          	andi	a0,s5,16
8000567a:	54b2                	lw	s1,44(sp)
8000567c:	02500c93          	li	s9,37
80005680:	8e0507e3          	beqz	a0,80004f6e <__SEGGER_RTL_vfprintf+0x62>
80005684:	02000593          	li	a1,32
80005688:	8552                	mv	a0,s4
8000568a:	865a                	mv	a2,s6
8000568c:	f68ff0ef          	jal	80004df4 <__SEGGER_RTL_print_padding>
80005690:	b8f9                	j	80004f6e <__SEGGER_RTL_vfprintf+0x62>
80005692:	4576                	lw	a0,92(sp)
80005694:	538020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
80005698:	85aa                	mv	a1,a0
8000569a:	8522                	mv	a0,s0
8000569c:	b60ff0ef          	jal	800049fc <__ltsf2>
800056a0:	00055663          	bgez	a0,800056ac <__SEGGER_RTL_vfprintf+0x7a0>
800056a4:	4576                	lw	a0,92(sp)
800056a6:	157d                	addi	a0,a0,-1
800056a8:	ceaa                	sw	a0,92(sp)
800056aa:	b7ed                	j	80005694 <__SEGGER_RTL_vfprintf+0x788>
800056ac:	001ab513          	seqz	a0,s5
800056b0:	157d                	addi	a0,a0,-1
800056b2:	06057593          	andi	a1,a0,96
800056b6:	4576                	lw	a0,92(sp)
800056b8:	00bcec33          	or	s8,s9,a1
800056bc:	5582                	lw	a1,32(sp)
800056be:	00bc7ab3          	and	s5,s8,a1
800056c2:	40000593          	li	a1,1024
800056c6:	d626                	sw	s1,44(sp)
800056c8:	02ba8a63          	beq	s5,a1,800056fc <__SEGGER_RTL_vfprintf+0x7f0>
800056cc:	5582                	lw	a1,32(sp)
800056ce:	00ba9763          	bne	s5,a1,800056dc <__SEGGER_RTL_vfprintf+0x7d0>
800056d2:	03655563          	bge	a0,s6,800056fc <__SEGGER_RTL_vfprintf+0x7f0>
800056d6:	55ed                	li	a1,-5
800056d8:	02a5d263          	bge	a1,a0,800056fc <__SEGGER_RTL_vfprintf+0x7f0>
800056dc:	400c7593          	andi	a1,s8,1024
800056e0:	080c7693          	andi	a3,s8,128
800056e4:	ca36                	sw	a3,20(sp)
800056e6:	80003ab7          	lui	s5,0x80003
800056ea:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
800056ee:	0c058b63          	beqz	a1,800057c4 <__SEGGER_RTL_vfprintf+0x8b8>
800056f2:	45b9                	li	a1,14
800056f4:	08a5d563          	bge	a1,a0,8000577e <__SEGGER_RTL_vfprintf+0x872>
800056f8:	4b01                	li	s6,0
800056fa:	a0e9                	j	800057c4 <__SEGGER_RTL_vfprintf+0x8b8>
800056fc:	02500c93          	li	s9,37
80005700:	02600593          	li	a1,38
80005704:	00b51f63          	bne	a0,a1,80005722 <__SEGGER_RTL_vfprintf+0x816>
80005708:	8522                	mv	a0,s0
8000570a:	45b2                	lw	a1,12(sp)
8000570c:	6c6010ef          	jal	80006dd2 <__divsf3>
80005710:	a00d                	j	80005732 <__SEGGER_RTL_vfprintf+0x826>
80005712:	84051ee3          	bnez	a0,80004f6e <__SEGGER_RTL_vfprintf+0x62>
80005716:	a509                	j	80005d18 <__SEGGER_RTL_vfprintf+0xe0c>
80005718:	000a2583          	lw	a1,0(s4)
8000571c:	00b50023          	sb	a1,0(a0)
80005720:	a8a1                	j	80005778 <__SEGGER_RTL_vfprintf+0x86c>
80005722:	40a00533          	neg	a0,a0
80005726:	4a6020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
8000572a:	85aa                	mv	a1,a0
8000572c:	8522                	mv	a0,s0
8000572e:	5f4010ef          	jal	80006d22 <__mulsf3>
80005732:	842a                	mv	s0,a0
80005734:	4581                	li	a1,0
80005736:	79c010ef          	jal	80006ed2 <__eqsf2>
8000573a:	1a050c63          	beqz	a0,800058f2 <__SEGGER_RTL_vfprintf+0x9e6>
8000573e:	8522                	mv	a0,s0
80005740:	0ad010ef          	jal	80006fec <__SEGGER_RTL_float32_isinf>
80005744:	14050c63          	beqz	a0,8000589c <__SEGGER_RTL_vfprintf+0x990>
80005748:	8522                	mv	a0,s0
8000574a:	4581                	li	a1,0
8000574c:	ab0ff0ef          	jal	800049fc <__ltsf2>
80005750:	6589                	lui	a1,0x2
80005752:	00bc75b3          	and	a1,s8,a1
80005756:	54055d63          	bgez	a0,80005cb0 <__SEGGER_RTL_vfprintf+0xda4>
8000575a:	80008537          	lui	a0,0x80008
8000575e:	d9d50513          	addi	a0,a0,-611 # 80007d9d <.L.str.2>
80005762:	5aa2                	lw	s5,40(sp)
80005764:	56058763          	beqz	a1,80005cd2 <__SEGGER_RTL_vfprintf+0xdc6>
80005768:	80008537          	lui	a0,0x80008
8000576c:	d9850513          	addi	a0,a0,-616 # 80007d98 <.L.str.1>
80005770:	a38d                	j	80005cd2 <__SEGGER_RTL_vfprintf+0xdc6>
80005772:	c10c                	sw	a1,0(a0)
80005774:	00052223          	sw	zero,4(a0)
80005778:	0491                	addi	s1,s1,4
8000577a:	ff4ff06f          	j	80004f6e <__SEGGER_RTL_vfprintf+0x62>
8000577e:	fff54593          	not	a1,a0
80005782:	95da                	add	a1,a1,s6
80005784:	4641                	li	a2,16
80005786:	8b2e                	mv	s6,a1
80005788:	00c5c363          	blt	a1,a2,8000578e <__SEGGER_RTL_vfprintf+0x882>
8000578c:	4b41                	li	s6,16
8000578e:	ea9d                	bnez	a3,800057c4 <__SEGGER_RTL_vfprintf+0x8b8>
80005790:	c995                	beqz	a1,800057c4 <__SEGGER_RTL_vfprintf+0x8b8>
80005792:	855a                	mv	a0,s6
80005794:	438020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
80005798:	85aa                	mv	a1,a0
8000579a:	8522                	mv	a0,s0
8000579c:	586010ef          	jal	80006d22 <__mulsf3>
800057a0:	3f0005b7          	lui	a1,0x3f000
800057a4:	8aaff0ef          	jal	8000484e <__addsf3>
800057a8:	201010ef          	jal	800071a8 <floorf>
800057ac:	412005b7          	lui	a1,0x41200
800057b0:	0ad010ef          	jal	8000705c <fmodf>
800057b4:	4581                	li	a1,0
800057b6:	71c010ef          	jal	80006ed2 <__eqsf2>
800057ba:	e501                	bnez	a0,800057c2 <__SEGGER_RTL_vfprintf+0x8b6>
800057bc:	1b7d                	addi	s6,s6,-1
800057be:	fc0b1ae3          	bnez	s6,80005792 <__SEGGER_RTL_vfprintf+0x886>
800057c2:	4576                	lw	a0,92(sp)
800057c4:	416005b3          	neg	a1,s6
800057c8:	1541                	addi	a0,a0,-16
800057ca:	00a5c363          	blt	a1,a0,800057d0 <__SEGGER_RTL_vfprintf+0x8c4>
800057ce:	852e                	mv	a0,a1
800057d0:	3fc020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
800057d4:	55fd                	li	a1,-1
800057d6:	043010ef          	jal	80007018 <ldexpf>
800057da:	85aa                	mv	a1,a0
800057dc:	8522                	mv	a0,s0
800057de:	870ff0ef          	jal	8000484e <__addsf3>
800057e2:	8baa                	mv	s7,a0
800057e4:	4576                	lw	a0,92(sp)
800057e6:	0505                	addi	a0,a0,1
800057e8:	3e4020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
800057ec:	85aa                	mv	a1,a0
800057ee:	855e                	mv	a0,s7
800057f0:	a78ff0ef          	jal	80004a68 <__gesf2>
800057f4:	45f6                	lw	a1,92(sp)
800057f6:	00052513          	slti	a0,a0,0
800057fa:	00154513          	xori	a0,a0,1
800057fe:	952e                	add	a0,a0,a1
80005800:	02054663          	bltz	a0,8000582c <__SEGGER_RTL_vfprintf+0x920>
80005804:	45c5                	li	a1,17
80005806:	02b56863          	bltu	a0,a1,80005836 <__SEGGER_RTL_vfprintf+0x92a>
8000580a:	ff050593          	addi	a1,a0,-16
8000580e:	ceae                	sw	a1,92(sp)
80005810:	40ad8533          	sub	a0,s11,a0
80005814:	3b8020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
80005818:	85aa                	mv	a1,a0
8000581a:	855e                	mv	a0,s7
8000581c:	506010ef          	jal	80006d22 <__mulsf3>
80005820:	6de010ef          	jal	80006efe <__fixunssfdi>
80005824:	842a                	mv	s0,a0
80005826:	84ae                	mv	s1,a1
80005828:	d202                	sw	zero,36(sp)
8000582a:	a01d                	j	80005850 <__SEGGER_RTL_vfprintf+0x944>
8000582c:	d25e                	sw	s7,36(sp)
8000582e:	4401                	li	s0,0
80005830:	4481                	li	s1,0
80005832:	ce82                	sw	zero,92(sp)
80005834:	a831                	j	80005850 <__SEGGER_RTL_vfprintf+0x944>
80005836:	ce82                	sw	zero,92(sp)
80005838:	855e                	mv	a0,s7
8000583a:	6c4010ef          	jal	80006efe <__fixunssfdi>
8000583e:	842a                	mv	s0,a0
80005840:	84ae                	mv	s1,a1
80005842:	a64ff0ef          	jal	80004aa6 <__floatundisf>
80005846:	85aa                	mv	a1,a0
80005848:	855e                	mv	a0,s7
8000584a:	ffdfe0ef          	jal	80004846 <__subsf3>
8000584e:	d22a                	sw	a0,36(sp)
80005850:	4c81                	li	s9,0
80005852:	bffc7b93          	andi	s7,s8,-1025
80005856:	5522                	lw	a0,40(sp)
80005858:	40ab0533          	sub	a0,s6,a0
8000585c:	008a8593          	addi	a1,s5,8
80005860:	46d2                	lw	a3,20(sp)
80005862:	41d0                	lw	a2,4(a1)
80005864:	00c48563          	beq	s1,a2,8000586e <__SEGGER_RTL_vfprintf+0x962>
80005868:	00c4b633          	sltu	a2,s1,a2
8000586c:	a021                	j	80005874 <__SEGGER_RTL_vfprintf+0x968>
8000586e:	4190                	lw	a2,0(a1)
80005870:	00c43633          	sltu	a2,s0,a2
80005874:	0505                	addi	a0,a0,1
80005876:	0c85                	addi	s9,s9,1
80005878:	05a1                	addi	a1,a1,8 # 41200008 <_flash_size+0x41100008>
8000587a:	d665                	beqz	a2,80005862 <__SEGGER_RTL_vfprintf+0x956>
8000587c:	45f6                	lw	a1,92(sp)
8000587e:	00db6633          	or	a2,s6,a3
80005882:	060c7693          	andi	a3,s8,96
80005886:	00163613          	seqz	a2,a2
8000588a:	00d036b3          	snez	a3,a3
8000588e:	fff6c693          	not	a3,a3
80005892:	9636                	add	a2,a2,a3
80005894:	8e0d                	sub	a2,a2,a1
80005896:	40a60ab3          	sub	s5,a2,a0
8000589a:	a2e9                	j	80005a64 <__SEGGER_RTL_vfprintf+0xb58>
8000589c:	44f6                	lw	s1,92(sp)
8000589e:	412005b7          	lui	a1,0x41200
800058a2:	8522                	mv	a0,s0
800058a4:	9c4ff0ef          	jal	80004a68 <__gesf2>
800058a8:	02054063          	bltz	a0,800058c8 <__SEGGER_RTL_vfprintf+0x9bc>
800058ac:	412005b7          	lui	a1,0x41200
800058b0:	8522                	mv	a0,s0
800058b2:	520010ef          	jal	80006dd2 <__divsf3>
800058b6:	842a                	mv	s0,a0
800058b8:	0485                	addi	s1,s1,1
800058ba:	412005b7          	lui	a1,0x41200
800058be:	9aaff0ef          	jal	80004a68 <__gesf2>
800058c2:	fe0555e3          	bgez	a0,800058ac <__SEGGER_RTL_vfprintf+0x9a0>
800058c6:	cea6                	sw	s1,92(sp)
800058c8:	3f8005b7          	lui	a1,0x3f800
800058cc:	8522                	mv	a0,s0
800058ce:	92eff0ef          	jal	800049fc <__ltsf2>
800058d2:	02055063          	bgez	a0,800058f2 <__SEGGER_RTL_vfprintf+0x9e6>
800058d6:	412005b7          	lui	a1,0x41200
800058da:	8522                	mv	a0,s0
800058dc:	446010ef          	jal	80006d22 <__mulsf3>
800058e0:	842a                	mv	s0,a0
800058e2:	14fd                	addi	s1,s1,-1
800058e4:	3f8005b7          	lui	a1,0x3f800
800058e8:	914ff0ef          	jal	800049fc <__ltsf2>
800058ec:	fe0545e3          	bltz	a0,800058d6 <__SEGGER_RTL_vfprintf+0x9ca>
800058f0:	cea6                	sw	s1,92(sp)
800058f2:	001b3513          	seqz	a0,s6
800058f6:	5582                	lw	a1,32(sp)
800058f8:	00bac5b3          	xor	a1,s5,a1
800058fc:	0015b593          	seqz	a1,a1
80005900:	40bb0b33          	sub	s6,s6,a1
80005904:	157d                	addi	a0,a0,-1
80005906:	01657bb3          	and	s7,a0,s6
8000590a:	41700533          	neg	a0,s7
8000590e:	2be020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
80005912:	55fd                	li	a1,-1
80005914:	704010ef          	jal	80007018 <ldexpf>
80005918:	85aa                	mv	a1,a0
8000591a:	8522                	mv	a0,s0
8000591c:	f33fe0ef          	jal	8000484e <__addsf3>
80005920:	8caa                	mv	s9,a0
80005922:	412005b7          	lui	a1,0x41200
80005926:	942ff0ef          	jal	80004a68 <__gesf2>
8000592a:	00054b63          	bltz	a0,80005940 <__SEGGER_RTL_vfprintf+0xa34>
8000592e:	4576                	lw	a0,92(sp)
80005930:	0505                	addi	a0,a0,1
80005932:	ceaa                	sw	a0,92(sp)
80005934:	412005b7          	lui	a1,0x41200
80005938:	8566                	mv	a0,s9
8000593a:	498010ef          	jal	80006dd2 <__divsf3>
8000593e:	8caa                	mv	s9,a0
80005940:	5aa2                	lw	s5,40(sp)
80005942:	060b8563          	beqz	s7,800059ac <__SEGGER_RTL_vfprintf+0xaa0>
80005946:	5502                	lw	a0,32(sp)
80005948:	c8050513          	addi	a0,a0,-896
8000594c:	00ac7533          	and	a0,s8,a0
80005950:	4592                	lw	a1,4(sp)
80005952:	04b51e63          	bne	a0,a1,800059ae <__SEGGER_RTL_vfprintf+0xaa2>
80005956:	4541                	li	a0,16
80005958:	00abc363          	blt	s7,a0,8000595e <__SEGGER_RTL_vfprintf+0xa52>
8000595c:	4bc1                	li	s7,16
8000595e:	855e                	mv	a0,s7
80005960:	26c020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
80005964:	85aa                	mv	a1,a0
80005966:	8566                	mv	a0,s9
80005968:	3ba010ef          	jal	80006d22 <__mulsf3>
8000596c:	592010ef          	jal	80006efe <__fixunssfdi>
80005970:	842a                	mv	s0,a0
80005972:	8d4d                	or	a0,a0,a1
80005974:	cd05                	beqz	a0,800059ac <__SEGGER_RTL_vfprintf+0xaa0>
80005976:	84ae                	mv	s1,a1
80005978:	4629                	li	a2,10
8000597a:	8522                	mv	a0,s0
8000597c:	85a6                	mv	a1,s1
8000597e:	4681                	li	a3,0
80005980:	091010ef          	jal	80007210 <__udivdi3>
80005984:	03358633          	mul	a2,a1,s3
80005988:	033536b3          	mulhu	a3,a0,s3
8000598c:	9636                	add	a2,a2,a3
8000598e:	033506b3          	mul	a3,a0,s3
80005992:	8c91                	sub	s1,s1,a2
80005994:	00d43633          	sltu	a2,s0,a3
80005998:	8c91                	sub	s1,s1,a2
8000599a:	8c15                	sub	s0,s0,a3
8000599c:	8c45                	or	s0,s0,s1
8000599e:	32041e63          	bnez	s0,80005cda <__SEGGER_RTL_vfprintf+0xdce>
800059a2:	1bfd                	addi	s7,s7,-1
800059a4:	842a                	mv	s0,a0
800059a6:	84ae                	mv	s1,a1
800059a8:	fc0b98e3          	bnez	s7,80005978 <__SEGGER_RTL_vfprintf+0xa6c>
800059ac:	4b01                	li	s6,0
800059ae:	d266                	sw	s9,36(sp)
800059b0:	080c7513          	andi	a0,s8,128
800059b4:	416a85b3          	sub	a1,s5,s6
800059b8:	4476                	lw	s0,92(sp)
800059ba:	00ab6533          	or	a0,s6,a0
800059be:	00a03533          	snez	a0,a0
800059c2:	8d89                	sub	a1,a1,a0
800059c4:	013c1513          	slli	a0,s8,0x13
800059c8:	ffb58a93          	addi	s5,a1,-5 # 411ffffb <_flash_size+0x410ffffb>
800059cc:	00054463          	bltz	a0,800059d4 <__SEGGER_RTL_vfprintf+0xac8>
800059d0:	4c85                	li	s9,1
800059d2:	a891                	j	80005a26 <__SEGGER_RTL_vfprintf+0xb1a>
800059d4:	4502                	lw	a0,0(sp)
800059d6:	02a41533          	mulh	a0,s0,a0
800059da:	01f55593          	srli	a1,a0,0x1f
800059de:	952e                	add	a0,a0,a1
800059e0:	00151593          	slli	a1,a0,0x1
800059e4:	40a40533          	sub	a0,s0,a0
800059e8:	8d0d                	sub	a0,a0,a1
800059ea:	0509                	addi	a0,a0,2
800059ec:	050a                	slli	a0,a0,0x2
800059ee:	edc18593          	addi	a1,gp,-292 # 8000376c <.LJTI0_3>
800059f2:	952e                	add	a0,a0,a1
800059f4:	4108                	lw	a0,0(a0)
800059f6:	4b89                	li	s7,2
800059f8:	54fd                	li	s1,-1
800059fa:	412005b7          	lui	a1,0x41200
800059fe:	4c85                	li	s9,1
80005a00:	8502                	jr	a0
80005a02:	4b8d                	li	s7,3
80005a04:	54f9                	li	s1,-2
80005a06:	42c805b7          	lui	a1,0x42c80
80005a0a:	5512                	lw	a0,36(sp)
80005a0c:	316010ef          	jal	80006d22 <__mulsf3>
80005a10:	d22a                	sw	a0,36(sp)
80005a12:	9426                	add	s0,s0,s1
80005a14:	cea2                	sw	s0,92(sp)
80005a16:	9aa6                	add	s5,s5,s1
80005a18:	8cde                	mv	s9,s7
80005a1a:	01602533          	sgtz	a0,s6
80005a1e:	40a00533          	neg	a0,a0
80005a22:	01657b33          	and	s6,a0,s6
80005a26:	4542                	lw	a0,16(sp)
80005a28:	00ac7bb3          	and	s7,s8,a0
80005a2c:	060c7513          	andi	a0,s8,96
80005a30:	00a03533          	snez	a0,a0
80005a34:	40aa84b3          	sub	s1,s5,a0
80005a38:	8522                	mv	a0,s0
80005a3a:	9caff0ef          	jal	80004c04 <abs>
80005a3e:	06452513          	slti	a0,a0,100
80005a42:	00154513          	xori	a0,a0,1
80005a46:	40a48ab3          	sub	s5,s1,a0
80005a4a:	5c12                	lw	s8,36(sp)
80005a4c:	8562                	mv	a0,s8
80005a4e:	4b0010ef          	jal	80006efe <__fixunssfdi>
80005a52:	842a                	mv	s0,a0
80005a54:	84ae                	mv	s1,a1
80005a56:	850ff0ef          	jal	80004aa6 <__floatundisf>
80005a5a:	85aa                	mv	a1,a0
80005a5c:	8562                	mv	a0,s8
80005a5e:	de9fe0ef          	jal	80004846 <__subsf3>
80005a62:	d22a                	sw	a0,36(sp)
80005a64:	01502533          	sgtz	a0,s5
80005a68:	40a00533          	neg	a0,a0
80005a6c:	210bf593          	andi	a1,s7,528
80005a70:	01557c33          	and	s8,a0,s5
80005a74:	e999                	bnez	a1,80005a8a <__SEGGER_RTL_vfprintf+0xb7e>
80005a76:	01505a63          	blez	s5,80005a8a <__SEGGER_RTL_vfprintf+0xb7e>
80005a7a:	1c7d                	addi	s8,s8,-1
80005a7c:	02000593          	li	a1,32
80005a80:	8552                	mv	a0,s4
80005a82:	ab0ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005a86:	fe0c1ae3          	bnez	s8,80005a7a <__SEGGER_RTL_vfprintf+0xb6e>
80005a8a:	80003ab7          	lui	s5,0x80003
80005a8e:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
80005a92:	020bf593          	andi	a1,s7,32
80005a96:	040bf513          	andi	a0,s7,64
80005a9a:	e589                	bnez	a1,80005aa4 <__SEGGER_RTL_vfprintf+0xb98>
80005a9c:	cd09                	beqz	a0,80005ab6 <__SEGGER_RTL_vfprintf+0xbaa>
80005a9e:	02000593          	li	a1,32
80005aa2:	a039                	j	80005ab0 <__SEGGER_RTL_vfprintf+0xba4>
80005aa4:	c501                	beqz	a0,80005aac <__SEGGER_RTL_vfprintf+0xba0>
80005aa6:	02d00593          	li	a1,45
80005aaa:	a019                	j	80005ab0 <__SEGGER_RTL_vfprintf+0xba4>
80005aac:	02b00593          	li	a1,43
80005ab0:	8552                	mv	a0,s4
80005ab2:	a80ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005ab6:	010bf513          	andi	a0,s7,16
80005aba:	e919                	bnez	a0,80005ad0 <__SEGGER_RTL_vfprintf+0xbc4>
80005abc:	000c0a63          	beqz	s8,80005ad0 <__SEGGER_RTL_vfprintf+0xbc4>
80005ac0:	1c7d                	addi	s8,s8,-1
80005ac2:	03000593          	li	a1,48
80005ac6:	8552                	mv	a0,s4
80005ac8:	a6aff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005acc:	fe0c1ae3          	bnez	s8,80005ac0 <__SEGGER_RTL_vfprintf+0xbb4>
80005ad0:	1cfd                	addi	s9,s9,-1
80005ad2:	003c9513          	slli	a0,s9,0x3
80005ad6:	00aa85b3          	add	a1,s5,a0
80005ada:	41c8                	lw	a0,4(a1)
80005adc:	418c                	lw	a1,0(a1)
80005ade:	02a48863          	beq	s1,a0,80005b0e <__SEGGER_RTL_vfprintf+0xc02>
80005ae2:	00a4b633          	sltu	a2,s1,a0
80005ae6:	e61d                	bnez	a2,80005b14 <__SEGGER_RTL_vfprintf+0xc08>
80005ae8:	03000613          	li	a2,48
80005aec:	00b436b3          	sltu	a3,s0,a1
80005af0:	8c89                	sub	s1,s1,a0
80005af2:	8c95                	sub	s1,s1,a3
80005af4:	8c0d                	sub	s0,s0,a1
80005af6:	00a48563          	beq	s1,a0,80005b00 <__SEGGER_RTL_vfprintf+0xbf4>
80005afa:	00a4b6b3          	sltu	a3,s1,a0
80005afe:	a019                	j	80005b04 <__SEGGER_RTL_vfprintf+0xbf8>
80005b00:	00b436b3          	sltu	a3,s0,a1
80005b04:	0605                	addi	a2,a2,1
80005b06:	d2fd                	beqz	a3,80005aec <__SEGGER_RTL_vfprintf+0xbe0>
80005b08:	0ff67593          	zext.b	a1,a2
80005b0c:	a031                	j	80005b18 <__SEGGER_RTL_vfprintf+0xc0c>
80005b0e:	00b43633          	sltu	a2,s0,a1
80005b12:	da79                	beqz	a2,80005ae8 <__SEGGER_RTL_vfprintf+0xbdc>
80005b14:	03000593          	li	a1,48
80005b18:	8552                	mv	a0,s4
80005b1a:	a18ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005b1e:	fa0c99e3          	bnez	s9,80005ad0 <__SEGGER_RTL_vfprintf+0xbc4>
80005b22:	5502                	lw	a0,32(sp)
80005b24:	c0050513          	addi	a0,a0,-1024
80005b28:	00abf433          	and	s0,s7,a0
80005b2c:	cc01                	beqz	s0,80005b44 <__SEGGER_RTL_vfprintf+0xc38>
80005b2e:	4576                	lw	a0,92(sp)
80005b30:	00a05a63          	blez	a0,80005b44 <__SEGGER_RTL_vfprintf+0xc38>
80005b34:	157d                	addi	a0,a0,-1
80005b36:	ceaa                	sw	a0,92(sp)
80005b38:	03000593          	li	a1,48
80005b3c:	8552                	mv	a0,s4
80005b3e:	9f4ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005b42:	b7f5                	j	80005b2e <__SEGGER_RTL_vfprintf+0xc22>
80005b44:	080bf513          	andi	a0,s7,128
80005b48:	00ab6533          	or	a0,s6,a0
80005b4c:	54b2                	lw	s1,44(sp)
80005b4e:	cd55                	beqz	a0,80005c0a <__SEGGER_RTL_vfprintf+0xcfe>
80005b50:	02e00593          	li	a1,46
80005b54:	8552                	mv	a0,s4
80005b56:	9dcff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005b5a:	45c1                	li	a1,16
80005b5c:	855a                	mv	a0,s6
80005b5e:	00bb4363          	blt	s6,a1,80005b64 <__SEGGER_RTL_vfprintf+0xc58>
80005b62:	4541                	li	a0,16
80005b64:	00a025b3          	sgtz	a1,a0
80005b68:	4676                	lw	a2,92(sp)
80005b6a:	40b005b3          	neg	a1,a1
80005b6e:	00a5fcb3          	and	s9,a1,a0
80005b72:	00143513          	seqz	a0,s0
80005b76:	157d                	addi	a0,a0,-1
80005b78:	8d71                	and	a0,a0,a2
80005b7a:	40ac8533          	sub	a0,s9,a0
80005b7e:	04e020ef          	jal	80007bcc <__SEGGER_RTL_pow10f>
80005b82:	07605763          	blez	s6,80005bf0 <__SEGGER_RTL_vfprintf+0xce4>
80005b86:	85aa                	mv	a1,a0
80005b88:	5512                	lw	a0,36(sp)
80005b8a:	198010ef          	jal	80006d22 <__mulsf3>
80005b8e:	370010ef          	jal	80006efe <__fixunssfdi>
80005b92:	842a                	mv	s0,a0
80005b94:	84ae                	mv	s1,a1
80005b96:	8ae6                	mv	s5,s9
80005b98:	1afd                	addi	s5,s5,-1
80005b9a:	003a9513          	slli	a0,s5,0x3
80005b9e:	800035b7          	lui	a1,0x80003
80005ba2:	06858593          	addi	a1,a1,104 # 80003068 <__SEGGER_RTL_ipow10>
80005ba6:	95aa                	add	a1,a1,a0
80005ba8:	41c8                	lw	a0,4(a1)
80005baa:	418c                	lw	a1,0(a1)
80005bac:	02a48863          	beq	s1,a0,80005bdc <__SEGGER_RTL_vfprintf+0xcd0>
80005bb0:	00a4b633          	sltu	a2,s1,a0
80005bb4:	e61d                	bnez	a2,80005be2 <__SEGGER_RTL_vfprintf+0xcd6>
80005bb6:	03000613          	li	a2,48
80005bba:	00b436b3          	sltu	a3,s0,a1
80005bbe:	8c89                	sub	s1,s1,a0
80005bc0:	8c95                	sub	s1,s1,a3
80005bc2:	8c0d                	sub	s0,s0,a1
80005bc4:	00a48563          	beq	s1,a0,80005bce <__SEGGER_RTL_vfprintf+0xcc2>
80005bc8:	00a4b6b3          	sltu	a3,s1,a0
80005bcc:	a019                	j	80005bd2 <__SEGGER_RTL_vfprintf+0xcc6>
80005bce:	00b436b3          	sltu	a3,s0,a1
80005bd2:	0605                	addi	a2,a2,1
80005bd4:	d2fd                	beqz	a3,80005bba <__SEGGER_RTL_vfprintf+0xcae>
80005bd6:	0ff67593          	zext.b	a1,a2
80005bda:	a031                	j	80005be6 <__SEGGER_RTL_vfprintf+0xcda>
80005bdc:	00b43633          	sltu	a2,s0,a1
80005be0:	da79                	beqz	a2,80005bb6 <__SEGGER_RTL_vfprintf+0xcaa>
80005be2:	03000593          	li	a1,48
80005be6:	8552                	mv	a0,s4
80005be8:	94aff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005bec:	fa0a96e3          	bnez	s5,80005b98 <__SEGGER_RTL_vfprintf+0xc8c>
80005bf0:	419b0533          	sub	a0,s6,s9
80005bf4:	54b2                	lw	s1,44(sp)
80005bf6:	c911                	beqz	a0,80005c0a <__SEGGER_RTL_vfprintf+0xcfe>
80005bf8:	416c8433          	sub	s0,s9,s6
80005bfc:	03000593          	li	a1,48
80005c00:	8552                	mv	a0,s4
80005c02:	930ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005c06:	0405                	addi	s0,s0,1
80005c08:	f875                	bnez	s0,80005bfc <__SEGGER_RTL_vfprintf+0xcf0>
80005c0a:	400bf513          	andi	a0,s7,1024
80005c0e:	02500c93          	li	s9,37
80005c12:	c969                	beqz	a0,80005ce4 <__SEGGER_RTL_vfprintf+0xdd8>
80005c14:	0bca                	slli	s7,s7,0x12
80005c16:	41fbd513          	srai	a0,s7,0x1f
80005c1a:	9901                	andi	a0,a0,-32
80005c1c:	06550593          	addi	a1,a0,101
80005c20:	8552                	mv	a0,s4
80005c22:	910ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005c26:	4576                	lw	a0,92(sp)
80005c28:	00054963          	bltz	a0,80005c3a <__SEGGER_RTL_vfprintf+0xd2e>
80005c2c:	02b00593          	li	a1,43
80005c30:	8552                	mv	a0,s4
80005c32:	900ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005c36:	4576                	lw	a0,92(sp)
80005c38:	a811                	j	80005c4c <__SEGGER_RTL_vfprintf+0xd40>
80005c3a:	02d00593          	li	a1,45
80005c3e:	8552                	mv	a0,s4
80005c40:	8f2ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005c44:	4576                	lw	a0,92(sp)
80005c46:	40a00533          	neg	a0,a0
80005c4a:	ceaa                	sw	a0,92(sp)
80005c4c:	06400493          	li	s1,100
80005c50:	02954663          	blt	a0,s1,80005c7c <__SEGGER_RTL_vfprintf+0xd70>
80005c54:	4422                	lw	s0,8(sp)
80005c56:	02853533          	mulhu	a0,a0,s0
80005c5a:	8115                	srli	a0,a0,0x5
80005c5c:	03050593          	addi	a1,a0,48
80005c60:	8552                	mv	a0,s4
80005c62:	8d0ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005c66:	4576                	lw	a0,92(sp)
80005c68:	028515b3          	mulh	a1,a0,s0
80005c6c:	01f5d613          	srli	a2,a1,0x1f
80005c70:	8595                	srai	a1,a1,0x5
80005c72:	95b2                	add	a1,a1,a2
80005c74:	029585b3          	mul	a1,a1,s1
80005c78:	8d0d                	sub	a0,a0,a1
80005c7a:	ceaa                	sw	a0,92(sp)
80005c7c:	54b2                	lw	s1,44(sp)
80005c7e:	4462                	lw	s0,24(sp)
80005c80:	02851533          	mulh	a0,a0,s0
80005c84:	01f55593          	srli	a1,a0,0x1f
80005c88:	8509                	srai	a0,a0,0x2
80005c8a:	952e                	add	a0,a0,a1
80005c8c:	03050593          	addi	a1,a0,48
80005c90:	8552                	mv	a0,s4
80005c92:	8a0ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005c96:	4576                	lw	a0,92(sp)
80005c98:	028515b3          	mulh	a1,a0,s0
80005c9c:	01f5d613          	srli	a2,a1,0x1f
80005ca0:	8589                	srai	a1,a1,0x2
80005ca2:	95b2                	add	a1,a1,a2
80005ca4:	033585b3          	mul	a1,a1,s3
80005ca8:	8d0d                	sub	a0,a0,a1
80005caa:	03050593          	addi	a1,a0,48
80005cae:	a805                	j	80005cde <__SEGGER_RTL_vfprintf+0xdd2>
80005cb0:	5aa2                	lw	s5,40(sp)
80005cb2:	c591                	beqz	a1,80005cbe <__SEGGER_RTL_vfprintf+0xdb2>
80005cb4:	800085b7          	lui	a1,0x80008
80005cb8:	da258593          	addi	a1,a1,-606 # 80007da2 <.L.str.3>
80005cbc:	a029                	j	80005cc6 <__SEGGER_RTL_vfprintf+0xdba>
80005cbe:	800085b7          	lui	a1,0x80008
80005cc2:	da758593          	addi	a1,a1,-601 # 80007da7 <.L.str.4>
80005cc6:	00158513          	addi	a0,a1,1
80005cca:	020c7613          	andi	a2,s8,32
80005cce:	c211                	beqz	a2,80005cd2 <__SEGGER_RTL_vfprintf+0xdc6>
80005cd0:	852e                	mv	a0,a1
80005cd2:	effc7b93          	andi	s7,s8,-257
80005cd6:	837ff06f          	j	8000550c <__SEGGER_RTL_vfprintf+0x600>
80005cda:	8b5e                	mv	s6,s7
80005cdc:	b9c9                	j	800059ae <__SEGGER_RTL_vfprintf+0xaa2>
80005cde:	8552                	mv	a0,s4
80005ce0:	852ff0ef          	jal	80004d32 <__SEGGER_RTL_putc>
80005ce4:	a80c0563          	beqz	s8,80004f6e <__SEGGER_RTL_vfprintf+0x62>
80005ce8:	1c7d                	addi	s8,s8,-1
80005cea:	02000593          	li	a1,32
80005cee:	bfc5                	j	80005cde <__SEGGER_RTL_vfprintf+0xdd2>
80005cf0:	00ca2503          	lw	a0,12(s4)
80005cf4:	c911                	beqz	a0,80005d08 <__SEGGER_RTL_vfprintf+0xdfc>
80005cf6:	000a2583          	lw	a1,0(s4)
80005cfa:	004a2603          	lw	a2,4(s4)
80005cfe:	00c5f563          	bgeu	a1,a2,80005d08 <__SEGGER_RTL_vfprintf+0xdfc>
80005d02:	952e                	add	a0,a0,a1
80005d04:	00050023          	sb	zero,0(a0)
80005d08:	8552                	mv	a0,s4
80005d0a:	8c8ff0ef          	jal	80004dd2 <__SEGGER_RTL_prin_flush>
80005d0e:	000a2503          	lw	a0,0(s4)
80005d12:	6125                	addi	sp,sp,96
80005d14:	6f70006f          	j	80006c0a <__riscv_restore_12>
80005d18:	8552                	mv	a0,s4
80005d1a:	8b8ff0ef          	jal	80004dd2 <__SEGGER_RTL_prin_flush>
80005d1e:	557d                	li	a0,-1
80005d20:	bfcd                	j	80005d12 <__SEGGER_RTL_vfprintf+0xe06>

Disassembly of section .segger.init.__SEGGER_init_heap:

80005d22 <__SEGGER_init_heap>:
80005d22:	00080537          	lui	a0,0x80
80005d26:	35850513          	addi	a0,a0,856 # 80358 <__heap_start__>

80005d2a <.Lpcrel_hi1>:
80005d2a:	000845b7          	lui	a1,0x84
80005d2e:	35858593          	addi	a1,a1,856 # 84358 <__heap_end__>
80005d32:	8d89                	sub	a1,a1,a0
80005d34:	a009                	j	80005d36 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

80005d36 <__SEGGER_RTL_init_heap>:
80005d36:	4621                	li	a2,8
80005d38:	00c5e963          	bltu	a1,a2,80005d4a <__SEGGER_RTL_init_heap+0x14>
80005d3c:	00080637          	lui	a2,0x80
80005d40:	34a62423          	sw	a0,840(a2) # 80348 <__SEGGER_RTL_heap_globals.0>
80005d44:	00052023          	sw	zero,0(a0)
80005d48:	c14c                	sw	a1,4(a0)
80005d4a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

80005d4c <__SEGGER_RTL_ascii_toupper>:
80005d4c:	f9f50593          	addi	a1,a0,-97
80005d50:	01a5b593          	sltiu	a1,a1,26
80005d54:	40b005b3          	neg	a1,a1
80005d58:	9981                	andi	a1,a1,-32
80005d5a:	952e                	add	a0,a0,a1
80005d5c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

80005d5e <__SEGGER_RTL_ascii_tolower>:
80005d5e:	fbf50593          	addi	a1,a0,-65
80005d62:	01a5b593          	sltiu	a1,a1,26
80005d66:	0596                	slli	a1,a1,0x5
80005d68:	8d4d                	or	a0,a0,a1
80005d6a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

80005d6c <__SEGGER_RTL_ascii_towupper>:
80005d6c:	f9f50593          	addi	a1,a0,-97
80005d70:	01a5b593          	sltiu	a1,a1,26
80005d74:	40b005b3          	neg	a1,a1
80005d78:	9981                	andi	a1,a1,-32
80005d7a:	952e                	add	a0,a0,a1
80005d7c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

80005d7e <__SEGGER_RTL_ascii_towlower>:
80005d7e:	fbf50593          	addi	a1,a0,-65
80005d82:	01a5b593          	sltiu	a1,a1,26
80005d86:	0596                	slli	a1,a1,0x5
80005d88:	8d4d                	or	a0,a0,a1
80005d8a:	8082                	ret

Disassembly of section .text.main:

80005d8c <main>:
#include "board.h"
#include "hpm_uart_drv.h"
#include "hpm_clock_drv.h"

int main(void)
{
80005d8c:	1141                	addi	sp,sp,-16
80005d8e:	c606                	sw	ra,12(sp)
     * board_init() :
     *   1. board_init_clock()      PLL  480MHz
     *   2. board_init_console()    init_uart0_pins()  PA00=UART0_TXD
     *                              UART0  115200
     */
    board_init();
80005d90:	2711                	jal	80006494 <board_init>

80005d92 <.L2>:

    while (1) {
        uart_send_byte(HPM_UART0, 0x00);   /*  0x00 */
80005d92:	4581                	li	a1,0
80005d94:	f0040537          	lui	a0,0xf0040
80005d98:	827fe0ef          	jal	800045be <uart_send_byte>
        clock_cpu_delay_ms(100);            /*  100ms */
80005d9c:	06400513          	li	a0,100
80005da0:	826fe0ef          	jal	80003dc6 <clock_cpu_delay_ms>
        uart_send_byte(HPM_UART0, 0x00);   /*  0x00 */
80005da4:	b7fd                	j	80005d92 <.L2>

Disassembly of section .text.reset_handler:

80005da6 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
80005da6:	1141                	addi	sp,sp,-16
80005da8:	c606                	sw	ra,12(sp)
    fencei();
80005daa:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
80005dae:	babfd0ef          	jal	80003958 <system_init>

    /* Entry function */
    MAIN_ENTRY();
80005db2:	3fe9                	jal	80005d8c <main>
}
80005db4:	0001                	nop
80005db6:	40b2                	lw	ra,12(sp)
80005db8:	0141                	addi	sp,sp,16
80005dba:	8082                	ret

Disassembly of section .text._init:

80005dbc <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
80005dbc:	0001                	nop
80005dbe:	8082                	ret

Disassembly of section .text.mchtmr_isr:

80005dc0 <mchtmr_isr>:
}
80005dc0:	0001                	nop
80005dc2:	8082                	ret

Disassembly of section .text.swi_isr:

80005dc4 <swi_isr>:
}
80005dc4:	0001                	nop
80005dc6:	8082                	ret

Disassembly of section .text.exception_handler:

80005dc8 <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
80005dc8:	1141                	addi	sp,sp,-16
80005dca:	c62a                	sw	a0,12(sp)
80005dcc:	c42e                	sw	a1,8(sp)
    switch (cause) {
80005dce:	4732                	lw	a4,12(sp)
80005dd0:	47bd                	li	a5,15
80005dd2:	00e7ea63          	bltu	a5,a4,80005de6 <.L23>
80005dd6:	47b2                	lw	a5,12(sp)
80005dd8:	00279713          	slli	a4,a5,0x2
80005ddc:	87818793          	addi	a5,gp,-1928 # 80003108 <.L7>
80005de0:	97ba                	add	a5,a5,a4
80005de2:	439c                	lw	a5,0(a5)
80005de4:	8782                	jr	a5

80005de6 <.L23>:
    case MCAUSE_LOAD_PAGE_FAULT:
        break;
    case MCAUSE_STORE_AMO_PAGE_FAULT:
        break;
    default:
        break;
80005de6:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
80005de8:	47a2                	lw	a5,8(sp)
}
80005dea:	853e                	mv	a0,a5
80005dec:	0141                	addi	sp,sp,16
80005dee:	8082                	ret

Disassembly of section .text.enable_plic_feature:

80005df0 <enable_plic_feature>:
{
80005df0:	1141                	addi	sp,sp,-16
    uint32_t plic_feature = 0;
80005df2:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
80005df4:	47b2                	lw	a5,12(sp)
80005df6:	0027e793          	ori	a5,a5,2
80005dfa:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
80005dfc:	47b2                	lw	a5,12(sp)
80005dfe:	0017e793          	ori	a5,a5,1
80005e02:	c63e                	sw	a5,12(sp)
80005e04:	e40007b7          	lui	a5,0xe4000
80005e08:	c43e                	sw	a5,8(sp)
80005e0a:	47b2                	lw	a5,12(sp)
80005e0c:	c23e                	sw	a5,4(sp)

80005e0e <.LBB14>:
    *(volatile uint32_t *) (base + HPM_PLIC_FEATURE_OFFSET) = feature;
80005e0e:	47a2                	lw	a5,8(sp)
80005e10:	4712                	lw	a4,4(sp)
80005e12:	c398                	sw	a4,0(a5)
}
80005e14:	0001                	nop

80005e16 <.LBE14>:
}
80005e16:	0001                	nop
80005e18:	0141                	addi	sp,sp,16
80005e1a:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

80005e1c <sysctl_enable_group_resource>:
{
80005e1c:	7179                	addi	sp,sp,-48
80005e1e:	d606                	sw	ra,44(sp)
80005e20:	c62a                	sw	a0,12(sp)
80005e22:	87ae                	mv	a5,a1
80005e24:	8736                	mv	a4,a3
80005e26:	00f105a3          	sb	a5,11(sp)
80005e2a:	87b2                	mv	a5,a2
80005e2c:	00f11423          	sh	a5,8(sp)
80005e30:	87ba                	mv	a5,a4
80005e32:	00f10523          	sb	a5,10(sp)
    if (resource < sysctl_resource_linkable_start) {
80005e36:	00815703          	lhu	a4,8(sp)
80005e3a:	0ff00793          	li	a5,255
80005e3e:	00e7e463          	bltu	a5,a4,80005e46 <.L55>
        return status_invalid_argument;
80005e42:	4789                	li	a5,2
80005e44:	a851                	j	80005ed8 <.L56>

80005e46 <.L55>:
    index = (resource - sysctl_resource_linkable_start) / 32;
80005e46:	00815783          	lhu	a5,8(sp)
80005e4a:	f0078793          	addi	a5,a5,-256 # e3ffff00 <__FLASH_segment_end__+0x63efff00>
80005e4e:	41f7d713          	srai	a4,a5,0x1f
80005e52:	8b7d                	andi	a4,a4,31
80005e54:	97ba                	add	a5,a5,a4
80005e56:	8795                	srai	a5,a5,0x5
80005e58:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
80005e5a:	00815783          	lhu	a5,8(sp)
80005e5e:	f0078713          	addi	a4,a5,-256
80005e62:	41f75793          	srai	a5,a4,0x1f
80005e66:	83ed                	srli	a5,a5,0x1b
80005e68:	973e                	add	a4,a4,a5
80005e6a:	8b7d                	andi	a4,a4,31
80005e6c:	40f707b3          	sub	a5,a4,a5
80005e70:	cc3e                	sw	a5,24(sp)
    switch (group) {
80005e72:	00b14783          	lbu	a5,11(sp)
80005e76:	efa9                	bnez	a5,80005ed0 <.L57>
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset)) | (enable ? (1UL << offset) : 0);
80005e78:	4732                	lw	a4,12(sp)
80005e7a:	47f2                	lw	a5,28(sp)
80005e7c:	08078793          	addi	a5,a5,128
80005e80:	0792                	slli	a5,a5,0x4
80005e82:	97ba                	add	a5,a5,a4
80005e84:	4398                	lw	a4,0(a5)
80005e86:	47e2                	lw	a5,24(sp)
80005e88:	4685                	li	a3,1
80005e8a:	00f697b3          	sll	a5,a3,a5
80005e8e:	fff7c793          	not	a5,a5
80005e92:	8f7d                	and	a4,a4,a5
80005e94:	00a14783          	lbu	a5,10(sp)
80005e98:	c791                	beqz	a5,80005ea4 <.L58>
80005e9a:	47e2                	lw	a5,24(sp)
80005e9c:	4685                	li	a3,1
80005e9e:	00f697b3          	sll	a5,a3,a5
80005ea2:	a011                	j	80005ea6 <.L59>

80005ea4 <.L58>:
80005ea4:	4781                	li	a5,0

80005ea6 <.L59>:
80005ea6:	8f5d                	or	a4,a4,a5
80005ea8:	46b2                	lw	a3,12(sp)
80005eaa:	47f2                	lw	a5,28(sp)
80005eac:	08078793          	addi	a5,a5,128
80005eb0:	0792                	slli	a5,a5,0x4
80005eb2:	97b6                	add	a5,a5,a3
80005eb4:	c398                	sw	a4,0(a5)
        if (enable) {
80005eb6:	00a14783          	lbu	a5,10(sp)
80005eba:	cf89                	beqz	a5,80005ed4 <.L63>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
80005ebc:	0001                	nop

80005ebe <.L61>:
80005ebe:	00815783          	lhu	a5,8(sp)
80005ec2:	85be                	mv	a1,a5
80005ec4:	4532                	lw	a0,12(sp)
80005ec6:	ae9fd0ef          	jal	800039ae <sysctl_resource_target_is_busy>
80005eca:	87aa                	mv	a5,a0
80005ecc:	fbed                	bnez	a5,80005ebe <.L61>
        break;
80005ece:	a019                	j	80005ed4 <.L63>

80005ed0 <.L57>:
        return status_invalid_argument;
80005ed0:	4789                	li	a5,2
80005ed2:	a019                	j	80005ed8 <.L56>

80005ed4 <.L63>:
        break;
80005ed4:	0001                	nop
    return status_success;
80005ed6:	4781                	li	a5,0

80005ed8 <.L56>:
}
80005ed8:	853e                	mv	a0,a5
80005eda:	50b2                	lw	ra,44(sp)
80005edc:	6145                	addi	sp,sp,48
80005ede:	8082                	ret

Disassembly of section .text.sysctl_check_group_resource_enable:

80005ee0 <sysctl_check_group_resource_enable>:
{
80005ee0:	1101                	addi	sp,sp,-32
80005ee2:	c62a                	sw	a0,12(sp)
80005ee4:	87ae                	mv	a5,a1
80005ee6:	8732                	mv	a4,a2
80005ee8:	00f105a3          	sb	a5,11(sp)
80005eec:	87ba                	mv	a5,a4
80005eee:	00f11423          	sh	a5,8(sp)
    index = (resource - sysctl_resource_linkable_start) / 32;
80005ef2:	00815783          	lhu	a5,8(sp)
80005ef6:	f0078793          	addi	a5,a5,-256
80005efa:	41f7d713          	srai	a4,a5,0x1f
80005efe:	8b7d                	andi	a4,a4,31
80005f00:	97ba                	add	a5,a5,a4
80005f02:	8795                	srai	a5,a5,0x5
80005f04:	cc3e                	sw	a5,24(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
80005f06:	00815783          	lhu	a5,8(sp)
80005f0a:	f0078713          	addi	a4,a5,-256
80005f0e:	41f75793          	srai	a5,a4,0x1f
80005f12:	83ed                	srli	a5,a5,0x1b
80005f14:	973e                	add	a4,a4,a5
80005f16:	8b7d                	andi	a4,a4,31
80005f18:	40f707b3          	sub	a5,a4,a5
80005f1c:	ca3e                	sw	a5,20(sp)
    switch (group) {
80005f1e:	00b14783          	lbu	a5,11(sp)
80005f22:	e38d                	bnez	a5,80005f44 <.L65>
        enable = ((ptr->GROUP0[index].VALUE & (1UL << offset)) != 0) ? true : false;
80005f24:	4732                	lw	a4,12(sp)
80005f26:	47e2                	lw	a5,24(sp)
80005f28:	08078793          	addi	a5,a5,128
80005f2c:	0792                	slli	a5,a5,0x4
80005f2e:	97ba                	add	a5,a5,a4
80005f30:	4398                	lw	a4,0(a5)
80005f32:	47d2                	lw	a5,20(sp)
80005f34:	00f757b3          	srl	a5,a4,a5
80005f38:	8b85                	andi	a5,a5,1
80005f3a:	00f037b3          	snez	a5,a5
80005f3e:	00f10fa3          	sb	a5,31(sp)
        break;
80005f42:	a021                	j	80005f4a <.L66>

80005f44 <.L65>:
        enable =  false;
80005f44:	00010fa3          	sb	zero,31(sp)
        break;
80005f48:	0001                	nop

80005f4a <.L66>:
    return enable;
80005f4a:	01f14783          	lbu	a5,31(sp)
}
80005f4e:	853e                	mv	a0,a5
80005f50:	6105                	addi	sp,sp,32
80005f52:	8082                	ret

Disassembly of section .text.sysctl_config_cpu0_domain_clock:

80005f54 <sysctl_config_cpu0_domain_clock>:

hpm_stat_t sysctl_config_cpu0_domain_clock(SYSCTL_Type *ptr,
                                           clock_source_t source,
                                           uint32_t cpu_div,
                                           uint32_t ahb_sub_div)
{
80005f54:	7179                	addi	sp,sp,-48
80005f56:	d606                	sw	ra,44(sp)
80005f58:	c62a                	sw	a0,12(sp)
80005f5a:	87ae                	mv	a5,a1
80005f5c:	c232                	sw	a2,4(sp)
80005f5e:	c036                	sw	a3,0(sp)
80005f60:	00f105a3          	sb	a5,11(sp)
    if (source >= clock_source_general_source_end) {
80005f64:	00b14703          	lbu	a4,11(sp)
80005f68:	479d                	li	a5,7
80005f6a:	00e7f463          	bgeu	a5,a4,80005f72 <.L86>
        return status_invalid_argument;
80005f6e:	4789                	li	a5,2
80005f70:	a849                	j	80006002 <.L87>

80005f72 <.L86>:
    }

    uint32_t origin_cpu_div = SYSCTL_CLOCK_CPU_DIV_GET(ptr->CLOCK_CPU[0]) + 1U;
80005f72:	4732                	lw	a4,12(sp)
80005f74:	6789                	lui	a5,0x2
80005f76:	97ba                	add	a5,a5,a4
80005f78:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80005f7c:	0ff7f793          	zext.b	a5,a5
80005f80:	0785                	addi	a5,a5,1
80005f82:	ce3e                	sw	a5,28(sp)
    if (origin_cpu_div == cpu_div) {
80005f84:	4772                	lw	a4,28(sp)
80005f86:	4792                	lw	a5,4(sp)
80005f88:	02f71e63          	bne	a4,a5,80005fc4 <.L88>
        ptr->CLOCK_CPU[0] = SYSCTL_CLOCK_CPU_MUX_SET(source) | SYSCTL_CLOCK_CPU_DIV_SET(cpu_div) | SYSCTL_CLOCK_CPU_SUB0_DIV_SET(ahb_sub_div - 1);
80005f8c:	00b14783          	lbu	a5,11(sp)
80005f90:	07a2                	slli	a5,a5,0x8
80005f92:	7007f713          	andi	a4,a5,1792
80005f96:	4792                	lw	a5,4(sp)
80005f98:	0ff7f793          	zext.b	a5,a5
80005f9c:	8f5d                	or	a4,a4,a5
80005f9e:	4782                	lw	a5,0(sp)
80005fa0:	17fd                	addi	a5,a5,-1
80005fa2:	01079693          	slli	a3,a5,0x10
80005fa6:	000f07b7          	lui	a5,0xf0
80005faa:	8ff5                	and	a5,a5,a3
80005fac:	8f5d                	or	a4,a4,a5
80005fae:	46b2                	lw	a3,12(sp)
80005fb0:	6789                	lui	a5,0x2
80005fb2:	97b6                	add	a5,a5,a3
80005fb4:	80e7a023          	sw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
        while (sysctl_cpu_clock_any_is_busy(ptr)) {
80005fb8:	0001                	nop

80005fba <.L89>:
80005fba:	4532                	lw	a0,12(sp)
80005fbc:	a1dfd0ef          	jal	800039d8 <sysctl_cpu_clock_any_is_busy>
80005fc0:	87aa                	mv	a5,a0
80005fc2:	ffe5                	bnez	a5,80005fba <.L89>

80005fc4 <.L88>:
        }
    }
    ptr->CLOCK_CPU[0] = SYSCTL_CLOCK_CPU_MUX_SET(source) | SYSCTL_CLOCK_CPU_DIV_SET(cpu_div - 1) | SYSCTL_CLOCK_CPU_SUB0_DIV_SET(ahb_sub_div - 1);
80005fc4:	00b14783          	lbu	a5,11(sp)
80005fc8:	07a2                	slli	a5,a5,0x8
80005fca:	7007f713          	andi	a4,a5,1792
80005fce:	4792                	lw	a5,4(sp)
80005fd0:	17fd                	addi	a5,a5,-1
80005fd2:	0ff7f793          	zext.b	a5,a5
80005fd6:	8f5d                	or	a4,a4,a5
80005fd8:	4782                	lw	a5,0(sp)
80005fda:	17fd                	addi	a5,a5,-1
80005fdc:	01079693          	slli	a3,a5,0x10
80005fe0:	000f07b7          	lui	a5,0xf0
80005fe4:	8ff5                	and	a5,a5,a3
80005fe6:	8f5d                	or	a4,a4,a5
80005fe8:	46b2                	lw	a3,12(sp)
80005fea:	6789                	lui	a5,0x2
80005fec:	97b6                	add	a5,a5,a3
80005fee:	80e7a023          	sw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>

    while (sysctl_cpu_clock_any_is_busy(ptr)) {
80005ff2:	0001                	nop

80005ff4 <.L90>:
80005ff4:	4532                	lw	a0,12(sp)
80005ff6:	9e3fd0ef          	jal	800039d8 <sysctl_cpu_clock_any_is_busy>
80005ffa:	87aa                	mv	a5,a0
80005ffc:	ffe5                	bnez	a5,80005ff4 <.L90>
    }

    clock_update_core_clock();
80005ffe:	2e09                	jal	80006310 <clock_update_core_clock>

    return status_success;
80006000:	4781                	li	a5,0

80006002 <.L87>:
}
80006002:	853e                	mv	a0,a5
80006004:	50b2                	lw	ra,44(sp)
80006006:	6145                	addi	sp,sp,48
80006008:	8082                	ret

Disassembly of section .text.clock_get_frequency:

8000600a <clock_get_frequency>:
{
8000600a:	7179                	addi	sp,sp,-48
8000600c:	d606                	sw	ra,44(sp)
8000600e:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80006010:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80006012:	47b2                	lw	a5,12(sp)
80006014:	83a1                	srli	a5,a5,0x8
80006016:	0ff7f793          	zext.b	a5,a5
8000601a:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
8000601c:	47b2                	lw	a5,12(sp)
8000601e:	0ff7f793          	zext.b	a5,a5
80006022:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80006024:	4762                	lw	a4,24(sp)
80006026:	47ad                	li	a5,11
80006028:	06e7e963          	bltu	a5,a4,8000609a <.L16>
8000602c:	47e2                	lw	a5,24(sp)
8000602e:	00279713          	slli	a4,a5,0x2
80006032:	8c018793          	addi	a5,gp,-1856 # 80003150 <.L18>
80006036:	97ba                	add	a5,a5,a4
80006038:	439c                	lw	a5,0(a5)
8000603a:	8782                	jr	a5

8000603c <.L26>:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
8000603c:	47d2                	lw	a5,20(sp)
8000603e:	0ff7f793          	zext.b	a5,a5
80006042:	853e                	mv	a0,a5
80006044:	b95fd0ef          	jal	80003bd8 <get_frequency_for_ip_in_common_group>
80006048:	ce2a                	sw	a0,28(sp)
        break;
8000604a:	a891                	j	8000609e <.L27>

8000604c <.L25>:
        clk_freq = get_frequency_for_adc(CLK_SRC_GROUP_ADC, node_or_instance);
8000604c:	45d2                	lw	a1,20(sp)
8000604e:	4505                	li	a0,1
80006050:	bf5fd0ef          	jal	80003c44 <get_frequency_for_adc>
80006054:	ce2a                	sw	a0,28(sp)
        break;
80006056:	a0a1                	j	8000609e <.L27>

80006058 <.L21>:
        clk_freq = get_frequency_for_dac(node_or_instance);
80006058:	4552                	lw	a0,20(sp)
8000605a:	20b9                	jal	800060a8 <.LFE116>
8000605c:	ce2a                	sw	a0,28(sp)
        break;
8000605e:	a081                	j	8000609e <.L27>

80006060 <.L24>:
        clk_freq = get_frequency_for_ewdg(node_or_instance);
80006060:	4552                	lw	a0,20(sp)
80006062:	c7bfd0ef          	jal	80003cdc <get_frequency_for_ewdg>
80006066:	ce2a                	sw	a0,28(sp)
        break;
80006068:	a81d                	j	8000609e <.L27>

8000606a <.L17>:
        clk_freq = get_frequency_for_pewdg();
8000606a:	20f1                	jal	80006136 <get_frequency_for_pewdg>
8000606c:	ce2a                	sw	a0,28(sp)
        break;
8000606e:	a805                	j	8000609e <.L27>

80006070 <.L23>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80006070:	016e37b7          	lui	a5,0x16e3
80006074:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006078:	ce3e                	sw	a5,28(sp)
        break;
8000607a:	a015                	j	8000609e <.L27>

8000607c <.L20>:
        clk_freq = get_frequency_for_cpu();
8000607c:	c93fd0ef          	jal	80003d0e <get_frequency_for_cpu>
80006080:	ce2a                	sw	a0,28(sp)
        break;
80006082:	a831                	j	8000609e <.L27>

80006084 <.L22>:
        clk_freq = get_frequency_for_ahb();
80006084:	28e9                	jal	8000615e <get_frequency_for_ahb>
80006086:	ce2a                	sw	a0,28(sp)
        break;
80006088:	a819                	j	8000609e <.L27>

8000608a <.L19>:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
8000608a:	47d2                	lw	a5,20(sp)
8000608c:	0ff7f793          	zext.b	a5,a5
80006090:	853e                	mv	a0,a5
80006092:	a99fd0ef          	jal	80003b2a <get_frequency_for_source>
80006096:	ce2a                	sw	a0,28(sp)
        break;
80006098:	a019                	j	8000609e <.L27>

8000609a <.L16>:
        clk_freq = 0UL;
8000609a:	ce02                	sw	zero,28(sp)
        break;
8000609c:	0001                	nop

8000609e <.L27>:
    return clk_freq;
8000609e:	47f2                	lw	a5,28(sp)
}
800060a0:	853e                	mv	a0,a5
800060a2:	50b2                	lw	ra,44(sp)
800060a4:	6145                	addi	sp,sp,48
800060a6:	8082                	ret

Disassembly of section .text.get_frequency_for_dac:

800060a8 <get_frequency_for_dac>:
{
800060a8:	7179                	addi	sp,sp,-48
800060aa:	d606                	sw	ra,44(sp)
800060ac:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
800060ae:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
800060b0:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
800060b4:	02800793          	li	a5,40
800060b8:	00f10d23          	sb	a5,26(sp)
    if (instance < DAC_INSTANCE_NUM) {
800060bc:	4732                	lw	a4,12(sp)
800060be:	4785                	li	a5,1
800060c0:	02e7ec63          	bltu	a5,a4,800060f8 <.L51>

800060c4 <.LBB8>:
        uint32_t mux_in_reg = SYSCTL_DACCLK_MUX_GET(HPM_SYSCTL->DACCLK[instance]);
800060c4:	f4000737          	lui	a4,0xf4000
800060c8:	47b2                	lw	a5,12(sp)
800060ca:	70078793          	addi	a5,a5,1792
800060ce:	078a                	slli	a5,a5,0x2
800060d0:	97ba                	add	a5,a5,a4
800060d2:	479c                	lw	a5,8(a5)
800060d4:	83a1                	srli	a5,a5,0x8
800060d6:	8b85                	andi	a5,a5,1
800060d8:	ca3e                	sw	a5,20(sp)
        if (mux_in_reg < ARRAY_SIZE(s_dac_clk_mux_node)) {
800060da:	4752                	lw	a4,20(sp)
800060dc:	4785                	li	a5,1
800060de:	00e7ed63          	bltu	a5,a4,800060f8 <.L51>
            node = s_dac_clk_mux_node[mux_in_reg];
800060e2:	02018713          	addi	a4,gp,32 # 800038b0 <s_dac_clk_mux_node>
800060e6:	47d2                	lw	a5,20(sp)
800060e8:	97ba                	add	a5,a5,a4
800060ea:	0007c783          	lbu	a5,0(a5)
800060ee:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
800060f2:	4785                	li	a5,1
800060f4:	00f10da3          	sb	a5,27(sp)

800060f8 <.L51>:
    if (is_mux_valid) {
800060f8:	01b14783          	lbu	a5,27(sp)
800060fc:	cb85                	beqz	a5,8000612c <.L52>
        if (node == clock_node_ahb) {
800060fe:	01a14703          	lbu	a4,26(sp)
80006102:	0fe00793          	li	a5,254
80006106:	00f71563          	bne	a4,a5,80006110 <.L53>
            clk_freq = get_frequency_for_ahb();
8000610a:	2891                	jal	8000615e <get_frequency_for_ahb>
8000610c:	ce2a                	sw	a0,28(sp)
8000610e:	a839                	j	8000612c <.L52>

80006110 <.L53>:
            node += instance;
80006110:	47b2                	lw	a5,12(sp)
80006112:	0ff7f793          	zext.b	a5,a5
80006116:	01a14703          	lbu	a4,26(sp)
8000611a:	97ba                	add	a5,a5,a4
8000611c:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
80006120:	01a14783          	lbu	a5,26(sp)
80006124:	853e                	mv	a0,a5
80006126:	ab3fd0ef          	jal	80003bd8 <get_frequency_for_ip_in_common_group>
8000612a:	ce2a                	sw	a0,28(sp)

8000612c <.L52>:
    return clk_freq;
8000612c:	47f2                	lw	a5,28(sp)
}
8000612e:	853e                	mv	a0,a5
80006130:	50b2                	lw	ra,44(sp)
80006132:	6145                	addi	sp,sp,48
80006134:	8082                	ret

Disassembly of section .text.get_frequency_for_pewdg:

80006136 <get_frequency_for_pewdg>:
{
80006136:	1141                	addi	sp,sp,-16
    if (EWDG_CTRL0_CLK_SEL_GET(HPM_PEWDG->CTRL0) == 0) {
80006138:	f41287b7          	lui	a5,0xf4128
8000613c:	4398                	lw	a4,0(a5)
8000613e:	200007b7          	lui	a5,0x20000
80006142:	8ff9                	and	a5,a5,a4
80006144:	e799                	bnez	a5,80006152 <.L60>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
80006146:	016e37b7          	lui	a5,0x16e3
8000614a:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
8000614e:	c63e                	sw	a5,12(sp)
80006150:	a019                	j	80006156 <.L61>

80006152 <.L60>:
        freq_in_hz = FREQ_32KHz;
80006152:	67a1                	lui	a5,0x8
80006154:	c63e                	sw	a5,12(sp)

80006156 <.L61>:
    return freq_in_hz;
80006156:	47b2                	lw	a5,12(sp)
}
80006158:	853e                	mv	a0,a5
8000615a:	0141                	addi	sp,sp,16
8000615c:	8082                	ret

Disassembly of section .text.get_frequency_for_ahb:

8000615e <get_frequency_for_ahb>:
{
8000615e:	1101                	addi	sp,sp,-32
80006160:	ce06                	sw	ra,28(sp)
    uint32_t div = SYSCTL_CLOCK_CPU_SUB0_DIV_GET(HPM_SYSCTL->CLOCK_CPU[0]) + 1U;
80006162:	f4000737          	lui	a4,0xf4000
80006166:	6789                	lui	a5,0x2
80006168:	97ba                	add	a5,a5,a4
8000616a:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
8000616e:	83c1                	srli	a5,a5,0x10
80006170:	8bbd                	andi	a5,a5,15
80006172:	0785                	addi	a5,a5,1
80006174:	c63e                	sw	a5,12(sp)
    return (get_frequency_for_cpu() / div);
80006176:	b99fd0ef          	jal	80003d0e <get_frequency_for_cpu>
8000617a:	872a                	mv	a4,a0
8000617c:	47b2                	lw	a5,12(sp)
8000617e:	02f757b3          	divu	a5,a4,a5
}
80006182:	853e                	mv	a0,a5
80006184:	40f2                	lw	ra,28(sp)
80006186:	6105                	addi	sp,sp,32
80006188:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

8000618a <clock_set_source_divider>:
{
8000618a:	7139                	addi	sp,sp,-64
8000618c:	de06                	sw	ra,60(sp)
8000618e:	c62a                	sw	a0,12(sp)
80006190:	87ae                	mv	a5,a1
80006192:	c232                	sw	a2,4(sp)
80006194:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
80006198:	d602                	sw	zero,44(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
8000619a:	47b2                	lw	a5,12(sp)
8000619c:	83a1                	srli	a5,a5,0x8
8000619e:	0ff7f793          	zext.b	a5,a5
800061a2:	d43e                	sw	a5,40(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
800061a4:	47b2                	lw	a5,12(sp)
800061a6:	0ff7f793          	zext.b	a5,a5
800061aa:	d23e                	sw	a5,36(sp)
    switch (clk_src_type) {
800061ac:	5722                	lw	a4,40(sp)
800061ae:	47ad                	li	a5,11
800061b0:	0ce7e263          	bltu	a5,a4,80006274 <.L132>
800061b4:	57a2                	lw	a5,40(sp)
800061b6:	00279713          	slli	a4,a5,0x2
800061ba:	91018793          	addi	a5,gp,-1776 # 800031a0 <.L134>
800061be:	97ba                	add	a5,a5,a4
800061c0:	439c                	lw	a5,0(a5)
800061c2:	8782                	jr	a5

800061c4 <.L138>:
        if ((div < 1U) || (div > 256U)) {
800061c4:	4792                	lw	a5,4(sp)
800061c6:	c791                	beqz	a5,800061d2 <.L139>
800061c8:	4712                	lw	a4,4(sp)
800061ca:	10000793          	li	a5,256
800061ce:	00e7f763          	bgeu	a5,a4,800061dc <.L140>

800061d2 <.L139>:
            status = status_clk_div_invalid;
800061d2:	6795                	lui	a5,0x5
800061d4:	5f078793          	addi	a5,a5,1520 # 55f0 <__FLASH_segment_used_size__+0x338>
800061d8:	d63e                	sw	a5,44(sp)
        break;
800061da:	a055                	j	8000627e <.L142>

800061dc <.L140>:
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
800061dc:	00b14783          	lbu	a5,11(sp)
800061e0:	8bbd                	andi	a5,a5,15
800061e2:	00f10da3          	sb	a5,27(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
800061e6:	5792                	lw	a5,36(sp)
800061e8:	0ff7f793          	zext.b	a5,a5
800061ec:	01b14703          	lbu	a4,27(sp)
800061f0:	4692                	lw	a3,4(sp)
800061f2:	863a                	mv	a2,a4
800061f4:	85be                	mv	a1,a5
800061f6:	f4000537          	lui	a0,0xf4000
800061fa:	82ffd0ef          	jal	80003a28 <sysctl_config_clock>

800061fe <.LBE13>:
        break;
800061fe:	a041                	j	8000627e <.L142>

80006200 <.L133>:
        status = status_clk_operation_unsupported;
80006200:	6795                	lui	a5,0x5
80006202:	5f378793          	addi	a5,a5,1523 # 55f3 <__FLASH_segment_used_size__+0x33b>
80006206:	d63e                	sw	a5,44(sp)
        break;
80006208:	a89d                	j	8000627e <.L142>

8000620a <.L137>:
        status = status_clk_fixed;
8000620a:	6795                	lui	a5,0x5
8000620c:	5fa78793          	addi	a5,a5,1530 # 55fa <__FLASH_segment_used_size__+0x342>
80006210:	d63e                	sw	a5,44(sp)
        break;
80006212:	a0b5                	j	8000627e <.L142>

80006214 <.L136>:
        status = status_clk_shared_cpu0;
80006214:	6795                	lui	a5,0x5
80006216:	5f878793          	addi	a5,a5,1528 # 55f8 <__FLASH_segment_used_size__+0x340>
8000621a:	d63e                	sw	a5,44(sp)
        break;
8000621c:	a08d                	j	8000627e <.L142>

8000621e <.L135>:
        if (node_or_instance == clock_node_cpu0) {
8000621e:	5712                	lw	a4,36(sp)
80006220:	0fc00793          	li	a5,252
80006224:	04f71363          	bne	a4,a5,8000626a <.L143>

80006228 <.LBB14>:
            uint32_t expected_freq = get_frequency_for_source((clock_source_t) src) / div;
80006228:	00b14783          	lbu	a5,11(sp)
8000622c:	853e                	mv	a0,a5
8000622e:	8fdfd0ef          	jal	80003b2a <get_frequency_for_source>
80006232:	872a                	mv	a4,a0
80006234:	4792                	lw	a5,4(sp)
80006236:	02f757b3          	divu	a5,a4,a5
8000623a:	d03e                	sw	a5,32(sp)
            uint32_t ahb_sub_div = (expected_freq + BUS_FREQ_MAX - 1U) / BUS_FREQ_MAX;
8000623c:	5702                	lw	a4,32(sp)
8000623e:	0bebc7b7          	lui	a5,0xbebc
80006242:	1ff78793          	addi	a5,a5,511 # bebc1ff <_flash_size+0xbdbc1ff>
80006246:	973e                	add	a4,a4,a5
80006248:	55e647b7          	lui	a5,0x55e64
8000624c:	b8978793          	addi	a5,a5,-1143 # 55e63b89 <_flash_size+0x55d63b89>
80006250:	02f737b3          	mulhu	a5,a4,a5
80006254:	83e9                	srli	a5,a5,0x1a
80006256:	ce3e                	sw	a5,28(sp)
            sysctl_config_cpu0_domain_clock(HPM_SYSCTL, (clock_source_t) src, div, ahb_sub_div);
80006258:	00b14783          	lbu	a5,11(sp)
8000625c:	46f2                	lw	a3,28(sp)
8000625e:	4612                	lw	a2,4(sp)
80006260:	85be                	mv	a1,a5
80006262:	f4000537          	lui	a0,0xf4000
80006266:	31fd                	jal	80005f54 <sysctl_config_cpu0_domain_clock>

80006268 <.LBE14>:
        break;
80006268:	a819                	j	8000627e <.L142>

8000626a <.L143>:
            status = status_clk_shared_cpu0;
8000626a:	6795                	lui	a5,0x5
8000626c:	5f878793          	addi	a5,a5,1528 # 55f8 <__FLASH_segment_used_size__+0x340>
80006270:	d63e                	sw	a5,44(sp)
        break;
80006272:	a031                	j	8000627e <.L142>

80006274 <.L132>:
        status = status_clk_src_invalid;
80006274:	6795                	lui	a5,0x5
80006276:	5f178793          	addi	a5,a5,1521 # 55f1 <__FLASH_segment_used_size__+0x339>
8000627a:	d63e                	sw	a5,44(sp)
        break;
8000627c:	0001                	nop

8000627e <.L142>:
    return status;
8000627e:	57b2                	lw	a5,44(sp)
}
80006280:	853e                	mv	a0,a5
80006282:	50f2                	lw	ra,60(sp)
80006284:	6121                	addi	sp,sp,64
80006286:	8082                	ret

Disassembly of section .text.clock_check_in_group:

80006288 <clock_check_in_group>:
{
80006288:	7179                	addi	sp,sp,-48
8000628a:	d606                	sw	ra,44(sp)
8000628c:	c62a                	sw	a0,12(sp)
8000628e:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80006290:	47b2                	lw	a5,12(sp)
80006292:	83c1                	srli	a5,a5,0x10
80006294:	ce3e                	sw	a5,28(sp)
    return sysctl_check_group_resource_enable(HPM_SYSCTL, group, resource);
80006296:	47a2                	lw	a5,8(sp)
80006298:	0ff7f793          	zext.b	a5,a5
8000629c:	4772                	lw	a4,28(sp)
8000629e:	08074733          	zext.h	a4,a4
800062a2:	863a                	mv	a2,a4
800062a4:	85be                	mv	a1,a5
800062a6:	f4000537          	lui	a0,0xf4000
800062aa:	391d                	jal	80005ee0 <sysctl_check_group_resource_enable>
800062ac:	87aa                	mv	a5,a0
}
800062ae:	853e                	mv	a0,a5
800062b0:	50b2                	lw	ra,44(sp)
800062b2:	6145                	addi	sp,sp,48
800062b4:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

800062b6 <clock_connect_group_to_cpu>:
{
800062b6:	1141                	addi	sp,sp,-16
800062b8:	c62a                	sw	a0,12(sp)
800062ba:	c42e                	sw	a1,8(sp)
    if (cpu == 0U) {
800062bc:	47a2                	lw	a5,8(sp)
800062be:	ef89                	bnez	a5,800062d8 <.L163>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
800062c0:	f40006b7          	lui	a3,0xf4000
800062c4:	47b2                	lw	a5,12(sp)
800062c6:	4705                	li	a4,1
800062c8:	00f71733          	sll	a4,a4,a5
800062cc:	47a2                	lw	a5,8(sp)
800062ce:	09078793          	addi	a5,a5,144
800062d2:	0792                	slli	a5,a5,0x4
800062d4:	97b6                	add	a5,a5,a3
800062d6:	c3d8                	sw	a4,4(a5)

800062d8 <.L163>:
}
800062d8:	0001                	nop
800062da:	0141                	addi	sp,sp,16
800062dc:	8082                	ret

Disassembly of section .text.clock_get_core_clock_ticks_per_ms:

800062de <clock_get_core_clock_ticks_per_ms>:
{
800062de:	1141                	addi	sp,sp,-16
800062e0:	c606                	sw	ra,12(sp)
    if (hpm_core_clock == 0U) {
800062e2:	000807b7          	lui	a5,0x80
800062e6:	3387a783          	lw	a5,824(a5) # 80338 <hpm_core_clock>
800062ea:	e391                	bnez	a5,800062ee <.L171>
        clock_update_core_clock();
800062ec:	2015                	jal	80006310 <.LFE141>

800062ee <.L171>:
    return (hpm_core_clock + FREQ_1KHz - 1U) / FREQ_1KHz;
800062ee:	000807b7          	lui	a5,0x80
800062f2:	3387a783          	lw	a5,824(a5) # 80338 <hpm_core_clock>
800062f6:	3e778713          	addi	a4,a5,999
800062fa:	106257b7          	lui	a5,0x10625
800062fe:	dd378793          	addi	a5,a5,-557 # 10624dd3 <_flash_size+0x10524dd3>
80006302:	02f737b3          	mulhu	a5,a4,a5
80006306:	8399                	srli	a5,a5,0x6
}
80006308:	853e                	mv	a0,a5
8000630a:	40b2                	lw	ra,12(sp)
8000630c:	0141                	addi	sp,sp,16
8000630e:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

80006310 <clock_update_core_clock>:

void clock_update_core_clock(void)
{
80006310:	1141                	addi	sp,sp,-16
80006312:	c606                	sw	ra,12(sp)
    hpm_core_clock = clock_get_frequency(clock_cpu0);
80006314:	6785                	lui	a5,0x1
80006316:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x6a6>
8000631a:	39c5                	jal	8000600a <clock_get_frequency>
8000631c:	872a                	mv	a4,a0
8000631e:	000807b7          	lui	a5,0x80
80006322:	32e7ac23          	sw	a4,824(a5) # 80338 <hpm_core_clock>
}
80006326:	0001                	nop
80006328:	40b2                	lw	ra,12(sp)
8000632a:	0141                	addi	sp,sp,16
8000632c:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

8000632e <l1c_dc_invalidate_all>:
{
8000632e:	1141                	addi	sp,sp,-16
80006330:	47dd                	li	a5,23
80006332:	00f107a3          	sb	a5,15(sp)

80006336 <.LBB68>:
}

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
80006336:	00f14783          	lbu	a5,15(sp)
8000633a:	7cc79073          	csrw	0x7cc,a5
}
8000633e:	0001                	nop

80006340 <.LBE68>:
}
80006340:	0001                	nop
80006342:	0141                	addi	sp,sp,16
80006344:	8082                	ret

Disassembly of section .text.init_py_pins_as_pgpio:

80006346 <init_py_pins_as_pgpio>:
    HPM_PIOC->PAD[IOC_PAD_PY00].FUNC_CTL = PIOC_PY00_FUNC_CTL_PGPIO_Y_00;
80006346:	f4118737          	lui	a4,0xf4118
8000634a:	6785                	lui	a5,0x1
8000634c:	97ba                	add	a5,a5,a4
8000634e:	e007a023          	sw	zero,-512(a5) # e00 <__NOR_CFG_OPTION_segment_size__+0x200>
    HPM_PIOC->PAD[IOC_PAD_PY01].FUNC_CTL = PIOC_PY01_FUNC_CTL_PGPIO_Y_01;
80006352:	f4118737          	lui	a4,0xf4118
80006356:	6785                	lui	a5,0x1
80006358:	97ba                	add	a5,a5,a4
8000635a:	e007a423          	sw	zero,-504(a5) # e08 <__NOR_CFG_OPTION_segment_size__+0x208>
    HPM_PIOC->PAD[IOC_PAD_PY02].FUNC_CTL = PIOC_PY02_FUNC_CTL_PGPIO_Y_02;
8000635e:	f4118737          	lui	a4,0xf4118
80006362:	6785                	lui	a5,0x1
80006364:	97ba                	add	a5,a5,a4
80006366:	e007a823          	sw	zero,-496(a5) # e10 <__NOR_CFG_OPTION_segment_size__+0x210>
    HPM_PIOC->PAD[IOC_PAD_PY03].FUNC_CTL = PIOC_PY03_FUNC_CTL_PGPIO_Y_03;
8000636a:	f4118737          	lui	a4,0xf4118
8000636e:	6785                	lui	a5,0x1
80006370:	97ba                	add	a5,a5,a4
80006372:	e007ac23          	sw	zero,-488(a5) # e18 <__NOR_CFG_OPTION_segment_size__+0x218>
    HPM_PIOC->PAD[IOC_PAD_PY04].FUNC_CTL = PIOC_PY04_FUNC_CTL_PGPIO_Y_04;
80006376:	f4118737          	lui	a4,0xf4118
8000637a:	6785                	lui	a5,0x1
8000637c:	97ba                	add	a5,a5,a4
8000637e:	e207a023          	sw	zero,-480(a5) # e20 <__NOR_CFG_OPTION_segment_size__+0x220>
    HPM_PIOC->PAD[IOC_PAD_PY05].FUNC_CTL = PIOC_PY05_FUNC_CTL_PGPIO_Y_05;
80006382:	f4118737          	lui	a4,0xf4118
80006386:	6785                	lui	a5,0x1
80006388:	97ba                	add	a5,a5,a4
8000638a:	e207a423          	sw	zero,-472(a5) # e28 <__NOR_CFG_OPTION_segment_size__+0x228>
}
8000638e:	0001                	nop
80006390:	8082                	ret

Disassembly of section .text.init_uart0_pins:

80006392 <init_uart0_pins>:
    HPM_IOC->PAD[IOC_PAD_PA00].FUNC_CTL = IOC_PA00_FUNC_CTL_UART0_TXD;
80006392:	f40407b7          	lui	a5,0xf4040
80006396:	4709                	li	a4,2
80006398:	c398                	sw	a4,0(a5)
    HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
8000639a:	f40407b7          	lui	a5,0xf4040
8000639e:	4709                	li	a4,2
800063a0:	c798                	sw	a4,8(a5)
}
800063a2:	0001                	nop
800063a4:	8082                	ret

Disassembly of section .text.init_uart3_pins:

800063a6 <init_uart3_pins>:

void init_uart3_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PA14].FUNC_CTL = IOC_PA14_FUNC_CTL_UART3_RXD;
800063a6:	f40407b7          	lui	a5,0xf4040
800063aa:	4709                	li	a4,2
800063ac:	dbb8                	sw	a4,112(a5)

    HPM_IOC->PAD[IOC_PAD_PA15].FUNC_CTL = IOC_PA15_FUNC_CTL_UART3_TXD;
800063ae:	f40407b7          	lui	a5,0xf4040
800063b2:	4709                	li	a4,2
800063b4:	dfb8                	sw	a4,120(a5)
}
800063b6:	0001                	nop
800063b8:	8082                	ret

Disassembly of section .text.sysctl_resource_any_is_busy:

800063ba <sysctl_resource_any_is_busy>:
{
800063ba:	1141                	addi	sp,sp,-16
800063bc:	c62a                	sw	a0,12(sp)
    return ptr->RESOURCE[0] & SYSCTL_RESOURCE_GLB_BUSY_MASK;
800063be:	47b2                	lw	a5,12(sp)
800063c0:	4398                	lw	a4,0(a5)
800063c2:	800007b7          	lui	a5,0x80000
800063c6:	8ff9                	and	a5,a5,a4
800063c8:	00f037b3          	snez	a5,a5
800063cc:	0ff7f793          	zext.b	a5,a5
}
800063d0:	853e                	mv	a0,a5
800063d2:	0141                	addi	sp,sp,16
800063d4:	8082                	ret

Disassembly of section .text.gptmr_check_status:

800063d6 <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
800063d6:	1141                	addi	sp,sp,-16
800063d8:	c62a                	sw	a0,12(sp)
800063da:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
800063dc:	47b2                	lw	a5,12(sp)
800063de:	2007a703          	lw	a4,512(a5) # 80000200 <_flash_size+0x7ff00200>
800063e2:	47a2                	lw	a5,8(sp)
800063e4:	8ff9                	and	a5,a5,a4
800063e6:	4722                	lw	a4,8(sp)
800063e8:	40f707b3          	sub	a5,a4,a5
800063ec:	0017b793          	seqz	a5,a5
800063f0:	0ff7f793          	zext.b	a5,a5
}
800063f4:	853e                	mv	a0,a5
800063f6:	0141                	addi	sp,sp,16
800063f8:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

800063fa <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
800063fa:	1141                	addi	sp,sp,-16
800063fc:	c62a                	sw	a0,12(sp)
800063fe:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
80006400:	47b2                	lw	a5,12(sp)
80006402:	4722                	lw	a4,8(sp)
80006404:	20e7a023          	sw	a4,512(a5)
}
80006408:	0001                	nop
8000640a:	0141                	addi	sp,sp,16
8000640c:	8082                	ret

Disassembly of section .text.usb_phy_disable_dp_dm_pulldown:

8000640e <usb_phy_disable_dp_dm_pulldown>:
 * @brief USB phy disconnect dp/dm pins pulldown resistance
 *
 * @param[in] ptr A USB peripheral base address
 */
static inline void usb_phy_disable_dp_dm_pulldown(USB_Type *ptr)
{
8000640e:	1141                	addi	sp,sp,-16
80006410:	c62a                	sw	a0,12(sp)
    ptr->PHY_CTRL0 |= 0x001000E0u;
80006412:	47b2                	lw	a5,12(sp)
80006414:	2107a703          	lw	a4,528(a5)
80006418:	001007b7          	lui	a5,0x100
8000641c:	0e078793          	addi	a5,a5,224 # 1000e0 <_flash_size+0xe0>
80006420:	8f5d                	or	a4,a4,a5
80006422:	47b2                	lw	a5,12(sp)
80006424:	20e7a823          	sw	a4,528(a5)
}
80006428:	0001                	nop
8000642a:	0141                	addi	sp,sp,16
8000642c:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_is_enabled:

8000642e <pllctlv2_xtal_is_enabled>:
{
8000642e:	1141                	addi	sp,sp,-16
80006430:	c62a                	sw	a0,12(sp)
    return IS_HPM_BITMASK_SET(ptr->XTAL, PLLCTLV2_XTAL_ENABLE_MASK);
80006432:	47b2                	lw	a5,12(sp)
80006434:	4398                	lw	a4,0(a5)
80006436:	100007b7          	lui	a5,0x10000
8000643a:	8ff9                	and	a5,a5,a4
8000643c:	00f037b3          	snez	a5,a5
80006440:	0ff7f793          	zext.b	a5,a5
}
80006444:	853e                	mv	a0,a5
80006446:	0141                	addi	sp,sp,16
80006448:	8082                	ret

Disassembly of section .text.board_init_console:

8000644a <board_init_console>:
{
8000644a:	1101                	addi	sp,sp,-32
8000644c:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
8000644e:	f0040537          	lui	a0,0xf0040
80006452:	2251                	jal	800065d6 <init_uart_pins>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
80006454:	4581                	li	a1,0
80006456:	011907b7          	lui	a5,0x1190
8000645a:	01578513          	addi	a0,a5,21 # 1190015 <_flash_size+0x1090015>
8000645e:	8f5fd0ef          	jal	80003d52 <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
80006462:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t)BOARD_CONSOLE_UART_BASE;
80006464:	f00407b7          	lui	a5,0xf0040
80006468:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
8000646a:	011907b7          	lui	a5,0x1190
8000646e:	01578513          	addi	a0,a5,21 # 1190015 <_flash_size+0x1090015>
80006472:	3e61                	jal	8000600a <clock_get_frequency>
80006474:	87aa                	mv	a5,a0
80006476:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
80006478:	67f1                	lui	a5,0x1c
8000647a:	20078793          	addi	a5,a5,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
8000647e:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
80006480:	878a                	mv	a5,sp
80006482:	853e                	mv	a0,a5
80006484:	2d1d                	jal	80006aba <console_init>
80006486:	87aa                	mv	a5,a0
80006488:	c391                	beqz	a5,8000648c <.L45>

8000648a <.L44>:
        while (1) {
8000648a:	a001                	j	8000648a <.L44>

8000648c <.L45>:
}
8000648c:	0001                	nop
8000648e:	40f2                	lw	ra,28(sp)
80006490:	6105                	addi	sp,sp,32
80006492:	8082                	ret

Disassembly of section .text.board_init:

80006494 <board_init>:
{
80006494:	1141                	addi	sp,sp,-16
80006496:	c606                	sw	ra,12(sp)
    init_py_pins_as_pgpio();
80006498:	357d                	jal	80006346 <init_py_pins_as_pgpio>
    board_init_usb_dp_dm_pins();
8000649a:	c2dfd0ef          	jal	800040c6 <board_init_usb_dp_dm_pins>
    board_init_clock();
8000649e:	2819                	jal	800064b4 <.LFE358>
    board_init_console();
800064a0:	376d                	jal	8000644a <board_init_console>
    board_init_pmp();
800064a2:	2a05                	jal	800065d2 <board_init_pmp>
    board_print_clock_freq();
800064a4:	b99fd0ef          	jal	8000403c <board_print_clock_freq>
    board_print_banner();
800064a8:	b53fd0ef          	jal	80003ffa <board_print_banner>
}
800064ac:	0001                	nop
800064ae:	40b2                	lw	ra,12(sp)
800064b0:	0141                	addi	sp,sp,16
800064b2:	8082                	ret

Disassembly of section .text.board_init_clock:

800064b4 <board_init_clock>:

void board_init_clock(void)
{
800064b4:	1101                	addi	sp,sp,-32
800064b6:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
800064b8:	6785                	lui	a5,0x1
800064ba:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x6a6>
800064be:	36b1                	jal	8000600a <clock_get_frequency>
800064c0:	c62a                	sw	a0,12(sp)

    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
800064c2:	4732                	lw	a4,12(sp)
800064c4:	016e37b7          	lui	a5,0x16e3
800064c8:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
800064cc:	00f71f63          	bne	a4,a5,800064ea <.L57>
        /* Configure the External OSC ramp-up time: ~9ms */
        pllctlv2_xtal_set_rampup_time(HPM_PLLCTLV2, 32UL * 1000UL * 9U);
800064d0:	000467b7          	lui	a5,0x46
800064d4:	50078593          	addi	a1,a5,1280 # 46500 <__ILM_segment_end__+0x26500>
800064d8:	f40c0537          	lui	a0,0xf40c0
800064dc:	af9fd0ef          	jal	80003fd4 <pllctlv2_xtal_set_rampup_time>

        /* Select clock setting preset1 */
        sysctl_clock_set_preset(HPM_SYSCTL, 2);
800064e0:	4589                	li	a1,2
800064e2:	f4000537          	lui	a0,0xf4000
800064e6:	a8ffd0ef          	jal	80003f74 <sysctl_clock_set_preset>

800064ea <.L57>:
    }

    /* group0[0] */
    clock_add_to_group(clock_cpu0, 0);
800064ea:	4581                	li	a1,0
800064ec:	6785                	lui	a5,0x1
800064ee:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x6a6>
800064f2:	861fd0ef          	jal	80003d52 <clock_add_to_group>
    clock_add_to_group(clock_ahb, 0);
800064f6:	4581                	li	a1,0
800064f8:	fffd07b7          	lui	a5,0xfffd0
800064fc:	5fe78513          	addi	a0,a5,1534 # fffd05fe <__AHB_SRAM_segment_end__+0xfbc85fe>
80006500:	853fd0ef          	jal	80003d52 <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
80006504:	4581                	li	a1,0
80006506:	010117b7          	lui	a5,0x1011
8000650a:	90078513          	addi	a0,a5,-1792 # 1010900 <_flash_size+0xf10900>
8000650e:	845fd0ef          	jal	80003d52 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
80006512:	4581                	li	a1,0
80006514:	01020537          	lui	a0,0x1020
80006518:	83bfd0ef          	jal	80003d52 <clock_add_to_group>
    clock_add_to_group(clock_rom, 0);
8000651c:	4581                	li	a1,0
8000651e:	010307b7          	lui	a5,0x1030
80006522:	50b78513          	addi	a0,a5,1291 # 103050b <_flash_size+0xf3050b>
80006526:	82dfd0ef          	jal	80003d52 <clock_add_to_group>
    clock_add_to_group(clock_mot0, 0);
8000652a:	4581                	li	a1,0
8000652c:	012d07b7          	lui	a5,0x12d0
80006530:	50578513          	addi	a0,a5,1285 # 12d0505 <_flash_size+0x11d0505>
80006534:	81ffd0ef          	jal	80003d52 <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
80006538:	4581                	li	a1,0
8000653a:	013107b7          	lui	a5,0x1310
8000653e:	50978513          	addi	a0,a5,1289 # 1310509 <_flash_size+0x1210509>
80006542:	811fd0ef          	jal	80003d52 <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
80006546:	4581                	li	a1,0
80006548:	013207b7          	lui	a5,0x1320
8000654c:	50a78513          	addi	a0,a5,1290 # 132050a <_flash_size+0x122050a>
80006550:	803fd0ef          	jal	80003d52 <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
80006554:	4581                	li	a1,0
80006556:	013307b7          	lui	a5,0x1330
8000655a:	01d78513          	addi	a0,a5,29 # 133001d <_flash_size+0x123001d>
8000655e:	ff4fd0ef          	jal	80003d52 <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
80006562:	4581                	li	a1,0
80006564:	010807b7          	lui	a5,0x1080
80006568:	50e78513          	addi	a0,a5,1294 # 108050e <_flash_size+0xf8050e>
8000656c:	fe6fd0ef          	jal	80003d52 <clock_add_to_group>

    /* Connect Group0 to CPU0 */
    clock_connect_group_to_cpu(0, 0);
80006570:	4581                	li	a1,0
80006572:	4501                	li	a0,0
80006574:	3389                	jal	800062b6 <clock_connect_group_to_cpu>

    /* Bump up DCDC voltage to 1275mv */
    pcfg_dcdc_set_voltage(HPM_PCFG, 1275);
80006576:	4fb00593          	li	a1,1275
8000657a:	f4104537          	lui	a0,0xf4104
8000657e:	29d5                	jal	80006a72 <pcfg_dcdc_set_voltage>

    /* Configure CPU to 480MHz, AXI/AHB to 160MHz */
    sysctl_config_cpu0_domain_clock(HPM_SYSCTL, clock_source_pll0_clk0, 2, 3);
80006580:	468d                	li	a3,3
80006582:	4609                	li	a2,2
80006584:	4585                	li	a1,1
80006586:	f4000537          	lui	a0,0xf4000
8000658a:	32e9                	jal	80005f54 <sysctl_config_cpu0_domain_clock>
    /* Configure PLL0 Post Divider */
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0, pllctlv2_div_1p0);    /* PLL0CLK0: 960MHz */
8000658c:	4681                	li	a3,0
8000658e:	4601                	li	a2,0
80006590:	4581                	li	a1,0
80006592:	f40c0537          	lui	a0,0xf40c0
80006596:	2c85                	jal	80006806 <pllctlv2_set_postdiv>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1, pllctlv2_div_1p6);    /* PLL0CLK1: 600MHz */
80006598:	468d                	li	a3,3
8000659a:	4605                	li	a2,1
8000659c:	4581                	li	a1,0
8000659e:	f40c0537          	lui	a0,0xf40c0
800065a2:	2495                	jal	80006806 <pllctlv2_set_postdiv>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk2, pllctlv2_div_2p4);    /* PLL0CLK2: 400MHz */
800065a4:	469d                	li	a3,7
800065a6:	4609                	li	a2,2
800065a8:	4581                	li	a1,0
800065aa:	f40c0537          	lui	a0,0xf40c0
800065ae:	2ca1                	jal	80006806 <pllctlv2_set_postdiv>
    /* Configure PLL0 Frequency to 960MHz */
    pllctlv2_init_pll_with_freq(HPM_PLLCTLV2, pllctlv2_pll0, 960000000);
800065b0:	39387637          	lui	a2,0x39387
800065b4:	4581                	li	a1,0
800065b6:	f40c0537          	lui	a0,0xf40c0
800065ba:	90efe0ef          	jal	800046c8 <pllctlv2_init_pll_with_freq>

    clock_update_core_clock();
800065be:	3b89                	jal	80006310 <clock_update_core_clock>

    /* Configure mchtmr to 24MHz */
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
800065c0:	4605                	li	a2,1
800065c2:	4581                	li	a1,0
800065c4:	01020537          	lui	a0,0x1020
800065c8:	36c9                	jal	8000618a <clock_set_source_divider>
}
800065ca:	0001                	nop
800065cc:	40f2                	lw	ra,28(sp)
800065ce:	6105                	addi	sp,sp,32
800065d0:	8082                	ret

Disassembly of section .text.board_init_pmp:

800065d2 <board_init_pmp>:
    return BOARD_LED_OFF_LEVEL;
}

void board_init_pmp(void)
{
}
800065d2:	0001                	nop
800065d4:	8082                	ret

Disassembly of section .text.init_uart_pins:

800065d6 <init_uart_pins>:
    }
    return freq;
}

void init_uart_pins(UART_Type *ptr)
{
800065d6:	1101                	addi	sp,sp,-32
800065d8:	ce06                	sw	ra,28(sp)
800065da:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
800065dc:	4732                	lw	a4,12(sp)
800065de:	f00407b7          	lui	a5,0xf0040
800065e2:	00f71463          	bne	a4,a5,800065ea <.L153>
        init_uart0_pins();
800065e6:	3375                	jal	80006392 <init_uart0_pins>
        /* using for uart_lin function */
        init_uart3_pins();
    } else {
        ;
    }
}
800065e8:	a839                	j	80006606 <.L156>

800065ea <.L153>:
    } else if (ptr == HPM_UART2) {
800065ea:	4732                	lw	a4,12(sp)
800065ec:	f00487b7          	lui	a5,0xf0048
800065f0:	00f71563          	bne	a4,a5,800065fa <.L155>
        init_uart2_pins();
800065f4:	8d1fd0ef          	jal	80003ec4 <init_uart2_pins>
}
800065f8:	a039                	j	80006606 <.L156>

800065fa <.L155>:
    } else if (ptr == HPM_UART3) {
800065fa:	4732                	lw	a4,12(sp)
800065fc:	f004c7b7          	lui	a5,0xf004c
80006600:	00f71363          	bne	a4,a5,80006606 <.L156>
        init_uart3_pins();
80006604:	334d                	jal	800063a6 <init_uart3_pins>

80006606 <.L156>:
}
80006606:	0001                	nop
80006608:	40f2                	lw	ra,28(sp)
8000660a:	6105                	addi	sp,sp,32
8000660c:	8082                	ret

Disassembly of section .text.uart_modem_config:

8000660e <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
8000660e:	1141                	addi	sp,sp,-16
80006610:	c62a                	sw	a0,12(sp)
80006612:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80006614:	47a2                	lw	a5,8(sp)
80006616:	0007c783          	lbu	a5,0(a5) # f004c000 <__FLASH_segment_end__+0x6ff4c000>
8000661a:	0796                	slli	a5,a5,0x5
8000661c:	0207f713          	andi	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
80006620:	47a2                	lw	a5,8(sp)
80006622:	0017c783          	lbu	a5,1(a5)
80006626:	0792                	slli	a5,a5,0x4
80006628:	8bc1                	andi	a5,a5,16
8000662a:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
8000662c:	47a2                	lw	a5,8(sp)
8000662e:	0027c783          	lbu	a5,2(a5)
80006632:	0017c793          	xori	a5,a5,1
80006636:	0ff7f793          	zext.b	a5,a5
8000663a:	0786                	slli	a5,a5,0x1
8000663c:	8b89                	andi	a5,a5,2
8000663e:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80006640:	47b2                	lw	a5,12(sp)
80006642:	db98                	sw	a4,48(a5)
}
80006644:	0001                	nop
80006646:	0141                	addi	sp,sp,16
80006648:	8082                	ret

Disassembly of section .text.uart_disable_irq:

8000664a <uart_disable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be disabled
 */
static inline void uart_disable_irq(UART_Type *ptr, uint32_t irq_mask)
{
8000664a:	1141                	addi	sp,sp,-16
8000664c:	c62a                	sw	a0,12(sp)
8000664e:	c42e                	sw	a1,8(sp)
    ptr->IER &= ~irq_mask;
80006650:	47b2                	lw	a5,12(sp)
80006652:	53d8                	lw	a4,36(a5)
80006654:	47a2                	lw	a5,8(sp)
80006656:	fff7c793          	not	a5,a5
8000665a:	8f7d                	and	a4,a4,a5
8000665c:	47b2                	lw	a5,12(sp)
8000665e:	d3d8                	sw	a4,36(a5)
}
80006660:	0001                	nop
80006662:	0141                	addi	sp,sp,16
80006664:	8082                	ret

Disassembly of section .text.uart_enable_irq:

80006666 <uart_enable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be enabled
 */
static inline void uart_enable_irq(UART_Type *ptr, uint32_t irq_mask)
{
80006666:	1141                	addi	sp,sp,-16
80006668:	c62a                	sw	a0,12(sp)
8000666a:	c42e                	sw	a1,8(sp)
    ptr->IER |= irq_mask;
8000666c:	47b2                	lw	a5,12(sp)
8000666e:	53d8                	lw	a4,36(a5)
80006670:	47a2                	lw	a5,8(sp)
80006672:	8f5d                	or	a4,a4,a5
80006674:	47b2                	lw	a5,12(sp)
80006676:	d3d8                	sw	a4,36(a5)
}
80006678:	0001                	nop
8000667a:	0141                	addi	sp,sp,16
8000667c:	8082                	ret

Disassembly of section .text.uart_default_config:

8000667e <uart_default_config>:
{
8000667e:	1141                	addi	sp,sp,-16
80006680:	c62a                	sw	a0,12(sp)
80006682:	c42e                	sw	a1,8(sp)
    config->baudrate = 115200;
80006684:	47a2                	lw	a5,8(sp)
80006686:	6771                	lui	a4,0x1c
80006688:	20070713          	addi	a4,a4,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
8000668c:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
8000668e:	47a2                	lw	a5,8(sp)
80006690:	470d                	li	a4,3
80006692:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
80006696:	47a2                	lw	a5,8(sp)
80006698:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
8000669c:	47a2                	lw	a5,8(sp)
8000669e:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
800066a2:	47a2                	lw	a5,8(sp)
800066a4:	4705                	li	a4,1
800066a6:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
800066aa:	47a2                	lw	a5,8(sp)
800066ac:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
800066b0:	47a2                	lw	a5,8(sp)
800066b2:	473d                	li	a4,15
800066b4:	00e785a3          	sb	a4,11(a5)
    config->dma_enable = false;
800066b8:	47a2                	lw	a5,8(sp)
800066ba:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
800066be:	47a2                	lw	a5,8(sp)
800066c0:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
800066c4:	47a2                	lw	a5,8(sp)
800066c6:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
800066ca:	47a2                	lw	a5,8(sp)
800066cc:	000788a3          	sb	zero,17(a5)
    config->rxidle_config.detect_enable = false;
800066d0:	47a2                	lw	a5,8(sp)
800066d2:	00078923          	sb	zero,18(a5)
    config->rxidle_config.detect_irq_enable = false;
800066d6:	47a2                	lw	a5,8(sp)
800066d8:	000789a3          	sb	zero,19(a5)
    config->rxidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
800066dc:	47a2                	lw	a5,8(sp)
800066de:	00078a23          	sb	zero,20(a5)
    config->rxidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
800066e2:	47a2                	lw	a5,8(sp)
800066e4:	4729                	li	a4,10
800066e6:	00e78aa3          	sb	a4,21(a5)
    config->txidle_config.detect_enable = false;
800066ea:	47a2                	lw	a5,8(sp)
800066ec:	00078b23          	sb	zero,22(a5)
    config->txidle_config.detect_irq_enable = false;
800066f0:	47a2                	lw	a5,8(sp)
800066f2:	00078ba3          	sb	zero,23(a5)
    config->txidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
800066f6:	47a2                	lw	a5,8(sp)
800066f8:	00078c23          	sb	zero,24(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
800066fc:	47a2                	lw	a5,8(sp)
800066fe:	4729                	li	a4,10
80006700:	00e78ca3          	sb	a4,25(a5)
    config->rx_enable = true;
80006704:	47a2                	lw	a5,8(sp)
80006706:	4705                	li	a4,1
80006708:	00e78d23          	sb	a4,26(a5)
}
8000670c:	0001                	nop
8000670e:	0141                	addi	sp,sp,16
80006710:	8082                	ret

Disassembly of section .text.uart_flush:

80006712 <uart_flush>:
{
80006712:	1101                	addi	sp,sp,-32
80006714:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
80006716:	ce02                	sw	zero,28(sp)
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80006718:	a811                	j	8000672c <.L60>

8000671a <.L63>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000671a:	4772                	lw	a4,28(sp)
8000671c:	6785                	lui	a5,0x1
8000671e:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80006722:	00e7eb63          	bltu	a5,a4,80006738 <.L66>
        retry++;
80006726:	47f2                	lw	a5,28(sp)
80006728:	0785                	addi	a5,a5,1
8000672a:	ce3e                	sw	a5,28(sp)

8000672c <.L60>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
8000672c:	47b2                	lw	a5,12(sp)
8000672e:	5bdc                	lw	a5,52(a5)
80006730:	0407f793          	andi	a5,a5,64
80006734:	d3fd                	beqz	a5,8000671a <.L63>
80006736:	a011                	j	8000673a <.L62>

80006738 <.L66>:
            break;
80006738:	0001                	nop

8000673a <.L62>:
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000673a:	4772                	lw	a4,28(sp)
8000673c:	6785                	lui	a5,0x1
8000673e:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80006742:	00e7f463          	bgeu	a5,a4,8000674a <.L64>
        return status_timeout;
80006746:	478d                	li	a5,3
80006748:	a011                	j	8000674c <.L65>

8000674a <.L64>:
    return status_success;
8000674a:	4781                	li	a5,0

8000674c <.L65>:
}
8000674c:	853e                	mv	a0,a5
8000674e:	6105                	addi	sp,sp,32
80006750:	8082                	ret

Disassembly of section .text.uart_init_rxline_idle_detection:

80006752 <uart_init_rxline_idle_detection>:
{
80006752:	1101                	addi	sp,sp,-32
80006754:	ce06                	sw	ra,28(sp)
80006756:	c62a                	sw	a0,12(sp)
80006758:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_RX_IDLE_EN_MASK
8000675a:	47b2                	lw	a5,12(sp)
8000675c:	43dc                	lw	a5,4(a5)
8000675e:	c007f713          	andi	a4,a5,-1024
80006762:	47b2                	lw	a5,12(sp)
80006764:	c3d8                	sw	a4,4(a5)
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
80006766:	47b2                	lw	a5,12(sp)
80006768:	43d8                	lw	a4,4(a5)
8000676a:	00814783          	lbu	a5,8(sp)
8000676e:	07a2                	slli	a5,a5,0x8
80006770:	1007f793          	andi	a5,a5,256
                    | UART_IDLE_CFG_RX_IDLE_THR_SET(rxidle_config.threshold)
80006774:	00b14683          	lbu	a3,11(sp)
80006778:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_RX_IDLE_COND_SET(rxidle_config.idle_cond);
8000677a:	00a14783          	lbu	a5,10(sp)
8000677e:	07a6                	slli	a5,a5,0x9
80006780:	2007f793          	andi	a5,a5,512
80006784:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
80006786:	8f5d                	or	a4,a4,a5
80006788:	47b2                	lw	a5,12(sp)
8000678a:	c3d8                	sw	a4,4(a5)
    if (rxidle_config.detect_irq_enable) {
8000678c:	00914783          	lbu	a5,9(sp)
80006790:	c791                	beqz	a5,8000679c <.L93>
        uart_enable_irq(ptr, uart_intr_rx_line_idle);
80006792:	800005b7          	lui	a1,0x80000
80006796:	4532                	lw	a0,12(sp)
80006798:	35f9                	jal	80006666 <uart_enable_irq>
8000679a:	a029                	j	800067a4 <.L94>

8000679c <.L93>:
        uart_disable_irq(ptr, uart_intr_rx_line_idle);
8000679c:	800005b7          	lui	a1,0x80000
800067a0:	4532                	lw	a0,12(sp)
800067a2:	3565                	jal	8000664a <uart_disable_irq>

800067a4 <.L94>:
    return status_success;
800067a4:	4781                	li	a5,0
}
800067a6:	853e                	mv	a0,a5
800067a8:	40f2                	lw	ra,28(sp)
800067aa:	6105                	addi	sp,sp,32
800067ac:	8082                	ret

Disassembly of section .text.pllctlv2_pll_clk_is_stable:

800067ae <pllctlv2_pll_clk_is_stable>:
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @param [in] clk Post-divider output index (pllctlv2_clk0 through pllctlv2_clk3)
 * @return true if the PLL CLK is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_clk_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
800067ae:	1101                	addi	sp,sp,-32
800067b0:	c62a                	sw	a0,12(sp)
800067b2:	87ae                	mv	a5,a1
800067b4:	8732                	mv	a4,a2
800067b6:	00f105a3          	sb	a5,11(sp)
800067ba:	87ba                	mv	a5,a4
800067bc:	00f10523          	sb	a5,10(sp)
    uint32_t status = ptr->PLL[pll].DIV[clk];
800067c0:	00b14683          	lbu	a3,11(sp)
800067c4:	00a14783          	lbu	a5,10(sp)
800067c8:	4732                	lw	a4,12(sp)
800067ca:	0696                	slli	a3,a3,0x5
800067cc:	97b6                	add	a5,a5,a3
800067ce:	03078793          	addi	a5,a5,48
800067d2:	078a                	slli	a5,a5,0x2
800067d4:	97ba                	add	a5,a5,a4
800067d6:	439c                	lw	a5,0(a5)
800067d8:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_ENABLE_MASK)
800067da:	4772                	lw	a4,28(sp)
800067dc:	100007b7          	lui	a5,0x10000
800067e0:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_DIV_RESPONSE_MASK)));
800067e2:	cb89                	beqz	a5,800067f4 <.L7>
800067e4:	47f2                	lw	a5,28(sp)
800067e6:	0007c963          	bltz	a5,800067f8 <.L8>
800067ea:	4772                	lw	a4,28(sp)
800067ec:	200007b7          	lui	a5,0x20000
800067f0:	8ff9                	and	a5,a5,a4
800067f2:	c399                	beqz	a5,800067f8 <.L8>

800067f4 <.L7>:
800067f4:	4785                	li	a5,1
800067f6:	a011                	j	800067fa <.L9>

800067f8 <.L8>:
800067f8:	4781                	li	a5,0

800067fa <.L9>:
800067fa:	8b85                	andi	a5,a5,1
800067fc:	0ff7f793          	zext.b	a5,a5
}
80006800:	853e                	mv	a0,a5
80006802:	6105                	addi	sp,sp,32
80006804:	8082                	ret

Disassembly of section .text.pllctlv2_set_postdiv:

80006806 <pllctlv2_set_postdiv>:
        ptr->PLL[pll].CONFIG |= PLLCTLV2_PLL_CONFIG_SPREAD_MASK;
    }
}

void pllctlv2_set_postdiv(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk, pllctlv2_div_t div_value)
{
80006806:	1101                	addi	sp,sp,-32
80006808:	ce06                	sw	ra,28(sp)
8000680a:	c62a                	sw	a0,12(sp)
8000680c:	87ae                	mv	a5,a1
8000680e:	8736                	mv	a4,a3
80006810:	00f105a3          	sb	a5,11(sp)
80006814:	87b2                	mv	a5,a2
80006816:	00f10523          	sb	a5,10(sp)
8000681a:	87ba                	mv	a5,a4
8000681c:	00f104a3          	sb	a5,9(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80006820:	47b2                	lw	a5,12(sp)
80006822:	c7ad                	beqz	a5,8000688c <.L32>
80006824:	00b14703          	lbu	a4,11(sp)
80006828:	4785                	li	a5,1
8000682a:	06e7e163          	bltu	a5,a4,8000688c <.L32>
        ptr->PLL[pll].DIV[clk] =
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
8000682e:	00b14683          	lbu	a3,11(sp)
80006832:	00a14783          	lbu	a5,10(sp)
80006836:	4732                	lw	a4,12(sp)
80006838:	0696                	slli	a3,a3,0x5
8000683a:	97b6                	add	a5,a5,a3
8000683c:	03078793          	addi	a5,a5,48 # 20000030 <_flash_size+0x1ff00030>
80006840:	078a                	slli	a5,a5,0x2
80006842:	97ba                	add	a5,a5,a4
80006844:	439c                	lw	a5,0(a5)
80006846:	fc07f693          	andi	a3,a5,-64
8000684a:	00914783          	lbu	a5,9(sp)
8000684e:	03f7f713          	andi	a4,a5,63
        ptr->PLL[pll].DIV[clk] =
80006852:	00b14603          	lbu	a2,11(sp)
80006856:	00a14783          	lbu	a5,10(sp)
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
8000685a:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].DIV[clk] =
8000685c:	46b2                	lw	a3,12(sp)
8000685e:	0616                	slli	a2,a2,0x5
80006860:	97b2                	add	a5,a5,a2
80006862:	03078793          	addi	a5,a5,48
80006866:	078a                	slli	a5,a5,0x2
80006868:	97b6                	add	a5,a5,a3
8000686a:	c398                	sw	a4,0(a5)

        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
8000686c:	a011                	j	80006870 <.L30>

8000686e <.L31>:
            NOP();
8000686e:	0001                	nop

80006870 <.L30>:
        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
80006870:	00a14703          	lbu	a4,10(sp)
80006874:	00b14783          	lbu	a5,11(sp)
80006878:	863a                	mv	a2,a4
8000687a:	85be                	mv	a1,a5
8000687c:	4532                	lw	a0,12(sp)
8000687e:	3f05                	jal	800067ae <pllctlv2_pll_clk_is_stable>
80006880:	87aa                	mv	a5,a0
80006882:	0017c793          	xori	a5,a5,1
80006886:	0ff7f793          	zext.b	a5,a5
8000688a:	f3f5                	bnez	a5,8000686e <.L31>

8000688c <.L32>:
        }
    }
}
8000688c:	0001                	nop
8000688e:	40f2                	lw	ra,28(sp)
80006890:	6105                	addi	sp,sp,32
80006892:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_freq_in_hz:

80006894 <pllctlv2_get_pll_freq_in_hz>:

uint32_t pllctlv2_get_pll_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
80006894:	7139                	addi	sp,sp,-64
80006896:	de06                	sw	ra,60(sp)
80006898:	c62a                	sw	a0,12(sp)
8000689a:	87ae                	mv	a5,a1
8000689c:	00f105a3          	sb	a5,11(sp)
    uint32_t freq = 0;
800068a0:	d602                	sw	zero,44(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
800068a2:	47b2                	lw	a5,12(sp)
800068a4:	12078963          	beqz	a5,800069d6 <.L34>
800068a8:	00b14703          	lbu	a4,11(sp)
800068ac:	4785                	li	a5,1
800068ae:	12e7e463          	bltu	a5,a4,800069d6 <.L34>

800068b2 <.LBB3>:
        uint32_t mfi = PLLCTLV2_PLL_MFI_MFI_GET(ptr->PLL[pll].MFI);
800068b2:	00b14783          	lbu	a5,11(sp)
800068b6:	4732                	lw	a4,12(sp)
800068b8:	0785                	addi	a5,a5,1
800068ba:	079e                	slli	a5,a5,0x7
800068bc:	97ba                	add	a5,a5,a4
800068be:	439c                	lw	a5,0(a5)
800068c0:	07f7f793          	andi	a5,a5,127
800068c4:	d23e                	sw	a5,36(sp)
        uint32_t mfn = PLLCTLV2_PLL_MFN_MFN_GET(ptr->PLL[pll].MFN);
800068c6:	00b14783          	lbu	a5,11(sp)
800068ca:	4732                	lw	a4,12(sp)
800068cc:	0785                	addi	a5,a5,1
800068ce:	079e                	slli	a5,a5,0x7
800068d0:	97ba                	add	a5,a5,a4
800068d2:	43d8                	lw	a4,4(a5)
800068d4:	400007b7          	lui	a5,0x40000
800068d8:	17fd                	addi	a5,a5,-1 # 3fffffff <_flash_size+0x3fefffff>
800068da:	8ff9                	and	a5,a5,a4
800068dc:	d03e                	sw	a5,32(sp)
        uint32_t mfd = PLLCTLV2_PLL_MFD_MFD_GET(ptr->PLL[pll].MFD);
800068de:	00b14783          	lbu	a5,11(sp)
800068e2:	4732                	lw	a4,12(sp)
800068e4:	0785                	addi	a5,a5,1
800068e6:	079e                	slli	a5,a5,0x7
800068e8:	97ba                	add	a5,a5,a4
800068ea:	4798                	lw	a4,8(a5)
800068ec:	400007b7          	lui	a5,0x40000
800068f0:	17fd                	addi	a5,a5,-1 # 3fffffff <_flash_size+0x3fefffff>
800068f2:	8ff9                	and	a5,a5,a4
800068f4:	ce3e                	sw	a5,28(sp)
        /* Trade-off for avoiding the float computing.
         * Ensure both `mfd` and `PLLCTLV2_PLL_XTAL_FREQ` are n * `FREQ_1MHz`, n is a positive integer
         */
        assert((mfd / FREQ_1MHz) * FREQ_1MHz == mfd);
800068f6:	4772                	lw	a4,28(sp)
800068f8:	431be7b7          	lui	a5,0x431be
800068fc:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
80006900:	02f737b3          	mulhu	a5,a4,a5
80006904:	83c9                	srli	a5,a5,0x12
80006906:	000f46b7          	lui	a3,0xf4
8000690a:	24068693          	addi	a3,a3,576 # f4240 <__DLM_segment_end__+0x54240>
8000690e:	02d787b3          	mul	a5,a5,a3
80006912:	40f707b3          	sub	a5,a4,a5
80006916:	cb89                	beqz	a5,80006928 <.L35>
80006918:	06f00613          	li	a2,111
8000691c:	03418593          	addi	a1,gp,52 # 800038c4 <.LC0>
80006920:	09c18513          	addi	a0,gp,156 # 8000392c <.LC1>
80006924:	ecffd0ef          	jal	800047f2 <__SEGGER_RTL_X_assert>

80006928 <.L35>:
        assert((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * FREQ_1MHz == PLLCTLV2_PLL_XTAL_FREQ);

        uint32_t scaled_num;
        uint32_t scaled_denom;
        uint32_t shifted_mfn;
        uint32_t max_mfn = 0xFFFFFFFF / (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz);
80006928:	0aaab7b7          	lui	a5,0xaaab
8000692c:	aaa78793          	addi	a5,a5,-1366 # aaaaaaa <_flash_size+0xa9aaaaa>
80006930:	cc3e                	sw	a5,24(sp)
        if (mfn < max_mfn) {
80006932:	5702                	lw	a4,32(sp)
80006934:	47e2                	lw	a5,24(sp)
80006936:	02f77f63          	bgeu	a4,a5,80006974 <.L36>
            scaled_num =  (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * mfn;
8000693a:	5702                	lw	a4,32(sp)
8000693c:	87ba                	mv	a5,a4
8000693e:	0786                	slli	a5,a5,0x1
80006940:	97ba                	add	a5,a5,a4
80006942:	078e                	slli	a5,a5,0x3
80006944:	c83e                	sw	a5,16(sp)
            scaled_denom = mfd / FREQ_1MHz;
80006946:	4772                	lw	a4,28(sp)
80006948:	431be7b7          	lui	a5,0x431be
8000694c:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
80006950:	02f737b3          	mulhu	a5,a4,a5
80006954:	83c9                	srli	a5,a5,0x12
80006956:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + scaled_num / scaled_denom;
80006958:	5712                	lw	a4,36(sp)
8000695a:	016e37b7          	lui	a5,0x16e3
8000695e:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006962:	02f70733          	mul	a4,a4,a5
80006966:	46c2                	lw	a3,16(sp)
80006968:	47d2                	lw	a5,20(sp)
8000696a:	02f6d7b3          	divu	a5,a3,a5
8000696e:	97ba                	add	a5,a5,a4
80006970:	d63e                	sw	a5,44(sp)
80006972:	a095                	j	800069d6 <.L34>

80006974 <.L36>:
        } else {
            shifted_mfn = mfn;
80006974:	5782                	lw	a5,32(sp)
80006976:	d43e                	sw	a5,40(sp)
            while (shifted_mfn > max_mfn) {
80006978:	a021                	j	80006980 <.L37>

8000697a <.L38>:
                shifted_mfn >>= 1;
8000697a:	57a2                	lw	a5,40(sp)
8000697c:	8385                	srli	a5,a5,0x1
8000697e:	d43e                	sw	a5,40(sp)

80006980 <.L37>:
            while (shifted_mfn > max_mfn) {
80006980:	5722                	lw	a4,40(sp)
80006982:	47e2                	lw	a5,24(sp)
80006984:	fee7ebe3          	bltu	a5,a4,8000697a <.L38>
            }
            scaled_denom = mfd / FREQ_1MHz;
80006988:	4772                	lw	a4,28(sp)
8000698a:	431be7b7          	lui	a5,0x431be
8000698e:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
80006992:	02f737b3          	mulhu	a5,a4,a5
80006996:	83c9                	srli	a5,a5,0x12
80006998:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * shifted_mfn) / scaled_denom +  ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * (mfn - shifted_mfn)) / scaled_denom;
8000699a:	5712                	lw	a4,36(sp)
8000699c:	016e37b7          	lui	a5,0x16e3
800069a0:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
800069a4:	02f706b3          	mul	a3,a4,a5
800069a8:	5722                	lw	a4,40(sp)
800069aa:	87ba                	mv	a5,a4
800069ac:	0786                	slli	a5,a5,0x1
800069ae:	97ba                	add	a5,a5,a4
800069b0:	078e                	slli	a5,a5,0x3
800069b2:	873e                	mv	a4,a5
800069b4:	47d2                	lw	a5,20(sp)
800069b6:	02f757b3          	divu	a5,a4,a5
800069ba:	96be                	add	a3,a3,a5
800069bc:	5702                	lw	a4,32(sp)
800069be:	57a2                	lw	a5,40(sp)
800069c0:	8f1d                	sub	a4,a4,a5
800069c2:	87ba                	mv	a5,a4
800069c4:	0786                	slli	a5,a5,0x1
800069c6:	97ba                	add	a5,a5,a4
800069c8:	078e                	slli	a5,a5,0x3
800069ca:	873e                	mv	a4,a5
800069cc:	47d2                	lw	a5,20(sp)
800069ce:	02f757b3          	divu	a5,a4,a5
800069d2:	97b6                	add	a5,a5,a3
800069d4:	d63e                	sw	a5,44(sp)

800069d6 <.L34>:
        }
    }
    return freq;
800069d6:	57b2                	lw	a5,44(sp)
}
800069d8:	853e                	mv	a0,a5
800069da:	50f2                	lw	ra,60(sp)
800069dc:	6121                	addi	sp,sp,64
800069de:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_postdiv_freq_in_hz:

800069e0 <pllctlv2_get_pll_postdiv_freq_in_hz>:

uint32_t pllctlv2_get_pll_postdiv_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
800069e0:	7179                	addi	sp,sp,-48
800069e2:	d606                	sw	ra,44(sp)
800069e4:	c62a                	sw	a0,12(sp)
800069e6:	87ae                	mv	a5,a1
800069e8:	8732                	mv	a4,a2
800069ea:	00f105a3          	sb	a5,11(sp)
800069ee:	87ba                	mv	a5,a4
800069f0:	00f10523          	sb	a5,10(sp)
    uint32_t postdiv_freq = 0;
800069f4:	ce02                	sw	zero,28(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
800069f6:	47b2                	lw	a5,12(sp)
800069f8:	cba5                	beqz	a5,80006a68 <.L41>
800069fa:	00b14703          	lbu	a4,11(sp)
800069fe:	4785                	li	a5,1
80006a00:	06e7e463          	bltu	a5,a4,80006a68 <.L41>

80006a04 <.LBB4>:
        uint32_t postdiv = PLLCTLV2_PLL_DIV_DIV_GET(ptr->PLL[pll].DIV[clk]);
80006a04:	00b14683          	lbu	a3,11(sp)
80006a08:	00a14783          	lbu	a5,10(sp)
80006a0c:	4732                	lw	a4,12(sp)
80006a0e:	0696                	slli	a3,a3,0x5
80006a10:	97b6                	add	a5,a5,a3
80006a12:	03078793          	addi	a5,a5,48
80006a16:	078a                	slli	a5,a5,0x2
80006a18:	97ba                	add	a5,a5,a4
80006a1a:	439c                	lw	a5,0(a5)
80006a1c:	03f7f793          	andi	a5,a5,63
80006a20:	cc3e                	sw	a5,24(sp)
        uint32_t pll_freq = pllctlv2_get_pll_freq_in_hz(ptr, pll);
80006a22:	00b14783          	lbu	a5,11(sp)
80006a26:	85be                	mv	a1,a5
80006a28:	4532                	lw	a0,12(sp)
80006a2a:	35ad                	jal	80006894 <pllctlv2_get_pll_freq_in_hz>
80006a2c:	ca2a                	sw	a0,20(sp)
        postdiv_freq = (uint32_t) (pll_freq / (100 + postdiv * 100 / 5U) * 100);
80006a2e:	4762                	lw	a4,24(sp)
80006a30:	87ba                	mv	a5,a4
80006a32:	078a                	slli	a5,a5,0x2
80006a34:	97ba                	add	a5,a5,a4
80006a36:	00279713          	slli	a4,a5,0x2
80006a3a:	97ba                	add	a5,a5,a4
80006a3c:	078a                	slli	a5,a5,0x2
80006a3e:	873e                	mv	a4,a5
80006a40:	ccccd7b7          	lui	a5,0xccccd
80006a44:	ccd78793          	addi	a5,a5,-819 # cccccccd <__FLASH_segment_end__+0x4cbccccd>
80006a48:	02f737b3          	mulhu	a5,a4,a5
80006a4c:	8389                	srli	a5,a5,0x2
80006a4e:	06478793          	addi	a5,a5,100
80006a52:	4752                	lw	a4,20(sp)
80006a54:	02f75733          	divu	a4,a4,a5
80006a58:	87ba                	mv	a5,a4
80006a5a:	078a                	slli	a5,a5,0x2
80006a5c:	97ba                	add	a5,a5,a4
80006a5e:	00279713          	slli	a4,a5,0x2
80006a62:	97ba                	add	a5,a5,a4
80006a64:	078a                	slli	a5,a5,0x2
80006a66:	ce3e                	sw	a5,28(sp)

80006a68 <.L41>:
    }

    return postdiv_freq;
80006a68:	47f2                	lw	a5,28(sp)
}
80006a6a:	853e                	mv	a0,a5
80006a6c:	50b2                	lw	ra,44(sp)
80006a6e:	6145                	addi	sp,sp,48
80006a70:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

80006a72 <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
80006a72:	1101                	addi	sp,sp,-32
80006a74:	c62a                	sw	a0,12(sp)
80006a76:	87ae                	mv	a5,a1
80006a78:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80006a7c:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
80006a7e:	00a15703          	lhu	a4,10(sp)
80006a82:	25700793          	li	a5,599
80006a86:	00e7f863          	bgeu	a5,a4,80006a96 <.L26>
80006a8a:	00a15703          	lhu	a4,10(sp)
80006a8e:	55f00793          	li	a5,1375
80006a92:	00e7f463          	bgeu	a5,a4,80006a9a <.L27>

80006a96 <.L26>:
        return status_invalid_argument;
80006a96:	4789                	li	a5,2
80006a98:	a831                	j	80006ab4 <.L28>

80006a9a <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
80006a9a:	47b2                	lw	a5,12(sp)
80006a9c:	4b98                	lw	a4,16(a5)
80006a9e:	77fd                	lui	a5,0xfffff
80006aa0:	8f7d                	and	a4,a4,a5
80006aa2:	00a15683          	lhu	a3,10(sp)
80006aa6:	6785                	lui	a5,0x1
80006aa8:	17fd                	addi	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
80006aaa:	8ff5                	and	a5,a5,a3
80006aac:	8f5d                	or	a4,a4,a5
80006aae:	47b2                	lw	a5,12(sp)
80006ab0:	cb98                	sw	a4,16(a5)
    return stat;
80006ab2:	47f2                	lw	a5,28(sp)

80006ab4 <.L28>:
}
80006ab4:	853e                	mv	a0,a5
80006ab6:	6105                	addi	sp,sp,32
80006ab8:	8082                	ret

Disassembly of section .text.console_init:

80006aba <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
80006aba:	7139                	addi	sp,sp,-64
80006abc:	de06                	sw	ra,60(sp)
80006abe:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
80006ac0:	4785                	li	a5,1
80006ac2:	d63e                	sw	a5,44(sp)

    /* disable buffer in standard library */
    setvbuf(stdin, NULL, _IONBF, 0);
80006ac4:	000807b7          	lui	a5,0x80
80006ac8:	3507a783          	lw	a5,848(a5) # 80350 <stdin>
80006acc:	4681                	li	a3,0
80006ace:	4609                	li	a2,2
80006ad0:	4581                	li	a1,0
80006ad2:	853e                	mv	a0,a5
80006ad4:	24a9                	jal	80006d1e <setvbuf>
    setvbuf(stdout, NULL, _IONBF, 0);
80006ad6:	000807b7          	lui	a5,0x80
80006ada:	34c7a783          	lw	a5,844(a5) # 8034c <stdout>
80006ade:	4681                	li	a3,0
80006ae0:	4609                	li	a2,2
80006ae2:	4581                	li	a1,0
80006ae4:	853e                	mv	a0,a5
80006ae6:	2c25                	jal	80006d1e <setvbuf>

    if (cfg->type == CONSOLE_TYPE_UART) {
80006ae8:	47b2                	lw	a5,12(sp)
80006aea:	439c                	lw	a5,0(a5)
80006aec:	e7b9                	bnez	a5,80006b3a <.L2>

80006aee <.LBB2>:
        uart_config_t config = {0};
80006aee:	c802                	sw	zero,16(sp)
80006af0:	ca02                	sw	zero,20(sp)
80006af2:	cc02                	sw	zero,24(sp)
80006af4:	ce02                	sw	zero,28(sp)
80006af6:	d002                	sw	zero,32(sp)
80006af8:	d202                	sw	zero,36(sp)
80006afa:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
80006afc:	47b2                	lw	a5,12(sp)
80006afe:	43dc                	lw	a5,4(a5)
80006b00:	873e                	mv	a4,a5
80006b02:	081c                	addi	a5,sp,16
80006b04:	85be                	mv	a1,a5
80006b06:	853a                	mv	a0,a4
80006b08:	3e9d                	jal	8000667e <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
80006b0a:	47b2                	lw	a5,12(sp)
80006b0c:	479c                	lw	a5,8(a5)
80006b0e:	c83e                	sw	a5,16(sp)
        config.baudrate = cfg->baudrate;
80006b10:	47b2                	lw	a5,12(sp)
80006b12:	47dc                	lw	a5,12(a5)
80006b14:	ca3e                	sw	a5,20(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
80006b16:	47b2                	lw	a5,12(sp)
80006b18:	43dc                	lw	a5,4(a5)
80006b1a:	873e                	mv	a4,a5
80006b1c:	081c                	addi	a5,sp,16
80006b1e:	85be                	mv	a1,a5
80006b20:	853a                	mv	a0,a4
80006b22:	8d3fd0ef          	jal	800043f4 <uart_init>
80006b26:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
80006b28:	57b2                	lw	a5,44(sp)
80006b2a:	eb81                	bnez	a5,80006b3a <.L2>
            g_console_uart = (UART_Type *)cfg->base;
80006b2c:	47b2                	lw	a5,12(sp)
80006b2e:	43dc                	lw	a5,4(a5)
80006b30:	873e                	mv	a4,a5
80006b32:	000807b7          	lui	a5,0x80
80006b36:	32e7ae23          	sw	a4,828(a5) # 8033c <g_console_uart>

80006b3a <.L2>:
        }
    }

    return stat;
80006b3a:	57b2                	lw	a5,44(sp)
}
80006b3c:	853e                	mv	a0,a5
80006b3e:	50f2                	lw	ra,60(sp)
80006b40:	6121                	addi	sp,sp,64
80006b42:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

80006b44 <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
80006b44:	7179                	addi	sp,sp,-48
80006b46:	d606                	sw	ra,44(sp)
80006b48:	c62a                	sw	a0,12(sp)
80006b4a:	c42e                	sw	a1,8(sp)
80006b4c:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
80006b4e:	ce02                	sw	zero,28(sp)
80006b50:	a0b9                	j	80006b9e <.L13>

80006b52 <.L17>:
        if (data[count] == '\n') {
80006b52:	4722                	lw	a4,8(sp)
80006b54:	47f2                	lw	a5,28(sp)
80006b56:	97ba                	add	a5,a5,a4
80006b58:	0007c703          	lbu	a4,0(a5)
80006b5c:	47a9                	li	a5,10
80006b5e:	00f71d63          	bne	a4,a5,80006b78 <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
80006b62:	0001                	nop

80006b64 <.L15>:
80006b64:	000807b7          	lui	a5,0x80
80006b68:	33c7a783          	lw	a5,828(a5) # 8033c <g_console_uart>
80006b6c:	45b5                	li	a1,13
80006b6e:	853e                	mv	a0,a5
80006b70:	a4ffd0ef          	jal	800045be <uart_send_byte>
80006b74:	87aa                	mv	a5,a0
80006b76:	f7fd                	bnez	a5,80006b64 <.L15>

80006b78 <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
80006b78:	0001                	nop

80006b7a <.L16>:
80006b7a:	000807b7          	lui	a5,0x80
80006b7e:	33c7a683          	lw	a3,828(a5) # 8033c <g_console_uart>
80006b82:	4722                	lw	a4,8(sp)
80006b84:	47f2                	lw	a5,28(sp)
80006b86:	97ba                	add	a5,a5,a4
80006b88:	0007c783          	lbu	a5,0(a5)
80006b8c:	85be                	mv	a1,a5
80006b8e:	8536                	mv	a0,a3
80006b90:	a2ffd0ef          	jal	800045be <uart_send_byte>
80006b94:	87aa                	mv	a5,a0
80006b96:	f3f5                	bnez	a5,80006b7a <.L16>
    for (count = 0; count < size; count++) {
80006b98:	47f2                	lw	a5,28(sp)
80006b9a:	0785                	addi	a5,a5,1
80006b9c:	ce3e                	sw	a5,28(sp)

80006b9e <.L13>:
80006b9e:	4772                	lw	a4,28(sp)
80006ba0:	4792                	lw	a5,4(sp)
80006ba2:	faf768e3          	bltu	a4,a5,80006b52 <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
80006ba6:	0001                	nop

80006ba8 <.L18>:
80006ba8:	000807b7          	lui	a5,0x80
80006bac:	33c7a783          	lw	a5,828(a5) # 8033c <g_console_uart>
80006bb0:	853e                	mv	a0,a5
80006bb2:	3685                	jal	80006712 <uart_flush>
80006bb4:	87aa                	mv	a5,a0
80006bb6:	fbed                	bnez	a5,80006ba8 <.L18>
    }
    return count;
80006bb8:	47f2                	lw	a5,28(sp)

}
80006bba:	853e                	mv	a0,a5
80006bbc:	50b2                	lw	ra,44(sp)
80006bbe:	6145                	addi	sp,sp,48
80006bc0:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

80006bc2 <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
80006bc2:	1141                	addi	sp,sp,-16
80006bc4:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
80006bc6:	4781                	li	a5,0
}
80006bc8:	853e                	mv	a0,a5
80006bca:	0141                	addi	sp,sp,16
80006bcc:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

80006bce <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
80006bce:	1141                	addi	sp,sp,-16
80006bd0:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
80006bd2:	4785                	li	a5,1
}
80006bd4:	853e                	mv	a0,a5
80006bd6:	0141                	addi	sp,sp,16
80006bd8:	8082                	ret

Disassembly of section .text.libc.__riscv_save_12:

80006bda <__riscv_save_12>:
80006bda:	7139                	addi	sp,sp,-64
80006bdc:	4301                	li	t1,0
80006bde:	c66e                	sw	s11,12(sp)
80006be0:	a019                	j	80006be6 <.L__riscv_save_s10_down>

80006be2 <__riscv_save_10>:
80006be2:	7139                	addi	sp,sp,-64
80006be4:	4341                	li	t1,16

80006be6 <.L__riscv_save_s10_down>:
80006be6:	c86a                	sw	s10,16(sp)
80006be8:	ca66                	sw	s9,20(sp)
80006bea:	cc62                	sw	s8,24(sp)
80006bec:	ce5e                	sw	s7,28(sp)
80006bee:	a021                	j	80006bf6 <.L__riscv_save_s6_down>

80006bf0 <__riscv_save_4>:
80006bf0:	7139                	addi	sp,sp,-64
80006bf2:	02000313          	li	t1,32

80006bf6 <.L__riscv_save_s6_down>:
80006bf6:	d05a                	sw	s6,32(sp)
80006bf8:	d256                	sw	s5,36(sp)
80006bfa:	d452                	sw	s4,40(sp)
80006bfc:	d64e                	sw	s3,44(sp)
80006bfe:	d84a                	sw	s2,48(sp)
80006c00:	da26                	sw	s1,52(sp)
80006c02:	dc22                	sw	s0,56(sp)
80006c04:	de06                	sw	ra,60(sp)
80006c06:	911a                	add	sp,sp,t1
80006c08:	8282                	jr	t0

Disassembly of section .text.libc.__riscv_restore_12:

80006c0a <__riscv_restore_12>:
80006c0a:	4db2                	lw	s11,12(sp)
80006c0c:	0141                	addi	sp,sp,16

80006c0e <__riscv_restore_11>:
80006c0e:	4d02                	lw	s10,0(sp)

80006c10 <__riscv_restore_10>:
80006c10:	4c92                	lw	s9,4(sp)

80006c12 <__riscv_restore_9>:
80006c12:	4c22                	lw	s8,8(sp)

80006c14 <__riscv_restore_8>:
80006c14:	4bb2                	lw	s7,12(sp)
80006c16:	0141                	addi	sp,sp,16

80006c18 <__riscv_restore_7>:
80006c18:	4b02                	lw	s6,0(sp)

80006c1a <__riscv_restore_6>:
80006c1a:	4a92                	lw	s5,4(sp)

80006c1c <__riscv_restore_5>:
80006c1c:	4a22                	lw	s4,8(sp)

80006c1e <__riscv_restore_4>:
80006c1e:	49b2                	lw	s3,12(sp)
80006c20:	0141                	addi	sp,sp,16

80006c22 <__riscv_restore_3>:
80006c22:	4902                	lw	s2,0(sp)

80006c24 <__riscv_restore_2>:
80006c24:	4492                	lw	s1,4(sp)

80006c26 <__riscv_restore_1>:
80006c26:	4422                	lw	s0,8(sp)

80006c28 <__riscv_restore_0>:
80006c28:	40b2                	lw	ra,12(sp)
80006c2a:	0141                	addi	sp,sp,16
80006c2c:	8082                	ret

Disassembly of section .text.libc.itoa:

80006c2e <itoa>:
80006c2e:	1141                	addi	sp,sp,-16
80006c30:	c606                	sw	ra,12(sp)
80006c32:	c422                	sw	s0,8(sp)
80006c34:	842e                	mv	s0,a1
80006c36:	00055963          	bgez	a0,80006c48 <itoa+0x1a>
80006c3a:	45a9                	li	a1,10
80006c3c:	00b61663          	bne	a2,a1,80006c48 <itoa+0x1a>
80006c40:	4629                	li	a2,10
80006c42:	4685                	li	a3,1
80006c44:	85a2                	mv	a1,s0
80006c46:	a019                	j	80006c4c <itoa+0x1e>
80006c48:	85a2                	mv	a1,s0
80006c4a:	4681                	li	a3,0
80006c4c:	b3dfd0ef          	jal	80004788 <__SEGGER_RTL_xtoa>
80006c50:	8522                	mv	a0,s0
80006c52:	40b2                	lw	ra,12(sp)
80006c54:	4422                	lw	s0,8(sp)
80006c56:	0141                	addi	sp,sp,16
80006c58:	8082                	ret

Disassembly of section .text.libc.abort:

80006c5a <abort>:
80006c5a:	1141                	addi	sp,sp,-16
80006c5c:	c606                	sw	ra,12(sp)
80006c5e:	4501                	li	a0,0
80006c60:	2011                	jal	80006c64 <raise>
80006c62:	bff5                	j	80006c5e <abort+0x4>

Disassembly of section .text.libc.raise:

80006c64 <raise>:
80006c64:	1141                	addi	sp,sp,-16
80006c66:	c606                	sw	ra,12(sp)
80006c68:	4615                	li	a2,5
80006c6a:	55fd                	li	a1,-1
80006c6c:	02a66f63          	bltu	a2,a0,80006caa <raise+0x46>
80006c70:	00251693          	slli	a3,a0,0x2
80006c74:	00080637          	lui	a2,0x80
80006c78:	31460613          	addi	a2,a2,788 # 80314 <__SEGGER_RTL_aSigTab>
80006c7c:	96b2                	add	a3,a3,a2
80006c7e:	4290                	lw	a2,0(a3)
80006c80:	80005737          	lui	a4,0x80005
80006c84:	84470713          	addi	a4,a4,-1980 # 80004844 <__SEGGER_RTL_SIGNAL_SIG_IGN>
80006c88:	c298                	sw	a4,0(a3)
80006c8a:	c605                	beqz	a2,80006cb2 <raise+0x4e>
80006c8c:	01e18793          	addi	a5,gp,30 # 800038ae <__SEGGER_RTL_SIGNAL_SIG_ERR>
80006c90:	00f60d63          	beq	a2,a5,80006caa <raise+0x46>
80006c94:	00e60a63          	beq	a2,a4,80006ca8 <raise+0x44>
80006c98:	800035b7          	lui	a1,0x80003
80006c9c:	06658593          	addi	a1,a1,102 # 80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>
80006ca0:	00b60963          	beq	a2,a1,80006cb2 <raise+0x4e>
80006ca4:	c28c                	sw	a1,0(a3)
80006ca6:	9602                	jalr	a2
80006ca8:	4581                	li	a1,0
80006caa:	852e                	mv	a0,a1
80006cac:	40b2                	lw	ra,12(sp)
80006cae:	0141                	addi	sp,sp,16
80006cb0:	8082                	ret
80006cb2:	4505                	li	a0,1
80006cb4:	ba4fc0ef          	jal	80003058 <exit>

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

80006cb8 <__SEGGER_RTL_puts_no_nl>:
80006cb8:	1141                	addi	sp,sp,-16
80006cba:	c606                	sw	ra,12(sp)
80006cbc:	c422                	sw	s0,8(sp)
80006cbe:	c226                	sw	s1,4(sp)
80006cc0:	000805b7          	lui	a1,0x80
80006cc4:	34c5a403          	lw	s0,844(a1) # 8034c <stdout>
80006cc8:	84aa                	mv	s1,a0
80006cca:	69b000ef          	jal	80007b64 <strlen>
80006cce:	862a                	mv	a2,a0
80006cd0:	8522                	mv	a0,s0
80006cd2:	85a6                	mv	a1,s1
80006cd4:	40b2                	lw	ra,12(sp)
80006cd6:	4422                	lw	s0,8(sp)
80006cd8:	4492                	lw	s1,4(sp)
80006cda:	0141                	addi	sp,sp,16
80006cdc:	b5a5                	j	80006b44 <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.fwrite:

80006cde <fwrite>:
80006cde:	1101                	addi	sp,sp,-32
80006ce0:	ce06                	sw	ra,28(sp)
80006ce2:	cc22                	sw	s0,24(sp)
80006ce4:	ca26                	sw	s1,20(sp)
80006ce6:	c84a                	sw	s2,16(sp)
80006ce8:	c64e                	sw	s3,12(sp)
80006cea:	84b6                	mv	s1,a3
80006cec:	89b2                	mv	s3,a2
80006cee:	842e                	mv	s0,a1
80006cf0:	892a                	mv	s2,a0
80006cf2:	8536                	mv	a0,a3
80006cf4:	35f9                	jal	80006bc2 <__SEGGER_RTL_X_file_stat>
80006cf6:	00054663          	bltz	a0,80006d02 <fwrite+0x24>
80006cfa:	02898633          	mul	a2,s3,s0
80006cfe:	00867463          	bgeu	a2,s0,80006d06 <fwrite+0x28>
80006d02:	4501                	li	a0,0
80006d04:	a031                	j	80006d10 <fwrite+0x32>
80006d06:	8526                	mv	a0,s1
80006d08:	85ca                	mv	a1,s2
80006d0a:	3d2d                	jal	80006b44 <__SEGGER_RTL_X_file_write>
80006d0c:	02855533          	divu	a0,a0,s0
80006d10:	40f2                	lw	ra,28(sp)
80006d12:	4462                	lw	s0,24(sp)
80006d14:	44d2                	lw	s1,20(sp)
80006d16:	4942                	lw	s2,16(sp)
80006d18:	49b2                	lw	s3,12(sp)
80006d1a:	6105                	addi	sp,sp,32
80006d1c:	8082                	ret

Disassembly of section .text.libc.setvbuf:

80006d1e <setvbuf>:
80006d1e:	4501                	li	a0,0
80006d20:	8082                	ret

Disassembly of section .text.libc.__mulsf3:

80006d22 <__mulsf3>:
80006d22:	80000737          	lui	a4,0x80000
80006d26:	0ff00293          	li	t0,255
80006d2a:	00b547b3          	xor	a5,a0,a1
80006d2e:	8ff9                	and	a5,a5,a4
80006d30:	00151613          	slli	a2,a0,0x1
80006d34:	8261                	srli	a2,a2,0x18
80006d36:	00159693          	slli	a3,a1,0x1
80006d3a:	82e1                	srli	a3,a3,0x18
80006d3c:	ce29                	beqz	a2,80006d96 <.L__mulsf3_lhs_zero_or_subnormal>
80006d3e:	c6bd                	beqz	a3,80006dac <.L__mulsf3_rhs_zero_or_subnormal>
80006d40:	04560f63          	beq	a2,t0,80006d9e <.L__mulsf3_lhs_inf_or_nan>
80006d44:	06568963          	beq	a3,t0,80006db6 <.L__mulsf3_rhs_inf_or_nan>
80006d48:	9636                	add	a2,a2,a3
80006d4a:	0522                	slli	a0,a0,0x8
80006d4c:	8d59                	or	a0,a0,a4
80006d4e:	05a2                	slli	a1,a1,0x8
80006d50:	8dd9                	or	a1,a1,a4
80006d52:	02b506b3          	mul	a3,a0,a1
80006d56:	02b53533          	mulhu	a0,a0,a1
80006d5a:	00d036b3          	snez	a3,a3
80006d5e:	8d55                	or	a0,a0,a3
80006d60:	00054463          	bltz	a0,80006d68 <.L__mulsf3_normalized>
80006d64:	0506                	slli	a0,a0,0x1
80006d66:	167d                	addi	a2,a2,-1

80006d68 <.L__mulsf3_normalized>:
80006d68:	f8160613          	addi	a2,a2,-127
80006d6c:	04064863          	bltz	a2,80006dbc <.L__mulsf3_zero_or_underflow>
80006d70:	12fd                	addi	t0,t0,-1 # ffffffff <__AHB_SRAM_segment_end__+0xfbf7fff>
80006d72:	00565f63          	bge	a2,t0,80006d90 <.L__mulsf3_inf>
80006d76:	01851693          	slli	a3,a0,0x18
80006d7a:	8121                	srli	a0,a0,0x8
80006d7c:	065e                	slli	a2,a2,0x17
80006d7e:	9532                	add	a0,a0,a2
80006d80:	0006d663          	bgez	a3,80006d8c <.L__mulsf3_apply_sign>
80006d84:	0505                	addi	a0,a0,1 # 1020001 <_flash_size+0xf20001>
80006d86:	0686                	slli	a3,a3,0x1
80006d88:	e291                	bnez	a3,80006d8c <.L__mulsf3_apply_sign>
80006d8a:	9979                	andi	a0,a0,-2

80006d8c <.L__mulsf3_apply_sign>:
80006d8c:	8d5d                	or	a0,a0,a5
80006d8e:	8082                	ret

80006d90 <.L__mulsf3_inf>:
80006d90:	7f800537          	lui	a0,0x7f800
80006d94:	bfe5                	j	80006d8c <.L__mulsf3_apply_sign>

80006d96 <.L__mulsf3_lhs_zero_or_subnormal>:
80006d96:	00568d63          	beq	a3,t0,80006db0 <.L__mulsf3_nan>

80006d9a <.L__mulsf3_signed_zero>:
80006d9a:	853e                	mv	a0,a5
80006d9c:	8082                	ret

80006d9e <.L__mulsf3_lhs_inf_or_nan>:
80006d9e:	0526                	slli	a0,a0,0x9
80006da0:	e901                	bnez	a0,80006db0 <.L__mulsf3_nan>
80006da2:	fe5697e3          	bne	a3,t0,80006d90 <.L__mulsf3_inf>
80006da6:	05a6                	slli	a1,a1,0x9
80006da8:	e581                	bnez	a1,80006db0 <.L__mulsf3_nan>
80006daa:	b7dd                	j	80006d90 <.L__mulsf3_inf>

80006dac <.L__mulsf3_rhs_zero_or_subnormal>:
80006dac:	fe5617e3          	bne	a2,t0,80006d9a <.L__mulsf3_signed_zero>

80006db0 <.L__mulsf3_nan>:
80006db0:	7fc00537          	lui	a0,0x7fc00
80006db4:	8082                	ret

80006db6 <.L__mulsf3_rhs_inf_or_nan>:
80006db6:	05a6                	slli	a1,a1,0x9
80006db8:	fde5                	bnez	a1,80006db0 <.L__mulsf3_nan>
80006dba:	bfd9                	j	80006d90 <.L__mulsf3_inf>

80006dbc <.L__mulsf3_zero_or_underflow>:
80006dbc:	0605                	addi	a2,a2,1
80006dbe:	fe71                	bnez	a2,80006d9a <.L__mulsf3_signed_zero>
80006dc0:	8521                	srai	a0,a0,0x8
80006dc2:	00150293          	addi	t0,a0,1 # 7fc00001 <_flash_size+0x7fb00001>
80006dc6:	0509                	addi	a0,a0,2
80006dc8:	fc0299e3          	bnez	t0,80006d9a <.L__mulsf3_signed_zero>
80006dcc:	00800537          	lui	a0,0x800
80006dd0:	bf75                	j	80006d8c <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__divsf3:

80006dd2 <__divsf3>:
80006dd2:	0ff00293          	li	t0,255
80006dd6:	00151713          	slli	a4,a0,0x1
80006dda:	8361                	srli	a4,a4,0x18
80006ddc:	00159793          	slli	a5,a1,0x1
80006de0:	83e1                	srli	a5,a5,0x18
80006de2:	00b54333          	xor	t1,a0,a1
80006de6:	01f35313          	srli	t1,t1,0x1f
80006dea:	037e                	slli	t1,t1,0x1f
80006dec:	cf4d                	beqz	a4,80006ea6 <.L__divsf3_lhs_zero_or_subnormal>
80006dee:	cbe9                	beqz	a5,80006ec0 <.L__divsf3_rhs_zero_or_subnormal>
80006df0:	0c570363          	beq	a4,t0,80006eb6 <.L__divsf3_lhs_inf_or_nan>
80006df4:	0c578b63          	beq	a5,t0,80006eca <.L__divsf3_rhs_inf_or_nan>
80006df8:	8f1d                	sub	a4,a4,a5

80006dfa <.Lpcrel_hi0>:
80006dfa:	d0018293          	addi	t0,gp,-768 # 80003590 <__SEGGER_RTL_fdiv_reciprocal_table>
80006dfe:	00f5d693          	srli	a3,a1,0xf
80006e02:	0fc6f693          	andi	a3,a3,252
80006e06:	9696                	add	a3,a3,t0
80006e08:	429c                	lw	a5,0(a3)
80006e0a:	4187d613          	srai	a2,a5,0x18
80006e0e:	00f59693          	slli	a3,a1,0xf
80006e12:	82e1                	srli	a3,a3,0x18
80006e14:	0016f293          	andi	t0,a3,1
80006e18:	8285                	srli	a3,a3,0x1
80006e1a:	fc068693          	addi	a3,a3,-64
80006e1e:	9696                	add	a3,a3,t0
80006e20:	02d60633          	mul	a2,a2,a3
80006e24:	07a2                	slli	a5,a5,0x8
80006e26:	83a1                	srli	a5,a5,0x8
80006e28:	963e                	add	a2,a2,a5
80006e2a:	05a2                	slli	a1,a1,0x8
80006e2c:	81a1                	srli	a1,a1,0x8
80006e2e:	008007b7          	lui	a5,0x800
80006e32:	8ddd                	or	a1,a1,a5
80006e34:	02c586b3          	mul	a3,a1,a2
80006e38:	0522                	slli	a0,a0,0x8
80006e3a:	8121                	srli	a0,a0,0x8
80006e3c:	8d5d                	or	a0,a0,a5
80006e3e:	02c697b3          	mulh	a5,a3,a2
80006e42:	00b532b3          	sltu	t0,a0,a1
80006e46:	00551533          	sll	a0,a0,t0
80006e4a:	40570733          	sub	a4,a4,t0
80006e4e:	01465693          	srli	a3,a2,0x14
80006e52:	8a85                	andi	a3,a3,1
80006e54:	0016c693          	xori	a3,a3,1
80006e58:	062e                	slli	a2,a2,0xb
80006e5a:	8e1d                	sub	a2,a2,a5
80006e5c:	8e15                	sub	a2,a2,a3
80006e5e:	050a                	slli	a0,a0,0x2
80006e60:	02a617b3          	mulh	a5,a2,a0
80006e64:	07e70613          	addi	a2,a4,126 # 8000007e <_flash_size+0x7ff0007e>
80006e68:	055a                	slli	a0,a0,0x16
80006e6a:	8d0d                	sub	a0,a0,a1
80006e6c:	02b786b3          	mul	a3,a5,a1
80006e70:	0fe00293          	li	t0,254
80006e74:	00567f63          	bgeu	a2,t0,80006e92 <.L__divsf3_underflow_or_overflow>
80006e78:	40a68533          	sub	a0,a3,a0
80006e7c:	000522b3          	sltz	t0,a0
80006e80:	9796                	add	a5,a5,t0
80006e82:	0017f513          	andi	a0,a5,1
80006e86:	8385                	srli	a5,a5,0x1
80006e88:	953e                	add	a0,a0,a5
80006e8a:	065e                	slli	a2,a2,0x17
80006e8c:	9532                	add	a0,a0,a2
80006e8e:	951a                	add	a0,a0,t1
80006e90:	8082                	ret

80006e92 <.L__divsf3_underflow_or_overflow>:
80006e92:	851a                	mv	a0,t1
80006e94:	00564563          	blt	a2,t0,80006e9e <.L__divsf3_done>
80006e98:	7f800337          	lui	t1,0x7f800

80006e9c <.L__divsf3_apply_sign>:
80006e9c:	951a                	add	a0,a0,t1

80006e9e <.L__divsf3_done>:
80006e9e:	8082                	ret

80006ea0 <.L__divsf3_inf>:
80006ea0:	7f800537          	lui	a0,0x7f800
80006ea4:	bfe5                	j	80006e9c <.L__divsf3_apply_sign>

80006ea6 <.L__divsf3_lhs_zero_or_subnormal>:
80006ea6:	c789                	beqz	a5,80006eb0 <.L__divsf3_nan>
80006ea8:	02579363          	bne	a5,t0,80006ece <.L__divsf3_signed_zero>
80006eac:	05a6                	slli	a1,a1,0x9
80006eae:	c185                	beqz	a1,80006ece <.L__divsf3_signed_zero>

80006eb0 <.L__divsf3_nan>:
80006eb0:	7fc00537          	lui	a0,0x7fc00
80006eb4:	8082                	ret

80006eb6 <.L__divsf3_lhs_inf_or_nan>:
80006eb6:	0526                	slli	a0,a0,0x9
80006eb8:	fd65                	bnez	a0,80006eb0 <.L__divsf3_nan>
80006eba:	fe5793e3          	bne	a5,t0,80006ea0 <.L__divsf3_inf>
80006ebe:	bfcd                	j	80006eb0 <.L__divsf3_nan>

80006ec0 <.L__divsf3_rhs_zero_or_subnormal>:
80006ec0:	fe5710e3          	bne	a4,t0,80006ea0 <.L__divsf3_inf>
80006ec4:	0526                	slli	a0,a0,0x9
80006ec6:	f56d                	bnez	a0,80006eb0 <.L__divsf3_nan>
80006ec8:	bfe1                	j	80006ea0 <.L__divsf3_inf>

80006eca <.L__divsf3_rhs_inf_or_nan>:
80006eca:	05a6                	slli	a1,a1,0x9
80006ecc:	f1f5                	bnez	a1,80006eb0 <.L__divsf3_nan>

80006ece <.L__divsf3_signed_zero>:
80006ece:	851a                	mv	a0,t1
80006ed0:	8082                	ret

Disassembly of section .text.libc.__eqsf2:

80006ed2 <__eqsf2>:
80006ed2:	ff000637          	lui	a2,0xff000
80006ed6:	00151693          	slli	a3,a0,0x1
80006eda:	02d66063          	bltu	a2,a3,80006efa <.L__eqsf2_one>
80006ede:	00159693          	slli	a3,a1,0x1
80006ee2:	00d66c63          	bltu	a2,a3,80006efa <.L__eqsf2_one>
80006ee6:	00b56633          	or	a2,a0,a1
80006eea:	0606                	slli	a2,a2,0x1
80006eec:	c609                	beqz	a2,80006ef6 <.L__eqsf2_zero>
80006eee:	8d0d                	sub	a0,a0,a1
80006ef0:	00a03533          	snez	a0,a0
80006ef4:	8082                	ret

80006ef6 <.L__eqsf2_zero>:
80006ef6:	4501                	li	a0,0
80006ef8:	8082                	ret

80006efa <.L__eqsf2_one>:
80006efa:	4505                	li	a0,1
80006efc:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

80006efe <__fixunssfdi>:
80006efe:	04054a63          	bltz	a0,80006f52 <.L__fixunssfdi_zero_result>
80006f02:	00151613          	slli	a2,a0,0x1
80006f06:	8261                	srli	a2,a2,0x18
80006f08:	f8160613          	addi	a2,a2,-127 # feffff81 <__AHB_SRAM_segment_end__+0xebf7f81>
80006f0c:	04064363          	bltz	a2,80006f52 <.L__fixunssfdi_zero_result>
80006f10:	800006b7          	lui	a3,0x80000
80006f14:	02000293          	li	t0,32
80006f18:	00565b63          	bge	a2,t0,80006f2e <.L__fixunssfdi_long_shift>
80006f1c:	40c00633          	neg	a2,a2
80006f20:	067d                	addi	a2,a2,31
80006f22:	0522                	slli	a0,a0,0x8
80006f24:	8d55                	or	a0,a0,a3
80006f26:	00c55533          	srl	a0,a0,a2
80006f2a:	4581                	li	a1,0
80006f2c:	8082                	ret

80006f2e <.L__fixunssfdi_long_shift>:
80006f2e:	40c00633          	neg	a2,a2
80006f32:	03f60613          	addi	a2,a2,63
80006f36:	02064163          	bltz	a2,80006f58 <.L__fixunssfdi_overflow_result>
80006f3a:	00851593          	slli	a1,a0,0x8
80006f3e:	8dd5                	or	a1,a1,a3
80006f40:	4501                	li	a0,0
80006f42:	c619                	beqz	a2,80006f50 <.L__fixunssfdi_shift_32>
80006f44:	40c006b3          	neg	a3,a2
80006f48:	00d59533          	sll	a0,a1,a3
80006f4c:	00c5d5b3          	srl	a1,a1,a2

80006f50 <.L__fixunssfdi_shift_32>:
80006f50:	8082                	ret

80006f52 <.L__fixunssfdi_zero_result>:
80006f52:	4501                	li	a0,0
80006f54:	4581                	li	a1,0
80006f56:	8082                	ret

80006f58 <.L__fixunssfdi_overflow_result>:
80006f58:	557d                	li	a0,-1
80006f5a:	55fd                	li	a1,-1
80006f5c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

80006f5e <__SEGGER_RTL_ldouble_to_double>:
80006f5e:	00169793          	slli	a5,a3,0x1
80006f62:	453d                	li	a0,15
80006f64:	83c5                	srli	a5,a5,0x11
80006f66:	052a                	slli	a0,a0,0xa
80006f68:	80000837          	lui	a6,0x80000
80006f6c:	00f56663          	bltu	a0,a5,80006f78 <__SEGGER_RTL_ldouble_to_double+0x1a>
80006f70:	4501                	li	a0,0
80006f72:	0106f5b3          	and	a1,a3,a6
80006f76:	8082                	ret
80006f78:	5545                	li	a0,-15
80006f7a:	6711                	lui	a4,0x4
80006f7c:	052a                	slli	a0,a0,0xa
80006f7e:	953e                	add	a0,a0,a5
80006f80:	3ff70713          	addi	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
80006f84:	83a9                	srli	a5,a5,0xa
80006f86:	00e50963          	beq	a0,a4,80006f98 <__SEGGER_RTL_ldouble_to_double+0x3a>
80006f8a:	0117b713          	sltiu	a4,a5,17
80006f8e:	40e00733          	neg	a4,a4
80006f92:	8ef9                	and	a3,a3,a4
80006f94:	8e79                	and	a2,a2,a4
80006f96:	8df9                	and	a1,a1,a4
80006f98:	4741                	li	a4,16
80006f9a:	00f77463          	bgeu	a4,a5,80006fa2 <__SEGGER_RTL_ldouble_to_double+0x44>
80006f9e:	7ff00513          	li	a0,2047
80006fa2:	0106f733          	and	a4,a3,a6
80006fa6:	0552                	slli	a0,a0,0x14
80006fa8:	8d59                	or	a0,a0,a4
80006faa:	01c65713          	srli	a4,a2,0x1c
80006fae:	0692                	slli	a3,a3,0x4
80006fb0:	0612                	slli	a2,a2,0x4
80006fb2:	01c5d793          	srli	a5,a1,0x1c
80006fb6:	8ed9                	or	a3,a3,a4
80006fb8:	06b2                	slli	a3,a3,0xc
80006fba:	00c6d593          	srli	a1,a3,0xc
80006fbe:	8dc9                	or	a1,a1,a0
80006fc0:	00f66533          	or	a0,a2,a5
80006fc4:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

80006fc6 <__trunctfsf2>:
80006fc6:	1141                	addi	sp,sp,-16
80006fc8:	c606                	sw	ra,12(sp)
80006fca:	4118                	lw	a4,0(a0)
80006fcc:	414c                	lw	a1,4(a0)
80006fce:	4510                	lw	a2,8(a0)
80006fd0:	4554                	lw	a3,12(a0)
80006fd2:	853a                	mv	a0,a4
80006fd4:	3769                	jal	80006f5e <__SEGGER_RTL_ldouble_to_double>
80006fd6:	b7bfd0ef          	jal	80004b50 <__truncdfsf2>
80006fda:	40b2                	lw	ra,12(sp)
80006fdc:	0141                	addi	sp,sp,16
80006fde:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

80006fe0 <__SEGGER_RTL_float32_isnan>:
80006fe0:	0506                	slli	a0,a0,0x1
80006fe2:	ff0005b7          	lui	a1,0xff000
80006fe6:	00a5b533          	sltu	a0,a1,a0
80006fea:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

80006fec <__SEGGER_RTL_float32_isinf>:
80006fec:	0506                	slli	a0,a0,0x1
80006fee:	8105                	srli	a0,a0,0x1
80006ff0:	7f8005b7          	lui	a1,0x7f800
80006ff4:	8d2d                	xor	a0,a0,a1
80006ff6:	00153513          	seqz	a0,a0
80006ffa:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

80006ffc <__SEGGER_RTL_float32_isnormal>:
80006ffc:	00151593          	slli	a1,a0,0x1
80007000:	7f800637          	lui	a2,0x7f800
80007004:	81e1                	srli	a1,a1,0x18
80007006:	8d71                	and	a0,a0,a2
80007008:	0ff5b593          	sltiu	a1,a1,255
8000700c:	00a03533          	snez	a0,a0
80007010:	8d6d                	and	a0,a0,a1
80007012:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

80007014 <__SEGGER_RTL_float32_signbit>:
80007014:	817d                	srli	a0,a0,0x1f
80007016:	8082                	ret

Disassembly of section .text.libc.ldexpf:

80007018 <ldexpf>:
80007018:	00151613          	slli	a2,a0,0x1
8000701c:	8261                	srli	a2,a2,0x18
8000701e:	f0160693          	addi	a3,a2,-255 # 7f7fff01 <_flash_size+0x7f6fff01>
80007022:	f0200713          	li	a4,-254
80007026:	02e6ea63          	bltu	a3,a4,8000705a <ldexpf+0x42>
8000702a:	95b2                	add	a1,a1,a2
8000702c:	fff58613          	addi	a2,a1,-1 # 7f7fffff <_flash_size+0x7f6fffff>
80007030:	0fd00693          	li	a3,253
80007034:	00c6e963          	bltu	a3,a2,80007046 <ldexpf+0x2e>
80007038:	80800637          	lui	a2,0x80800
8000703c:	167d                	addi	a2,a2,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
8000703e:	8d71                	and	a0,a0,a2
80007040:	05de                	slli	a1,a1,0x17
80007042:	8d4d                	or	a0,a0,a1
80007044:	8082                	ret
80007046:	0015a593          	slti	a1,a1,1
8000704a:	80000637          	lui	a2,0x80000
8000704e:	8d71                	and	a0,a0,a2
80007050:	15fd                	addi	a1,a1,-1
80007052:	7f800637          	lui	a2,0x7f800
80007056:	8df1                	and	a1,a1,a2
80007058:	8d4d                	or	a0,a0,a1
8000705a:	8082                	ret

Disassembly of section .text.libc.fmodf:

8000705c <fmodf>:
8000705c:	b95ff2ef          	jal	t0,80006bf0 <__riscv_save_4>
80007060:	84aa                	mv	s1,a0
80007062:	01755993          	srli	s3,a0,0x17
80007066:	fff98513          	addi	a0,s3,-1
8000706a:	0fd00613          	li	a2,253
8000706e:	0ea66363          	bltu	a2,a0,80007154 <fmodf+0xf8>
80007072:	0175d513          	srli	a0,a1,0x17
80007076:	f0150513          	addi	a0,a0,-255 # 7fbfff01 <_flash_size+0x7fafff01>
8000707a:	f0200613          	li	a2,-254
8000707e:	0cc56b63          	bltu	a0,a2,80007154 <fmodf+0xf8>
80007082:	00149413          	slli	s0,s1,0x1
80007086:	8005                	srli	s0,s0,0x1
80007088:	80000537          	lui	a0,0x80000
8000708c:	00a4f933          	and	s2,s1,a0
80007090:	1085f063          	bgeu	a1,s0,80007190 <fmodf+0x134>
80007094:	00800637          	lui	a2,0x800
80007098:	0ff9f513          	zext.b	a0,s3
8000709c:	fff60693          	addi	a3,a2,-1 # 7fffff <_flash_size+0x6fffff>
800070a0:	c509                	beqz	a0,800070aa <fmodf+0x4e>
800070a2:	00d4f433          	and	s0,s1,a3
800070a6:	8c51                	or	s0,s0,a2
800070a8:	a831                	j	800070c4 <fmodf+0x68>
800070aa:	01745513          	srli	a0,s0,0x17
800070ae:	e911                	bnez	a0,800070c2 <fmodf+0x66>
800070b0:	8622                	mv	a2,s0
800070b2:	00161413          	slli	s0,a2,0x1
800070b6:	01665713          	srli	a4,a2,0x16
800070ba:	157d                	addi	a0,a0,-1 # 7fffffff <_flash_size+0x7fefffff>
800070bc:	8622                	mv	a2,s0
800070be:	db75                	beqz	a4,800070b2 <fmodf+0x56>
800070c0:	a011                	j	800070c4 <fmodf+0x68>
800070c2:	4501                	li	a0,0
800070c4:	00159613          	slli	a2,a1,0x1
800070c8:	8261                	srli	a2,a2,0x18
800070ca:	ca01                	beqz	a2,800070da <fmodf+0x7e>
800070cc:	8df5                	and	a1,a1,a3
800070ce:	008006b7          	lui	a3,0x800
800070d2:	8dd5                	or	a1,a1,a3
800070d4:	02a64063          	blt	a2,a0,800070f4 <fmodf+0x98>
800070d8:	a081                	j	80007118 <fmodf+0xbc>
800070da:	0175d613          	srli	a2,a1,0x17
800070de:	ea15                	bnez	a2,80007112 <fmodf+0xb6>
800070e0:	86ae                	mv	a3,a1
800070e2:	00169593          	slli	a1,a3,0x1
800070e6:	0166d713          	srli	a4,a3,0x16
800070ea:	167d                	addi	a2,a2,-1
800070ec:	86ae                	mv	a3,a1
800070ee:	db75                	beqz	a4,800070e2 <fmodf+0x86>
800070f0:	02a65463          	bge	a2,a0,80007118 <fmodf+0xbc>
800070f4:	40b406b3          	sub	a3,s0,a1
800070f8:	0006c563          	bltz	a3,80007102 <fmodf+0xa6>
800070fc:	04b40a63          	beq	s0,a1,80007150 <fmodf+0xf4>
80007100:	a011                	j	80007104 <fmodf+0xa8>
80007102:	86a2                	mv	a3,s0
80007104:	157d                	addi	a0,a0,-1
80007106:	00169413          	slli	s0,a3,0x1
8000710a:	fea645e3          	blt	a2,a0,800070f4 <fmodf+0x98>
8000710e:	8532                	mv	a0,a2
80007110:	a021                	j	80007118 <fmodf+0xbc>
80007112:	4601                	li	a2,0
80007114:	fea040e3          	bgtz	a0,800070f4 <fmodf+0x98>
80007118:	40b40633          	sub	a2,s0,a1
8000711c:	00064563          	bltz	a2,80007126 <fmodf+0xca>
80007120:	00b41463          	bne	s0,a1,80007128 <fmodf+0xcc>
80007124:	a035                	j	80007150 <fmodf+0xf4>
80007126:	8622                	mv	a2,s0
80007128:	01765593          	srli	a1,a2,0x17
8000712c:	e989                	bnez	a1,8000713e <fmodf+0xe2>
8000712e:	00161593          	slli	a1,a2,0x1
80007132:	01665693          	srli	a3,a2,0x16
80007136:	157d                	addi	a0,a0,-1
80007138:	862e                	mv	a2,a1
8000713a:	daf5                	beqz	a3,8000712e <fmodf+0xd2>
8000713c:	a011                	j	80007140 <fmodf+0xe4>
8000713e:	85b2                	mv	a1,a2
80007140:	04a05c63          	blez	a0,80007198 <fmodf+0x13c>
80007144:	fff50613          	addi	a2,a0,-1
80007148:	065e                	slli	a2,a2,0x17
8000714a:	964a                	add	a2,a2,s2
8000714c:	00c58933          	add	s2,a1,a2
80007150:	854a                	mv	a0,s2
80007152:	b4e9                	j	80006c1c <__riscv_restore_5>
80007154:	00149413          	slli	s0,s1,0x1
80007158:	ff000537          	lui	a0,0xff000
8000715c:	02856c63          	bltu	a0,s0,80007194 <fmodf+0x138>
80007160:	00159a13          	slli	s4,a1,0x1
80007164:	05456063          	bltu	a0,s4,800071a4 <fmodf+0x148>
80007168:	8005                	srli	s0,s0,0x1
8000716a:	7f800537          	lui	a0,0x7f800
8000716e:	7fc00937          	lui	s2,0x7fc00
80007172:	fca40fe3          	beq	s0,a0,80007150 <fmodf+0xf4>
80007176:	e409                	bnez	s0,80007180 <fmodf+0x124>
80007178:	852e                	mv	a0,a1
8000717a:	4581                	li	a1,0
8000717c:	3b99                	jal	80006ed2 <__eqsf2>
8000717e:	e919                	bnez	a0,80007194 <fmodf+0x138>
80007180:	001a5593          	srli	a1,s4,0x1
80007184:	d5f1                	beqz	a1,80007150 <fmodf+0xf4>
80007186:	7f800537          	lui	a0,0x7f800
8000718a:	eea59fe3          	bne	a1,a0,80007088 <fmodf+0x2c>
8000718e:	a019                	j	80007194 <fmodf+0x138>
80007190:	fc8580e3          	beq	a1,s0,80007150 <fmodf+0xf4>
80007194:	8926                	mv	s2,s1
80007196:	bf6d                	j	80007150 <fmodf+0xf4>
80007198:	4601                	li	a2,0
8000719a:	4685                	li	a3,1
8000719c:	8e89                	sub	a3,a3,a0
8000719e:	00d5d5b3          	srl	a1,a1,a3
800071a2:	b75d                	j	80007148 <fmodf+0xec>
800071a4:	892e                	mv	s2,a1
800071a6:	b76d                	j	80007150 <fmodf+0xf4>

Disassembly of section .text.libc.floorf:

800071a8 <floorf>:
800071a8:	00151593          	slli	a1,a0,0x1
800071ac:	81e1                	srli	a1,a1,0x18
800071ae:	fff58613          	addi	a2,a1,-1
800071b2:	0fe00693          	li	a3,254
800071b6:	04d67963          	bgeu	a2,a3,80007208 <floorf+0x60>
800071ba:	07e00613          	li	a2,126
800071be:	00b66763          	bltu	a2,a1,800071cc <floorf+0x24>
800071c2:	857d                	srai	a0,a0,0x1f
800071c4:	bf8005b7          	lui	a1,0xbf800
800071c8:	8d6d                	and	a0,a0,a1
800071ca:	8082                	ret
800071cc:	09500613          	li	a2,149
800071d0:	02b66b63          	bltu	a2,a1,80007206 <floorf+0x5e>
800071d4:	f8158593          	addi	a1,a1,-127 # bf7fff81 <__FLASH_segment_end__+0x3f6fff81>
800071d8:	ff800637          	lui	a2,0xff800
800071dc:	00052693          	slti	a3,a0,0
800071e0:	40b65633          	sra	a2,a2,a1
800071e4:	8e69                	and	a2,a2,a0
800071e6:	00b51533          	sll	a0,a0,a1
800071ea:	0016c693          	xori	a3,a3,1
800071ee:	0526                	slli	a0,a0,0x9
800071f0:	8125                	srli	a0,a0,0x9
800071f2:	00153513          	seqz	a0,a0
800071f6:	8d55                	or	a0,a0,a3
800071f8:	008006b7          	lui	a3,0x800
800071fc:	00b6d5b3          	srl	a1,a3,a1
80007200:	157d                	addi	a0,a0,-1 # 7f7fffff <_flash_size+0x7f6fffff>
80007202:	8d6d                	and	a0,a0,a1
80007204:	9532                	add	a0,a0,a2
80007206:	8082                	ret
80007208:	fdfd                	bnez	a1,80007206 <floorf+0x5e>
8000720a:	800005b7          	lui	a1,0x80000
8000720e:	bf6d                	j	800071c8 <floorf+0x20>

Disassembly of section .text.libc.__udivdi3:

80007210 <__udivdi3>:
80007210:	872e                	mv	a4,a1
80007212:	e2b1                	bnez	a3,80007256 <__udivdi3+0x46>
80007214:	2a070863          	beqz	a4,800074c4 <__udivdi3+0x2b4>
80007218:	01865793          	srli	a5,a2,0x18
8000721c:	8fd5                	or	a5,a5,a3
8000721e:	ef85                	bnez	a5,80007256 <__udivdi3+0x46>
80007220:	00563813          	sltiu	a6,a2,5
80007224:	0016b793          	seqz	a5,a3
80007228:	0107f7b3          	and	a5,a5,a6
8000722c:	3c078363          	beqz	a5,800075f2 <__udivdi3+0x3e2>
80007230:	4689                	li	a3,2
80007232:	3ec6ce63          	blt	a3,a2,8000762e <__udivdi3+0x41e>
80007236:	4785                	li	a5,1
80007238:	86aa                	mv	a3,a0
8000723a:	28f60f63          	beq	a2,a5,800074d8 <__udivdi3+0x2c8>
8000723e:	4681                	li	a3,0
80007240:	4789                	li	a5,2
80007242:	4701                	li	a4,0
80007244:	28f61a63          	bne	a2,a5,800074d8 <__udivdi3+0x2c8>
80007248:	8105                	srli	a0,a0,0x1
8000724a:	01f59693          	slli	a3,a1,0x1f
8000724e:	8ec9                	or	a3,a3,a0
80007250:	0015d713          	srli	a4,a1,0x1
80007254:	a451                	j	800074d8 <__udivdi3+0x2c8>
80007256:	14068e63          	beqz	a3,800073b2 <__udivdi3+0x1a2>
8000725a:	0106d813          	srli	a6,a3,0x10
8000725e:	00155293          	srli	t0,a0,0x1
80007262:	01f59713          	slli	a4,a1,0x1f
80007266:	0015d893          	srli	a7,a1,0x1
8000726a:	00165313          	srli	t1,a2,0x1
8000726e:	800073b7          	lui	t2,0x80007
80007272:	6fc38393          	addi	t2,t2,1788 # 800076fc <__SEGGER_RTL_Moeller_inverse_lut>
80007276:	00183793          	seqz	a5,a6
8000727a:	00e2e2b3          	or	t0,t0,a4
8000727e:	00479813          	slli	a6,a5,0x4
80007282:	010697b3          	sll	a5,a3,a6
80007286:	0187d713          	srli	a4,a5,0x18
8000728a:	00173713          	seqz	a4,a4
8000728e:	070e                	slli	a4,a4,0x3
80007290:	00e79e33          	sll	t3,a5,a4
80007294:	00e86833          	or	a6,a6,a4
80007298:	01ce5793          	srli	a5,t3,0x1c
8000729c:	0017b793          	seqz	a5,a5
800072a0:	078a                	slli	a5,a5,0x2
800072a2:	00fe1e33          	sll	t3,t3,a5
800072a6:	00f86833          	or	a6,a6,a5
800072aa:	01ee5713          	srli	a4,t3,0x1e
800072ae:	00173713          	seqz	a4,a4
800072b2:	0706                	slli	a4,a4,0x1
800072b4:	00ee17b3          	sll	a5,t3,a4
800072b8:	00e86733          	or	a4,a6,a4
800072bc:	fff7c793          	not	a5,a5
800072c0:	83fd                	srli	a5,a5,0x1f
800072c2:	8f5d                	or	a4,a4,a5
800072c4:	00e697b3          	sll	a5,a3,a4
800072c8:	01f74813          	xori	a6,a4,31
800072cc:	01035733          	srl	a4,t1,a6
800072d0:	00e7efb3          	or	t6,a5,a4
800072d4:	001ff313          	andi	t1,t6,1
800072d8:	016fd713          	srli	a4,t6,0x16
800072dc:	0706                	slli	a4,a4,0x1
800072de:	971e                	add	a4,a4,t2
800072e0:	c0075383          	lhu	t2,-1024(a4)
800072e4:	00bfd713          	srli	a4,t6,0xb
800072e8:	001fde13          	srli	t3,t6,0x1
800072ec:	00170e93          	addi	t4,a4,1
800072f0:	02738733          	mul	a4,t2,t2
800072f4:	03d73eb3          	mulhu	t4,a4,t4
800072f8:	8f7e                	mv	t5,t6
800072fa:	9e1a                	add	t3,t3,t1
800072fc:	40600333          	neg	t1,t1
80007300:	0392                	slli	t2,t2,0x4
80007302:	fffec713          	not	a4,t4
80007306:	93ba                	add	t2,t2,a4
80007308:	0013d713          	srli	a4,t2,0x1
8000730c:	00e37333          	and	t1,t1,a4
80007310:	87fe                	mv	a5,t6
80007312:	03c38733          	mul	a4,t2,t3
80007316:	40e30733          	sub	a4,t1,a4
8000731a:	00f39313          	slli	t1,t2,0xf
8000731e:	02e3b733          	mulhu	a4,t2,a4
80007322:	8305                	srli	a4,a4,0x1
80007324:	00e30e33          	add	t3,t1,a4
80007328:	03fe0333          	mul	t1,t3,t6
8000732c:	03fe33b3          	mulhu	t2,t3,t6
80007330:	9f1a                	add	t5,t5,t1
80007332:	006f3733          	sltu	a4,t5,t1
80007336:	97ba                	add	a5,a5,a4
80007338:	979e                	add	a5,a5,t2
8000733a:	40fe0733          	sub	a4,t3,a5
8000733e:	03173333          	mulhu	t1,a4,a7
80007342:	03170733          	mul	a4,a4,a7
80007346:	00e283b3          	add	t2,t0,a4
8000734a:	0053b7b3          	sltu	a5,t2,t0
8000734e:	989a                	add	a7,a7,t1
80007350:	00f88333          	add	t1,a7,a5
80007354:	00130893          	addi	a7,t1,1 # 7f800001 <_flash_size+0x7f700001>
80007358:	03f887b3          	mul	a5,a7,t6
8000735c:	40f287b3          	sub	a5,t0,a5
80007360:	00f3b733          	sltu	a4,t2,a5
80007364:	40e00733          	neg	a4,a4
80007368:	01f772b3          	and	t0,a4,t6
8000736c:	92be                	add	t0,t0,a5
8000736e:	00f3e363          	bltu	t2,a5,80007374 <__udivdi3+0x164>
80007372:	8346                	mv	t1,a7
80007374:	01f2b733          	sltu	a4,t0,t6
80007378:	00174713          	xori	a4,a4,1
8000737c:	971a                	add	a4,a4,t1
8000737e:	01075733          	srl	a4,a4,a6
80007382:	fff70793          	addi	a5,a4,-1
80007386:	00f73733          	sltu	a4,a4,a5
8000738a:	177d                	addi	a4,a4,-1
8000738c:	8ff9                	and	a5,a5,a4
8000738e:	02f68833          	mul	a6,a3,a5
80007392:	02f638b3          	mulhu	a7,a2,a5
80007396:	02f60733          	mul	a4,a2,a5
8000739a:	9846                	add	a6,a6,a7
8000739c:	41058833          	sub	a6,a1,a6
800073a0:	00e535b3          	sltu	a1,a0,a4
800073a4:	40b805b3          	sub	a1,a6,a1
800073a8:	12d58163          	beq	a1,a3,800074ca <__udivdi3+0x2ba>
800073ac:	00d5b533          	sltu	a0,a1,a3
800073b0:	a205                	j	800074d0 <__udivdi3+0x2c0>
800073b2:	10070963          	beqz	a4,800074c4 <__udivdi3+0x2b4>
800073b6:	12c77463          	bgeu	a4,a2,800074de <__udivdi3+0x2ce>
800073ba:	01065693          	srli	a3,a2,0x10
800073be:	00155893          	srli	a7,a0,0x1
800073c2:	80007837          	lui	a6,0x80007
800073c6:	6fc80813          	addi	a6,a6,1788 # 800076fc <__SEGGER_RTL_Moeller_inverse_lut>
800073ca:	0016b693          	seqz	a3,a3
800073ce:	0692                	slli	a3,a3,0x4
800073d0:	00d61733          	sll	a4,a2,a3
800073d4:	01875793          	srli	a5,a4,0x18
800073d8:	0017b793          	seqz	a5,a5
800073dc:	078e                	slli	a5,a5,0x3
800073de:	00f71733          	sll	a4,a4,a5
800073e2:	8edd                	or	a3,a3,a5
800073e4:	01c75793          	srli	a5,a4,0x1c
800073e8:	0017b793          	seqz	a5,a5
800073ec:	078a                	slli	a5,a5,0x2
800073ee:	00f71733          	sll	a4,a4,a5
800073f2:	8edd                	or	a3,a3,a5
800073f4:	01e75793          	srli	a5,a4,0x1e
800073f8:	0017b793          	seqz	a5,a5
800073fc:	0786                	slli	a5,a5,0x1
800073fe:	00f71733          	sll	a4,a4,a5
80007402:	8edd                	or	a3,a3,a5
80007404:	fff74713          	not	a4,a4
80007408:	837d                	srli	a4,a4,0x1f
8000740a:	8ed9                	or	a3,a3,a4
8000740c:	00d59733          	sll	a4,a1,a3
80007410:	01f6c793          	xori	a5,a3,31
80007414:	00d512b3          	sll	t0,a0,a3
80007418:	00d616b3          	sll	a3,a2,a3
8000741c:	00f8d633          	srl	a2,a7,a5
80007420:	0016f593          	andi	a1,a3,1
80007424:	00b6d793          	srli	a5,a3,0xb
80007428:	0166d513          	srli	a0,a3,0x16
8000742c:	0506                	slli	a0,a0,0x1
8000742e:	9542                	add	a0,a0,a6
80007430:	c0055503          	lhu	a0,-1024(a0)
80007434:	0016d813          	srli	a6,a3,0x1
80007438:	00c768b3          	or	a7,a4,a2
8000743c:	0785                	addi	a5,a5,1 # 800001 <_flash_size+0x700001>
8000743e:	02a50733          	mul	a4,a0,a0
80007442:	02f73733          	mulhu	a4,a4,a5
80007446:	87b6                	mv	a5,a3
80007448:	982e                	add	a6,a6,a1
8000744a:	40b005b3          	neg	a1,a1
8000744e:	0512                	slli	a0,a0,0x4
80007450:	fff74713          	not	a4,a4
80007454:	953a                	add	a0,a0,a4
80007456:	00155713          	srli	a4,a0,0x1
8000745a:	8df9                	and	a1,a1,a4
8000745c:	8736                	mv	a4,a3
8000745e:	03050633          	mul	a2,a0,a6
80007462:	8d91                	sub	a1,a1,a2
80007464:	00f51613          	slli	a2,a0,0xf
80007468:	02b53533          	mulhu	a0,a0,a1
8000746c:	8105                	srli	a0,a0,0x1
8000746e:	9532                	add	a0,a0,a2
80007470:	02d505b3          	mul	a1,a0,a3
80007474:	02d53633          	mulhu	a2,a0,a3
80007478:	97ae                	add	a5,a5,a1
8000747a:	00b7b5b3          	sltu	a1,a5,a1
8000747e:	972e                	add	a4,a4,a1
80007480:	9732                	add	a4,a4,a2
80007482:	8d19                	sub	a0,a0,a4
80007484:	031535b3          	mulhu	a1,a0,a7
80007488:	03150533          	mul	a0,a0,a7
8000748c:	00a28733          	add	a4,t0,a0
80007490:	00573533          	sltu	a0,a4,t0
80007494:	95c6                	add	a1,a1,a7
80007496:	952e                	add	a0,a0,a1
80007498:	00150613          	addi	a2,a0,1
8000749c:	02d605b3          	mul	a1,a2,a3
800074a0:	40b287b3          	sub	a5,t0,a1
800074a4:	00f735b3          	sltu	a1,a4,a5
800074a8:	40b005b3          	neg	a1,a1
800074ac:	8df5                	and	a1,a1,a3
800074ae:	95be                	add	a1,a1,a5
800074b0:	00f76363          	bltu	a4,a5,800074b6 <__udivdi3+0x2a6>
800074b4:	8532                	mv	a0,a2
800074b6:	4701                	li	a4,0
800074b8:	00d5b5b3          	sltu	a1,a1,a3
800074bc:	0015c693          	xori	a3,a1,1
800074c0:	96aa                	add	a3,a3,a0
800074c2:	a819                	j	800074d8 <__udivdi3+0x2c8>
800074c4:	02c556b3          	divu	a3,a0,a2
800074c8:	a801                	j	800074d8 <__udivdi3+0x2c8>
800074ca:	8d19                	sub	a0,a0,a4
800074cc:	00c53533          	sltu	a0,a0,a2
800074d0:	4701                	li	a4,0
800074d2:	00154693          	xori	a3,a0,1
800074d6:	96be                	add	a3,a3,a5
800074d8:	8536                	mv	a0,a3
800074da:	85ba                	mv	a1,a4
800074dc:	8082                	ret
800074de:	02c758b3          	divu	a7,a4,a2
800074e2:	01065693          	srli	a3,a2,0x10
800074e6:	00155293          	srli	t0,a0,0x1
800074ea:	80007837          	lui	a6,0x80007
800074ee:	6fc80813          	addi	a6,a6,1788 # 800076fc <__SEGGER_RTL_Moeller_inverse_lut>
800074f2:	0016b693          	seqz	a3,a3
800074f6:	02c885b3          	mul	a1,a7,a2
800074fa:	0692                	slli	a3,a3,0x4
800074fc:	8f0d                	sub	a4,a4,a1
800074fe:	00d617b3          	sll	a5,a2,a3
80007502:	0187d593          	srli	a1,a5,0x18
80007506:	0015b593          	seqz	a1,a1
8000750a:	058e                	slli	a1,a1,0x3
8000750c:	00b797b3          	sll	a5,a5,a1
80007510:	8dd5                	or	a1,a1,a3
80007512:	01c7d693          	srli	a3,a5,0x1c
80007516:	0016b693          	seqz	a3,a3
8000751a:	068a                	slli	a3,a3,0x2
8000751c:	00d797b3          	sll	a5,a5,a3
80007520:	8dd5                	or	a1,a1,a3
80007522:	01e7d693          	srli	a3,a5,0x1e
80007526:	0016b693          	seqz	a3,a3
8000752a:	0686                	slli	a3,a3,0x1
8000752c:	00d797b3          	sll	a5,a5,a3
80007530:	8dd5                	or	a1,a1,a3
80007532:	fff7c693          	not	a3,a5
80007536:	82fd                	srli	a3,a3,0x1f
80007538:	8dd5                	or	a1,a1,a3
8000753a:	00b71733          	sll	a4,a4,a1
8000753e:	01f5c793          	xori	a5,a1,31
80007542:	00b51333          	sll	t1,a0,a1
80007546:	00b61633          	sll	a2,a2,a1
8000754a:	00f2d5b3          	srl	a1,t0,a5
8000754e:	00167693          	andi	a3,a2,1
80007552:	00b65793          	srli	a5,a2,0xb
80007556:	01665513          	srli	a0,a2,0x16
8000755a:	0506                	slli	a0,a0,0x1
8000755c:	9542                	add	a0,a0,a6
8000755e:	c0055503          	lhu	a0,-1024(a0)
80007562:	00165813          	srli	a6,a2,0x1
80007566:	00b762b3          	or	t0,a4,a1
8000756a:	0785                	addi	a5,a5,1
8000756c:	02a50733          	mul	a4,a0,a0
80007570:	02f73733          	mulhu	a4,a4,a5
80007574:	87b2                	mv	a5,a2
80007576:	9836                	add	a6,a6,a3
80007578:	40d006b3          	neg	a3,a3
8000757c:	0512                	slli	a0,a0,0x4
8000757e:	fff74713          	not	a4,a4
80007582:	953a                	add	a0,a0,a4
80007584:	00155713          	srli	a4,a0,0x1
80007588:	8ef9                	and	a3,a3,a4
8000758a:	8732                	mv	a4,a2
8000758c:	030505b3          	mul	a1,a0,a6
80007590:	8e8d                	sub	a3,a3,a1
80007592:	00f51593          	slli	a1,a0,0xf
80007596:	02d53533          	mulhu	a0,a0,a3
8000759a:	8105                	srli	a0,a0,0x1
8000759c:	952e                	add	a0,a0,a1
8000759e:	02c505b3          	mul	a1,a0,a2
800075a2:	02c536b3          	mulhu	a3,a0,a2
800075a6:	97ae                	add	a5,a5,a1
800075a8:	00b7b5b3          	sltu	a1,a5,a1
800075ac:	972e                	add	a4,a4,a1
800075ae:	9736                	add	a4,a4,a3
800075b0:	8d19                	sub	a0,a0,a4
800075b2:	025535b3          	mulhu	a1,a0,t0
800075b6:	02550533          	mul	a0,a0,t0
800075ba:	00a307b3          	add	a5,t1,a0
800075be:	0067b533          	sltu	a0,a5,t1
800075c2:	9596                	add	a1,a1,t0
800075c4:	952e                	add	a0,a0,a1
800075c6:	00150713          	addi	a4,a0,1
800075ca:	02c705b3          	mul	a1,a4,a2
800075ce:	40b305b3          	sub	a1,t1,a1
800075d2:	00b7b6b3          	sltu	a3,a5,a1
800075d6:	40d006b3          	neg	a3,a3
800075da:	8ef1                	and	a3,a3,a2
800075dc:	96ae                	add	a3,a3,a1
800075de:	00b7e363          	bltu	a5,a1,800075e4 <__udivdi3+0x3d4>
800075e2:	853a                	mv	a0,a4
800075e4:	00c6b5b3          	sltu	a1,a3,a2
800075e8:	0015c693          	xori	a3,a1,1
800075ec:	96aa                	add	a3,a3,a0
800075ee:	8746                	mv	a4,a7
800075f0:	b5e5                	j	800074d8 <__udivdi3+0x2c8>
800075f2:	01065793          	srli	a5,a2,0x10
800075f6:	02c5d733          	divu	a4,a1,a2
800075fa:	8edd                	or	a3,a3,a5
800075fc:	02c707b3          	mul	a5,a4,a2
80007600:	8d9d                	sub	a1,a1,a5
80007602:	e6a9                	bnez	a3,8000764c <__udivdi3+0x43c>
80007604:	01055693          	srli	a3,a0,0x10
80007608:	05c2                	slli	a1,a1,0x10
8000760a:	0542                	slli	a0,a0,0x10
8000760c:	8dd5                	or	a1,a1,a3
8000760e:	8141                	srli	a0,a0,0x10
80007610:	02c5d5b3          	divu	a1,a1,a2
80007614:	02c587b3          	mul	a5,a1,a2
80007618:	8e9d                	sub	a3,a3,a5
8000761a:	06c2                	slli	a3,a3,0x10
8000761c:	8d55                	or	a0,a0,a3
8000761e:	02c556b3          	divu	a3,a0,a2
80007622:	05c2                	slli	a1,a1,0x10
80007624:	96ae                	add	a3,a3,a1
80007626:	00b6b533          	sltu	a0,a3,a1
8000762a:	972a                	add	a4,a4,a0
8000762c:	b575                	j	800074d8 <__udivdi3+0x2c8>
8000762e:	468d                	li	a3,3
80007630:	06d60d63          	beq	a2,a3,800076aa <__udivdi3+0x49a>
80007634:	4681                	li	a3,0
80007636:	4791                	li	a5,4
80007638:	4701                	li	a4,0
8000763a:	e8f61fe3          	bne	a2,a5,800074d8 <__udivdi3+0x2c8>
8000763e:	8109                	srli	a0,a0,0x2
80007640:	01e59693          	slli	a3,a1,0x1e
80007644:	8ec9                	or	a3,a3,a0
80007646:	0025d713          	srli	a4,a1,0x2
8000764a:	b579                	j	800074d8 <__udivdi3+0x2c8>
8000764c:	01855813          	srli	a6,a0,0x18
80007650:	05a2                	slli	a1,a1,0x8
80007652:	00851793          	slli	a5,a0,0x8
80007656:	01051693          	slli	a3,a0,0x10
8000765a:	0ff57893          	zext.b	a7,a0
8000765e:	0105e5b3          	or	a1,a1,a6
80007662:	83e1                	srli	a5,a5,0x18
80007664:	0186d813          	srli	a6,a3,0x18
80007668:	02c5d533          	divu	a0,a1,a2
8000766c:	02c506b3          	mul	a3,a0,a2
80007670:	0562                	slli	a0,a0,0x18
80007672:	8d95                	sub	a1,a1,a3
80007674:	05a2                	slli	a1,a1,0x8
80007676:	8ddd                	or	a1,a1,a5
80007678:	02c5d6b3          	divu	a3,a1,a2
8000767c:	02c687b3          	mul	a5,a3,a2
80007680:	06c2                	slli	a3,a3,0x10
80007682:	8d9d                	sub	a1,a1,a5
80007684:	9536                	add	a0,a0,a3
80007686:	05a2                	slli	a1,a1,0x8
80007688:	0105e5b3          	or	a1,a1,a6
8000768c:	02c5d6b3          	divu	a3,a1,a2
80007690:	02c687b3          	mul	a5,a3,a2
80007694:	06a2                	slli	a3,a3,0x8
80007696:	8d9d                	sub	a1,a1,a5
80007698:	05a2                	slli	a1,a1,0x8
8000769a:	0115e5b3          	or	a1,a1,a7
8000769e:	02c5d5b3          	divu	a1,a1,a2
800076a2:	9536                	add	a0,a0,a3
800076a4:	00b506b3          	add	a3,a0,a1
800076a8:	bd05                	j	800074d8 <__udivdi3+0x2c8>
800076aa:	555555b7          	lui	a1,0x55555
800076ae:	55558593          	addi	a1,a1,1365 # 55555555 <_flash_size+0x55455555>
800076b2:	02a5b633          	mulhu	a2,a1,a0
800076b6:	02a58533          	mul	a0,a1,a0
800076ba:	02e5b6b3          	mulhu	a3,a1,a4
800076be:	02e585b3          	mul	a1,a1,a4
800076c2:	962e                	add	a2,a2,a1
800076c4:	00b635b3          	sltu	a1,a2,a1
800076c8:	9532                	add	a0,a0,a2
800076ca:	95b6                	add	a1,a1,a3
800076cc:	00c536b3          	sltu	a3,a0,a2
800076d0:	96ae                	add	a3,a3,a1
800076d2:	00d60733          	add	a4,a2,a3
800076d6:	9536                	add	a0,a0,a3
800076d8:	00c73633          	sltu	a2,a4,a2
800076dc:	00d536b3          	sltu	a3,a0,a3
800076e0:	0505                	addi	a0,a0,1
800076e2:	95b2                	add	a1,a1,a2
800076e4:	00d70633          	add	a2,a4,a3
800076e8:	00153693          	seqz	a3,a0
800076ec:	00e63533          	sltu	a0,a2,a4
800076f0:	96b2                	add	a3,a3,a2
800076f2:	952e                	add	a0,a0,a1
800076f4:	00c6b733          	sltu	a4,a3,a2
800076f8:	972a                	add	a4,a4,a0
800076fa:	bbf9                	j	800074d8 <__udivdi3+0x2c8>

Disassembly of section .text.libc.memset:

80007afc <memset>:
80007afc:	872a                	mv	a4,a0
80007afe:	c22d                	beqz	a2,80007b60 <.Lmemset_memset_end>

80007b00 <.Lmemset_unaligned_byte_set_loop>:
80007b00:	01e51693          	slli	a3,a0,0x1e
80007b04:	c699                	beqz	a3,80007b12 <.Lmemset_fast_set>
80007b06:	00b50023          	sb	a1,0(a0)
80007b0a:	0505                	addi	a0,a0,1
80007b0c:	167d                	addi	a2,a2,-1 # ff7fffff <__AHB_SRAM_segment_end__+0xf3f7fff>
80007b0e:	fa6d                	bnez	a2,80007b00 <.Lmemset_unaligned_byte_set_loop>
80007b10:	a881                	j	80007b60 <.Lmemset_memset_end>

80007b12 <.Lmemset_fast_set>:
80007b12:	0ff5f593          	zext.b	a1,a1
80007b16:	00859693          	slli	a3,a1,0x8
80007b1a:	8dd5                	or	a1,a1,a3
80007b1c:	01059693          	slli	a3,a1,0x10
80007b20:	8dd5                	or	a1,a1,a3
80007b22:	02000693          	li	a3,32
80007b26:	00d66f63          	bltu	a2,a3,80007b44 <.Lmemset_word_set>

80007b2a <.Lmemset_fast_set_loop>:
80007b2a:	c10c                	sw	a1,0(a0)
80007b2c:	c14c                	sw	a1,4(a0)
80007b2e:	c50c                	sw	a1,8(a0)
80007b30:	c54c                	sw	a1,12(a0)
80007b32:	c90c                	sw	a1,16(a0)
80007b34:	c94c                	sw	a1,20(a0)
80007b36:	cd0c                	sw	a1,24(a0)
80007b38:	cd4c                	sw	a1,28(a0)
80007b3a:	9536                	add	a0,a0,a3
80007b3c:	8e15                	sub	a2,a2,a3
80007b3e:	fed676e3          	bgeu	a2,a3,80007b2a <.Lmemset_fast_set_loop>
80007b42:	ce19                	beqz	a2,80007b60 <.Lmemset_memset_end>

80007b44 <.Lmemset_word_set>:
80007b44:	4691                	li	a3,4
80007b46:	00d66863          	bltu	a2,a3,80007b56 <.Lmemset_byte_set_loop>

80007b4a <.Lmemset_word_set_loop>:
80007b4a:	c10c                	sw	a1,0(a0)
80007b4c:	9536                	add	a0,a0,a3
80007b4e:	8e15                	sub	a2,a2,a3
80007b50:	fed67de3          	bgeu	a2,a3,80007b4a <.Lmemset_word_set_loop>
80007b54:	c611                	beqz	a2,80007b60 <.Lmemset_memset_end>

80007b56 <.Lmemset_byte_set_loop>:
80007b56:	00b50023          	sb	a1,0(a0)
80007b5a:	0505                	addi	a0,a0,1
80007b5c:	167d                	addi	a2,a2,-1
80007b5e:	fe65                	bnez	a2,80007b56 <.Lmemset_byte_set_loop>

80007b60 <.Lmemset_memset_end>:
80007b60:	853a                	mv	a0,a4
80007b62:	8082                	ret

Disassembly of section .text.libc.strlen:

80007b64 <strlen>:
80007b64:	85aa                	mv	a1,a0
80007b66:	00357693          	andi	a3,a0,3
80007b6a:	c29d                	beqz	a3,80007b90 <.Lstrlen_aligned>
80007b6c:	00054603          	lbu	a2,0(a0)
80007b70:	ce21                	beqz	a2,80007bc8 <.Lstrlen_done>
80007b72:	0505                	addi	a0,a0,1
80007b74:	00357693          	andi	a3,a0,3
80007b78:	ce81                	beqz	a3,80007b90 <.Lstrlen_aligned>
80007b7a:	00054603          	lbu	a2,0(a0)
80007b7e:	c629                	beqz	a2,80007bc8 <.Lstrlen_done>
80007b80:	0505                	addi	a0,a0,1
80007b82:	00357693          	andi	a3,a0,3
80007b86:	c689                	beqz	a3,80007b90 <.Lstrlen_aligned>
80007b88:	00054603          	lbu	a2,0(a0)
80007b8c:	ce15                	beqz	a2,80007bc8 <.Lstrlen_done>
80007b8e:	0505                	addi	a0,a0,1

80007b90 <.Lstrlen_aligned>:
80007b90:	01010637          	lui	a2,0x1010
80007b94:	10160613          	addi	a2,a2,257 # 1010101 <_flash_size+0xf10101>
80007b98:	00761693          	slli	a3,a2,0x7

80007b9c <.Lstrlen_wordstrlen>:
80007b9c:	4118                	lw	a4,0(a0)
80007b9e:	0511                	addi	a0,a0,4
80007ba0:	40c707b3          	sub	a5,a4,a2
80007ba4:	fff74713          	not	a4,a4
80007ba8:	8ff9                	and	a5,a5,a4
80007baa:	8ff5                	and	a5,a5,a3
80007bac:	dbe5                	beqz	a5,80007b9c <.Lstrlen_wordstrlen>
80007bae:	1571                	addi	a0,a0,-4
80007bb0:	01879713          	slli	a4,a5,0x18
80007bb4:	eb11                	bnez	a4,80007bc8 <.Lstrlen_done>
80007bb6:	0505                	addi	a0,a0,1
80007bb8:	01079713          	slli	a4,a5,0x10
80007bbc:	e711                	bnez	a4,80007bc8 <.Lstrlen_done>
80007bbe:	0505                	addi	a0,a0,1
80007bc0:	00879713          	slli	a4,a5,0x8
80007bc4:	e311                	bnez	a4,80007bc8 <.Lstrlen_done>
80007bc6:	0505                	addi	a0,a0,1

80007bc8 <.Lstrlen_done>:
80007bc8:	8d0d                	sub	a0,a0,a1
80007bca:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

80007bcc <__SEGGER_RTL_pow10f>:
80007bcc:	1101                	addi	sp,sp,-32
80007bce:	ce06                	sw	ra,28(sp)
80007bd0:	cc22                	sw	s0,24(sp)
80007bd2:	ca26                	sw	s1,20(sp)
80007bd4:	c84a                	sw	s2,16(sp)
80007bd6:	c64e                	sw	s3,12(sp)
80007bd8:	892a                	mv	s2,a0
80007bda:	c515                	beqz	a0,80007c06 <__SEGGER_RTL_pow10f+0x3a>
80007bdc:	41f95513          	srai	a0,s2,0x1f
80007be0:	e0018413          	addi	s0,gp,-512 # 80003690 <__SEGGER_RTL_aPower2f>
80007be4:	00a944b3          	xor	s1,s2,a0
80007be8:	8c89                	sub	s1,s1,a0
80007bea:	3f8009b7          	lui	s3,0x3f800
80007bee:	0014f513          	andi	a0,s1,1
80007bf2:	c511                	beqz	a0,80007bfe <__SEGGER_RTL_pow10f+0x32>
80007bf4:	400c                	lw	a1,0(s0)
80007bf6:	854e                	mv	a0,s3
80007bf8:	92aff0ef          	jal	80006d22 <__mulsf3>
80007bfc:	89aa                	mv	s3,a0
80007bfe:	8085                	srli	s1,s1,0x1
80007c00:	0411                	addi	s0,s0,4
80007c02:	f4f5                	bnez	s1,80007bee <__SEGGER_RTL_pow10f+0x22>
80007c04:	a019                	j	80007c0a <__SEGGER_RTL_pow10f+0x3e>
80007c06:	3f8009b7          	lui	s3,0x3f800
80007c0a:	3f800537          	lui	a0,0x3f800
80007c0e:	85ce                	mv	a1,s3
80007c10:	9c2ff0ef          	jal	80006dd2 <__divsf3>
80007c14:	00094363          	bltz	s2,80007c1a <__SEGGER_RTL_pow10f+0x4e>
80007c18:	854e                	mv	a0,s3
80007c1a:	40f2                	lw	ra,28(sp)
80007c1c:	4462                	lw	s0,24(sp)
80007c1e:	44d2                	lw	s1,20(sp)
80007c20:	4942                	lw	s2,16(sp)
80007c22:	49b2                	lw	s3,12(sp)
80007c24:	6105                	addi	sp,sp,32
80007c26:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

80007c28 <__SEGGER_RTL_current_locale>:
80007c28:	00080537          	lui	a0,0x80
80007c2c:	32c52503          	lw	a0,812(a0) # 8032c <__SEGGER_RTL_locale_ptr>
80007c30:	e509                	bnez	a0,80007c3a <__SEGGER_RTL_current_locale+0x12>
80007c32:	00080537          	lui	a0,0x80
80007c36:	30050513          	addi	a0,a0,768 # 80300 <__RAL_global_locale>
80007c3a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

80007c3c <__SEGGER_RTL_ascii_mbtowc>:
80007c3c:	4701                	li	a4,0
80007c3e:	c19d                	beqz	a1,80007c64 <__SEGGER_RTL_ascii_mbtowc+0x28>
80007c40:	c215                	beqz	a2,80007c64 <__SEGGER_RTL_ascii_mbtowc+0x28>
80007c42:	0005c603          	lbu	a2,0(a1)
80007c46:	01861593          	slli	a1,a2,0x18
80007c4a:	0005cc63          	bltz	a1,80007c62 <__SEGGER_RTL_ascii_mbtowc+0x26>
80007c4e:	85e1                	srai	a1,a1,0x18
80007c50:	c111                	beqz	a0,80007c54 <__SEGGER_RTL_ascii_mbtowc+0x18>
80007c52:	c110                	sw	a2,0(a0)
80007c54:	0006a023          	sw	zero,0(a3) # 800000 <_flash_size+0x700000>
80007c58:	0006a223          	sw	zero,4(a3)
80007c5c:	00b03733          	snez	a4,a1
80007c60:	a011                	j	80007c64 <__SEGGER_RTL_ascii_mbtowc+0x28>
80007c62:	5779                	li	a4,-2
80007c64:	853a                	mv	a0,a4
80007c66:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

80007c68 <__SEGGER_RTL_ascii_wctomb>:
80007c68:	07f00613          	li	a2,127
80007c6c:	00b67463          	bgeu	a2,a1,80007c74 <__SEGGER_RTL_ascii_wctomb+0xc>
80007c70:	5579                	li	a0,-2
80007c72:	8082                	ret
80007c74:	00b50023          	sb	a1,0(a0)
80007c78:	4505                	li	a0,1
80007c7a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

80007c7c <__SEGGER_RTL_ascii_isctype>:
80007c7c:	07f00613          	li	a2,127
80007c80:	02a66263          	bltu	a2,a0,80007ca4 <__SEGGER_RTL_ascii_isctype+0x28>
80007c84:	80008637          	lui	a2,0x80008
80007c88:	e4260613          	addi	a2,a2,-446 # 80007e42 <__SEGGER_RTL_ascii_ctype_map>
80007c8c:	9532                	add	a0,a0,a2
80007c8e:	80008637          	lui	a2,0x80008
80007c92:	e0d60613          	addi	a2,a2,-499 # 80007e0d <__SEGGER_RTL_ascii_ctype_mask>
80007c96:	95b2                	add	a1,a1,a2
80007c98:	00054503          	lbu	a0,0(a0)
80007c9c:	0005c583          	lbu	a1,0(a1)
80007ca0:	8d6d                	and	a0,a0,a1
80007ca2:	8082                	ret
80007ca4:	4501                	li	a0,0
80007ca6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

80007ca8 <__SEGGER_RTL_ascii_iswctype>:
80007ca8:	07f00613          	li	a2,127
80007cac:	02a66263          	bltu	a2,a0,80007cd0 <__SEGGER_RTL_ascii_iswctype+0x28>
80007cb0:	80008637          	lui	a2,0x80008
80007cb4:	e4260613          	addi	a2,a2,-446 # 80007e42 <__SEGGER_RTL_ascii_ctype_map>
80007cb8:	9532                	add	a0,a0,a2
80007cba:	80008637          	lui	a2,0x80008
80007cbe:	e0d60613          	addi	a2,a2,-499 # 80007e0d <__SEGGER_RTL_ascii_ctype_mask>
80007cc2:	95b2                	add	a1,a1,a2
80007cc4:	00054503          	lbu	a0,0(a0)
80007cc8:	0005c583          	lbu	a1,0(a1)
80007ccc:	8d6d                	and	a0,a0,a1
80007cce:	8082                	ret
80007cd0:	4501                	li	a0,0
80007cd2:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

80008288 <__SEGGER_init_zero>:
80008288:	4008                	lw	a0,0(s0)
8000828a:	404c                	lw	a1,4(s0)
8000828c:	0421                	addi	s0,s0,8
8000828e:	c591                	beqz	a1,8000829a <.L__SEGGER_init_zero_Done>

80008290 <.L__SEGGER_init_zero_Loop>:
80008290:	00050023          	sb	zero,0(a0)
80008294:	0505                	addi	a0,a0,1
80008296:	15fd                	addi	a1,a1,-1
80008298:	fde5                	bnez	a1,80008290 <.L__SEGGER_init_zero_Loop>

8000829a <.L__SEGGER_init_zero_Done>:
8000829a:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

8000829c <__SEGGER_init_copy>:
8000829c:	4008                	lw	a0,0(s0)
8000829e:	404c                	lw	a1,4(s0)
800082a0:	4410                	lw	a2,8(s0)
800082a2:	0431                	addi	s0,s0,12
800082a4:	ca09                	beqz	a2,800082b6 <.L__SEGGER_init_copy_Done>

800082a6 <.L__SEGGER_init_copy_Loop>:
800082a6:	00058683          	lb	a3,0(a1)
800082aa:	00d50023          	sb	a3,0(a0)
800082ae:	0505                	addi	a0,a0,1
800082b0:	0585                	addi	a1,a1,1
800082b2:	167d                	addi	a2,a2,-1
800082b4:	fa6d                	bnez	a2,800082a6 <.L__SEGGER_init_copy_Loop>

800082b6 <.L__SEGGER_init_copy_Done>:
800082b6:	8082                	ret
