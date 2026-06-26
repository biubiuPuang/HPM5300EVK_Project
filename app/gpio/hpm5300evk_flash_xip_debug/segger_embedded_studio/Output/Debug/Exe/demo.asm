
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
80003008:	80009237          	lui	tp,0x80009
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	c3e20213          	addi	tp,tp,-962 # 80008c3e <__thread_pointer$>
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
80003020:	06c010ef          	jal	8000408c <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003024:	034010ef          	jal	80004058 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
80003028:	7f4030ef          	jal	8000681c <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
8000302c:	2b0030ef          	jal	800062dc <_init>

80003030 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003030:	80008437          	lui	s0,0x80008
80003034:	66040413          	addi	s0,s0,1632 # 80008660 <__SEGGER_RTL_ascii_ctype_map+0x83>

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
80003040:	369000ef          	jal	80003ba8 <_clean_up>

80003044 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
80003044:	000002b7          	lui	t0,0x0
80003048:	00028293          	mv	t0,t0
    csrw mtvec, t0
8000304c:	30529073          	csrw	mtvec,t0

    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
80003050:	7d016073          	csrsi	0x7d0,2

80003054 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80003054:	270030ef          	jal	800062c4 <reset_handler>
        tail    exit
80003058:	a009                	j	8000305a <exit>

8000305a <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
8000305a:	a001                	j	8000305a <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
8000305c:	4501                	li	a0,0
        li      a1, 0
8000305e:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
80003060:	264030ef          	jal	800062c4 <reset_handler>
        tail    exit
80003064:	bfdd                	j	8000305a <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>:
80003066:	8082                	ret

Disassembly of section .text.uart_read_byte:

800038be <uart_read_byte>:
 *
 * @param ptr UART base address
 * @retval RX byte
 */
static inline uint8_t uart_read_byte(UART_Type *ptr)
{
800038be:	1141                	addi	sp,sp,-16
800038c0:	c62a                	sw	a0,12(sp)
    return (ptr->RBR & UART_RBR_RBR_MASK);
800038c2:	47b2                	lw	a5,12(sp)
800038c4:	539c                	lw	a5,32(a5)
800038c6:	0ff7f793          	zext.b	a5,a5
}
800038ca:	853e                	mv	a0,a5
800038cc:	0141                	addi	sp,sp,16
800038ce:	8082                	ret

Disassembly of section .text.uart_check_status:

800038d2 <uart_check_status>:
 * @param mask Status mask value to be checked against
 * @retval true if any bit in given mask is set
 * @retval false if none of any bit in given mask is set
 */
static inline bool uart_check_status(UART_Type *ptr, uart_stat_t mask)
{
800038d2:	1141                	addi	sp,sp,-16
800038d4:	c62a                	sw	a0,12(sp)
800038d6:	87ae                	mv	a5,a1
800038d8:	00f105a3          	sb	a5,11(sp)
    return ((ptr->LSR & mask) != 0U) ? true : false;
800038dc:	47b2                	lw	a5,12(sp)
800038de:	5bd8                	lw	a4,52(a5)
800038e0:	00b14783          	lbu	a5,11(sp)
800038e4:	8ff9                	and	a5,a5,a4
800038e6:	00f037b3          	snez	a5,a5
800038ea:	0ff7f793          	zext.b	a5,a5
}
800038ee:	853e                	mv	a0,a5
800038f0:	0141                	addi	sp,sp,16
800038f2:	8082                	ret

Disassembly of section .text.gpio_write_pin:

80003988 <gpio_write_pin>:
 * @param port Port index
 * @param pin Pin index
 * @param high Pin level set to high when it is set to true
 */
static inline void gpio_write_pin(GPIO_Type *ptr, uint32_t port, uint8_t pin, uint8_t high)
{
80003988:	1141                	addi	sp,sp,-16
8000398a:	c62a                	sw	a0,12(sp)
8000398c:	c42e                	sw	a1,8(sp)
8000398e:	87b2                	mv	a5,a2
80003990:	8736                	mv	a4,a3
80003992:	00f103a3          	sb	a5,7(sp)
80003996:	87ba                	mv	a5,a4
80003998:	00f10323          	sb	a5,6(sp)
    if (high) {
8000399c:	00614783          	lbu	a5,6(sp)
800039a0:	cf91                	beqz	a5,800039bc <.L7>
        ptr->DO[port].SET = 1 << pin;
800039a2:	00714783          	lbu	a5,7(sp)
800039a6:	4705                	li	a4,1
800039a8:	00f717b3          	sll	a5,a4,a5
800039ac:	86be                	mv	a3,a5
800039ae:	4732                	lw	a4,12(sp)
800039b0:	47a2                	lw	a5,8(sp)
800039b2:	07c1                	addi	a5,a5,16
800039b4:	0792                	slli	a5,a5,0x4
800039b6:	97ba                	add	a5,a5,a4
800039b8:	c3d4                	sw	a3,4(a5)
    } else {
        ptr->DO[port].CLEAR = 1 << pin;
    }
}
800039ba:	a829                	j	800039d4 <.L9>

800039bc <.L7>:
        ptr->DO[port].CLEAR = 1 << pin;
800039bc:	00714783          	lbu	a5,7(sp)
800039c0:	4705                	li	a4,1
800039c2:	00f717b3          	sll	a5,a4,a5
800039c6:	86be                	mv	a3,a5
800039c8:	4732                	lw	a4,12(sp)
800039ca:	47a2                	lw	a5,8(sp)
800039cc:	07c1                	addi	a5,a5,16
800039ce:	0792                	slli	a5,a5,0x4
800039d0:	97ba                	add	a5,a5,a4
800039d2:	c794                	sw	a3,8(a5)

800039d4 <.L9>:
}
800039d4:	0001                	nop
800039d6:	0141                	addi	sp,sp,16
800039d8:	8082                	ret

Disassembly of section .text.gptmr_channel_is_opmode:

800039da <gptmr_channel_is_opmode>:
 * @param [in] ptr GPTMR base address
 * @param [in] ch_index channel index
 * @retval bool true for opmode, false for normal mode
 */
static inline bool gptmr_channel_is_opmode(GPTMR_Type *ptr, uint8_t ch_index)
{
800039da:	1141                	addi	sp,sp,-16
800039dc:	c62a                	sw	a0,12(sp)
800039de:	87ae                	mv	a5,a1
800039e0:	00f105a3          	sb	a5,11(sp)
    return ((ptr->CHANNEL[ch_index].CR & GPTMR_CHANNEL_CR_OPMODE_MASK) == GPTMR_CHANNEL_CR_OPMODE_MASK) ? true : false;
800039e4:	00b14783          	lbu	a5,11(sp)
800039e8:	4732                	lw	a4,12(sp)
800039ea:	079a                	slli	a5,a5,0x6
800039ec:	97ba                	add	a5,a5,a4
800039ee:	4398                	lw	a4,0(a5)
800039f0:	000207b7          	lui	a5,0x20
800039f4:	8f7d                	and	a4,a4,a5
800039f6:	7781                	lui	a5,0xfffe0
800039f8:	97ba                	add	a5,a5,a4
800039fa:	0017b793          	seqz	a5,a5
800039fe:	0ff7f793          	zext.b	a5,a5
}
80003a02:	853e                	mv	a0,a5
80003a04:	0141                	addi	sp,sp,16
80003a06:	8082                	ret

Disassembly of section .text.main:

80003a08 <main>:

/* ==================================================================
 * 主函数
 * ================================================================== */
int main(void)
{
80003a08:	7171                	addi	sp,sp,-176
80003a0a:	d706                	sw	ra,172(sp)
     * board_init() 做了:
     *   - 配 PLL: CPU 480MHz, AHB 160MHz
     *   - 配 UART0: PA00=TX, PA01=RX, 波特率 115200
     *   (时钟/LOGO 打印已被 #define 抑制)
     */
    board_init();
80003a0c:	785020ef          	jal	80006990 <board_init>

    /* ─── 用户自定义启动打印（可修改 USER_BOOT_MSG 内容）─── */
    printf("%s", USER_BOOT_MSG);
80003a10:	f7418793          	addi	a5,gp,-140 # 80003804 <.LC0>
80003a14:	85be                	mv	a1,a5
80003a16:	01418513          	addi	a0,gp,20 # 800038a4 <.LC1>
80003a1a:	137010ef          	jal	80005350 <printf>

    /* ===== 初始化 LED (PA23) ===== */
    init_led_pins_as_gpio();
80003a1e:	68b020ef          	jal	800068a8 <init_led_pins_as_gpio>
    gpio_set_pin_output_with_initial(LED_GPIO_CTRL, LED_GPIO_INDEX,
80003a22:	171000ef          	jal	80004392 <board_get_led_gpio_off_level>
80003a26:	87aa                	mv	a5,a0
80003a28:	86be                	mv	a3,a5
80003a2a:	465d                	li	a2,23
80003a2c:	4581                	li	a1,0
80003a2e:	f00d0537          	lui	a0,0xf00d0
80003a32:	657000ef          	jal	80004888 <gpio_set_pin_output_with_initial>
                                     LED_GPIO_PIN,
                                     board_get_led_gpio_off_level());

    /* ===== 配置 GPTMR1 10ms 定时中断 ===== */
    clock_add_to_group(WDT_GPTMR_CLK, 0);
80003a36:	4581                	li	a1,0
80003a38:	010e07b7          	lui	a5,0x10e0
80003a3c:	00a78513          	addi	a0,a5,10 # 10e000a <_flash_size+0xfe000a>
80003a40:	2355                	jal	80003fe4 <clock_add_to_group>

    uint32_t gptmr_freq = clock_get_frequency(WDT_GPTMR_CLK);
80003a42:	010e07b7          	lui	a5,0x10e0
80003a46:	00a78513          	addi	a0,a5,10 # 10e000a <_flash_size+0xfe000a>
80003a4a:	2e1020ef          	jal	8000652a <clock_get_frequency>
80003a4e:	cf2a                	sw	a0,156(sp)
    gptmr_channel_config_t gptmr_cfg;
    gptmr_channel_get_default_config(WDT_GPTMR, &gptmr_cfg);
80003a50:	007c                	addi	a5,sp,12
80003a52:	85be                	mv	a1,a5
80003a54:	f0004537          	lui	a0,0xf0004
80003a58:	00e010ef          	jal	80004a66 <gptmr_channel_get_default_config>
    gptmr_cfg.reload = gptmr_freq / 1000 * GPTMR_TICK_MS;
80003a5c:	477a                	lw	a4,156(sp)
80003a5e:	106257b7          	lui	a5,0x10625
80003a62:	dd378793          	addi	a5,a5,-557 # 10624dd3 <_flash_size+0x10524dd3>
80003a66:	02f737b3          	mulhu	a5,a4,a5
80003a6a:	0067d713          	srli	a4,a5,0x6
80003a6e:	87ba                	mv	a5,a4
80003a70:	078a                	slli	a5,a5,0x2
80003a72:	97ba                	add	a5,a5,a4
80003a74:	0786                	slli	a5,a5,0x1
80003a76:	cc3e                	sw	a5,24(sp)

    gptmr_channel_config(WDT_GPTMR, WDT_GPTMR_CH, &gptmr_cfg, false);
80003a78:	007c                	addi	a5,sp,12
80003a7a:	4681                	li	a3,0
80003a7c:	863e                	mv	a2,a5
80003a7e:	4581                	li	a1,0
80003a80:	f0004537          	lui	a0,0xf0004
80003a84:	252030ef          	jal	80006cd6 <gptmr_channel_config>
    gptmr_enable_irq(WDT_GPTMR, GPTMR_CH_RLD_IRQ_MASK(WDT_GPTMR_CH));
80003a88:	4585                	li	a1,1
80003a8a:	f0004537          	lui	a0,0xf0004
80003a8e:	786020ef          	jal	80006214 <gptmr_enable_irq>
80003a92:	4799                	li	a5,6
80003a94:	c4be                	sw	a5,72(sp)
80003a96:	4785                	li	a5,1
80003a98:	c2be                	sw	a5,68(sp)
80003a9a:	e40007b7          	lui	a5,0xe4000
80003a9e:	c0be                	sw	a5,64(sp)
80003aa0:	47a6                	lw	a5,72(sp)
80003aa2:	de3e                	sw	a5,60(sp)
80003aa4:	4796                	lw	a5,68(sp)
80003aa6:	dc3e                	sw	a5,56(sp)

80003aa8 <.LBB22>:
                                                              uint32_t irq,
                                                              uint32_t priority)
{
    volatile uint32_t *priority_ptr = (volatile uint32_t *) (base +
                                                             HPM_PLIC_PRIORITY_OFFSET +
                                                             ((irq - 1) << HPM_PLIC_PRIORITY_SHIFT_PER_SOURCE));
80003aa8:	57f2                	lw	a5,60(sp)
80003aaa:	17fd                	addi	a5,a5,-1 # e3ffffff <__FLASH_segment_end__+0x63efffff>
80003aac:	00279713          	slli	a4,a5,0x2
                                                             HPM_PLIC_PRIORITY_OFFSET +
80003ab0:	4786                	lw	a5,64(sp)
80003ab2:	97ba                	add	a5,a5,a4
80003ab4:	0791                	addi	a5,a5,4
    volatile uint32_t *priority_ptr = (volatile uint32_t *) (base +
80003ab6:	da3e                	sw	a5,52(sp)
    *priority_ptr = priority;
80003ab8:	57d2                	lw	a5,52(sp)
80003aba:	5762                	lw	a4,56(sp)
80003abc:	c398                	sw	a4,0(a5)
}
80003abe:	0001                	nop

80003ac0 <.LBE24>:
 * @param[in] priority Priority of interrupt
 */
ATTR_ALWAYS_INLINE static inline void intc_set_irq_priority(uint32_t irq, uint32_t priority)
{
    __plic_set_irq_priority(HPM_PLIC_BASE, irq, priority);
}
80003ac0:	0001                	nop
80003ac2:	d282                	sw	zero,100(sp)
80003ac4:	4799                	li	a5,6
80003ac6:	d0be                	sw	a5,96(sp)
80003ac8:	e40007b7          	lui	a5,0xe4000
80003acc:	cebe                	sw	a5,92(sp)
80003ace:	5796                	lw	a5,100(sp)
80003ad0:	ccbe                	sw	a5,88(sp)
80003ad2:	5786                	lw	a5,96(sp)
80003ad4:	cabe                	sw	a5,84(sp)

80003ad6 <.LBB26>:
                                                        uint32_t target,
                                                        uint32_t irq)
{
    volatile uint32_t *current_ptr = (volatile uint32_t *) (base +
                                                            HPM_PLIC_ENABLE_OFFSET +
                                                            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80003ad6:	47e6                	lw	a5,88(sp)
80003ad8:	00779713          	slli	a4,a5,0x7
                                                            HPM_PLIC_ENABLE_OFFSET +
80003adc:	47f6                	lw	a5,92(sp)
80003ade:	973e                	add	a4,a4,a5
                                                            ((irq >> 5) << 2));
80003ae0:	47d6                	lw	a5,84(sp)
80003ae2:	8395                	srli	a5,a5,0x5
80003ae4:	078a                	slli	a5,a5,0x2
                                                            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80003ae6:	973e                	add	a4,a4,a5
80003ae8:	6789                	lui	a5,0x2
80003aea:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *) (base +
80003aec:	c8be                	sw	a5,80(sp)
    uint32_t current = *current_ptr;
80003aee:	47c6                	lw	a5,80(sp)
80003af0:	439c                	lw	a5,0(a5)
80003af2:	c6be                	sw	a5,76(sp)
    current = current | (1 << (irq & 0x1F));
80003af4:	47d6                	lw	a5,84(sp)
80003af6:	8bfd                	andi	a5,a5,31
80003af8:	4705                	li	a4,1
80003afa:	00f717b3          	sll	a5,a4,a5
80003afe:	873e                	mv	a4,a5
80003b00:	47b6                	lw	a5,76(sp)
80003b02:	8fd9                	or	a5,a5,a4
80003b04:	c6be                	sw	a5,76(sp)
    *current_ptr = current;
80003b06:	47c6                	lw	a5,80(sp)
80003b08:	4736                	lw	a4,76(sp)
80003b0a:	c398                	sw	a4,0(a5)
}
80003b0c:	0001                	nop

80003b0e <.LBE28>:
}
80003b0e:	0001                	nop

80003b10 <.LBE26>:
    intc_m_enable_irq_with_priority(WDT_GPTMR_IRQ, 1);
    gptmr_start_counter(WDT_GPTMR, WDT_GPTMR_CH);
80003b10:	4581                	li	a1,0
80003b12:	f0004537          	lui	a0,0xf0004
80003b16:	752020ef          	jal	80006268 <gptmr_start_counter>

    /* ===== 使能 UART0 接收中断 ===== */
    uart_enable_irq(HPM_UART0, uart_intr_rx_data_avail_or_timeout);
80003b1a:	4585                	li	a1,1
80003b1c:	f0040537          	lui	a0,0xf0040
80003b20:	6dc020ef          	jal	800061fc <uart_enable_irq>
80003b24:	47b5                	li	a5,13
80003b26:	debe                	sw	a5,124(sp)
80003b28:	4785                	li	a5,1
80003b2a:	dcbe                	sw	a5,120(sp)
80003b2c:	e40007b7          	lui	a5,0xe4000
80003b30:	dabe                	sw	a5,116(sp)
80003b32:	57f6                	lw	a5,124(sp)
80003b34:	d8be                	sw	a5,112(sp)
80003b36:	57e6                	lw	a5,120(sp)
80003b38:	d6be                	sw	a5,108(sp)

80003b3a <.LBB30>:
                                                             ((irq - 1) << HPM_PLIC_PRIORITY_SHIFT_PER_SOURCE));
80003b3a:	57c6                	lw	a5,112(sp)
80003b3c:	17fd                	addi	a5,a5,-1 # e3ffffff <__FLASH_segment_end__+0x63efffff>
80003b3e:	00279713          	slli	a4,a5,0x2
                                                             HPM_PLIC_PRIORITY_OFFSET +
80003b42:	57d6                	lw	a5,116(sp)
80003b44:	97ba                	add	a5,a5,a4
80003b46:	0791                	addi	a5,a5,4
    volatile uint32_t *priority_ptr = (volatile uint32_t *) (base +
80003b48:	d4be                	sw	a5,104(sp)
    *priority_ptr = priority;
80003b4a:	57a6                	lw	a5,104(sp)
80003b4c:	5736                	lw	a4,108(sp)
80003b4e:	c398                	sw	a4,0(a5)
}
80003b50:	0001                	nop

80003b52 <.LBE32>:
}
80003b52:	0001                	nop
80003b54:	cd02                	sw	zero,152(sp)
80003b56:	47b5                	li	a5,13
80003b58:	cb3e                	sw	a5,148(sp)
80003b5a:	e40007b7          	lui	a5,0xe4000
80003b5e:	c93e                	sw	a5,144(sp)
80003b60:	47ea                	lw	a5,152(sp)
80003b62:	c73e                	sw	a5,140(sp)
80003b64:	47da                	lw	a5,148(sp)
80003b66:	c53e                	sw	a5,136(sp)

80003b68 <.LBB34>:
                                                            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80003b68:	47ba                	lw	a5,140(sp)
80003b6a:	00779713          	slli	a4,a5,0x7
                                                            HPM_PLIC_ENABLE_OFFSET +
80003b6e:	47ca                	lw	a5,144(sp)
80003b70:	973e                	add	a4,a4,a5
                                                            ((irq >> 5) << 2));
80003b72:	47aa                	lw	a5,136(sp)
80003b74:	8395                	srli	a5,a5,0x5
80003b76:	078a                	slli	a5,a5,0x2
                                                            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80003b78:	973e                	add	a4,a4,a5
80003b7a:	6789                	lui	a5,0x2
80003b7c:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *) (base +
80003b7e:	c33e                	sw	a5,132(sp)
    uint32_t current = *current_ptr;
80003b80:	479a                	lw	a5,132(sp)
80003b82:	439c                	lw	a5,0(a5)
80003b84:	c13e                	sw	a5,128(sp)
    current = current | (1 << (irq & 0x1F));
80003b86:	47aa                	lw	a5,136(sp)
80003b88:	8bfd                	andi	a5,a5,31
80003b8a:	4705                	li	a4,1
80003b8c:	00f717b3          	sll	a5,a4,a5
80003b90:	873e                	mv	a4,a5
80003b92:	478a                	lw	a5,128(sp)
80003b94:	8fd9                	or	a5,a5,a4
80003b96:	c13e                	sw	a5,128(sp)
    *current_ptr = current;
80003b98:	479a                	lw	a5,132(sp)
80003b9a:	470a                	lw	a4,128(sp)
80003b9c:	c398                	sw	a4,0(a5)
}
80003b9e:	0001                	nop

80003ba0 <.LBE36>:
}
80003ba0:	0001                	nop

80003ba2 <.L27>:
    intc_m_enable_irq_with_priority(IRQn_UART0, 1);

    /* 主循环空闲 — 所有逻辑由两个 ISR 协作完成 */
    while (1) {
        __asm volatile("wfi");
80003ba2:	10500073          	wfi
80003ba6:	bff5                	j	80003ba2 <.L27>

Disassembly of section .text._clean_up:

80003ba8 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
80003ba8:	7139                	addi	sp,sp,-64

80003baa <.LBB18>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003baa:	28b01793          	bseti	a5,zero,0xb
80003bae:	3047b073          	csrc	mie,a5
}
80003bb2:	0001                	nop
80003bb4:	da02                	sw	zero,52(sp)
80003bb6:	d802                	sw	zero,48(sp)
80003bb8:	e40007b7          	lui	a5,0xe4000
80003bbc:	d63e                	sw	a5,44(sp)
80003bbe:	57d2                	lw	a5,52(sp)
80003bc0:	d43e                	sw	a5,40(sp)
80003bc2:	57c2                	lw	a5,48(sp)
80003bc4:	d23e                	sw	a5,36(sp)

80003bc6 <.LBB20>:
                                                              (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
80003bc6:	57a2                	lw	a5,40(sp)
80003bc8:	00c79713          	slli	a4,a5,0xc
                                                              HPM_PLIC_THRESHOLD_OFFSET +
80003bcc:	57b2                	lw	a5,44(sp)
80003bce:	973e                	add	a4,a4,a5
80003bd0:	002007b7          	lui	a5,0x200
80003bd4:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *) (base +
80003bd6:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
80003bd8:	5782                	lw	a5,32(sp)
80003bda:	5712                	lw	a4,36(sp)
80003bdc:	c398                	sw	a4,0(a5)
}
80003bde:	0001                	nop

80003be0 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
80003be0:	0001                	nop

80003be2 <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
80003be2:	de02                	sw	zero,60(sp)
80003be4:	a82d                	j	80003c1e <.L2>

80003be6 <.L3>:
80003be6:	ce02                	sw	zero,28(sp)
80003be8:	57f2                	lw	a5,60(sp)
80003bea:	cc3e                	sw	a5,24(sp)
80003bec:	e40007b7          	lui	a5,0xe4000
80003bf0:	ca3e                	sw	a5,20(sp)
80003bf2:	47f2                	lw	a5,28(sp)
80003bf4:	c83e                	sw	a5,16(sp)
80003bf6:	47e2                	lw	a5,24(sp)
80003bf8:	c63e                	sw	a5,12(sp)

80003bfa <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
                                                           HPM_PLIC_CLAIM_OFFSET +
                                                           (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
80003bfa:	47c2                	lw	a5,16(sp)
80003bfc:	00c79713          	slli	a4,a5,0xc
                                                           HPM_PLIC_CLAIM_OFFSET +
80003c00:	47d2                	lw	a5,20(sp)
80003c02:	973e                	add	a4,a4,a5
80003c04:	002007b7          	lui	a5,0x200
80003c08:	0791                	addi	a5,a5,4 # 200004 <_flash_size+0x100004>
80003c0a:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
80003c0c:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
80003c0e:	47a2                	lw	a5,8(sp)
80003c10:	4732                	lw	a4,12(sp)
80003c12:	c398                	sw	a4,0(a5)
}
80003c14:	0001                	nop

80003c16 <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
80003c16:	0001                	nop

80003c18 <.LBE25>:
80003c18:	57f2                	lw	a5,60(sp)
80003c1a:	0785                	addi	a5,a5,1
80003c1c:	de3e                	sw	a5,60(sp)

80003c1e <.L2>:
80003c1e:	5772                	lw	a4,60(sp)
80003c20:	07f00793          	li	a5,127
80003c24:	fce7f1e3          	bgeu	a5,a4,80003be6 <.L3>

80003c28 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
80003c28:	dc02                	sw	zero,56(sp)
80003c2a:	a821                	j	80003c42 <.L4>

80003c2c <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
80003c2c:	57e2                	lw	a5,56(sp)
80003c2e:	00279713          	slli	a4,a5,0x2
80003c32:	e40027b7          	lui	a5,0xe4002
80003c36:	97ba                	add	a5,a5,a4
80003c38:	0007a023          	sw	zero,0(a5) # e4002000 <__FLASH_segment_end__+0x63f02000>
    for (uint32_t i = 0; i < 4; i++) {
80003c3c:	57e2                	lw	a5,56(sp)
80003c3e:	0785                	addi	a5,a5,1
80003c40:	dc3e                	sw	a5,56(sp)

80003c42 <.L4>:
80003c42:	5762                	lw	a4,56(sp)
80003c44:	478d                	li	a5,3
80003c46:	fee7f3e3          	bgeu	a5,a4,80003c2c <.L5>

80003c4a <.LBE29>:
    }
}
80003c4a:	0001                	nop
80003c4c:	0001                	nop
80003c4e:	6121                	addi	sp,sp,64
80003c50:	8082                	ret

Disassembly of section .text.syscall_handler:

80003c52 <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
80003c52:	1101                	addi	sp,sp,-32
80003c54:	ce2a                	sw	a0,28(sp)
80003c56:	cc2e                	sw	a1,24(sp)
80003c58:	ca32                	sw	a2,20(sp)
80003c5a:	c836                	sw	a3,16(sp)
80003c5c:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
80003c5e:	0001                	nop
80003c60:	6105                	addi	sp,sp,32
80003c62:	8082                	ret

Disassembly of section .text.system_init:

80003c64 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
80003c64:	7179                	addi	sp,sp,-48
80003c66:	d606                	sw	ra,44(sp)

80003c68 <.LBB16>:
#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
80003c68:	306027f3          	csrr	a5,mcounteren
80003c6c:	ce3e                	sw	a5,28(sp)
80003c6e:	47f2                	lw	a5,28(sp)

80003c70 <.LBE16>:
80003c70:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80003c72:	47e2                	lw	a5,24(sp)
80003c74:	0017e793          	ori	a5,a5,1
80003c78:	30679073          	csrw	mcounteren,a5
80003c7c:	47a1                	li	a5,8
80003c7e:	c83e                	sw	a5,16(sp)

80003c80 <.LBB17>:
    return read_clear_csr(CSR_MSTATUS, mask);
80003c80:	c602                	sw	zero,12(sp)
80003c82:	47c2                	lw	a5,16(sp)
80003c84:	3007b7f3          	csrrc	a5,mstatus,a5
80003c88:	c63e                	sw	a5,12(sp)
80003c8a:	47b2                	lw	a5,12(sp)

80003c8c <.LBE19>:
80003c8c:	0001                	nop

80003c8e <.LBB20>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003c8e:	28b01793          	bseti	a5,zero,0xb
80003c92:	3047b073          	csrc	mie,a5
}
80003c96:	0001                	nop

80003c98 <.LBE20>:
#endif

    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();

    enable_plic_feature();
80003c98:	678020ef          	jal	80006310 <enable_plic_feature>

80003c9c <.LBB22>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003c9c:	28b01793          	bseti	a5,zero,0xb
80003ca0:	3047a073          	csrs	mie,a5
}
80003ca4:	0001                	nop
80003ca6:	47a1                	li	a5,8
80003ca8:	ca3e                	sw	a5,20(sp)

80003caa <.LBB24>:
    set_csr(CSR_MSTATUS, mask);
80003caa:	47d2                	lw	a5,20(sp)
80003cac:	3007a073          	csrs	mstatus,a5
}
80003cb0:	0001                	nop

80003cb2 <.LBE24>:
    enable_irq_from_intc();

#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif
}
80003cb2:	0001                	nop
80003cb4:	50b2                	lw	ra,44(sp)
80003cb6:	6145                	addi	sp,sp,48
80003cb8:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

80003cba <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
80003cba:	1141                	addi	sp,sp,-16
80003cbc:	c62a                	sw	a0,12(sp)
80003cbe:	87ae                	mv	a5,a1
80003cc0:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
80003cc4:	00a15783          	lhu	a5,10(sp)
80003cc8:	4732                	lw	a4,12(sp)
80003cca:	078a                	slli	a5,a5,0x2
80003ccc:	97ba                	add	a5,a5,a4
80003cce:	4398                	lw	a4,0(a5)
80003cd0:	400007b7          	lui	a5,0x40000
80003cd4:	8ff9                	and	a5,a5,a4
80003cd6:	00f037b3          	snez	a5,a5
80003cda:	0ff7f793          	zext.b	a5,a5
}
80003cde:	853e                	mv	a0,a5
80003ce0:	0141                	addi	sp,sp,16
80003ce2:	8082                	ret

Disassembly of section .text.sysctl_cpu_clock_any_is_busy:

80003ce4 <sysctl_cpu_clock_any_is_busy>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @return true if any clock is busy
 */
static inline bool sysctl_cpu_clock_any_is_busy(SYSCTL_Type *ptr)
{
80003ce4:	1141                	addi	sp,sp,-16
80003ce6:	c62a                	sw	a0,12(sp)
    return ptr->CLOCK_CPU[0] & SYSCTL_CLOCK_CPU_GLB_BUSY_MASK;
80003ce8:	4732                	lw	a4,12(sp)
80003cea:	6789                	lui	a5,0x2
80003cec:	97ba                	add	a5,a5,a4
80003cee:	8007a703          	lw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003cf2:	800007b7          	lui	a5,0x80000
80003cf6:	8ff9                	and	a5,a5,a4
80003cf8:	00f037b3          	snez	a5,a5
80003cfc:	0ff7f793          	zext.b	a5,a5
}
80003d00:	853e                	mv	a0,a5
80003d02:	0141                	addi	sp,sp,16
80003d04:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

80003d06 <sysctl_clock_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr, clock_node_t clock)
{
80003d06:	1141                	addi	sp,sp,-16
80003d08:	c62a                	sw	a0,12(sp)
80003d0a:	87ae                	mv	a5,a1
80003d0c:	00f105a3          	sb	a5,11(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
80003d10:	00b14783          	lbu	a5,11(sp)
80003d14:	4732                	lw	a4,12(sp)
80003d16:	60078793          	addi	a5,a5,1536 # 80000600 <__NOR_CFG_OPTION_segment_used_end__+0x1f0>
80003d1a:	078a                	slli	a5,a5,0x2
80003d1c:	97ba                	add	a5,a5,a4
80003d1e:	43d8                	lw	a4,4(a5)
80003d20:	400007b7          	lui	a5,0x40000
80003d24:	8ff9                	and	a5,a5,a4
80003d26:	00f037b3          	snez	a5,a5
80003d2a:	0ff7f793          	zext.b	a5,a5
}
80003d2e:	853e                	mv	a0,a5
80003d30:	0141                	addi	sp,sp,16
80003d32:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

80003d34 <sysctl_config_clock>:
    }
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node, clock_source_t source, uint32_t divide_by)
{
80003d34:	1101                	addi	sp,sp,-32
80003d36:	ce06                	sw	ra,28(sp)
80003d38:	c62a                	sw	a0,12(sp)
80003d3a:	87ae                	mv	a5,a1
80003d3c:	8732                	mv	a4,a2
80003d3e:	c236                	sw	a3,4(sp)
80003d40:	00f105a3          	sb	a5,11(sp)
80003d44:	87ba                	mv	a5,a4
80003d46:	00f10523          	sb	a5,10(sp)
    if (node >= clock_node_adc_start) {
80003d4a:	00b14703          	lbu	a4,11(sp)
80003d4e:	02300793          	li	a5,35
80003d52:	00e7f463          	bgeu	a5,a4,80003d5a <.L81>
        return status_invalid_argument;
80003d56:	4789                	li	a5,2
80003d58:	a8b1                	j	80003db4 <.L82>

80003d5a <.L81>:
    }

    if (source >= clock_source_general_source_end) {
80003d5a:	00a14703          	lbu	a4,10(sp)
80003d5e:	479d                	li	a5,7
80003d60:	00e7f463          	bgeu	a5,a4,80003d68 <.L83>
        return status_invalid_argument;
80003d64:	4789                	li	a5,2
80003d66:	a0b9                	j	80003db4 <.L82>

80003d68 <.L83>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80003d68:	00b14783          	lbu	a5,11(sp)
80003d6c:	4732                	lw	a4,12(sp)
80003d6e:	60078793          	addi	a5,a5,1536 # 40000600 <_flash_size+0x3ff00600>
80003d72:	078a                	slli	a5,a5,0x2
80003d74:	97ba                	add	a5,a5,a4
80003d76:	43dc                	lw	a5,4(a5)
80003d78:	8007f693          	andi	a3,a5,-2048
        (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80003d7c:	00a14783          	lbu	a5,10(sp)
80003d80:	07a2                	slli	a5,a5,0x8
80003d82:	7007f713          	andi	a4,a5,1792
80003d86:	4792                	lw	a5,4(sp)
80003d88:	17fd                	addi	a5,a5,-1
80003d8a:	0ff7f793          	zext.b	a5,a5
80003d8e:	8f5d                	or	a4,a4,a5
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80003d90:	00b14783          	lbu	a5,11(sp)
80003d94:	8f55                	or	a4,a4,a3
80003d96:	46b2                	lw	a3,12(sp)
80003d98:	60078793          	addi	a5,a5,1536
80003d9c:	078a                	slli	a5,a5,0x2
80003d9e:	97b6                	add	a5,a5,a3
80003da0:	c3d8                	sw	a4,4(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
80003da2:	0001                	nop

80003da4 <.L84>:
80003da4:	00b14783          	lbu	a5,11(sp)
80003da8:	85be                	mv	a1,a5
80003daa:	4532                	lw	a0,12(sp)
80003dac:	3fa9                	jal	80003d06 <sysctl_clock_target_is_busy>
80003dae:	87aa                	mv	a5,a0
80003db0:	fbf5                	bnez	a5,80003da4 <.L84>
    }
    return status_success;
80003db2:	4781                	li	a5,0

80003db4 <.L82>:
}
80003db4:	853e                	mv	a0,a5
80003db6:	40f2                	lw	ra,28(sp)
80003db8:	6105                	addi	sp,sp,32
80003dba:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

80003dbc <get_frequency_for_source>:
    }
    return clk_freq;
}

uint32_t get_frequency_for_source(clock_source_t source)
{
80003dbc:	7179                	addi	sp,sp,-48
80003dbe:	d606                	sw	ra,44(sp)
80003dc0:	87aa                	mv	a5,a0
80003dc2:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80003dc6:	ce02                	sw	zero,28(sp)
    switch (source) {
80003dc8:	00f14783          	lbu	a5,15(sp)
80003dcc:	471d                	li	a4,7
80003dce:	08f76763          	bltu	a4,a5,80003e5c <.L30>
80003dd2:	00279713          	slli	a4,a5,0x2
80003dd6:	8f018793          	addi	a5,gp,-1808 # 80003180 <.L32>
80003dda:	97ba                	add	a5,a5,a4
80003ddc:	439c                	lw	a5,0(a5)
80003dde:	8782                	jr	a5

80003de0 <.L39>:
    case clock_source_osc0_clk0:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80003de0:	016e37b7          	lui	a5,0x16e3
80003de4:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80003de8:	ce3e                	sw	a5,28(sp)
        break;
80003dea:	a89d                	j	80003e60 <.L40>

80003dec <.L38>:
    case clock_source_pll0_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0);
80003dec:	4601                	li	a2,0
80003dee:	4581                	li	a1,0
80003df0:	f40c0537          	lui	a0,0xf40c0
80003df4:	398030ef          	jal	8000718c <pllctlv2_get_pll_postdiv_freq_in_hz>
80003df8:	ce2a                	sw	a0,28(sp)
        break;
80003dfa:	a09d                	j	80003e60 <.L40>

80003dfc <.L37>:
    case clock_source_pll0_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1);
80003dfc:	4605                	li	a2,1
80003dfe:	4581                	li	a1,0
80003e00:	f40c0537          	lui	a0,0xf40c0
80003e04:	388030ef          	jal	8000718c <pllctlv2_get_pll_postdiv_freq_in_hz>
80003e08:	ce2a                	sw	a0,28(sp)
        break;
80003e0a:	a899                	j	80003e60 <.L40>

80003e0c <.L36>:
    case clock_source_pll0_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk2);
80003e0c:	4609                	li	a2,2
80003e0e:	4581                	li	a1,0
80003e10:	f40c0537          	lui	a0,0xf40c0
80003e14:	378030ef          	jal	8000718c <pllctlv2_get_pll_postdiv_freq_in_hz>
80003e18:	ce2a                	sw	a0,28(sp)
        break;
80003e1a:	a099                	j	80003e60 <.L40>

80003e1c <.L35>:
    case clock_source_pll1_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk0);
80003e1c:	4601                	li	a2,0
80003e1e:	4585                	li	a1,1
80003e20:	f40c0537          	lui	a0,0xf40c0
80003e24:	368030ef          	jal	8000718c <pllctlv2_get_pll_postdiv_freq_in_hz>
80003e28:	ce2a                	sw	a0,28(sp)
        break;
80003e2a:	a81d                	j	80003e60 <.L40>

80003e2c <.L34>:
    case clock_source_pll1_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk1);
80003e2c:	4605                	li	a2,1
80003e2e:	4585                	li	a1,1
80003e30:	f40c0537          	lui	a0,0xf40c0
80003e34:	358030ef          	jal	8000718c <pllctlv2_get_pll_postdiv_freq_in_hz>
80003e38:	ce2a                	sw	a0,28(sp)
        break;
80003e3a:	a01d                	j	80003e60 <.L40>

80003e3c <.L33>:
    case clock_source_pll1_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk2);
80003e3c:	4609                	li	a2,2
80003e3e:	4585                	li	a1,1
80003e40:	f40c0537          	lui	a0,0xf40c0
80003e44:	348030ef          	jal	8000718c <pllctlv2_get_pll_postdiv_freq_in_hz>
80003e48:	ce2a                	sw	a0,28(sp)
        break;
80003e4a:	a819                	j	80003e60 <.L40>

80003e4c <.L31>:
    case clock_source_pll1_clk3:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk3);
80003e4c:	460d                	li	a2,3
80003e4e:	4585                	li	a1,1
80003e50:	f40c0537          	lui	a0,0xf40c0
80003e54:	338030ef          	jal	8000718c <pllctlv2_get_pll_postdiv_freq_in_hz>
80003e58:	ce2a                	sw	a0,28(sp)
        break;
80003e5a:	a019                	j	80003e60 <.L40>

80003e5c <.L30>:
    default:
        clk_freq = 0UL;
80003e5c:	ce02                	sw	zero,28(sp)
        break;
80003e5e:	0001                	nop

80003e60 <.L40>:
    }

    return clk_freq;
80003e60:	47f2                	lw	a5,28(sp)
}
80003e62:	853e                	mv	a0,a5
80003e64:	50b2                	lw	ra,44(sp)
80003e66:	6145                	addi	sp,sp,48
80003e68:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

80003e6a <get_frequency_for_ip_in_common_group>:

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
80003e6a:	7139                	addi	sp,sp,-64
80003e6c:	de06                	sw	ra,60(sp)
80003e6e:	87aa                	mv	a5,a0
80003e70:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80003e74:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
80003e76:	00f14783          	lbu	a5,15(sp)
80003e7a:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
80003e7c:	5722                	lw	a4,40(sp)
80003e7e:	02700793          	li	a5,39
80003e82:	04e7e563          	bltu	a5,a4,80003ecc <.L43>

80003e86 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
80003e86:	57a2                	lw	a5,40(sp)
80003e88:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
80003e8a:	f4000737          	lui	a4,0xf4000
80003e8e:	5792                	lw	a5,36(sp)
80003e90:	60078793          	addi	a5,a5,1536
80003e94:	078a                	slli	a5,a5,0x2
80003e96:	97ba                	add	a5,a5,a4
80003e98:	43dc                	lw	a5,4(a5)
80003e9a:	0ff7f793          	zext.b	a5,a5
80003e9e:	0785                	addi	a5,a5,1
80003ea0:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
80003ea2:	f4000737          	lui	a4,0xf4000
80003ea6:	5792                	lw	a5,36(sp)
80003ea8:	60078793          	addi	a5,a5,1536
80003eac:	078a                	slli	a5,a5,0x2
80003eae:	97ba                	add	a5,a5,a4
80003eb0:	43dc                	lw	a5,4(a5)
80003eb2:	83a1                	srli	a5,a5,0x8
80003eb4:	8b9d                	andi	a5,a5,7
80003eb6:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
80003eba:	01f14783          	lbu	a5,31(sp)
80003ebe:	853e                	mv	a0,a5
80003ec0:	3df5                	jal	80003dbc <get_frequency_for_source>
80003ec2:	872a                	mv	a4,a0
80003ec4:	5782                	lw	a5,32(sp)
80003ec6:	02f757b3          	divu	a5,a4,a5
80003eca:	d63e                	sw	a5,44(sp)

80003ecc <.L43>:
    }
    return clk_freq;
80003ecc:	57b2                	lw	a5,44(sp)
}
80003ece:	853e                	mv	a0,a5
80003ed0:	50f2                	lw	ra,60(sp)
80003ed2:	6121                	addi	sp,sp,64
80003ed4:	8082                	ret

Disassembly of section .text.get_frequency_for_adc:

80003ed6 <get_frequency_for_adc>:

static uint32_t get_frequency_for_adc(uint32_t clk_src_type, uint32_t instance)
{
80003ed6:	7179                	addi	sp,sp,-48
80003ed8:	d606                	sw	ra,44(sp)
80003eda:	c62a                	sw	a0,12(sp)
80003edc:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
80003ede:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
80003ee0:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
80003ee4:	02800793          	li	a5,40
80003ee8:	00f10d23          	sb	a5,26(sp)
    uint32_t adc_index = instance;
80003eec:	47a2                	lw	a5,8(sp)
80003eee:	ca3e                	sw	a5,20(sp)

    (void) clk_src_type;

    if (adc_index < ADC_INSTANCE_NUM) {
80003ef0:	4752                	lw	a4,20(sp)
80003ef2:	4785                	li	a5,1
80003ef4:	02e7ee63          	bltu	a5,a4,80003f30 <.L46>

80003ef8 <.LBB7>:
        uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
80003ef8:	f4000737          	lui	a4,0xf4000
80003efc:	47d2                	lw	a5,20(sp)
80003efe:	70078793          	addi	a5,a5,1792
80003f02:	078a                	slli	a5,a5,0x2
80003f04:	97ba                	add	a5,a5,a4
80003f06:	439c                	lw	a5,0(a5)
80003f08:	83a1                	srli	a5,a5,0x8
80003f0a:	8b85                	andi	a5,a5,1
80003f0c:	c83e                	sw	a5,16(sp)
        if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
80003f0e:	4742                	lw	a4,16(sp)
80003f10:	4785                	li	a5,1
80003f12:	00e7ef63          	bltu	a5,a4,80003f30 <.L46>
            node = s_adc_clk_mux_node[mux_in_reg];
80003f16:	800047b7          	lui	a5,0x80004
80003f1a:	8bc78713          	addi	a4,a5,-1860 # 800038bc <s_adc_clk_mux_node>
80003f1e:	47c2                	lw	a5,16(sp)
80003f20:	97ba                	add	a5,a5,a4
80003f22:	0007c783          	lbu	a5,0(a5)
80003f26:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
80003f2a:	4785                	li	a5,1
80003f2c:	00f10da3          	sb	a5,27(sp)

80003f30 <.L46>:
        }
    }

    if (is_mux_valid) {
80003f30:	01b14783          	lbu	a5,27(sp)
80003f34:	cb85                	beqz	a5,80003f64 <.L47>
        if (node != clock_node_ahb) {
80003f36:	01a14703          	lbu	a4,26(sp)
80003f3a:	0fe00793          	li	a5,254
80003f3e:	02f70063          	beq	a4,a5,80003f5e <.L48>
            node += instance;
80003f42:	47a2                	lw	a5,8(sp)
80003f44:	0ff7f793          	zext.b	a5,a5
80003f48:	01a14703          	lbu	a4,26(sp)
80003f4c:	97ba                	add	a5,a5,a4
80003f4e:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
80003f52:	01a14783          	lbu	a5,26(sp)
80003f56:	853e                	mv	a0,a5
80003f58:	3f09                	jal	80003e6a <get_frequency_for_ip_in_common_group>
80003f5a:	ce2a                	sw	a0,28(sp)
80003f5c:	a021                	j	80003f64 <.L47>

80003f5e <.L48>:
        } else {
            clk_freq = get_frequency_for_ahb();
80003f5e:	720020ef          	jal	8000667e <get_frequency_for_ahb>
80003f62:	ce2a                	sw	a0,28(sp)

80003f64 <.L47>:
        }
    }
    return clk_freq;
80003f64:	47f2                	lw	a5,28(sp)
}
80003f66:	853e                	mv	a0,a5
80003f68:	50b2                	lw	ra,44(sp)
80003f6a:	6145                	addi	sp,sp,48
80003f6c:	8082                	ret

Disassembly of section .text.get_frequency_for_ewdg:

80003f6e <get_frequency_for_ewdg>:

    return clk_freq;
}

static uint32_t get_frequency_for_ewdg(uint32_t instance)
{
80003f6e:	7179                	addi	sp,sp,-48
80003f70:	d606                	sw	ra,44(sp)
80003f72:	c62a                	sw	a0,12(sp)
    uint32_t freq_in_hz;
    if (EWDG_CTRL0_CLK_SEL_GET(s_wdgs[instance]->CTRL0) == 0) {
80003f74:	8b818713          	addi	a4,gp,-1864 # 80003148 <s_wdgs>
80003f78:	47b2                	lw	a5,12(sp)
80003f7a:	078a                	slli	a5,a5,0x2
80003f7c:	97ba                	add	a5,a5,a4
80003f7e:	439c                	lw	a5,0(a5)
80003f80:	4398                	lw	a4,0(a5)
80003f82:	200007b7          	lui	a5,0x20000
80003f86:	8ff9                	and	a5,a5,a4
80003f88:	e789                	bnez	a5,80003f92 <.L56>
        freq_in_hz = get_frequency_for_ahb();
80003f8a:	6f4020ef          	jal	8000667e <get_frequency_for_ahb>
80003f8e:	ce2a                	sw	a0,28(sp)
80003f90:	a019                	j	80003f96 <.L57>

80003f92 <.L56>:
    } else {
        freq_in_hz = FREQ_32KHz;
80003f92:	67a1                	lui	a5,0x8
80003f94:	ce3e                	sw	a5,28(sp)

80003f96 <.L57>:
    }

    return freq_in_hz;
80003f96:	47f2                	lw	a5,28(sp)
}
80003f98:	853e                	mv	a0,a5
80003f9a:	50b2                	lw	ra,44(sp)
80003f9c:	6145                	addi	sp,sp,48
80003f9e:	8082                	ret

Disassembly of section .text.get_frequency_for_cpu:

80003fa0 <get_frequency_for_cpu>:

    return freq_in_hz;
}

static uint32_t get_frequency_for_cpu(void)
{
80003fa0:	1101                	addi	sp,sp,-32
80003fa2:	ce06                	sw	ra,28(sp)
    uint32_t mux = SYSCTL_CLOCK_CPU_MUX_GET(HPM_SYSCTL->CLOCK_CPU[0]);
80003fa4:	f4000737          	lui	a4,0xf4000
80003fa8:	6789                	lui	a5,0x2
80003faa:	97ba                	add	a5,a5,a4
80003fac:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003fb0:	83a1                	srli	a5,a5,0x8
80003fb2:	8b9d                	andi	a5,a5,7
80003fb4:	c63e                	sw	a5,12(sp)
    uint32_t div = SYSCTL_CLOCK_CPU_DIV_GET(HPM_SYSCTL->CLOCK_CPU[0]) + 1U;
80003fb6:	f4000737          	lui	a4,0xf4000
80003fba:	6789                	lui	a5,0x2
80003fbc:	97ba                	add	a5,a5,a4
80003fbe:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003fc2:	0ff7f793          	zext.b	a5,a5
80003fc6:	0785                	addi	a5,a5,1
80003fc8:	c43e                	sw	a5,8(sp)
    return (get_frequency_for_source(mux) / div);
80003fca:	47b2                	lw	a5,12(sp)
80003fcc:	0ff7f793          	zext.b	a5,a5
80003fd0:	853e                	mv	a0,a5
80003fd2:	33ed                	jal	80003dbc <get_frequency_for_source>
80003fd4:	872a                	mv	a4,a0
80003fd6:	47a2                	lw	a5,8(sp)
80003fd8:	02f757b3          	divu	a5,a4,a5
}
80003fdc:	853e                	mv	a0,a5
80003fde:	40f2                	lw	ra,28(sp)
80003fe0:	6105                	addi	sp,sp,32
80003fe2:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80003fe4 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80003fe4:	7179                	addi	sp,sp,-48
80003fe6:	d606                	sw	ra,44(sp)
80003fe8:	c62a                	sw	a0,12(sp)
80003fea:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80003fec:	47b2                	lw	a5,12(sp)
80003fee:	83c1                	srli	a5,a5,0x10
80003ff0:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80003ff2:	4772                	lw	a4,28(sp)
80003ff4:	13600793          	li	a5,310
80003ff8:	00e7ef63          	bltu	a5,a4,80004016 <.L155>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
80003ffc:	47a2                	lw	a5,8(sp)
80003ffe:	0ff7f793          	zext.b	a5,a5
80004002:	4772                	lw	a4,28(sp)
80004004:	08074733          	zext.h	a4,a4
80004008:	4685                	li	a3,1
8000400a:	863a                	mv	a2,a4
8000400c:	85be                	mv	a1,a5
8000400e:	f4000537          	lui	a0,0xf4000
80004012:	32a020ef          	jal	8000633c <sysctl_enable_group_resource>

80004016 <.L155>:
    }
}
80004016:	0001                	nop
80004018:	50b2                	lw	ra,44(sp)
8000401a:	6145                	addi	sp,sp,48
8000401c:	8082                	ret

Disassembly of section .text.clock_remove_from_group:

8000401e <clock_remove_from_group>:

void clock_remove_from_group(clock_name_t clock_name, uint32_t group)
{
8000401e:	7179                	addi	sp,sp,-48
80004020:	d606                	sw	ra,44(sp)
80004022:	c62a                	sw	a0,12(sp)
80004024:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80004026:	47b2                	lw	a5,12(sp)
80004028:	83c1                	srli	a5,a5,0x10
8000402a:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
8000402c:	4772                	lw	a4,28(sp)
8000402e:	13600793          	li	a5,310
80004032:	00e7ef63          	bltu	a5,a4,80004050 <.L158>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, false);
80004036:	47a2                	lw	a5,8(sp)
80004038:	0ff7f793          	zext.b	a5,a5
8000403c:	4772                	lw	a4,28(sp)
8000403e:	08074733          	zext.h	a4,a4
80004042:	4681                	li	a3,0
80004044:	863a                	mv	a2,a4
80004046:	85be                	mv	a1,a5
80004048:	f4000537          	lui	a0,0xf4000
8000404c:	2f0020ef          	jal	8000633c <sysctl_enable_group_resource>

80004050 <.L158>:
    }
}
80004050:	0001                	nop
80004052:	50b2                	lw	ra,44(sp)
80004054:	6145                	addi	sp,sp,48
80004056:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

80004058 <l1c_dc_enable>:
    }
#endif
}

void l1c_dc_enable(void)
{
80004058:	1101                	addi	sp,sp,-32
8000405a:	ce06                	sw	ra,28(sp)

8000405c <.LBB48>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
8000405c:	7ca027f3          	csrr	a5,0x7ca
80004060:	c63e                	sw	a5,12(sp)
80004062:	47b2                	lw	a5,12(sp)

80004064 <.LBE52>:
80004064:	0001                	nop

80004066 <.LBE50>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
80004066:	8b89                	andi	a5,a5,2
80004068:	00f037b3          	snez	a5,a5
8000406c:	0ff7f793          	zext.b	a5,a5

80004070 <.LBE48>:
    if (!l1c_dc_is_enabled()) {
80004070:	0017c793          	xori	a5,a5,1
80004074:	0ff7f793          	zext.b	a5,a5
80004078:	c791                	beqz	a5,80004084 <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
8000407a:	2081                	jal	800040ba <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
8000407c:	40200793          	li	a5,1026
80004080:	7ca7a073          	csrs	0x7ca,a5

80004084 <.L11>:
    }
}
80004084:	0001                	nop
80004086:	40f2                	lw	ra,28(sp)
80004088:	6105                	addi	sp,sp,32
8000408a:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

8000408c <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
8000408c:	1141                	addi	sp,sp,-16

8000408e <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
8000408e:	7ca027f3          	csrr	a5,0x7ca
80004092:	c63e                	sw	a5,12(sp)
80004094:	47b2                	lw	a5,12(sp)

80004096 <.LBE62>:
80004096:	0001                	nop

80004098 <.LBE60>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
80004098:	8b85                	andi	a5,a5,1
8000409a:	00f037b3          	snez	a5,a5
8000409e:	0ff7f793          	zext.b	a5,a5

800040a2 <.LBE58>:
    if (!l1c_ic_is_enabled()) {
800040a2:	0017c793          	xori	a5,a5,1
800040a6:	0ff7f793          	zext.b	a5,a5
800040aa:	c789                	beqz	a5,800040b4 <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
800040ac:	30100793          	li	a5,769
800040b0:	7ca7a073          	csrs	0x7ca,a5

800040b4 <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
800040b4:	0001                	nop
800040b6:	0141                	addi	sp,sp,16
800040b8:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

800040ba <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
800040ba:	6799                	lui	a5,0x6
800040bc:	7ca7a073          	csrs	0x7ca,a5
}
800040c0:	0001                	nop
800040c2:	8082                	ret

Disassembly of section .text.init_uart2_pins:

800040c4 <init_uart2_pins>:
    HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
}

void init_uart2_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PB08].FUNC_CTL = IOC_PB08_FUNC_CTL_UART2_TXD;
800040c4:	f40407b7          	lui	a5,0xf4040
800040c8:	4709                	li	a4,2
800040ca:	14e7a023          	sw	a4,320(a5) # f4040140 <__AHB_SRAM_segment_end__+0x3c38140>

    HPM_IOC->PAD[IOC_PAD_PB09].FUNC_CTL = IOC_PB09_FUNC_CTL_UART2_RXD;
800040ce:	f40407b7          	lui	a5,0xf4040
800040d2:	4709                	li	a4,2
800040d4:	14e7a423          	sw	a4,328(a5) # f4040148 <__AHB_SRAM_segment_end__+0x3c38148>

    HPM_IOC->PAD[IOC_PAD_PB10].FUNC_CTL = IOC_PB10_FUNC_CTL_UART2_DE;
800040d8:	f40407b7          	lui	a5,0xf4040
800040dc:	4709                	li	a4,2
800040de:	14e7a823          	sw	a4,336(a5) # f4040150 <__AHB_SRAM_segment_end__+0x3c38150>
}
800040e2:	0001                	nop
800040e4:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

800040e6 <sysctl_resource_target_is_busy>:
{
800040e6:	1141                	addi	sp,sp,-16
800040e8:	c62a                	sw	a0,12(sp)
800040ea:	87ae                	mv	a5,a1
800040ec:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
800040f0:	00a15783          	lhu	a5,10(sp)
800040f4:	4732                	lw	a4,12(sp)
800040f6:	078a                	slli	a5,a5,0x2
800040f8:	97ba                	add	a5,a5,a4
800040fa:	4398                	lw	a4,0(a5)
800040fc:	400007b7          	lui	a5,0x40000
80004100:	8ff9                	and	a5,a5,a4
80004102:	00f037b3          	snez	a5,a5
80004106:	0ff7f793          	zext.b	a5,a5
}
8000410a:	853e                	mv	a0,a5
8000410c:	0141                	addi	sp,sp,16
8000410e:	8082                	ret

Disassembly of section .text.sysctl_resource_target_set_mode:

80004110 <sysctl_resource_target_set_mode>:
{
80004110:	1141                	addi	sp,sp,-16
80004112:	c62a                	sw	a0,12(sp)
80004114:	87ae                	mv	a5,a1
80004116:	8732                	mv	a4,a2
80004118:	00f11523          	sh	a5,10(sp)
8000411c:	87ba                	mv	a5,a4
8000411e:	00f104a3          	sb	a5,9(sp)
        (ptr->RESOURCE[resource] & ~SYSCTL_RESOURCE_MODE_MASK) |
80004122:	00a15783          	lhu	a5,10(sp)
80004126:	4732                	lw	a4,12(sp)
80004128:	078a                	slli	a5,a5,0x2
8000412a:	97ba                	add	a5,a5,a4
8000412c:	439c                	lw	a5,0(a5)
8000412e:	ffc7f693          	andi	a3,a5,-4
        SYSCTL_RESOURCE_MODE_SET(mode);
80004132:	00914783          	lbu	a5,9(sp)
80004136:	0037f713          	andi	a4,a5,3
    ptr->RESOURCE[resource] =
8000413a:	00a15783          	lhu	a5,10(sp)
        (ptr->RESOURCE[resource] & ~SYSCTL_RESOURCE_MODE_MASK) |
8000413e:	8f55                	or	a4,a4,a3
    ptr->RESOURCE[resource] =
80004140:	46b2                	lw	a3,12(sp)
80004142:	078a                	slli	a5,a5,0x2
80004144:	97b6                	add	a5,a5,a3
80004146:	c398                	sw	a4,0(a5)
}
80004148:	0001                	nop
8000414a:	0141                	addi	sp,sp,16
8000414c:	8082                	ret

Disassembly of section .text.sysctl_resource_target_get_mode:

8000414e <sysctl_resource_target_get_mode>:
{
8000414e:	1141                	addi	sp,sp,-16
80004150:	c62a                	sw	a0,12(sp)
80004152:	87ae                	mv	a5,a1
80004154:	00f11523          	sh	a5,10(sp)
    return SYSCTL_RESOURCE_MODE_GET(ptr->RESOURCE[resource]);
80004158:	00a15783          	lhu	a5,10(sp)
8000415c:	4732                	lw	a4,12(sp)
8000415e:	078a                	slli	a5,a5,0x2
80004160:	97ba                	add	a5,a5,a4
80004162:	439c                	lw	a5,0(a5)
80004164:	0ff7f793          	zext.b	a5,a5
80004168:	8b8d                	andi	a5,a5,3
8000416a:	0ff7f793          	zext.b	a5,a5
}
8000416e:	853e                	mv	a0,a5
80004170:	0141                	addi	sp,sp,16
80004172:	8082                	ret

Disassembly of section .text.sysctl_clock_set_preset:

80004174 <sysctl_clock_set_preset>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] preset preset
 */
static inline void sysctl_clock_set_preset(SYSCTL_Type *ptr, sysctl_preset_t preset)
{
80004174:	1141                	addi	sp,sp,-16
80004176:	c62a                	sw	a0,12(sp)
80004178:	87ae                	mv	a5,a1
8000417a:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_MUX_MASK) | SYSCTL_GLOBAL00_MUX_SET(preset);
8000417e:	4732                	lw	a4,12(sp)
80004180:	6789                	lui	a5,0x2
80004182:	97ba                	add	a5,a5,a4
80004184:	439c                	lw	a5,0(a5)
80004186:	f007f713          	andi	a4,a5,-256
8000418a:	00b14783          	lbu	a5,11(sp)
8000418e:	8f5d                	or	a4,a4,a5
80004190:	46b2                	lw	a3,12(sp)
80004192:	6789                	lui	a5,0x2
80004194:	97b6                	add	a5,a5,a3
80004196:	c398                	sw	a4,0(a5)
}
80004198:	0001                	nop
8000419a:	0141                	addi	sp,sp,16
8000419c:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_is_stable:

8000419e <pllctlv2_xtal_is_stable>:
 * @brief Checks the stability status of the external crystal oscillator
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @return true if the external crystal oscillator is stable and ready for use
 */
static inline bool pllctlv2_xtal_is_stable(PLLCTLV2_Type *ptr)
{
8000419e:	1101                	addi	sp,sp,-32
800041a0:	c62a                	sw	a0,12(sp)
    uint32_t status = ptr->XTAL;
800041a2:	47b2                	lw	a5,12(sp)
800041a4:	439c                	lw	a5,0(a5)
800041a6:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_XTAL_ENABLE_MASK)
800041a8:	4772                	lw	a4,28(sp)
800041aa:	100007b7          	lui	a5,0x10000
800041ae:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_XTAL_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_XTAL_RESPONSE_MASK)));
800041b0:	cb89                	beqz	a5,800041c2 <.L30>
800041b2:	47f2                	lw	a5,28(sp)
800041b4:	0007c963          	bltz	a5,800041c6 <.L31>
800041b8:	4772                	lw	a4,28(sp)
800041ba:	200007b7          	lui	a5,0x20000
800041be:	8ff9                	and	a5,a5,a4
800041c0:	c399                	beqz	a5,800041c6 <.L31>

800041c2 <.L30>:
800041c2:	4785                	li	a5,1
800041c4:	a011                	j	800041c8 <.L32>

800041c6 <.L31>:
800041c6:	4781                	li	a5,0

800041c8 <.L32>:
800041c8:	8b85                	andi	a5,a5,1
800041ca:	0ff7f793          	zext.b	a5,a5
}
800041ce:	853e                	mv	a0,a5
800041d0:	6105                	addi	sp,sp,32
800041d2:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_set_rampup_time:

800041d4 <pllctlv2_xtal_set_rampup_time>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] rc24m_cycles Number of RC24M clock cycles for the ramp-up period
 * @note The ramp-up time affects how quickly the crystal oscillator reaches stable operation
 */
static inline void pllctlv2_xtal_set_rampup_time(PLLCTLV2_Type *ptr, uint32_t rc24m_cycles)
{
800041d4:	1141                	addi	sp,sp,-16
800041d6:	c62a                	sw	a0,12(sp)
800041d8:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTLV2_XTAL_RAMP_TIME_MASK) | PLLCTLV2_XTAL_RAMP_TIME_SET(rc24m_cycles);
800041da:	47b2                	lw	a5,12(sp)
800041dc:	4398                	lw	a4,0(a5)
800041de:	fff007b7          	lui	a5,0xfff00
800041e2:	8f7d                	and	a4,a4,a5
800041e4:	46a2                	lw	a3,8(sp)
800041e6:	001007b7          	lui	a5,0x100
800041ea:	17fd                	addi	a5,a5,-1 # fffff <__FLASH_segment_size__+0x2fff>
800041ec:	8ff5                	and	a5,a5,a3
800041ee:	8f5d                	or	a4,a4,a5
800041f0:	47b2                	lw	a5,12(sp)
800041f2:	c398                	sw	a4,0(a5)
}
800041f4:	0001                	nop
800041f6:	0141                	addi	sp,sp,16
800041f8:	8082                	ret

Disassembly of section .text.board_print_banner:

800041fa <board_print_banner>:
#endif
#endif
}

void board_print_banner(void)
{
800041fa:	d8010113          	addi	sp,sp,-640
800041fe:	26112e23          	sw	ra,636(sp)
    const uint8_t banner[] = "\n"
80004202:	95c18713          	addi	a4,gp,-1700 # 800031ec <.LC0>
80004206:	878a                	mv	a5,sp
80004208:	86ba                	mv	a3,a4
8000420a:	26f00713          	li	a4,623
8000420e:	863a                	mv	a2,a4
80004210:	85b6                	mv	a1,a3
80004212:	853e                	mv	a0,a5
80004214:	66b000ef          	jal	8000507e <memcpy>
"$$ |  $$ |$$ |      $$ |\\$  /$$ |$$ |$$ |      $$ |      $$ |  $$ |\n"
"$$ |  $$ |$$ |      $$ | \\_/ $$ |$$ |\\$$$$$$$\\ $$ |      \\$$$$$$  |\n"
"\\__|  \\__|\\__|      \\__|     \\__|\\__| \\_______|\\__|       \\______/\n"
"----------------------------------------------------------------------\n";
#ifdef SDK_VERSION_STRING
    printf("hpm_sdk: %s\n", SDK_VERSION_STRING);
80004218:	94018593          	addi	a1,gp,-1728 # 800031d0 <.LC1>
8000421c:	94818513          	addi	a0,gp,-1720 # 800031d8 <.LC2>
80004220:	130010ef          	jal	80005350 <printf>
#endif
    printf("%s", banner);
80004224:	878a                	mv	a5,sp
80004226:	85be                	mv	a1,a5
80004228:	95818513          	addi	a0,gp,-1704 # 800031e8 <.LC3>
8000422c:	124010ef          	jal	80005350 <printf>
}
80004230:	0001                	nop
80004232:	27c12083          	lw	ra,636(sp)
80004236:	28010113          	addi	sp,sp,640
8000423a:	8082                	ret

Disassembly of section .text.board_print_clock_freq:

8000423c <board_print_clock_freq>:

void board_print_clock_freq(void)
{
8000423c:	1141                	addi	sp,sp,-16
8000423e:	c606                	sw	ra,12(sp)
    printf("==============================\n");
80004240:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
80004244:	10c010ef          	jal	80005350 <printf>
    printf(" %s clock summary\n", BOARD_NAME);
80004248:	bec18593          	addi	a1,gp,-1044 # 8000347c <.LC5>
8000424c:	bf818513          	addi	a0,gp,-1032 # 80003488 <.LC6>
80004250:	100010ef          	jal	80005350 <printf>
    printf("==============================\n");
80004254:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
80004258:	0f8010ef          	jal	80005350 <printf>
    printf("cpu0:\t\t %luHz\n", clock_get_frequency(clock_cpu0));
8000425c:	6785                	lui	a5,0x1
8000425e:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x4b2>
80004262:	2c8020ef          	jal	8000652a <clock_get_frequency>
80004266:	87aa                	mv	a5,a0
80004268:	85be                	mv	a1,a5
8000426a:	c0c18513          	addi	a0,gp,-1012 # 8000349c <.LC7>
8000426e:	0e2010ef          	jal	80005350 <printf>
    printf("ahb:\t\t %luHz\n", clock_get_frequency(clock_ahb));
80004272:	fffd07b7          	lui	a5,0xfffd0
80004276:	5fe78513          	addi	a0,a5,1534 # fffd05fe <__AHB_SRAM_segment_end__+0xfbc85fe>
8000427a:	2b0020ef          	jal	8000652a <clock_get_frequency>
8000427e:	87aa                	mv	a5,a0
80004280:	85be                	mv	a1,a5
80004282:	c1c18513          	addi	a0,gp,-996 # 800034ac <.LC8>
80004286:	0ca010ef          	jal	80005350 <printf>
    printf("mchtmr0:\t %luHz\n", clock_get_frequency(clock_mchtmr0));
8000428a:	01020537          	lui	a0,0x1020
8000428e:	29c020ef          	jal	8000652a <clock_get_frequency>
80004292:	87aa                	mv	a5,a0
80004294:	85be                	mv	a1,a5
80004296:	c2c18513          	addi	a0,gp,-980 # 800034bc <.LC9>
8000429a:	0b6010ef          	jal	80005350 <printf>
    printf("xpi0:\t\t %luHz\n", clock_get_frequency(clock_xpi0));
8000429e:	013307b7          	lui	a5,0x1330
800042a2:	01d78513          	addi	a0,a5,29 # 133001d <_flash_size+0x123001d>
800042a6:	284020ef          	jal	8000652a <clock_get_frequency>
800042aa:	87aa                	mv	a5,a0
800042ac:	85be                	mv	a1,a5
800042ae:	c4018513          	addi	a0,gp,-960 # 800034d0 <.LC10>
800042b2:	09e010ef          	jal	80005350 <printf>
    printf("==============================\n");
800042b6:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
800042ba:	096010ef          	jal	80005350 <printf>
}
800042be:	0001                	nop
800042c0:	40b2                	lw	ra,12(sp)
800042c2:	0141                	addi	sp,sp,16
800042c4:	8082                	ret

Disassembly of section .text.board_init_usb_dp_dm_pins:

800042c6 <board_init_usb_dp_dm_pins>:
    board_print_banner();
#endif
}

void board_init_usb_dp_dm_pins(void)
{
800042c6:	1101                	addi	sp,sp,-32
800042c8:	ce06                	sw	ra,28(sp)
    /* Disconnect usb dp/dm pins pull down 45ohm resistance */

    while (sysctl_resource_any_is_busy(HPM_SYSCTL)) {
800042ca:	0001                	nop

800042cc <.L50>:
800042cc:	f4000537          	lui	a0,0xf4000
800042d0:	5e4020ef          	jal	800068b4 <sysctl_resource_any_is_busy>
800042d4:	87aa                	mv	a5,a0
800042d6:	fbfd                	bnez	a5,800042cc <.L50>
        ;
    }
    if (pllctlv2_xtal_is_stable(HPM_PLLCTLV2) && pllctlv2_xtal_is_enabled(HPM_PLLCTLV2)) {
800042d8:	f40c0537          	lui	a0,0xf40c0
800042dc:	35c9                	jal	8000419e <pllctlv2_xtal_is_stable>
800042de:	87aa                	mv	a5,a0
800042e0:	c7b1                	beqz	a5,8000432c <.L51>
800042e2:	f40c0537          	lui	a0,0xf40c0
800042e6:	642020ef          	jal	80006928 <pllctlv2_xtal_is_enabled>
800042ea:	87aa                	mv	a5,a0
800042ec:	c3a1                	beqz	a5,8000432c <.L51>
        if (clock_check_in_group(clock_usb0, 0)) {
800042ee:	4581                	li	a1,0
800042f0:	013407b7          	lui	a5,0x1340
800042f4:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
800042f8:	4b0020ef          	jal	800067a8 <clock_check_in_group>
800042fc:	87aa                	mv	a5,a0
800042fe:	c791                	beqz	a5,8000430a <.L52>
            usb_phy_disable_dp_dm_pulldown(HPM_USB0);
80004300:	f300c537          	lui	a0,0xf300c
80004304:	604020ef          	jal	80006908 <usb_phy_disable_dp_dm_pulldown>
        if (clock_check_in_group(clock_usb0, 0)) {
80004308:	a049                	j	8000438a <.L54>

8000430a <.L52>:
        } else {
            clock_add_to_group(clock_usb0, 0);
8000430a:	4581                	li	a1,0
8000430c:	013407b7          	lui	a5,0x1340
80004310:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004314:	39c1                	jal	80003fe4 <clock_add_to_group>
            usb_phy_disable_dp_dm_pulldown(HPM_USB0);
80004316:	f300c537          	lui	a0,0xf300c
8000431a:	5ee020ef          	jal	80006908 <usb_phy_disable_dp_dm_pulldown>
            clock_remove_from_group(clock_usb0, 0);
8000431e:	4581                	li	a1,0
80004320:	013407b7          	lui	a5,0x1340
80004324:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004328:	39dd                	jal	8000401e <clock_remove_from_group>
        if (clock_check_in_group(clock_usb0, 0)) {
8000432a:	a085                	j	8000438a <.L54>

8000432c <.L51>:
        }
    } else {
        uint8_t tmp;
        tmp = sysctl_resource_target_get_mode(HPM_SYSCTL, sysctl_resource_xtal);
8000432c:	02000593          	li	a1,32
80004330:	f4000537          	lui	a0,0xf4000
80004334:	3d29                	jal	8000414e <sysctl_resource_target_get_mode>
80004336:	87aa                	mv	a5,a0
80004338:	00f107a3          	sb	a5,15(sp)
        sysctl_resource_target_set_mode(HPM_SYSCTL, sysctl_resource_xtal, 0x03);    /* NOLINT */
8000433c:	460d                	li	a2,3
8000433e:	02000593          	li	a1,32
80004342:	f4000537          	lui	a0,0xf4000
80004346:	33e9                	jal	80004110 <sysctl_resource_target_set_mode>
        clock_add_to_group(clock_usb0, 0);
80004348:	4581                	li	a1,0
8000434a:	013407b7          	lui	a5,0x1340
8000434e:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004352:	3949                	jal	80003fe4 <clock_add_to_group>
        usb_phy_disable_dp_dm_pulldown(HPM_USB0);
80004354:	f300c537          	lui	a0,0xf300c
80004358:	5b0020ef          	jal	80006908 <usb_phy_disable_dp_dm_pulldown>
        clock_remove_from_group(clock_usb0, 0);
8000435c:	4581                	li	a1,0
8000435e:	013407b7          	lui	a5,0x1340
80004362:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004366:	3965                	jal	8000401e <clock_remove_from_group>
        while (sysctl_resource_target_is_busy(HPM_SYSCTL, sysctl_resource_usb0)) {
80004368:	0001                	nop

8000436a <.L55>:
8000436a:	13400593          	li	a1,308
8000436e:	f4000537          	lui	a0,0xf4000
80004372:	3b95                	jal	800040e6 <sysctl_resource_target_is_busy>
80004374:	87aa                	mv	a5,a0
80004376:	fbf5                	bnez	a5,8000436a <.L55>
            ;
        }
        sysctl_resource_target_set_mode(HPM_SYSCTL, sysctl_resource_xtal, tmp);
80004378:	00f14783          	lbu	a5,15(sp)
8000437c:	863e                	mv	a2,a5
8000437e:	02000593          	li	a1,32
80004382:	f4000537          	lui	a0,0xf4000
80004386:	3369                	jal	80004110 <sysctl_resource_target_set_mode>

80004388 <.LBE14>:
    }
}
80004388:	0001                	nop

8000438a <.L54>:
8000438a:	0001                	nop
8000438c:	40f2                	lw	ra,28(sp)
8000438e:	6105                	addi	sp,sp,32
80004390:	8082                	ret

Disassembly of section .text.board_get_led_gpio_off_level:

80004392 <board_get_led_gpio_off_level>:
    return BOARD_LED_OFF_LEVEL;
}

uint8_t board_get_led_gpio_off_level(void)
{
    return BOARD_LED_OFF_LEVEL;
80004392:	4785                	li	a5,1
}
80004394:	853e                	mv	a0,a5
80004396:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

80004398 <uart_calculate_baudrate>:
    config->rx_enable = true;
#endif
}

static bool uart_calculate_baudrate(uint32_t freq, uint32_t baudrate, uint16_t *div_out, uint8_t *osc_out)
{
80004398:	711d                	addi	sp,sp,-96
8000439a:	ce86                	sw	ra,92(sp)
8000439c:	cca2                	sw	s0,88(sp)
8000439e:	caa6                	sw	s1,84(sp)
800043a0:	c8ca                	sw	s2,80(sp)
800043a2:	c6ce                	sw	s3,76(sp)
800043a4:	c4d2                	sw	s4,72(sp)
800043a6:	c2d6                	sw	s5,68(sp)
800043a8:	c0da                	sw	s6,64(sp)
800043aa:	de5e                	sw	s7,60(sp)
800043ac:	dc62                	sw	s8,56(sp)
800043ae:	da66                	sw	s9,52(sp)
800043b0:	c62a                	sw	a0,12(sp)
800043b2:	c42e                	sw	a1,8(sp)
800043b4:	c232                	sw	a2,4(sp)
800043b6:	c036                	sw	a3,0(sp)
    uint32_t div, osc, delta;
    uint64_t tmp;
    if ((div_out == NULL) || (!freq) || (!baudrate)
800043b8:	4692                	lw	a3,4(sp)
800043ba:	ca9d                	beqz	a3,800043f0 <.L6>
800043bc:	46b2                	lw	a3,12(sp)
800043be:	ca8d                	beqz	a3,800043f0 <.L6>
800043c0:	46a2                	lw	a3,8(sp)
800043c2:	c69d                	beqz	a3,800043f0 <.L6>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
800043c4:	4622                	lw	a2,8(sp)
800043c6:	0c700693          	li	a3,199
800043ca:	02c6f363          	bgeu	a3,a2,800043f0 <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
800043ce:	46a2                	lw	a3,8(sp)
800043d0:	068e                	slli	a3,a3,0x3
800043d2:	4632                	lw	a2,12(sp)
800043d4:	00d66e63          	bltu	a2,a3,800043f0 <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
800043d8:	4632                	lw	a2,12(sp)
800043da:	800086b7          	lui	a3,0x80008
800043de:	0685                	addi	a3,a3,1 # 80008001 <__SEGGER_RTL_Moeller_inverse_lut+0x155>
800043e0:	02d636b3          	mulhu	a3,a2,a3
800043e4:	00f6d613          	srli	a2,a3,0xf
800043e8:	46a2                	lw	a3,8(sp)
800043ea:	0696                	slli	a3,a3,0x5
800043ec:	00c6f463          	bgeu	a3,a2,800043f4 <.L7>

800043f0 <.L6>:
        return 0;
800043f0:	4781                	li	a5,0
800043f2:	a2f5                	j	800045de <.L8>

800043f4 <.L7>:
    }

    tmp = ((uint64_t)freq * HPM_UART_BAUDRATE_SCALE) / baudrate;
800043f4:	46b2                	lw	a3,12(sp)
800043f6:	8736                	mv	a4,a3
800043f8:	4781                	li	a5,0
800043fa:	3e800693          	li	a3,1000
800043fe:	02d78633          	mul	a2,a5,a3
80004402:	4681                	li	a3,0
80004404:	02d706b3          	mul	a3,a4,a3
80004408:	9636                	add	a2,a2,a3
8000440a:	3e800693          	li	a3,1000
8000440e:	02d705b3          	mul	a1,a4,a3
80004412:	02d738b3          	mulhu	a7,a4,a3
80004416:	882e                	mv	a6,a1
80004418:	011607b3          	add	a5,a2,a7
8000441c:	88be                	mv	a7,a5
8000441e:	47a2                	lw	a5,8(sp)
80004420:	833e                	mv	t1,a5
80004422:	4381                	li	t2,0
80004424:	861a                	mv	a2,t1
80004426:	869e                	mv	a3,t2
80004428:	8542                	mv	a0,a6
8000442a:	85c6                	mv	a1,a7
8000442c:	594030ef          	jal	800079c0 <__udivdi3>
80004430:	872a                	mv	a4,a0
80004432:	87ae                	mv	a5,a1
80004434:	d03a                	sw	a4,32(sp)
80004436:	d23e                	sw	a5,36(sp)

    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80004438:	47a1                	li	a5,8
8000443a:	d63e                	sw	a5,44(sp)
8000443c:	aa61                	j	800045d4 <.L9>

8000443e <.L21>:
        /* osc range: HPM_UART_OSC_MIN - UART_SOC_OVERSAMPLE_MAX, even number */
        delta = 0;
8000443e:	d402                	sw	zero,40(sp)
        /* Calculate divider with rounding */
        div = (uint32_t)((tmp + osc * (HPM_UART_BAUDRATE_SCALE / 2)) / (osc * HPM_UART_BAUDRATE_SCALE));
80004440:	5732                	lw	a4,44(sp)
80004442:	87ba                	mv	a5,a4
80004444:	078a                	slli	a5,a5,0x2
80004446:	97ba                	add	a5,a5,a4
80004448:	00279713          	slli	a4,a5,0x2
8000444c:	97ba                	add	a5,a5,a4
8000444e:	00279713          	slli	a4,a5,0x2
80004452:	97ba                	add	a5,a5,a4
80004454:	078a                	slli	a5,a5,0x2
80004456:	843e                	mv	s0,a5
80004458:	4481                	li	s1,0
8000445a:	5602                	lw	a2,32(sp)
8000445c:	5692                	lw	a3,36(sp)
8000445e:	00c40733          	add	a4,s0,a2
80004462:	85ba                	mv	a1,a4
80004464:	0085b5b3          	sltu	a1,a1,s0
80004468:	00d487b3          	add	a5,s1,a3
8000446c:	00f586b3          	add	a3,a1,a5
80004470:	87b6                	mv	a5,a3
80004472:	853a                	mv	a0,a4
80004474:	85be                	mv	a1,a5
80004476:	5732                	lw	a4,44(sp)
80004478:	87ba                	mv	a5,a4
8000447a:	078a                	slli	a5,a5,0x2
8000447c:	97ba                	add	a5,a5,a4
8000447e:	00279713          	slli	a4,a5,0x2
80004482:	97ba                	add	a5,a5,a4
80004484:	00279713          	slli	a4,a5,0x2
80004488:	97ba                	add	a5,a5,a4
8000448a:	078e                	slli	a5,a5,0x3
8000448c:	8b3e                	mv	s6,a5
8000448e:	4b81                	li	s7,0
80004490:	865a                	mv	a2,s6
80004492:	86de                	mv	a3,s7
80004494:	52c030ef          	jal	800079c0 <__udivdi3>
80004498:	872a                	mv	a4,a0
8000449a:	87ae                	mv	a5,a1
8000449c:	ce3a                	sw	a4,28(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN || div > HPM_UART_BAUDRATE_DIV_MAX) {
8000449e:	47f2                	lw	a5,28(sp)
800044a0:	12078463          	beqz	a5,800045c8 <.L24>
800044a4:	4772                	lw	a4,28(sp)
800044a6:	67c1                	lui	a5,0x10
800044a8:	12f77063          	bgeu	a4,a5,800045c8 <.L24>
            /* invalid div */
            continue;
        }
        if ((div * osc * HPM_UART_BAUDRATE_SCALE) > tmp) {
800044ac:	4772                	lw	a4,28(sp)
800044ae:	57b2                	lw	a5,44(sp)
800044b0:	02f70733          	mul	a4,a4,a5
800044b4:	87ba                	mv	a5,a4
800044b6:	078a                	slli	a5,a5,0x2
800044b8:	97ba                	add	a5,a5,a4
800044ba:	00279713          	slli	a4,a5,0x2
800044be:	97ba                	add	a5,a5,a4
800044c0:	00279713          	slli	a4,a5,0x2
800044c4:	97ba                	add	a5,a5,a4
800044c6:	078e                	slli	a5,a5,0x3
800044c8:	893e                	mv	s2,a5
800044ca:	4981                	li	s3,0
800044cc:	5792                	lw	a5,36(sp)
800044ce:	874e                	mv	a4,s3
800044d0:	00e7ea63          	bltu	a5,a4,800044e4 <.L22>
800044d4:	5792                	lw	a5,36(sp)
800044d6:	874e                	mv	a4,s3
800044d8:	02e79a63          	bne	a5,a4,8000450c <.L13>
800044dc:	5782                	lw	a5,32(sp)
800044de:	874a                	mv	a4,s2
800044e0:	02e7f663          	bgeu	a5,a4,8000450c <.L13>

800044e4 <.L22>:
            delta = (uint32_t)((div * osc * HPM_UART_BAUDRATE_SCALE) - tmp);
800044e4:	4772                	lw	a4,28(sp)
800044e6:	57b2                	lw	a5,44(sp)
800044e8:	02f70733          	mul	a4,a4,a5
800044ec:	87ba                	mv	a5,a4
800044ee:	078a                	slli	a5,a5,0x2
800044f0:	97ba                	add	a5,a5,a4
800044f2:	00279713          	slli	a4,a5,0x2
800044f6:	97ba                	add	a5,a5,a4
800044f8:	00279713          	slli	a4,a5,0x2
800044fc:	97ba                	add	a5,a5,a4
800044fe:	078e                	slli	a5,a5,0x3
80004500:	873e                	mv	a4,a5
80004502:	5782                	lw	a5,32(sp)
80004504:	40f707b3          	sub	a5,a4,a5
80004508:	d43e                	sw	a5,40(sp)
8000450a:	a8b9                	j	80004568 <.L15>

8000450c <.L13>:
        } else if ((div * osc * HPM_UART_BAUDRATE_SCALE) < tmp) {
8000450c:	4772                	lw	a4,28(sp)
8000450e:	57b2                	lw	a5,44(sp)
80004510:	02f70733          	mul	a4,a4,a5
80004514:	87ba                	mv	a5,a4
80004516:	078a                	slli	a5,a5,0x2
80004518:	97ba                	add	a5,a5,a4
8000451a:	00279713          	slli	a4,a5,0x2
8000451e:	97ba                	add	a5,a5,a4
80004520:	00279713          	slli	a4,a5,0x2
80004524:	97ba                	add	a5,a5,a4
80004526:	078e                	slli	a5,a5,0x3
80004528:	8a3e                	mv	s4,a5
8000452a:	4a81                	li	s5,0
8000452c:	5792                	lw	a5,36(sp)
8000452e:	8756                	mv	a4,s5
80004530:	00f76a63          	bltu	a4,a5,80004544 <.L23>
80004534:	5792                	lw	a5,36(sp)
80004536:	8756                	mv	a4,s5
80004538:	02e79863          	bne	a5,a4,80004568 <.L15>
8000453c:	5782                	lw	a5,32(sp)
8000453e:	8752                	mv	a4,s4
80004540:	02f77463          	bgeu	a4,a5,80004568 <.L15>

80004544 <.L23>:
            delta = (uint32_t)(tmp - (div * osc * HPM_UART_BAUDRATE_SCALE));
80004544:	5682                	lw	a3,32(sp)
80004546:	4772                	lw	a4,28(sp)
80004548:	57b2                	lw	a5,44(sp)
8000454a:	02f70733          	mul	a4,a4,a5
8000454e:	87ba                	mv	a5,a4
80004550:	078a                	slli	a5,a5,0x2
80004552:	97ba                	add	a5,a5,a4
80004554:	00279713          	slli	a4,a5,0x2
80004558:	97ba                	add	a5,a5,a4
8000455a:	00279713          	slli	a4,a5,0x2
8000455e:	97ba                	add	a5,a5,a4
80004560:	078e                	slli	a5,a5,0x3
80004562:	40f687b3          	sub	a5,a3,a5
80004566:	d43e                	sw	a5,40(sp)

80004568 <.L15>:
        }
        if (delta && (((delta * 100) / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
80004568:	57a2                	lw	a5,40(sp)
8000456a:	cb95                	beqz	a5,8000459e <.L17>
8000456c:	5722                	lw	a4,40(sp)
8000456e:	87ba                	mv	a5,a4
80004570:	078a                	slli	a5,a5,0x2
80004572:	97ba                	add	a5,a5,a4
80004574:	00279713          	slli	a4,a5,0x2
80004578:	97ba                	add	a5,a5,a4
8000457a:	078a                	slli	a5,a5,0x2
8000457c:	8c3e                	mv	s8,a5
8000457e:	4c81                	li	s9,0
80004580:	5602                	lw	a2,32(sp)
80004582:	5692                	lw	a3,36(sp)
80004584:	8562                	mv	a0,s8
80004586:	85e6                	mv	a1,s9
80004588:	438030ef          	jal	800079c0 <__udivdi3>
8000458c:	872a                	mv	a4,a0
8000458e:	87ae                	mv	a5,a1
80004590:	86be                	mv	a3,a5
80004592:	ee8d                	bnez	a3,800045cc <.L25>
80004594:	86be                	mv	a3,a5
80004596:	e681                	bnez	a3,8000459e <.L17>
80004598:	478d                	li	a5,3
8000459a:	02e7e963          	bltu	a5,a4,800045cc <.L25>

8000459e <.L17>:
            continue;
        } else {
            *div_out = div;
8000459e:	47f2                	lw	a5,28(sp)
800045a0:	0807c733          	zext.h	a4,a5
800045a4:	4792                	lw	a5,4(sp)
800045a6:	00e79023          	sh	a4,0(a5) # 10000 <__AHB_SRAM_segment_size__+0x8000>
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
800045aa:	5732                	lw	a4,44(sp)
800045ac:	02000793          	li	a5,32
800045b0:	00f70663          	beq	a4,a5,800045bc <.L19>
800045b4:	57b2                	lw	a5,44(sp)
800045b6:	0ff7f793          	zext.b	a5,a5
800045ba:	a011                	j	800045be <.L20>

800045bc <.L19>:
800045bc:	4781                	li	a5,0

800045be <.L20>:
800045be:	4702                	lw	a4,0(sp)
800045c0:	00f70023          	sb	a5,0(a4) # f4000000 <__AHB_SRAM_segment_end__+0x3bf8000>
            return true;
800045c4:	4785                	li	a5,1
800045c6:	a821                	j	800045de <.L8>

800045c8 <.L24>:
            continue;
800045c8:	0001                	nop
800045ca:	a011                	j	800045ce <.L12>

800045cc <.L25>:
            continue;
800045cc:	0001                	nop

800045ce <.L12>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
800045ce:	57b2                	lw	a5,44(sp)
800045d0:	0789                	addi	a5,a5,2
800045d2:	d63e                	sw	a5,44(sp)

800045d4 <.L9>:
800045d4:	5732                	lw	a4,44(sp)
800045d6:	47f9                	li	a5,30
800045d8:	e6e7f3e3          	bgeu	a5,a4,8000443e <.L21>
        }
    }
    return false;
800045dc:	4781                	li	a5,0

800045de <.L8>:
}
800045de:	853e                	mv	a0,a5
800045e0:	40f6                	lw	ra,92(sp)
800045e2:	4466                	lw	s0,88(sp)
800045e4:	44d6                	lw	s1,84(sp)
800045e6:	4946                	lw	s2,80(sp)
800045e8:	49b6                	lw	s3,76(sp)
800045ea:	4a26                	lw	s4,72(sp)
800045ec:	4a96                	lw	s5,68(sp)
800045ee:	4b06                	lw	s6,64(sp)
800045f0:	5bf2                	lw	s7,60(sp)
800045f2:	5c62                	lw	s8,56(sp)
800045f4:	5cd2                	lw	s9,52(sp)
800045f6:	6125                	addi	sp,sp,96
800045f8:	8082                	ret

Disassembly of section .text.uart_init:

800045fa <uart_init>:

hpm_stat_t uart_init(UART_Type *ptr, uart_config_t *config)
{
800045fa:	7179                	addi	sp,sp,-48
800045fc:	d606                	sw	ra,44(sp)
800045fe:	c62a                	sw	a0,12(sp)
80004600:	c42e                	sw	a1,8(sp)
    uint32_t tmp;
    uint8_t osc;
    uint16_t div;

    /* disable all interrupts */
    ptr->IER = 0;
80004602:	47b2                	lw	a5,12(sp)
80004604:	0207a223          	sw	zero,36(a5)
    /* Set DLAB to 1 */
    ptr->LCR |= UART_LCR_DLAB_MASK;
80004608:	47b2                	lw	a5,12(sp)
8000460a:	57dc                	lw	a5,44(a5)
8000460c:	0807e713          	ori	a4,a5,128
80004610:	47b2                	lw	a5,12(sp)
80004612:	d7d8                	sw	a4,44(a5)

    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
80004614:	47a2                	lw	a5,8(sp)
80004616:	4398                	lw	a4,0(a5)
80004618:	47a2                	lw	a5,8(sp)
8000461a:	43dc                	lw	a5,4(a5)
8000461c:	01b10693          	addi	a3,sp,27
80004620:	0830                	addi	a2,sp,24
80004622:	85be                	mv	a1,a5
80004624:	853a                	mv	a0,a4
80004626:	3b8d                	jal	80004398 <uart_calculate_baudrate>
80004628:	87aa                	mv	a5,a0
8000462a:	0017c793          	xori	a5,a5,1
8000462e:	0ff7f793          	zext.b	a5,a5
80004632:	c781                	beqz	a5,8000463a <.L27>
        return status_uart_no_suitable_baudrate_parameter_found;
80004634:	3e900793          	li	a5,1001
80004638:	a251                	j	800047bc <.L44>

8000463a <.L27>:
    }
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
8000463a:	47b2                	lw	a5,12(sp)
8000463c:	4bdc                	lw	a5,20(a5)
8000463e:	fe07f713          	andi	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
80004642:	01b14783          	lbu	a5,27(sp)
80004646:	8bfd                	andi	a5,a5,31
80004648:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
8000464a:	47b2                	lw	a5,12(sp)
8000464c:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
8000464e:	01815783          	lhu	a5,24(sp)
80004652:	0ff7f713          	zext.b	a4,a5
80004656:	47b2                	lw	a5,12(sp)
80004658:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
8000465a:	01815783          	lhu	a5,24(sp)
8000465e:	83a1                	srli	a5,a5,0x8
80004660:	0807c7b3          	zext.h	a5,a5
80004664:	0ff7f713          	zext.b	a4,a5
80004668:	47b2                	lw	a5,12(sp)
8000466a:	d3d8                	sw	a4,36(a5)

    /* DLAB bit needs to be cleared once baudrate is configured */
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
8000466c:	47b2                	lw	a5,12(sp)
8000466e:	57dc                	lw	a5,44(a5)
80004670:	f7f7f793          	andi	a5,a5,-129
80004674:	ce3e                	sw	a5,28(sp)

    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
80004676:	47f2                	lw	a5,28(sp)
80004678:	fc77f793          	andi	a5,a5,-57
8000467c:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
8000467e:	47a2                	lw	a5,8(sp)
80004680:	00a7c783          	lbu	a5,10(a5)
80004684:	4711                	li	a4,4
80004686:	02f76d63          	bltu	a4,a5,800046c0 <.L29>
8000468a:	00279713          	slli	a4,a5,0x2
8000468e:	cec18793          	addi	a5,gp,-788 # 8000357c <.L31>
80004692:	97ba                	add	a5,a5,a4
80004694:	439c                	lw	a5,0(a5)
80004696:	8782                	jr	a5

80004698 <.L34>:
    case parity_none:
        break;
    case parity_odd:
        tmp |= UART_LCR_PEN_MASK;
80004698:	47f2                	lw	a5,28(sp)
8000469a:	0087e793          	ori	a5,a5,8
8000469e:	ce3e                	sw	a5,28(sp)
        break;
800046a0:	a01d                	j	800046c6 <.L36>

800046a2 <.L33>:
    case parity_even:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
800046a2:	47f2                	lw	a5,28(sp)
800046a4:	0187e793          	ori	a5,a5,24
800046a8:	ce3e                	sw	a5,28(sp)
        break;
800046aa:	a831                	j	800046c6 <.L36>

800046ac <.L32>:
    case parity_always_1:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
800046ac:	47f2                	lw	a5,28(sp)
800046ae:	0287e793          	ori	a5,a5,40
800046b2:	ce3e                	sw	a5,28(sp)
        break;
800046b4:	a809                	j	800046c6 <.L36>

800046b6 <.L30>:
    case parity_always_0:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
800046b6:	47f2                	lw	a5,28(sp)
800046b8:	0387e793          	ori	a5,a5,56
800046bc:	ce3e                	sw	a5,28(sp)
            | UART_LCR_SPS_MASK;
        break;
800046be:	a021                	j	800046c6 <.L36>

800046c0 <.L29>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
800046c0:	4789                	li	a5,2
800046c2:	a8ed                	j	800047bc <.L44>

800046c4 <.L45>:
        break;
800046c4:	0001                	nop

800046c6 <.L36>:
    }

    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
800046c6:	47f2                	lw	a5,28(sp)
800046c8:	9be1                	andi	a5,a5,-8
800046ca:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
800046cc:	47a2                	lw	a5,8(sp)
800046ce:	0087c783          	lbu	a5,8(a5)
800046d2:	4709                	li	a4,2
800046d4:	00e78e63          	beq	a5,a4,800046f0 <.L37>
800046d8:	4709                	li	a4,2
800046da:	02f74663          	blt	a4,a5,80004706 <.L38>
800046de:	c795                	beqz	a5,8000470a <.L46>
800046e0:	4705                	li	a4,1
800046e2:	02e79263          	bne	a5,a4,80004706 <.L38>
    case stop_bits_1:
        break;
    case stop_bits_1_5:
        tmp |= UART_LCR_STB_MASK;
800046e6:	47f2                	lw	a5,28(sp)
800046e8:	0047e793          	ori	a5,a5,4
800046ec:	ce3e                	sw	a5,28(sp)
        break;
800046ee:	a839                	j	8000470c <.L41>

800046f0 <.L37>:
    case stop_bits_2:
        if (config->word_length < word_length_6_bits) {
800046f0:	47a2                	lw	a5,8(sp)
800046f2:	0097c783          	lbu	a5,9(a5)
800046f6:	e399                	bnez	a5,800046fc <.L42>
            /* invalid configuration */
            return status_invalid_argument;
800046f8:	4789                	li	a5,2
800046fa:	a0c9                	j	800047bc <.L44>

800046fc <.L42>:
        }
        tmp |= UART_LCR_STB_MASK;
800046fc:	47f2                	lw	a5,28(sp)
800046fe:	0047e793          	ori	a5,a5,4
80004702:	ce3e                	sw	a5,28(sp)
        break;
80004704:	a021                	j	8000470c <.L41>

80004706 <.L38>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
80004706:	4789                	li	a5,2
80004708:	a855                	j	800047bc <.L44>

8000470a <.L46>:
        break;
8000470a:	0001                	nop

8000470c <.L41>:
    }

    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
8000470c:	47a2                	lw	a5,8(sp)
8000470e:	0097c783          	lbu	a5,9(a5)
80004712:	0037f713          	andi	a4,a5,3
80004716:	47f2                	lw	a5,28(sp)
80004718:	8f5d                	or	a4,a4,a5
8000471a:	47b2                	lw	a5,12(sp)
8000471c:	d7d8                	sw	a4,44(a5)

#if defined(HPM_IP_FEATURE_UART_FINE_FIFO_THRLD) && (HPM_IP_FEATURE_UART_FINE_FIFO_THRLD == 1)
    /* reset TX and RX fifo */
    ptr->FCRR = UART_FCRR_TFIFORST_MASK | UART_FCRR_RFIFORST_MASK;
8000471e:	47b2                	lw	a5,12(sp)
80004720:	4719                	li	a4,6
80004722:	cf98                	sw	a4,24(a5)
    /* Enable FIFO */
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
        | UART_FCRR_FIFOE_SET(config->fifo_enable)
80004724:	47a2                	lw	a5,8(sp)
80004726:	00e7c783          	lbu	a5,14(a5)
8000472a:	86be                	mv	a3,a5
        | UART_FCRR_TFIFOT4_SET(config->tx_fifo_level)
8000472c:	47a2                	lw	a5,8(sp)
8000472e:	00b7c783          	lbu	a5,11(a5)
80004732:	01079713          	slli	a4,a5,0x10
80004736:	001f07b7          	lui	a5,0x1f0
8000473a:	8ff9                	and	a5,a5,a4
8000473c:	00f6e733          	or	a4,a3,a5
        | UART_FCRR_RFIFOT4_SET(config->rx_fifo_level)
80004740:	47a2                	lw	a5,8(sp)
80004742:	00c7c783          	lbu	a5,12(a5) # 1f000c <_flash_size+0xf000c>
80004746:	00879693          	slli	a3,a5,0x8
8000474a:	6789                	lui	a5,0x2
8000474c:	f0078793          	addi	a5,a5,-256 # 1f00 <__NOR_CFG_OPTION_segment_size__+0x1300>
80004750:	8ff5                	and	a5,a5,a3
80004752:	8f5d                	or	a4,a4,a5
#if defined(HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT) && (HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT == 1)
        | UART_FCRR_TMOUT_RXDMA_DIS_MASK /**< disable RX timeout trigger dma */
#endif
        | UART_FCRR_DMAE_SET(config->dma_enable);
80004754:	47a2                	lw	a5,8(sp)
80004756:	00d7c783          	lbu	a5,13(a5)
8000475a:	078e                	slli	a5,a5,0x3
8000475c:	8ba1                	andi	a5,a5,8
8000475e:	8f5d                	or	a4,a4,a5
80004760:	008007b7          	lui	a5,0x800
80004764:	8f5d                	or	a4,a4,a5
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
80004766:	47b2                	lw	a5,12(sp)
80004768:	cf98                	sw	a4,24(a5)
    ptr->FCR = tmp;
    /* store FCR register value */
    ptr->GPR = tmp;
#endif

    uart_modem_config(ptr, &config->modem_config);
8000476a:	47a2                	lw	a5,8(sp)
8000476c:	07bd                	addi	a5,a5,15 # 80000f <_flash_size+0x70000f>
8000476e:	85be                	mv	a1,a5
80004770:	4532                	lw	a0,12(sp)
80004772:	398020ef          	jal	80006b0a <uart_modem_config>

#if defined(HPM_IP_FEATURE_UART_RX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_RX_IDLE_DETECT == 1)
    uart_init_rxline_idle_detection(ptr, config->rxidle_config);
80004776:	47a2                	lw	a5,8(sp)
80004778:	0127d703          	lhu	a4,18(a5)
8000477c:	0147d783          	lhu	a5,20(a5)
80004780:	07c2                	slli	a5,a5,0x10
80004782:	8fd9                	or	a5,a5,a4
80004784:	873e                	mv	a4,a5
80004786:	85ba                	mv	a1,a4
80004788:	4532                	lw	a0,12(sp)
8000478a:	4c4020ef          	jal	80006c4e <uart_init_rxline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
    uart_init_txline_idle_detection(ptr, config->txidle_config);
8000478e:	47a2                	lw	a5,8(sp)
80004790:	0167d703          	lhu	a4,22(a5)
80004794:	0187d783          	lhu	a5,24(a5)
80004798:	07c2                	slli	a5,a5,0x10
8000479a:	8fd9                	or	a5,a5,a4
8000479c:	873e                	mv	a4,a5
8000479e:	85ba                	mv	a1,a4
800047a0:	4532                	lw	a0,12(sp)
800047a2:	2885                	jal	80004812 <uart_init_txline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    if (config->rx_enable) {
800047a4:	47a2                	lw	a5,8(sp)
800047a6:	01a7c783          	lbu	a5,26(a5)
800047aa:	cb81                	beqz	a5,800047ba <.L43>
        ptr->IDLE_CFG |= UART_IDLE_CFG_RXEN_MASK;
800047ac:	47b2                	lw	a5,12(sp)
800047ae:	43d8                	lw	a4,4(a5)
800047b0:	28b01793          	bseti	a5,zero,0xb
800047b4:	8f5d                	or	a4,a4,a5
800047b6:	47b2                	lw	a5,12(sp)
800047b8:	c3d8                	sw	a4,4(a5)

800047ba <.L43>:
    }
#endif
    return status_success;
800047ba:	4781                	li	a5,0

800047bc <.L44>:
}
800047bc:	853e                	mv	a0,a5
800047be:	50b2                	lw	ra,44(sp)
800047c0:	6145                	addi	sp,sp,48
800047c2:	8082                	ret

Disassembly of section .text.uart_send_byte:

800047c4 <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
800047c4:	1101                	addi	sp,sp,-32
800047c6:	c62a                	sw	a0,12(sp)
800047c8:	87ae                	mv	a5,a1
800047ca:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
800047ce:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
800047d0:	a811                	j	800047e4 <.L52>

800047d2 <.L55>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
800047d2:	4772                	lw	a4,28(sp)
800047d4:	6785                	lui	a5,0x1
800047d6:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800047da:	00e7eb63          	bltu	a5,a4,800047f0 <.L58>
            break;
        }
        retry++;
800047de:	47f2                	lw	a5,28(sp)
800047e0:	0785                	addi	a5,a5,1
800047e2:	ce3e                	sw	a5,28(sp)

800047e4 <.L52>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
800047e4:	47b2                	lw	a5,12(sp)
800047e6:	5bdc                	lw	a5,52(a5)
800047e8:	0207f793          	andi	a5,a5,32
800047ec:	d3fd                	beqz	a5,800047d2 <.L55>
800047ee:	a011                	j	800047f2 <.L54>

800047f0 <.L58>:
            break;
800047f0:	0001                	nop

800047f2 <.L54>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
800047f2:	4772                	lw	a4,28(sp)
800047f4:	6785                	lui	a5,0x1
800047f6:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800047fa:	00e7f463          	bgeu	a5,a4,80004802 <.L56>
        return status_timeout;
800047fe:	478d                	li	a5,3
80004800:	a031                	j	8000480c <.L57>

80004802 <.L56>:
    }

    ptr->THR = UART_THR_THR_SET(c);
80004802:	00b14703          	lbu	a4,11(sp)
80004806:	47b2                	lw	a5,12(sp)
80004808:	d398                	sw	a4,32(a5)
    return status_success;
8000480a:	4781                	li	a5,0

8000480c <.L57>:
}
8000480c:	853e                	mv	a0,a5
8000480e:	6105                	addi	sp,sp,32
80004810:	8082                	ret

Disassembly of section .text.uart_init_txline_idle_detection:

80004812 <uart_init_txline_idle_detection>:
}
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
hpm_stat_t uart_init_txline_idle_detection(UART_Type *ptr, uart_rxline_idle_config_t txidle_config)
{
80004812:	1101                	addi	sp,sp,-32
80004814:	ce06                	sw	ra,28(sp)
80004816:	c62a                	sw	a0,12(sp)
80004818:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_TX_IDLE_EN_MASK
8000481a:	47b2                	lw	a5,12(sp)
8000481c:	43d8                	lw	a4,4(a5)
8000481e:	fc0107b7          	lui	a5,0xfc010
80004822:	17fd                	addi	a5,a5,-1 # fc00ffff <__AHB_SRAM_segment_end__+0xbc07fff>
80004824:	8f7d                	and	a4,a4,a5
80004826:	47b2                	lw	a5,12(sp)
80004828:	c3d8                	sw	a4,4(a5)
                    | UART_IDLE_CFG_TX_IDLE_THR_MASK
                    | UART_IDLE_CFG_TX_IDLE_COND_MASK);
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
8000482a:	47b2                	lw	a5,12(sp)
8000482c:	43d8                	lw	a4,4(a5)
8000482e:	00814783          	lbu	a5,8(sp)
80004832:	01879693          	slli	a3,a5,0x18
80004836:	010007b7          	lui	a5,0x1000
8000483a:	8efd                	and	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_THR_SET(txidle_config.threshold)
8000483c:	00b14783          	lbu	a5,11(sp)
80004840:	01079613          	slli	a2,a5,0x10
80004844:	00ff07b7          	lui	a5,0xff0
80004848:	8ff1                	and	a5,a5,a2
8000484a:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_COND_SET(txidle_config.idle_cond);
8000484c:	00a14783          	lbu	a5,10(sp)
80004850:	01979613          	slli	a2,a5,0x19
80004854:	020007b7          	lui	a5,0x2000
80004858:	8ff1                	and	a5,a5,a2
8000485a:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
8000485c:	8f5d                	or	a4,a4,a5
8000485e:	47b2                	lw	a5,12(sp)
80004860:	c3d8                	sw	a4,4(a5)

    if (txidle_config.detect_irq_enable) {
80004862:	00914783          	lbu	a5,9(sp)
80004866:	c799                	beqz	a5,80004874 <.L97>
        uart_enable_irq(ptr, uart_intr_tx_line_idle);
80004868:	400005b7          	lui	a1,0x40000
8000486c:	4532                	lw	a0,12(sp)
8000486e:	2f4020ef          	jal	80006b62 <uart_enable_irq>
80004872:	a031                	j	8000487e <.L98>

80004874 <.L97>:
    } else {
        uart_disable_irq(ptr, uart_intr_tx_line_idle);
80004874:	400005b7          	lui	a1,0x40000
80004878:	4532                	lw	a0,12(sp)
8000487a:	2cc020ef          	jal	80006b46 <uart_disable_irq>

8000487e <.L98>:
    }

    return status_success;
8000487e:	4781                	li	a5,0
}
80004880:	853e                	mv	a0,a5
80004882:	40f2                	lw	ra,28(sp)
80004884:	6105                	addi	sp,sp,32
80004886:	8082                	ret

Disassembly of section .text.gpio_set_pin_output_with_initial:

80004888 <gpio_set_pin_output_with_initial>:
        return;
    }
}

void gpio_set_pin_output_with_initial(GPIO_Type *ptr, uint32_t port, uint8_t pin, uint8_t initial)
{
80004888:	1141                	addi	sp,sp,-16
8000488a:	c62a                	sw	a0,12(sp)
8000488c:	c42e                	sw	a1,8(sp)
8000488e:	87b2                	mv	a5,a2
80004890:	8736                	mv	a4,a3
80004892:	00f103a3          	sb	a5,7(sp)
80004896:	87ba                	mv	a5,a4
80004898:	00f10323          	sb	a5,6(sp)
    if (initial & 1) {
8000489c:	00614783          	lbu	a5,6(sp)
800048a0:	8b85                	andi	a5,a5,1
800048a2:	cf91                	beqz	a5,800048be <.L25>
        ptr->DO[port].SET = 1 << pin;
800048a4:	00714783          	lbu	a5,7(sp)
800048a8:	4705                	li	a4,1
800048aa:	00f717b3          	sll	a5,a4,a5
800048ae:	86be                	mv	a3,a5
800048b0:	4732                	lw	a4,12(sp)
800048b2:	47a2                	lw	a5,8(sp)
800048b4:	07c1                	addi	a5,a5,16 # 2000010 <_flash_size+0x1f00010>
800048b6:	0792                	slli	a5,a5,0x4
800048b8:	97ba                	add	a5,a5,a4
800048ba:	c3d4                	sw	a3,4(a5)
800048bc:	a829                	j	800048d6 <.L26>

800048be <.L25>:
    } else {
        ptr->DO[port].CLEAR = 1 << pin;
800048be:	00714783          	lbu	a5,7(sp)
800048c2:	4705                	li	a4,1
800048c4:	00f717b3          	sll	a5,a4,a5
800048c8:	86be                	mv	a3,a5
800048ca:	4732                	lw	a4,12(sp)
800048cc:	47a2                	lw	a5,8(sp)
800048ce:	07c1                	addi	a5,a5,16
800048d0:	0792                	slli	a5,a5,0x4
800048d2:	97ba                	add	a5,a5,a4
800048d4:	c794                	sw	a3,8(a5)

800048d6 <.L26>:
    }
    ptr->OE[port].SET = 1 << pin;
800048d6:	00714783          	lbu	a5,7(sp)
800048da:	4705                	li	a4,1
800048dc:	00f717b3          	sll	a5,a4,a5
800048e0:	86be                	mv	a3,a5
800048e2:	4732                	lw	a4,12(sp)
800048e4:	47a2                	lw	a5,8(sp)
800048e6:	02078793          	addi	a5,a5,32
800048ea:	0792                	slli	a5,a5,0x4
800048ec:	97ba                	add	a5,a5,a4
800048ee:	c3d4                	sw	a3,4(a5)
}
800048f0:	0001                	nop
800048f2:	0141                	addi	sp,sp,16
800048f4:	8082                	ret

Disassembly of section .text.gptmr_channel_reset_count:

800048f6 <gptmr_channel_reset_count>:
{
800048f6:	1141                	addi	sp,sp,-16
800048f8:	c62a                	sw	a0,12(sp)
800048fa:	87ae                	mv	a5,a1
800048fc:	00f105a3          	sb	a5,11(sp)
    ptr->CHANNEL[ch_index].CR |= GPTMR_CHANNEL_CR_CNTRST_MASK;
80004900:	00b14783          	lbu	a5,11(sp)
80004904:	4732                	lw	a4,12(sp)
80004906:	079a                	slli	a5,a5,0x6
80004908:	97ba                	add	a5,a5,a4
8000490a:	4394                	lw	a3,0(a5)
8000490c:	00b14783          	lbu	a5,11(sp)
80004910:	6711                	lui	a4,0x4
80004912:	8f55                	or	a4,a4,a3
80004914:	46b2                	lw	a3,12(sp)
80004916:	079a                	slli	a5,a5,0x6
80004918:	97b6                	add	a5,a5,a3
8000491a:	c398                	sw	a4,0(a5)
    ptr->CHANNEL[ch_index].CR &= ~GPTMR_CHANNEL_CR_CNTRST_MASK;
8000491c:	00b14783          	lbu	a5,11(sp)
80004920:	4732                	lw	a4,12(sp)
80004922:	079a                	slli	a5,a5,0x6
80004924:	97ba                	add	a5,a5,a4
80004926:	4394                	lw	a3,0(a5)
80004928:	00b14783          	lbu	a5,11(sp)
8000492c:	7771                	lui	a4,0xffffc
8000492e:	177d                	addi	a4,a4,-1 # ffffbfff <__AHB_SRAM_segment_end__+0xfbf3fff>
80004930:	8f75                	and	a4,a4,a3
80004932:	46b2                	lw	a3,12(sp)
80004934:	079a                	slli	a5,a5,0x6
80004936:	97b6                	add	a5,a5,a3
80004938:	c398                	sw	a4,0(a5)
}
8000493a:	0001                	nop
8000493c:	0141                	addi	sp,sp,16
8000493e:	8082                	ret

Disassembly of section .text.gptmr_channel_set_capmode:

80004940 <gptmr_channel_set_capmode>:
{
80004940:	1141                	addi	sp,sp,-16
80004942:	c62a                	sw	a0,12(sp)
80004944:	87ae                	mv	a5,a1
80004946:	8732                	mv	a4,a2
80004948:	00f105a3          	sb	a5,11(sp)
8000494c:	87ba                	mv	a5,a4
8000494e:	00f10523          	sb	a5,10(sp)
    ptr->CHANNEL[ch_index].CR = (ptr->CHANNEL[ch_index].CR & ~GPTMR_CHANNEL_CR_CAPMODE_MASK) | GPTMR_CHANNEL_CR_CAPMODE_SET(mode);
80004952:	00b14783          	lbu	a5,11(sp)
80004956:	4732                	lw	a4,12(sp)
80004958:	079a                	slli	a5,a5,0x6
8000495a:	97ba                	add	a5,a5,a4
8000495c:	439c                	lw	a5,0(a5)
8000495e:	ff87f693          	andi	a3,a5,-8
80004962:	00a14783          	lbu	a5,10(sp)
80004966:	0077f713          	andi	a4,a5,7
8000496a:	00b14783          	lbu	a5,11(sp)
8000496e:	8f55                	or	a4,a4,a3
80004970:	46b2                	lw	a3,12(sp)
80004972:	079a                	slli	a5,a5,0x6
80004974:	97b6                	add	a5,a5,a3
80004976:	c398                	sw	a4,0(a5)
}
80004978:	0001                	nop
8000497a:	0141                	addi	sp,sp,16
8000497c:	8082                	ret

Disassembly of section .text.gptmr_update_cmp:

8000497e <gptmr_update_cmp>:
{
8000497e:	1141                	addi	sp,sp,-16
80004980:	c62a                	sw	a0,12(sp)
80004982:	87ae                	mv	a5,a1
80004984:	8732                	mv	a4,a2
80004986:	c236                	sw	a3,4(sp)
80004988:	00f105a3          	sb	a5,11(sp)
8000498c:	87ba                	mv	a5,a4
8000498e:	00f10523          	sb	a5,10(sp)
    if ((cmp > 0) && (cmp != 0xFFFFFFFFu)) {
80004992:	4792                	lw	a5,4(sp)
80004994:	cb81                	beqz	a5,800049a4 <.L4>
80004996:	4712                	lw	a4,4(sp)
80004998:	57fd                	li	a5,-1
8000499a:	00f70563          	beq	a4,a5,800049a4 <.L4>
        cmp--;
8000499e:	4792                	lw	a5,4(sp)
800049a0:	17fd                	addi	a5,a5,-1
800049a2:	c23e                	sw	a5,4(sp)

800049a4 <.L4>:
    ptr->CHANNEL[ch_index].CMP[cmp_index] = GPTMR_CHANNEL_CMP_CMP_SET(cmp);
800049a4:	00b14683          	lbu	a3,11(sp)
800049a8:	00a14783          	lbu	a5,10(sp)
800049ac:	4732                	lw	a4,12(sp)
800049ae:	0692                	slli	a3,a3,0x4
800049b0:	97b6                	add	a5,a5,a3
800049b2:	078a                	slli	a5,a5,0x2
800049b4:	97ba                	add	a5,a5,a4
800049b6:	4712                	lw	a4,4(sp)
800049b8:	c3d8                	sw	a4,4(a5)
}
800049ba:	0001                	nop
800049bc:	0141                	addi	sp,sp,16
800049be:	8082                	ret

Disassembly of section .text.gptmr_channel_config_update_reload:

800049c0 <gptmr_channel_config_update_reload>:
{
800049c0:	1141                	addi	sp,sp,-16
800049c2:	c62a                	sw	a0,12(sp)
800049c4:	87ae                	mv	a5,a1
800049c6:	c232                	sw	a2,4(sp)
800049c8:	00f105a3          	sb	a5,11(sp)
    if ((reload > 0) && (reload != 0xFFFFFFFFu)) {
800049cc:	4792                	lw	a5,4(sp)
800049ce:	cb81                	beqz	a5,800049de <.L6>
800049d0:	4712                	lw	a4,4(sp)
800049d2:	57fd                	li	a5,-1
800049d4:	00f70563          	beq	a4,a5,800049de <.L6>
        reload--;
800049d8:	4792                	lw	a5,4(sp)
800049da:	17fd                	addi	a5,a5,-1
800049dc:	c23e                	sw	a5,4(sp)

800049de <.L6>:
    ptr->CHANNEL[ch_index].RLD = GPTMR_CHANNEL_RLD_RLD_SET(reload);
800049de:	00b14783          	lbu	a5,11(sp)
800049e2:	4732                	lw	a4,12(sp)
800049e4:	079a                	slli	a5,a5,0x6
800049e6:	97ba                	add	a5,a5,a4
800049e8:	4712                	lw	a4,4(sp)
800049ea:	c7d8                	sw	a4,12(a5)
}
800049ec:	0001                	nop
800049ee:	0141                	addi	sp,sp,16
800049f0:	8082                	ret

Disassembly of section .text.gptmr_channel_disable_monitor:

800049f2 <gptmr_channel_disable_monitor>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] ch_index channel index
 */
static inline void gptmr_channel_disable_monitor(GPTMR_Type *ptr, uint8_t ch_index)
{
800049f2:	1141                	addi	sp,sp,-16
800049f4:	c62a                	sw	a0,12(sp)
800049f6:	87ae                	mv	a5,a1
800049f8:	00f105a3          	sb	a5,11(sp)
    ptr->CHANNEL[ch_index].CR &= ~GPTMR_CHANNEL_CR_MONITOR_EN_MASK;
800049fc:	00b14783          	lbu	a5,11(sp)
80004a00:	4732                	lw	a4,12(sp)
80004a02:	079a                	slli	a5,a5,0x6
80004a04:	97ba                	add	a5,a5,a4
80004a06:	4394                	lw	a3,0(a5)
80004a08:	00b14783          	lbu	a5,11(sp)
80004a0c:	7761                	lui	a4,0xffff8
80004a0e:	177d                	addi	a4,a4,-1 # ffff7fff <__AHB_SRAM_segment_end__+0xfbeffff>
80004a10:	8f75                	and	a4,a4,a3
80004a12:	46b2                	lw	a3,12(sp)
80004a14:	079a                	slli	a5,a5,0x6
80004a16:	97b6                	add	a5,a5,a3
80004a18:	c398                	sw	a4,0(a5)
}
80004a1a:	0001                	nop
80004a1c:	0141                	addi	sp,sp,16
80004a1e:	8082                	ret

Disassembly of section .text.gptmr_channel_set_monitor_type:

80004a20 <gptmr_channel_set_monitor_type>:
 * @param [in] ptr GPTMR base address
 * @param [in] ch_index channel index
 * @param [in] type gptmr_channel_monitor_type_t
 */
static inline void gptmr_channel_set_monitor_type(GPTMR_Type *ptr, uint8_t ch_index, gptmr_channel_monitor_type_t type)
{
80004a20:	1141                	addi	sp,sp,-16
80004a22:	c62a                	sw	a0,12(sp)
80004a24:	87ae                	mv	a5,a1
80004a26:	8732                	mv	a4,a2
80004a28:	00f105a3          	sb	a5,11(sp)
80004a2c:	87ba                	mv	a5,a4
80004a2e:	00f10523          	sb	a5,10(sp)
    ptr->CHANNEL[ch_index].CR = (ptr->CHANNEL[ch_index].CR & ~GPTMR_CHANNEL_CR_MONITOR_SEL_MASK) | GPTMR_CHANNEL_CR_MONITOR_SEL_SET(type);
80004a32:	00b14783          	lbu	a5,11(sp)
80004a36:	4732                	lw	a4,12(sp)
80004a38:	079a                	slli	a5,a5,0x6
80004a3a:	97ba                	add	a5,a5,a4
80004a3c:	4398                	lw	a4,0(a5)
80004a3e:	77c1                	lui	a5,0xffff0
80004a40:	17fd                	addi	a5,a5,-1 # fffeffff <__AHB_SRAM_segment_end__+0xfbe7fff>
80004a42:	00f776b3          	and	a3,a4,a5
80004a46:	00a14783          	lbu	a5,10(sp)
80004a4a:	01079713          	slli	a4,a5,0x10
80004a4e:	67c1                	lui	a5,0x10
80004a50:	8f7d                	and	a4,a4,a5
80004a52:	00b14783          	lbu	a5,11(sp)
80004a56:	8f55                	or	a4,a4,a3
80004a58:	46b2                	lw	a3,12(sp)
80004a5a:	079a                	slli	a5,a5,0x6
80004a5c:	97b6                	add	a5,a5,a3
80004a5e:	c398                	sw	a4,0(a5)
}
80004a60:	0001                	nop
80004a62:	0141                	addi	sp,sp,16
80004a64:	8082                	ret

Disassembly of section .text.gptmr_channel_get_default_config:

80004a66 <gptmr_channel_get_default_config>:
 */

#include "hpm_gptmr_drv.h"

void gptmr_channel_get_default_config(GPTMR_Type *ptr, gptmr_channel_config_t *config)
{
80004a66:	7179                	addi	sp,sp,-48
80004a68:	d606                	sw	ra,44(sp)
80004a6a:	c62a                	sw	a0,12(sp)
80004a6c:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->mode = gptmr_work_mode_no_capture;
80004a6e:	47a2                	lw	a5,8(sp)
80004a70:	00078023          	sb	zero,0(a5) # 10000 <__AHB_SRAM_segment_size__+0x8000>
    config->dma_request_event = gptmr_dma_request_disabled;
80004a74:	47a2                	lw	a5,8(sp)
80004a76:	577d                	li	a4,-1
80004a78:	00e780a3          	sb	a4,1(a5)
    config->synci_edge = gptmr_synci_edge_none;
80004a7c:	47a2                	lw	a5,8(sp)
80004a7e:	00079123          	sh	zero,2(a5)

80004a82 <.LBB2>:
    for (uint8_t i = 0; i < GPTMR_CH_CMP_COUNT; i++) {
80004a82:	00010fa3          	sb	zero,31(sp)
80004a86:	a829                	j	80004aa0 <.L11>

80004a88 <.L12>:
        config->cmp[i] = 0xFFFFFFFEUL;
80004a88:	01f14783          	lbu	a5,31(sp)
80004a8c:	4722                	lw	a4,8(sp)
80004a8e:	078a                	slli	a5,a5,0x2
80004a90:	97ba                	add	a5,a5,a4
80004a92:	5779                	li	a4,-2
80004a94:	c3d8                	sw	a4,4(a5)
    for (uint8_t i = 0; i < GPTMR_CH_CMP_COUNT; i++) {
80004a96:	01f14783          	lbu	a5,31(sp)
80004a9a:	0785                	addi	a5,a5,1
80004a9c:	00f10fa3          	sb	a5,31(sp)

80004aa0 <.L11>:
80004aa0:	01f14703          	lbu	a4,31(sp)
80004aa4:	4785                	li	a5,1
80004aa6:	fee7f1e3          	bgeu	a5,a4,80004a88 <.L12>

80004aaa <.LBE2>:
    }
    config->reload = 0xFFFFFFFEUL;
80004aaa:	47a2                	lw	a5,8(sp)
80004aac:	5779                	li	a4,-2
80004aae:	c7d8                	sw	a4,12(a5)
    config->cmp_initial_polarity_high = true;
80004ab0:	47a2                	lw	a5,8(sp)
80004ab2:	4705                	li	a4,1
80004ab4:	00e78823          	sb	a4,16(a5)
    config->enable_cmp_output = true;
80004ab8:	47a2                	lw	a5,8(sp)
80004aba:	4705                	li	a4,1
80004abc:	00e788a3          	sb	a4,17(a5)
    config->enable_sync_follow_previous_channel = false;
80004ac0:	47a2                	lw	a5,8(sp)
80004ac2:	00078923          	sb	zero,18(a5)
    config->enable_software_sync = false;
80004ac6:	47a2                	lw	a5,8(sp)
80004ac8:	000789a3          	sb	zero,19(a5)
    config->debug_mode = true;
80004acc:	47a2                	lw	a5,8(sp)
80004ace:	4705                	li	a4,1
80004ad0:	00e78a23          	sb	a4,20(a5)
#if defined(HPM_IP_FEATURE_GPTMR_CNT_MODE) && (HPM_IP_FEATURE_GPTMR_CNT_MODE  == 1)
    config->counter_mode = gptmr_counter_mode_internal;
#endif

#if defined(HPM_IP_FEATURE_GPTMR_OP_MODE) && (HPM_IP_FEATURE_GPTMR_OP_MODE  == 1)
    config->enable_opmode = false;
80004ad4:	47a2                	lw	a5,8(sp)
80004ad6:	02078223          	sb	zero,36(a5)
#endif

#if defined(HPM_IP_FEATURE_GPTMR_MONITOR) && (HPM_IP_FEATURE_GPTMR_MONITOR  == 1)
    config->enable_monitor = false;
80004ada:	47a2                	lw	a5,8(sp)
80004adc:	00078aa3          	sb	zero,21(a5)
    gptmr_channel_get_default_monitor_config(ptr, &config->monitor_config);
80004ae0:	47a2                	lw	a5,8(sp)
80004ae2:	07e1                	addi	a5,a5,24
80004ae4:	85be                	mv	a1,a5
80004ae6:	4532                	lw	a0,12(sp)
80004ae8:	39c020ef          	jal	80006e84 <gptmr_channel_get_default_monitor_config>
#endif
}
80004aec:	0001                	nop
80004aee:	50b2                	lw	ra,44(sp)
80004af0:	6145                	addi	sp,sp,48
80004af2:	8082                	ret

Disassembly of section .text.pllctlv2_pll_is_stable:

80004af4 <pllctlv2_pll_is_stable>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @return true if the PLL is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
80004af4:	1101                	addi	sp,sp,-32
80004af6:	c62a                	sw	a0,12(sp)
80004af8:	87ae                	mv	a5,a1
80004afa:	00f105a3          	sb	a5,11(sp)
    uint32_t status = ptr->PLL[pll].MFI;
80004afe:	00b14783          	lbu	a5,11(sp)
80004b02:	4732                	lw	a4,12(sp)
80004b04:	0785                	addi	a5,a5,1
80004b06:	079e                	slli	a5,a5,0x7
80004b08:	97ba                	add	a5,a5,a4
80004b0a:	439c                	lw	a5,0(a5)
80004b0c:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_ENABLE_MASK)
80004b0e:	4772                	lw	a4,28(sp)
80004b10:	100007b7          	lui	a5,0x10000
80004b14:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_MFI_RESPONSE_MASK)));
80004b16:	cb89                	beqz	a5,80004b28 <.L2>
80004b18:	47f2                	lw	a5,28(sp)
80004b1a:	0007c963          	bltz	a5,80004b2c <.L3>
80004b1e:	4772                	lw	a4,28(sp)
80004b20:	200007b7          	lui	a5,0x20000
80004b24:	8ff9                	and	a5,a5,a4
80004b26:	c399                	beqz	a5,80004b2c <.L3>

80004b28 <.L2>:
80004b28:	4785                	li	a5,1
80004b2a:	a011                	j	80004b2e <.L4>

80004b2c <.L3>:
80004b2c:	4781                	li	a5,0

80004b2e <.L4>:
80004b2e:	8b85                	andi	a5,a5,1
80004b30:	0ff7f793          	zext.b	a5,a5
}
80004b34:	853e                	mv	a0,a5
80004b36:	6105                	addi	sp,sp,32
80004b38:	8082                	ret

Disassembly of section .text.pllctlv2_init_pll_with_freq:

80004b3a <pllctlv2_init_pll_with_freq>:
    }
    return status;
}

hpm_stat_t pllctlv2_init_pll_with_freq(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, uint32_t freq_in_hz)
{
80004b3a:	7179                	addi	sp,sp,-48
80004b3c:	d606                	sw	ra,44(sp)
80004b3e:	c62a                	sw	a0,12(sp)
80004b40:	87ae                	mv	a5,a1
80004b42:	c232                	sw	a2,4(sp)
80004b44:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status;
    if ((ptr == NULL) || (freq_in_hz < PLLCTLV2_PLL_FREQ_MIN) || (freq_in_hz > PLLCTLV2_PLL_FREQ_MAX) ||
80004b48:	47b2                	lw	a5,12(sp)
80004b4a:	c395                	beqz	a5,80004b6e <.L19>
80004b4c:	4712                	lw	a4,4(sp)
80004b4e:	16e367b7          	lui	a5,0x16e36
80004b52:	00f76e63          	bltu	a4,a5,80004b6e <.L19>
80004b56:	4712                	lw	a4,4(sp)
80004b58:	3d8317b7          	lui	a5,0x3d831
80004b5c:	20078793          	addi	a5,a5,512 # 3d831200 <_flash_size+0x3d731200>
80004b60:	00e7e763          	bltu	a5,a4,80004b6e <.L19>
80004b64:	00b14703          	lbu	a4,11(sp)
80004b68:	4785                	li	a5,1
80004b6a:	00e7f563          	bgeu	a5,a4,80004b74 <.L20>

80004b6e <.L19>:
        (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
        status = status_invalid_argument;
80004b6e:	4789                	li	a5,2
80004b70:	ce3e                	sw	a5,28(sp)
80004b72:	a8bd                	j	80004bf0 <.L21>

80004b74 <.L20>:
    } else {
        uint32_t mfn = freq_in_hz % PLLCTLV2_PLL_XTAL_FREQ;
80004b74:	4792                	lw	a5,4(sp)
80004b76:	165ea737          	lui	a4,0x165ea
80004b7a:	f8170713          	addi	a4,a4,-127 # 165e9f81 <_flash_size+0x164e9f81>
80004b7e:	02e7b733          	mulhu	a4,a5,a4
80004b82:	01575693          	srli	a3,a4,0x15
80004b86:	016e3737          	lui	a4,0x16e3
80004b8a:	60070713          	addi	a4,a4,1536 # 16e3600 <_flash_size+0x15e3600>
80004b8e:	02e68733          	mul	a4,a3,a4
80004b92:	8f99                	sub	a5,a5,a4
80004b94:	cc3e                	sw	a5,24(sp)
        uint32_t mfi = freq_in_hz / PLLCTLV2_PLL_XTAL_FREQ;
80004b96:	4712                	lw	a4,4(sp)
80004b98:	165ea7b7          	lui	a5,0x165ea
80004b9c:	f8178793          	addi	a5,a5,-127 # 165e9f81 <_flash_size+0x164e9f81>
80004ba0:	02f737b3          	mulhu	a5,a4,a5
80004ba4:	83d5                	srli	a5,a5,0x15
80004ba6:	ca3e                	sw	a5,20(sp)

        /*
         * NOTE: Default MFD value is 240M
         */
        ptr->PLL[pll].MFN = mfn * PLLCTLV2_PLL_MFN_FACTOR;
80004ba8:	00b14683          	lbu	a3,11(sp)
80004bac:	4762                	lw	a4,24(sp)
80004bae:	87ba                	mv	a5,a4
80004bb0:	078a                	slli	a5,a5,0x2
80004bb2:	97ba                	add	a5,a5,a4
80004bb4:	0786                	slli	a5,a5,0x1
80004bb6:	863e                	mv	a2,a5
80004bb8:	4732                	lw	a4,12(sp)
80004bba:	00168793          	addi	a5,a3,1
80004bbe:	079e                	slli	a5,a5,0x7
80004bc0:	97ba                	add	a5,a5,a4
80004bc2:	c3d0                	sw	a2,4(a5)
        ptr->PLL[pll].MFI = mfi;
80004bc4:	00b14783          	lbu	a5,11(sp)
80004bc8:	4732                	lw	a4,12(sp)
80004bca:	0785                	addi	a5,a5,1
80004bcc:	079e                	slli	a5,a5,0x7
80004bce:	97ba                	add	a5,a5,a4
80004bd0:	4752                	lw	a4,20(sp)
80004bd2:	c398                	sw	a4,0(a5)


        while (!pllctlv2_pll_is_stable(ptr, pll)) {
80004bd4:	a011                	j	80004bd8 <.L22>

80004bd6 <.L23>:
            NOP();
80004bd6:	0001                	nop

80004bd8 <.L22>:
        while (!pllctlv2_pll_is_stable(ptr, pll)) {
80004bd8:	00b14783          	lbu	a5,11(sp)
80004bdc:	85be                	mv	a1,a5
80004bde:	4532                	lw	a0,12(sp)
80004be0:	3f11                	jal	80004af4 <pllctlv2_pll_is_stable>
80004be2:	87aa                	mv	a5,a0
80004be4:	0017c793          	xori	a5,a5,1
80004be8:	0ff7f793          	zext.b	a5,a5
80004bec:	f7ed                	bnez	a5,80004bd6 <.L23>
        }

        status = status_success;
80004bee:	ce02                	sw	zero,28(sp)

80004bf0 <.L21>:
    }
    return status;
80004bf0:	47f2                	lw	a5,28(sp)
}
80004bf2:	853e                	mv	a0,a5
80004bf4:	50b2                	lw	ra,44(sp)
80004bf6:	6145                	addi	sp,sp,48
80004bf8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

80004bfa <__SEGGER_RTL_xtoa>:
80004bfa:	882e                	mv	a6,a1
80004bfc:	ca91                	beqz	a3,80004c10 <__SEGGER_RTL_xtoa+0x16>
80004bfe:	00180693          	addi	a3,a6,1
80004c02:	02d00593          	li	a1,45
80004c06:	00b80023          	sb	a1,0(a6)
80004c0a:	40a00533          	neg	a0,a0
80004c0e:	a011                	j	80004c12 <__SEGGER_RTL_xtoa+0x18>
80004c10:	86c2                	mv	a3,a6
80004c12:	ffe68713          	addi	a4,a3,-2
80004c16:	48a5                	li	a7,9
80004c18:	85aa                	mv	a1,a0
80004c1a:	02c55533          	divu	a0,a0,a2
80004c1e:	02c507b3          	mul	a5,a0,a2
80004c22:	40f587b3          	sub	a5,a1,a5
80004c26:	00f8e563          	bltu	a7,a5,80004c30 <__SEGGER_RTL_xtoa+0x36>
80004c2a:	03078793          	addi	a5,a5,48
80004c2e:	a019                	j	80004c34 <__SEGGER_RTL_xtoa+0x3a>
80004c30:	05778793          	addi	a5,a5,87
80004c34:	00f70123          	sb	a5,2(a4)
80004c38:	0705                	addi	a4,a4,1
80004c3a:	fcc5ffe3          	bgeu	a1,a2,80004c18 <__SEGGER_RTL_xtoa+0x1e>
80004c3e:	00070123          	sb	zero,2(a4)
80004c42:	0006c503          	lbu	a0,0(a3)
80004c46:	85ba                	mv	a1,a4
80004c48:	00174603          	lbu	a2,1(a4)
80004c4c:	00a700a3          	sb	a0,1(a4)
80004c50:	00168513          	addi	a0,a3,1
80004c54:	00c68023          	sb	a2,0(a3)
80004c58:	177d                	addi	a4,a4,-1
80004c5a:	86aa                	mv	a3,a0
80004c5c:	feb563e3          	bltu	a0,a1,80004c42 <__SEGGER_RTL_xtoa+0x48>
80004c60:	8542                	mv	a0,a6
80004c62:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

80004c64 <__SEGGER_RTL_X_assert>:
80004c64:	1101                	addi	sp,sp,-32
80004c66:	ce06                	sw	ra,28(sp)
80004c68:	cc22                	sw	s0,24(sp)
80004c6a:	ca26                	sw	s1,20(sp)
80004c6c:	86b2                	mv	a3,a2
80004c6e:	842e                	mv	s0,a1
80004c70:	84aa                	mv	s1,a0
80004c72:	004c                	addi	a1,sp,4
80004c74:	4629                	li	a2,10
80004c76:	8536                	mv	a0,a3
80004c78:	762020ef          	jal	800073da <itoa>
80004c7c:	8522                	mv	a0,s0
80004c7e:	7ea020ef          	jal	80007468 <__SEGGER_RTL_puts_no_nl>
80004c82:	80008537          	lui	a0,0x80008
80004c86:	4f150513          	addi	a0,a0,1265 # 800084f1 <.L.str>
80004c8a:	7de020ef          	jal	80007468 <__SEGGER_RTL_puts_no_nl>
80004c8e:	0048                	addi	a0,sp,4
80004c90:	7d8020ef          	jal	80007468 <__SEGGER_RTL_puts_no_nl>
80004c94:	01718513          	addi	a0,gp,23 # 800038a7 <.L.str.1>
80004c98:	7d0020ef          	jal	80007468 <__SEGGER_RTL_puts_no_nl>
80004c9c:	8526                	mv	a0,s1
80004c9e:	7ca020ef          	jal	80007468 <__SEGGER_RTL_puts_no_nl>
80004ca2:	80008537          	lui	a0,0x80008
80004ca6:	4f350513          	addi	a0,a0,1267 # 800084f3 <.L.str.2>
80004caa:	7be020ef          	jal	80007468 <__SEGGER_RTL_puts_no_nl>
80004cae:	758020ef          	jal	80007406 <abort>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

80004cb2 <__SEGGER_RTL_SIGNAL_SIG_ERR>:
80004cb2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

80004cb4 <__SEGGER_RTL_SIGNAL_SIG_IGN>:
80004cb4:	8082                	ret

Disassembly of section .text.libc.__subsf3:

80004cb6 <__subsf3>:
80004cb6:	80000637          	lui	a2,0x80000
80004cba:	8db1                	xor	a1,a1,a2
80004cbc:	a009                	j	80004cbe <__addsf3>

Disassembly of section .text.libc.__addsf3:

80004cbe <__addsf3>:
80004cbe:	80000637          	lui	a2,0x80000
80004cc2:	00b546b3          	xor	a3,a0,a1
80004cc6:	0806ca63          	bltz	a3,80004d5a <.L__addsf3_subtract>
80004cca:	00b57563          	bgeu	a0,a1,80004cd4 <.L__addsf3_add_already_ordered>
80004cce:	86aa                	mv	a3,a0
80004cd0:	852e                	mv	a0,a1
80004cd2:	85b6                	mv	a1,a3

80004cd4 <.L__addsf3_add_already_ordered>:
80004cd4:	00151713          	slli	a4,a0,0x1
80004cd8:	8361                	srli	a4,a4,0x18
80004cda:	00159693          	slli	a3,a1,0x1
80004cde:	82e1                	srli	a3,a3,0x18
80004ce0:	0ff00293          	li	t0,255
80004ce4:	06570563          	beq	a4,t0,80004d4e <.L__addsf3_add_inf_or_nan>
80004ce8:	c325                	beqz	a4,80004d48 <.L__addsf3_zero>
80004cea:	ceb1                	beqz	a3,80004d46 <.L__addsf3_add_done>
80004cec:	40d706b3          	sub	a3,a4,a3
80004cf0:	42e1                	li	t0,24
80004cf2:	04d2ca63          	blt	t0,a3,80004d46 <.L__addsf3_add_done>
80004cf6:	05a2                	slli	a1,a1,0x8
80004cf8:	8dd1                	or	a1,a1,a2
80004cfa:	01755713          	srli	a4,a0,0x17
80004cfe:	0522                	slli	a0,a0,0x8
80004d00:	8d51                	or	a0,a0,a2
80004d02:	47e5                	li	a5,25
80004d04:	8f95                	sub	a5,a5,a3
80004d06:	00f59633          	sll	a2,a1,a5
80004d0a:	821d                	srli	a2,a2,0x7
80004d0c:	00d5d5b3          	srl	a1,a1,a3
80004d10:	00b507b3          	add	a5,a0,a1
80004d14:	00a7f463          	bgeu	a5,a0,80004d1c <.L__addsf3_add_no_normalization>
80004d18:	8385                	srli	a5,a5,0x1
80004d1a:	0709                	addi	a4,a4,2

80004d1c <.L__addsf3_add_no_normalization>:
80004d1c:	177d                	addi	a4,a4,-1
80004d1e:	0ff77593          	zext.b	a1,a4
80004d22:	f0158593          	addi	a1,a1,-255 # 3fffff01 <_flash_size+0x3fefff01>
80004d26:	cd91                	beqz	a1,80004d42 <.L__addsf3_inf>
80004d28:	075e                	slli	a4,a4,0x17
80004d2a:	0087d513          	srli	a0,a5,0x8
80004d2e:	07e2                	slli	a5,a5,0x18
80004d30:	8fd1                	or	a5,a5,a2
80004d32:	0007d663          	bgez	a5,80004d3e <.L__addsf3_no_tie>
80004d36:	0786                	slli	a5,a5,0x1
80004d38:	0505                	addi	a0,a0,1
80004d3a:	e391                	bnez	a5,80004d3e <.L__addsf3_no_tie>
80004d3c:	9979                	andi	a0,a0,-2

80004d3e <.L__addsf3_no_tie>:
80004d3e:	953a                	add	a0,a0,a4
80004d40:	8082                	ret

80004d42 <.L__addsf3_inf>:
80004d42:	01771513          	slli	a0,a4,0x17

80004d46 <.L__addsf3_add_done>:
80004d46:	8082                	ret

80004d48 <.L__addsf3_zero>:
80004d48:	817d                	srli	a0,a0,0x1f
80004d4a:	057e                	slli	a0,a0,0x1f
80004d4c:	8082                	ret

80004d4e <.L__addsf3_add_inf_or_nan>:
80004d4e:	00951613          	slli	a2,a0,0x9
80004d52:	da75                	beqz	a2,80004d46 <.L__addsf3_add_done>

80004d54 <.L__addsf3_return_nan>:
80004d54:	7fc00537          	lui	a0,0x7fc00
80004d58:	8082                	ret

80004d5a <.L__addsf3_subtract>:
80004d5a:	8db1                	xor	a1,a1,a2
80004d5c:	40b506b3          	sub	a3,a0,a1
80004d60:	00b57563          	bgeu	a0,a1,80004d6a <.L__addsf3_sub_already_ordered>
80004d64:	8eb1                	xor	a3,a3,a2
80004d66:	8d15                	sub	a0,a0,a3
80004d68:	95b6                	add	a1,a1,a3

80004d6a <.L__addsf3_sub_already_ordered>:
80004d6a:	00159693          	slli	a3,a1,0x1
80004d6e:	82e1                	srli	a3,a3,0x18
80004d70:	00151713          	slli	a4,a0,0x1
80004d74:	8361                	srli	a4,a4,0x18
80004d76:	05a2                	slli	a1,a1,0x8
80004d78:	8dd1                	or	a1,a1,a2
80004d7a:	0ff00293          	li	t0,255
80004d7e:	0c570c63          	beq	a4,t0,80004e56 <.L__addsf3_sub_inf_or_nan>
80004d82:	c2f5                	beqz	a3,80004e66 <.L__addsf3_sub_zero>
80004d84:	40d706b3          	sub	a3,a4,a3
80004d88:	c695                	beqz	a3,80004db4 <.L__addsf3_exponents_equal>
80004d8a:	4285                	li	t0,1
80004d8c:	08569063          	bne	a3,t0,80004e0c <.L__addsf3_exponents_differ_by_more_than_1>
80004d90:	01755693          	srli	a3,a0,0x17
80004d94:	0526                	slli	a0,a0,0x9
80004d96:	00b532b3          	sltu	t0,a0,a1
80004d9a:	8d0d                	sub	a0,a0,a1
80004d9c:	02029263          	bnez	t0,80004dc0 <.L__addsf3_normalization_steps>
80004da0:	06de                	slli	a3,a3,0x17
80004da2:	01751593          	slli	a1,a0,0x17
80004da6:	8125                	srli	a0,a0,0x9
80004da8:	0005d463          	bgez	a1,80004db0 <.L__addsf3_sub_no_tie_single>
80004dac:	0505                	addi	a0,a0,1 # 7fc00001 <_flash_size+0x7fb00001>
80004dae:	9979                	andi	a0,a0,-2

80004db0 <.L__addsf3_sub_no_tie_single>:
80004db0:	9536                	add	a0,a0,a3

80004db2 <.L__addsf3_sub_done>:
80004db2:	8082                	ret

80004db4 <.L__addsf3_exponents_equal>:
80004db4:	01755693          	srli	a3,a0,0x17
80004db8:	0526                	slli	a0,a0,0x9
80004dba:	0586                	slli	a1,a1,0x1
80004dbc:	8d0d                	sub	a0,a0,a1
80004dbe:	d975                	beqz	a0,80004db2 <.L__addsf3_sub_done>

80004dc0 <.L__addsf3_normalization_steps>:
80004dc0:	4581                	li	a1,0
80004dc2:	01055793          	srli	a5,a0,0x10
80004dc6:	e399                	bnez	a5,80004dcc <.Ltmp0>
80004dc8:	0542                	slli	a0,a0,0x10
80004dca:	05c1                	addi	a1,a1,16

80004dcc <.Ltmp0>:
80004dcc:	01855793          	srli	a5,a0,0x18
80004dd0:	e399                	bnez	a5,80004dd6 <.Ltmp1>
80004dd2:	0522                	slli	a0,a0,0x8
80004dd4:	05a1                	addi	a1,a1,8

80004dd6 <.Ltmp1>:
80004dd6:	01c55793          	srli	a5,a0,0x1c
80004dda:	e399                	bnez	a5,80004de0 <.Ltmp2>
80004ddc:	0512                	slli	a0,a0,0x4
80004dde:	0591                	addi	a1,a1,4

80004de0 <.Ltmp2>:
80004de0:	01e55793          	srli	a5,a0,0x1e
80004de4:	e399                	bnez	a5,80004dea <.Ltmp3>
80004de6:	050a                	slli	a0,a0,0x2
80004de8:	0589                	addi	a1,a1,2

80004dea <.Ltmp3>:
80004dea:	00054463          	bltz	a0,80004df2 <.Ltmp4>
80004dee:	0506                	slli	a0,a0,0x1
80004df0:	0585                	addi	a1,a1,1

80004df2 <.Ltmp4>:
80004df2:	0585                	addi	a1,a1,1
80004df4:	0506                	slli	a0,a0,0x1
80004df6:	00e5f763          	bgeu	a1,a4,80004e04 <.L__addsf3_underflow>
80004dfa:	8e8d                	sub	a3,a3,a1
80004dfc:	06de                	slli	a3,a3,0x17
80004dfe:	8125                	srli	a0,a0,0x9
80004e00:	9536                	add	a0,a0,a3
80004e02:	8082                	ret

80004e04 <.L__addsf3_underflow>:
80004e04:	0086d513          	srli	a0,a3,0x8
80004e08:	057e                	slli	a0,a0,0x1f
80004e0a:	8082                	ret

80004e0c <.L__addsf3_exponents_differ_by_more_than_1>:
80004e0c:	42e5                	li	t0,25
80004e0e:	fad2e2e3          	bltu	t0,a3,80004db2 <.L__addsf3_sub_done>
80004e12:	0685                	addi	a3,a3,1
80004e14:	40d00733          	neg	a4,a3
80004e18:	00e59733          	sll	a4,a1,a4
80004e1c:	00d5d5b3          	srl	a1,a1,a3
80004e20:	00e03733          	snez	a4,a4
80004e24:	95ae                	add	a1,a1,a1
80004e26:	95ba                	add	a1,a1,a4
80004e28:	01755693          	srli	a3,a0,0x17
80004e2c:	0522                	slli	a0,a0,0x8
80004e2e:	8d51                	or	a0,a0,a2
80004e30:	40b50733          	sub	a4,a0,a1
80004e34:	00074463          	bltz	a4,80004e3c <.L__addsf3_sub_already_normalized>
80004e38:	070a                	slli	a4,a4,0x2
80004e3a:	8305                	srli	a4,a4,0x1

80004e3c <.L__addsf3_sub_already_normalized>:
80004e3c:	16fd                	addi	a3,a3,-1
80004e3e:	06de                	slli	a3,a3,0x17
80004e40:	00875513          	srli	a0,a4,0x8
80004e44:	0762                	slli	a4,a4,0x18
80004e46:	00075663          	bgez	a4,80004e52 <.L__addsf3_sub_no_tie>
80004e4a:	0706                	slli	a4,a4,0x1
80004e4c:	0505                	addi	a0,a0,1
80004e4e:	e311                	bnez	a4,80004e52 <.L__addsf3_sub_no_tie>
80004e50:	9979                	andi	a0,a0,-2

80004e52 <.L__addsf3_sub_no_tie>:
80004e52:	9536                	add	a0,a0,a3
80004e54:	8082                	ret

80004e56 <.L__addsf3_sub_inf_or_nan>:
80004e56:	0ff00293          	li	t0,255
80004e5a:	ee568de3          	beq	a3,t0,80004d54 <.L__addsf3_return_nan>
80004e5e:	00951593          	slli	a1,a0,0x9
80004e62:	d9a1                	beqz	a1,80004db2 <.L__addsf3_sub_done>
80004e64:	bdc5                	j	80004d54 <.L__addsf3_return_nan>

80004e66 <.L__addsf3_sub_zero>:
80004e66:	f731                	bnez	a4,80004db2 <.L__addsf3_sub_done>
80004e68:	4501                	li	a0,0
80004e6a:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

80004e6c <__ltsf2>:
80004e6c:	ff000637          	lui	a2,0xff000
80004e70:	00151693          	slli	a3,a0,0x1
80004e74:	02d66763          	bltu	a2,a3,80004ea2 <.L__ltsf2_zero>
80004e78:	00159693          	slli	a3,a1,0x1
80004e7c:	02d66363          	bltu	a2,a3,80004ea2 <.L__ltsf2_zero>
80004e80:	00b56633          	or	a2,a0,a1
80004e84:	00161693          	slli	a3,a2,0x1
80004e88:	ce89                	beqz	a3,80004ea2 <.L__ltsf2_zero>
80004e8a:	00064763          	bltz	a2,80004e98 <.L__ltsf2_negative>
80004e8e:	00b53533          	sltu	a0,a0,a1
80004e92:	40a00533          	neg	a0,a0
80004e96:	8082                	ret

80004e98 <.L__ltsf2_negative>:
80004e98:	00a5b533          	sltu	a0,a1,a0
80004e9c:	40a00533          	neg	a0,a0
80004ea0:	8082                	ret

80004ea2 <.L__ltsf2_zero>:
80004ea2:	4501                	li	a0,0
80004ea4:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

80004ea6 <__gtsf2>:
80004ea6:	ff000637          	lui	a2,0xff000
80004eaa:	00151693          	slli	a3,a0,0x1
80004eae:	02d66363          	bltu	a2,a3,80004ed4 <.L__gtsf2_zero>
80004eb2:	00159693          	slli	a3,a1,0x1
80004eb6:	00d66f63          	bltu	a2,a3,80004ed4 <.L__gtsf2_zero>
80004eba:	00b56633          	or	a2,a0,a1
80004ebe:	00161693          	slli	a3,a2,0x1
80004ec2:	ca89                	beqz	a3,80004ed4 <.L__gtsf2_zero>
80004ec4:	00064563          	bltz	a2,80004ece <.L__gtsf2_negative>
80004ec8:	00a5b533          	sltu	a0,a1,a0
80004ecc:	8082                	ret

80004ece <.L__gtsf2_negative>:
80004ece:	00b53533          	sltu	a0,a0,a1
80004ed2:	8082                	ret

80004ed4 <.L__gtsf2_zero>:
80004ed4:	4501                	li	a0,0
80004ed6:	8082                	ret

Disassembly of section .text.libc.__gesf2:

80004ed8 <__gesf2>:
80004ed8:	ff000637          	lui	a2,0xff000
80004edc:	00151693          	slli	a3,a0,0x1
80004ee0:	02d66763          	bltu	a2,a3,80004f0e <.L__gesf2_nan>
80004ee4:	00159693          	slli	a3,a1,0x1
80004ee8:	02d66363          	bltu	a2,a3,80004f0e <.L__gesf2_nan>
80004eec:	00b56633          	or	a2,a0,a1
80004ef0:	00161693          	slli	a3,a2,0x1
80004ef4:	ce99                	beqz	a3,80004f12 <.L__gesf2_zero>
80004ef6:	00064763          	bltz	a2,80004f04 <.L__gesf2_negative>
80004efa:	00b53533          	sltu	a0,a0,a1
80004efe:	40a00533          	neg	a0,a0
80004f02:	8082                	ret

80004f04 <.L__gesf2_negative>:
80004f04:	00a5b533          	sltu	a0,a1,a0
80004f08:	40a00533          	neg	a0,a0
80004f0c:	8082                	ret

80004f0e <.L__gesf2_nan>:
80004f0e:	557d                	li	a0,-1
80004f10:	8082                	ret

80004f12 <.L__gesf2_zero>:
80004f12:	4501                	li	a0,0
80004f14:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

80004f16 <__floatundisf>:
80004f16:	c5bd                	beqz	a1,80004f84 <.L__floatundisf_high_word_zero>
80004f18:	4701                	li	a4,0
80004f1a:	0105d693          	srli	a3,a1,0x10
80004f1e:	e299                	bnez	a3,80004f24 <.Ltmp45>
80004f20:	0741                	addi	a4,a4,16
80004f22:	05c2                	slli	a1,a1,0x10

80004f24 <.Ltmp45>:
80004f24:	0185d693          	srli	a3,a1,0x18
80004f28:	e299                	bnez	a3,80004f2e <.Ltmp46>
80004f2a:	0721                	addi	a4,a4,8
80004f2c:	05a2                	slli	a1,a1,0x8

80004f2e <.Ltmp46>:
80004f2e:	01c5d693          	srli	a3,a1,0x1c
80004f32:	e299                	bnez	a3,80004f38 <.Ltmp47>
80004f34:	0711                	addi	a4,a4,4
80004f36:	0592                	slli	a1,a1,0x4

80004f38 <.Ltmp47>:
80004f38:	01e5d693          	srli	a3,a1,0x1e
80004f3c:	e299                	bnez	a3,80004f42 <.Ltmp48>
80004f3e:	0709                	addi	a4,a4,2
80004f40:	058a                	slli	a1,a1,0x2

80004f42 <.Ltmp48>:
80004f42:	0005c463          	bltz	a1,80004f4a <.Ltmp49>
80004f46:	0705                	addi	a4,a4,1
80004f48:	0586                	slli	a1,a1,0x1

80004f4a <.Ltmp49>:
80004f4a:	fff74613          	not	a2,a4
80004f4e:	00c556b3          	srl	a3,a0,a2
80004f52:	8285                	srli	a3,a3,0x1
80004f54:	8dd5                	or	a1,a1,a3
80004f56:	00e51533          	sll	a0,a0,a4
80004f5a:	0be60613          	addi	a2,a2,190 # ff0000be <__AHB_SRAM_segment_end__+0xebf80be>
80004f5e:	00a03533          	snez	a0,a0
80004f62:	8dc9                	or	a1,a1,a0

80004f64 <.L__floatundisf_round_and_pack>:
80004f64:	065e                	slli	a2,a2,0x17
80004f66:	0085d513          	srli	a0,a1,0x8
80004f6a:	05de                	slli	a1,a1,0x17
80004f6c:	0005a333          	sltz	t1,a1
80004f70:	95ae                	add	a1,a1,a1
80004f72:	959a                	add	a1,a1,t1
80004f74:	0005d663          	bgez	a1,80004f80 <.L__floatundisf_round_down>
80004f78:	95ae                	add	a1,a1,a1
80004f7a:	00b035b3          	snez	a1,a1
80004f7e:	952e                	add	a0,a0,a1

80004f80 <.L__floatundisf_round_down>:
80004f80:	9532                	add	a0,a0,a2

80004f82 <.L__floatundisf_done>:
80004f82:	8082                	ret

80004f84 <.L__floatundisf_high_word_zero>:
80004f84:	dd7d                	beqz	a0,80004f82 <.L__floatundisf_done>
80004f86:	09d00613          	li	a2,157
80004f8a:	01055693          	srli	a3,a0,0x10
80004f8e:	e299                	bnez	a3,80004f94 <.Ltmp50>
80004f90:	0542                	slli	a0,a0,0x10
80004f92:	1641                	addi	a2,a2,-16

80004f94 <.Ltmp50>:
80004f94:	01855693          	srli	a3,a0,0x18
80004f98:	e299                	bnez	a3,80004f9e <.Ltmp51>
80004f9a:	0522                	slli	a0,a0,0x8
80004f9c:	1661                	addi	a2,a2,-8

80004f9e <.Ltmp51>:
80004f9e:	01c55693          	srli	a3,a0,0x1c
80004fa2:	e299                	bnez	a3,80004fa8 <.Ltmp52>
80004fa4:	0512                	slli	a0,a0,0x4
80004fa6:	1671                	addi	a2,a2,-4

80004fa8 <.Ltmp52>:
80004fa8:	01e55693          	srli	a3,a0,0x1e
80004fac:	e299                	bnez	a3,80004fb2 <.Ltmp53>
80004fae:	050a                	slli	a0,a0,0x2
80004fb0:	1679                	addi	a2,a2,-2

80004fb2 <.Ltmp53>:
80004fb2:	00054463          	bltz	a0,80004fba <.Ltmp54>
80004fb6:	0506                	slli	a0,a0,0x1
80004fb8:	167d                	addi	a2,a2,-1

80004fba <.Ltmp54>:
80004fba:	85aa                	mv	a1,a0
80004fbc:	4501                	li	a0,0
80004fbe:	b75d                	j	80004f64 <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

80004fc0 <__truncdfsf2>:
80004fc0:	00159693          	slli	a3,a1,0x1
80004fc4:	82d5                	srli	a3,a3,0x15
80004fc6:	7ff00613          	li	a2,2047
80004fca:	04c68663          	beq	a3,a2,80005016 <.L__truncdfsf2_inf_nan>
80004fce:	c8068693          	addi	a3,a3,-896
80004fd2:	02d05e63          	blez	a3,8000500e <.L__truncdfsf2_underflow>
80004fd6:	0ff00613          	li	a2,255
80004fda:	04c6f263          	bgeu	a3,a2,8000501e <.L__truncdfsf2_inf>
80004fde:	06de                	slli	a3,a3,0x17
80004fe0:	01f5d613          	srli	a2,a1,0x1f
80004fe4:	067e                	slli	a2,a2,0x1f
80004fe6:	8ed1                	or	a3,a3,a2
80004fe8:	05b2                	slli	a1,a1,0xc
80004fea:	01455613          	srli	a2,a0,0x14
80004fee:	8dd1                	or	a1,a1,a2
80004ff0:	81a5                	srli	a1,a1,0x9
80004ff2:	00251613          	slli	a2,a0,0x2
80004ff6:	00062733          	sltz	a4,a2
80004ffa:	9632                	add	a2,a2,a2
80004ffc:	000627b3          	sltz	a5,a2
80005000:	9632                	add	a2,a2,a2
80005002:	963a                	add	a2,a2,a4
80005004:	c211                	beqz	a2,80005008 <.L__truncdfsf2_no_round_tie>
80005006:	95be                	add	a1,a1,a5

80005008 <.L__truncdfsf2_no_round_tie>:
80005008:	00d58533          	add	a0,a1,a3
8000500c:	8082                	ret

8000500e <.L__truncdfsf2_underflow>:
8000500e:	01f5d513          	srli	a0,a1,0x1f
80005012:	057e                	slli	a0,a0,0x1f
80005014:	8082                	ret

80005016 <.L__truncdfsf2_inf_nan>:
80005016:	00c59693          	slli	a3,a1,0xc
8000501a:	8ec9                	or	a3,a3,a0
8000501c:	ea81                	bnez	a3,8000502c <.L__truncdfsf2_nan>

8000501e <.L__truncdfsf2_inf>:
8000501e:	81fd                	srli	a1,a1,0x1f
80005020:	05fe                	slli	a1,a1,0x1f
80005022:	7f800537          	lui	a0,0x7f800
80005026:	8d4d                	or	a0,a0,a1
80005028:	4581                	li	a1,0
8000502a:	8082                	ret

8000502c <.L__truncdfsf2_nan>:
8000502c:	800006b7          	lui	a3,0x80000
80005030:	00d5f633          	and	a2,a1,a3
80005034:	058e                	slli	a1,a1,0x3
80005036:	8175                	srli	a0,a0,0x1d
80005038:	8d4d                	or	a0,a0,a1
8000503a:	0506                	slli	a0,a0,0x1
8000503c:	8105                	srli	a0,a0,0x1
8000503e:	8d51                	or	a0,a0,a2
80005040:	82a5                	srli	a3,a3,0x9
80005042:	8d55                	or	a0,a0,a3
80005044:	8082                	ret

Disassembly of section .text.libc.frexpf:

80005046 <frexpf>:
80005046:	01755613          	srli	a2,a0,0x17
8000504a:	0ff67613          	zext.b	a2,a2
8000504e:	0ff00693          	li	a3,255
80005052:	00d60363          	beq	a2,a3,80005058 <frexpf+0x12>
80005056:	e601                	bnez	a2,8000505e <frexpf+0x18>
80005058:	0005a023          	sw	zero,0(a1)
8000505c:	8082                	ret
8000505e:	f8260613          	addi	a2,a2,-126
80005062:	c190                	sw	a2,0(a1)
80005064:	808005b7          	lui	a1,0x80800
80005068:	15fd                	addi	a1,a1,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
8000506a:	8d6d                	and	a0,a0,a1
8000506c:	3f0005b7          	lui	a1,0x3f000
80005070:	8d4d                	or	a0,a0,a1
80005072:	8082                	ret

Disassembly of section .text.libc.abs:

80005074 <abs>:
80005074:	41f55593          	srai	a1,a0,0x1f
80005078:	8d2d                	xor	a0,a0,a1
8000507a:	8d0d                	sub	a0,a0,a1
8000507c:	8082                	ret

Disassembly of section .text.libc.memcpy:

8000507e <memcpy>:
8000507e:	c251                	beqz	a2,80005102 <.Lmemcpy_done>
80005080:	87aa                	mv	a5,a0
80005082:	00b546b3          	xor	a3,a0,a1
80005086:	06fa                	slli	a3,a3,0x1e
80005088:	e2bd                	bnez	a3,800050ee <.Lmemcpy_byte_copy>
8000508a:	01e51693          	slli	a3,a0,0x1e
8000508e:	ce81                	beqz	a3,800050a6 <.Lmemcpy_aligned>

80005090 <.Lmemcpy_word_align>:
80005090:	00058683          	lb	a3,0(a1) # 3f000000 <_flash_size+0x3ef00000>
80005094:	00d50023          	sb	a3,0(a0) # 7f800000 <_flash_size+0x7f700000>
80005098:	0585                	addi	a1,a1,1
8000509a:	0505                	addi	a0,a0,1
8000509c:	167d                	addi	a2,a2,-1
8000509e:	c22d                	beqz	a2,80005100 <.Lmemcpy_memcpy_end>
800050a0:	01e51693          	slli	a3,a0,0x1e
800050a4:	f6f5                	bnez	a3,80005090 <.Lmemcpy_word_align>

800050a6 <.Lmemcpy_aligned>:
800050a6:	02000693          	li	a3,32
800050aa:	02d66763          	bltu	a2,a3,800050d8 <.Lmemcpy_word_copy>

800050ae <.Lmemcpy_aligned_block_copy_loop>:
800050ae:	4198                	lw	a4,0(a1)
800050b0:	c118                	sw	a4,0(a0)
800050b2:	41d8                	lw	a4,4(a1)
800050b4:	c158                	sw	a4,4(a0)
800050b6:	4598                	lw	a4,8(a1)
800050b8:	c518                	sw	a4,8(a0)
800050ba:	45d8                	lw	a4,12(a1)
800050bc:	c558                	sw	a4,12(a0)
800050be:	4998                	lw	a4,16(a1)
800050c0:	c918                	sw	a4,16(a0)
800050c2:	49d8                	lw	a4,20(a1)
800050c4:	c958                	sw	a4,20(a0)
800050c6:	4d98                	lw	a4,24(a1)
800050c8:	cd18                	sw	a4,24(a0)
800050ca:	4dd8                	lw	a4,28(a1)
800050cc:	cd58                	sw	a4,28(a0)
800050ce:	9536                	add	a0,a0,a3
800050d0:	95b6                	add	a1,a1,a3
800050d2:	8e15                	sub	a2,a2,a3
800050d4:	fcd67de3          	bgeu	a2,a3,800050ae <.Lmemcpy_aligned_block_copy_loop>

800050d8 <.Lmemcpy_word_copy>:
800050d8:	c605                	beqz	a2,80005100 <.Lmemcpy_memcpy_end>
800050da:	4691                	li	a3,4
800050dc:	00d66963          	bltu	a2,a3,800050ee <.Lmemcpy_byte_copy>

800050e0 <.Lmemcpy_word_copy_loop>:
800050e0:	4198                	lw	a4,0(a1)
800050e2:	c118                	sw	a4,0(a0)
800050e4:	9536                	add	a0,a0,a3
800050e6:	95b6                	add	a1,a1,a3
800050e8:	8e15                	sub	a2,a2,a3
800050ea:	fed67be3          	bgeu	a2,a3,800050e0 <.Lmemcpy_word_copy_loop>

800050ee <.Lmemcpy_byte_copy>:
800050ee:	ca09                	beqz	a2,80005100 <.Lmemcpy_memcpy_end>

800050f0 <.Lmemcpy_byte_copy_loop>:
800050f0:	00058703          	lb	a4,0(a1)
800050f4:	00e50023          	sb	a4,0(a0)
800050f8:	0585                	addi	a1,a1,1
800050fa:	0505                	addi	a0,a0,1
800050fc:	167d                	addi	a2,a2,-1
800050fe:	fa6d                	bnez	a2,800050f0 <.Lmemcpy_byte_copy_loop>

80005100 <.Lmemcpy_memcpy_end>:
80005100:	853e                	mv	a0,a5

80005102 <.Lmemcpy_done>:
80005102:	8082                	ret

Disassembly of section .text.libc.strnlen:

80005104 <strnlen>:
80005104:	cda9                	beqz	a1,8000515e <strnlen+0x5a>
80005106:	00054603          	lbu	a2,0(a0)
8000510a:	ca31                	beqz	a2,8000515e <strnlen+0x5a>
8000510c:	ffc57713          	andi	a4,a0,-4
80005110:	00357613          	andi	a2,a0,3
80005114:	00351693          	slli	a3,a0,0x3
80005118:	95b2                	add	a1,a1,a2
8000511a:	4310                	lw	a2,0(a4)
8000511c:	57fd                	li	a5,-1
8000511e:	00d796b3          	sll	a3,a5,a3
80005122:	fff6c693          	not	a3,a3
80005126:	4791                	li	a5,4
80005128:	8ed1                	or	a3,a3,a2
8000512a:	02f5ed63          	bltu	a1,a5,80005164 <strnlen+0x60>
8000512e:	01010637          	lui	a2,0x1010
80005132:	808087b7          	lui	a5,0x80808
80005136:	10060893          	addi	a7,a2,256 # 1010100 <_flash_size+0xf10100>
8000513a:	08078793          	addi	a5,a5,128 # 80808080 <__FLASH_segment_end__+0x708080>
8000513e:	480d                	li	a6,3
80005140:	863a                	mv	a2,a4
80005142:	40d88733          	sub	a4,a7,a3
80005146:	8f55                	or	a4,a4,a3
80005148:	8f7d                	and	a4,a4,a5
8000514a:	00f71c63          	bne	a4,a5,80005162 <strnlen+0x5e>
8000514e:	4254                	lw	a3,4(a2)
80005150:	00460713          	addi	a4,a2,4
80005154:	15f1                	addi	a1,a1,-4
80005156:	863a                	mv	a2,a4
80005158:	feb865e3          	bltu	a6,a1,80005142 <strnlen+0x3e>
8000515c:	a021                	j	80005164 <strnlen+0x60>
8000515e:	4501                	li	a0,0
80005160:	8082                	ret
80005162:	8732                	mv	a4,a2
80005164:	0ff6f613          	zext.b	a2,a3
80005168:	c215                	beqz	a2,8000518c <strnlen+0x88>
8000516a:	6641                	lui	a2,0x10
8000516c:	f0060613          	addi	a2,a2,-256 # ff00 <__AHB_SRAM_segment_size__+0x7f00>
80005170:	8e75                	and	a2,a2,a3
80005172:	ce01                	beqz	a2,8000518a <strnlen+0x86>
80005174:	00ff0637          	lui	a2,0xff0
80005178:	8e75                	and	a2,a2,a3
8000517a:	c205                	beqz	a2,8000519a <strnlen+0x96>
8000517c:	82e1                	srli	a3,a3,0x18
8000517e:	00d03633          	snez	a2,a3
80005182:	060d                	addi	a2,a2,3 # ff0003 <_flash_size+0xef0003>
80005184:	00b67663          	bgeu	a2,a1,80005190 <strnlen+0x8c>
80005188:	a029                	j	80005192 <strnlen+0x8e>
8000518a:	4605                	li	a2,1
8000518c:	00b66363          	bltu	a2,a1,80005192 <strnlen+0x8e>
80005190:	862e                	mv	a2,a1
80005192:	40a70533          	sub	a0,a4,a0
80005196:	9532                	add	a0,a0,a2
80005198:	8082                	ret
8000519a:	4609                	li	a2,2
8000519c:	feb67ae3          	bgeu	a2,a1,80005190 <strnlen+0x8c>
800051a0:	bfcd                	j	80005192 <strnlen+0x8e>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

800051a2 <__SEGGER_RTL_putc>:
800051a2:	1141                	addi	sp,sp,-16
800051a4:	c606                	sw	ra,12(sp)
800051a6:	c422                	sw	s0,8(sp)
800051a8:	842a                	mv	s0,a0
800051aa:	4908                	lw	a0,16(a0)
800051ac:	00b103a3          	sb	a1,7(sp)
800051b0:	c11d                	beqz	a0,800051d6 <__SEGGER_RTL_putc+0x34>
800051b2:	4010                	lw	a2,0(s0)
800051b4:	4054                	lw	a3,4(s0)
800051b6:	06d67f63          	bgeu	a2,a3,80005234 <__SEGGER_RTL_putc+0x92>
800051ba:	4850                	lw	a2,20(s0)
800051bc:	00160693          	addi	a3,a2,1
800051c0:	9532                	add	a0,a0,a2
800051c2:	c854                	sw	a3,20(s0)
800051c4:	00b50023          	sb	a1,0(a0)
800051c8:	4848                	lw	a0,20(s0)
800051ca:	4c0c                	lw	a1,24(s0)
800051cc:	06b51463          	bne	a0,a1,80005234 <__SEGGER_RTL_putc+0x92>
800051d0:	8522                	mv	a0,s0
800051d2:	2885                	jal	80005242 <__SEGGER_RTL_prin_flush>
800051d4:	a085                	j	80005234 <__SEGGER_RTL_putc+0x92>
800051d6:	4448                	lw	a0,12(s0)
800051d8:	c105                	beqz	a0,800051f8 <__SEGGER_RTL_putc+0x56>
800051da:	4010                	lw	a2,0(s0)
800051dc:	4054                	lw	a3,4(s0)
800051de:	04d67b63          	bgeu	a2,a3,80005234 <__SEGGER_RTL_putc+0x92>
800051e2:	00160713          	addi	a4,a2,1
800051e6:	8eb9                	xor	a3,a3,a4
800051e8:	0016b693          	seqz	a3,a3
800051ec:	16fd                	addi	a3,a3,-1 # 7fffffff <_flash_size+0x7fefffff>
800051ee:	8df5                	and	a1,a1,a3
800051f0:	9532                	add	a0,a0,a2
800051f2:	00b50023          	sb	a1,0(a0)
800051f6:	a83d                	j	80005234 <__SEGGER_RTL_putc+0x92>
800051f8:	4408                	lw	a0,8(s0)
800051fa:	c115                	beqz	a0,8000521e <__SEGGER_RTL_putc+0x7c>
800051fc:	4010                	lw	a2,0(s0)
800051fe:	4054                	lw	a3,4(s0)
80005200:	02d67a63          	bgeu	a2,a3,80005234 <__SEGGER_RTL_putc+0x92>
80005204:	00160713          	addi	a4,a2,1
80005208:	060a                	slli	a2,a2,0x2
8000520a:	8eb9                	xor	a3,a3,a4
8000520c:	0016b693          	seqz	a3,a3
80005210:	16fd                	addi	a3,a3,-1
80005212:	8df5                	and	a1,a1,a3
80005214:	0ff5f593          	zext.b	a1,a1
80005218:	9532                	add	a0,a0,a2
8000521a:	c10c                	sw	a1,0(a0)
8000521c:	a821                	j	80005234 <__SEGGER_RTL_putc+0x92>
8000521e:	5014                	lw	a3,32(s0)
80005220:	ca91                	beqz	a3,80005234 <__SEGGER_RTL_putc+0x92>
80005222:	4008                	lw	a0,0(s0)
80005224:	404c                	lw	a1,4(s0)
80005226:	00b57763          	bgeu	a0,a1,80005234 <__SEGGER_RTL_putc+0x92>
8000522a:	00710593          	addi	a1,sp,7
8000522e:	4605                	li	a2,1
80005230:	8522                	mv	a0,s0
80005232:	9682                	jalr	a3
80005234:	4008                	lw	a0,0(s0)
80005236:	0505                	addi	a0,a0,1
80005238:	c008                	sw	a0,0(s0)
8000523a:	40b2                	lw	ra,12(sp)
8000523c:	4422                	lw	s0,8(sp)
8000523e:	0141                	addi	sp,sp,16
80005240:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

80005242 <__SEGGER_RTL_prin_flush>:
80005242:	4950                	lw	a2,20(a0)
80005244:	ce19                	beqz	a2,80005262 <__SEGGER_RTL_prin_flush+0x20>
80005246:	1141                	addi	sp,sp,-16
80005248:	c606                	sw	ra,12(sp)
8000524a:	c422                	sw	s0,8(sp)
8000524c:	842a                	mv	s0,a0
8000524e:	5114                	lw	a3,32(a0)
80005250:	c681                	beqz	a3,80005258 <__SEGGER_RTL_prin_flush+0x16>
80005252:	480c                	lw	a1,16(s0)
80005254:	8522                	mv	a0,s0
80005256:	9682                	jalr	a3
80005258:	00042a23          	sw	zero,20(s0)
8000525c:	40b2                	lw	ra,12(sp)
8000525e:	4422                	lw	s0,8(sp)
80005260:	0141                	addi	sp,sp,16
80005262:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

80005264 <__SEGGER_RTL_print_padding>:
80005264:	02c05963          	blez	a2,80005296 <__SEGGER_RTL_print_padding+0x32>
80005268:	1101                	addi	sp,sp,-32
8000526a:	ce06                	sw	ra,28(sp)
8000526c:	cc22                	sw	s0,24(sp)
8000526e:	ca26                	sw	s1,20(sp)
80005270:	c84a                	sw	s2,16(sp)
80005272:	c64e                	sw	s3,12(sp)
80005274:	892e                	mv	s2,a1
80005276:	84aa                	mv	s1,a0
80005278:	00160413          	addi	s0,a2,1
8000527c:	4985                	li	s3,1
8000527e:	8526                	mv	a0,s1
80005280:	85ca                	mv	a1,s2
80005282:	3705                	jal	800051a2 <__SEGGER_RTL_putc>
80005284:	147d                	addi	s0,s0,-1
80005286:	fe89ece3          	bltu	s3,s0,8000527e <__SEGGER_RTL_print_padding+0x1a>
8000528a:	40f2                	lw	ra,28(sp)
8000528c:	4462                	lw	s0,24(sp)
8000528e:	44d2                	lw	s1,20(sp)
80005290:	4942                	lw	s2,16(sp)
80005292:	49b2                	lw	s3,12(sp)
80005294:	6105                	addi	sp,sp,32
80005296:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

80005298 <__SEGGER_RTL_pre_padding>:
80005298:	0105f693          	andi	a3,a1,16
8000529c:	e699                	bnez	a3,800052aa <__SEGGER_RTL_pre_padding+0x12>
8000529e:	2005f593          	andi	a1,a1,512
800052a2:	c589                	beqz	a1,800052ac <__SEGGER_RTL_pre_padding+0x14>
800052a4:	03000593          	li	a1,48
800052a8:	bf75                	j	80005264 <__SEGGER_RTL_print_padding>
800052aa:	8082                	ret
800052ac:	02000593          	li	a1,32
800052b0:	bf55                	j	80005264 <__SEGGER_RTL_print_padding>

Disassembly of section .text.libc.vfprintf:

800052b2 <vfprintf>:
800052b2:	1141                	addi	sp,sp,-16
800052b4:	c606                	sw	ra,12(sp)
800052b6:	c422                	sw	s0,8(sp)
800052b8:	c226                	sw	s1,4(sp)
800052ba:	c04a                	sw	s2,0(sp)
800052bc:	8932                	mv	s2,a2
800052be:	84ae                	mv	s1,a1
800052c0:	842a                	mv	s0,a0
800052c2:	116030ef          	jal	800083d8 <__SEGGER_RTL_current_locale>
800052c6:	85aa                	mv	a1,a0
800052c8:	8522                	mv	a0,s0
800052ca:	8626                	mv	a2,s1
800052cc:	86ca                	mv	a3,s2
800052ce:	40b2                	lw	ra,12(sp)
800052d0:	4422                	lw	s0,8(sp)
800052d2:	4492                	lw	s1,4(sp)
800052d4:	4902                	lw	s2,0(sp)
800052d6:	0141                	addi	sp,sp,16
800052d8:	a009                	j	800052da <vfprintf_l>

Disassembly of section .text.libc.vfprintf_l:

800052da <vfprintf_l>:
800052da:	0b4022ef          	jal	t0,8000738e <__riscv_save_10>
800052de:	7179                	addi	sp,sp,-48
800052e0:	1080                	addi	s0,sp,96
800052e2:	8936                	mv	s2,a3
800052e4:	89b2                	mv	s3,a2
800052e6:	8a2e                	mv	s4,a1
800052e8:	8aaa                	mv	s5,a0
800052ea:	090020ef          	jal	8000737a <__SEGGER_RTL_X_file_bufsize>
800052ee:	8baa                	mv	s7,a0
800052f0:	8b0a                	mv	s6,sp
800052f2:	053d                	addi	a0,a0,15
800052f4:	9941                	andi	a0,a0,-16
800052f6:	40a104b3          	sub	s1,sp,a0
800052fa:	8126                	mv	sp,s1
800052fc:	fa840513          	addi	a0,s0,-88
80005300:	02400613          	li	a2,36
80005304:	4581                	li	a1,0
80005306:	7a7020ef          	jal	800082ac <memset>
8000530a:	80000537          	lui	a0,0x80000
8000530e:	800055b7          	lui	a1,0x80005
80005312:	34658593          	addi	a1,a1,838 # 80005346 <__SEGGER_RTL_stream_write>
80005316:	157d                	addi	a0,a0,-1 # 7fffffff <_flash_size+0x7fefffff>
80005318:	faa42623          	sw	a0,-84(s0)
8000531c:	fa942c23          	sw	s1,-72(s0)
80005320:	fd742023          	sw	s7,-64(s0)
80005324:	fd442223          	sw	s4,-60(s0)
80005328:	fcb42423          	sw	a1,-56(s0)
8000532c:	fd542623          	sw	s5,-52(s0)
80005330:	fa840513          	addi	a0,s0,-88
80005334:	85ce                	mv	a1,s3
80005336:	864a                	mv	a2,s2
80005338:	2091                	jal	8000537c <__SEGGER_RTL_vfprintf>
8000533a:	815a                	mv	sp,s6
8000533c:	fa040113          	addi	sp,s0,-96
80005340:	6145                	addi	sp,sp,48
80005342:	07e0206f          	j	800073c0 <__riscv_restore_8>

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

80005346 <__SEGGER_RTL_stream_write>:
80005346:	5154                	lw	a3,36(a0)
80005348:	852e                	mv	a0,a1
8000534a:	4585                	li	a1,1
8000534c:	1420206f          	j	8000748e <fwrite>

Disassembly of section .text.libc.printf:

80005350 <printf>:
80005350:	7179                	addi	sp,sp,-48
80005352:	c606                	sw	ra,12(sp)
80005354:	82aa                	mv	t0,a0
80005356:	d23e                	sw	a5,36(sp)
80005358:	d442                	sw	a6,40(sp)
8000535a:	d646                	sw	a7,44(sp)
8000535c:	00080537          	lui	a0,0x80
80005360:	35452503          	lw	a0,852(a0) # 80354 <stdout>
80005364:	ca2e                	sw	a1,20(sp)
80005366:	cc32                	sw	a2,24(sp)
80005368:	ce36                	sw	a3,28(sp)
8000536a:	d03a                	sw	a4,32(sp)
8000536c:	084c                	addi	a1,sp,20
8000536e:	c42e                	sw	a1,8(sp)
80005370:	0850                	addi	a2,sp,20
80005372:	8596                	mv	a1,t0
80005374:	3f3d                	jal	800052b2 <vfprintf>
80005376:	40b2                	lw	ra,12(sp)
80005378:	6145                	addi	sp,sp,48
8000537a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

8000537c <__SEGGER_RTL_vfprintf>:
8000537c:	00a022ef          	jal	t0,80007386 <__riscv_save_12>
80005380:	711d                	addi	sp,sp,-96
80005382:	8d2e                	mv	s10,a1
80005384:	8a2a                	mv	s4,a0
80005386:	448d                	li	s1,3
80005388:	00052023          	sw	zero,0(a0)
8000538c:	02500c93          	li	s9,37
80005390:	4dc1                	li	s11,16
80005392:	49a9                	li	s3,10
80005394:	66666537          	lui	a0,0x66666
80005398:	7e9675b7          	lui	a1,0x7e967
8000539c:	747d                	lui	s0,0xfffff
8000539e:	555556b7          	lui	a3,0x55555
800053a2:	51eb8737          	lui	a4,0x51eb8
800053a6:	000207b7          	lui	a5,0x20
800053aa:	66750513          	addi	a0,a0,1639 # 66666667 <_flash_size+0x66566667>
800053ae:	cc2a                	sw	a0,24(sp)
800053b0:	69958513          	addi	a0,a1,1689 # 7e967699 <_flash_size+0x7e867699>
800053b4:	c62a                	sw	a0,12(sp)
800053b6:	7ff40513          	addi	a0,s0,2047 # fffff7ff <__AHB_SRAM_segment_end__+0xfbf77ff>
800053ba:	c82a                	sw	a0,16(sp)
800053bc:	55668513          	addi	a0,a3,1366 # 55555556 <_flash_size+0x55455556>
800053c0:	c02a                	sw	a0,0(sp)
800053c2:	51f70513          	addi	a0,a4,1311 # 51eb851f <_flash_size+0x51db851f>
800053c6:	c42a                	sw	a0,8(sp)
800053c8:	02178513          	addi	a0,a5,33 # 20021 <__ILM_segment_end__+0x21>
800053cc:	ce2a                	sw	a0,28(sp)
800053ce:	4505                	li	a0,1
800053d0:	04aa                	slli	s1,s1,0xa
800053d2:	d026                	sw	s1,32(sp)
800053d4:	84b2                	mv	s1,a2
800053d6:	052e                	slli	a0,a0,0xb
800053d8:	c22a                	sw	a0,4(sp)
800053da:	e1818913          	addi	s2,gp,-488 # 800036a8 <.LJTI0_0>
800053de:	000d4583          	lbu	a1,0(s10)
800053e2:	01958863          	beq	a1,s9,800053f2 <__SEGGER_RTL_vfprintf+0x76>
800053e6:	56058de3          	beqz	a1,80006160 <__SEGGER_RTL_vfprintf+0xde4>
800053ea:	0d05                	addi	s10,s10,1
800053ec:	8552                	mv	a0,s4
800053ee:	3b55                	jal	800051a2 <__SEGGER_RTL_putc>
800053f0:	b7fd                	j	800053de <__SEGGER_RTL_vfprintf+0x62>
800053f2:	4b81                	li	s7,0
800053f4:	0d0d                	addi	s10,s10,3
800053f6:	05e00693          	li	a3,94
800053fa:	ffed4503          	lbu	a0,-2(s10)
800053fe:	fe050593          	addi	a1,a0,-32
80005402:	00bdeb63          	bltu	s11,a1,80005418 <__SEGGER_RTL_vfprintf+0x9c>
80005406:	058a                	slli	a1,a1,0x2
80005408:	95ca                	add	a1,a1,s2
8000540a:	4190                	lw	a2,0(a1)
8000540c:	08000593          	li	a1,128
80005410:	8602                	jr	a2
80005412:	04000593          	li	a1,64
80005416:	a831                	j	80005432 <__SEGGER_RTL_vfprintf+0xb6>
80005418:	02d51163          	bne	a0,a3,8000543a <__SEGGER_RTL_vfprintf+0xbe>
8000541c:	6585                	lui	a1,0x1
8000541e:	a811                	j	80005432 <__SEGGER_RTL_vfprintf+0xb6>
80005420:	45c1                	li	a1,16
80005422:	a801                	j	80005432 <__SEGGER_RTL_vfprintf+0xb6>
80005424:	20000593          	li	a1,512
80005428:	a029                	j	80005432 <__SEGGER_RTL_vfprintf+0xb6>
8000542a:	65a1                	lui	a1,0x8
8000542c:	a019                	j	80005432 <__SEGGER_RTL_vfprintf+0xb6>
8000542e:	02000593          	li	a1,32
80005432:	00bbebb3          	or	s7,s7,a1
80005436:	0d05                	addi	s10,s10,1
80005438:	b7c9                	j	800053fa <__SEGGER_RTL_vfprintf+0x7e>
8000543a:	fd050593          	addi	a1,a0,-48
8000543e:	0ff5f593          	zext.b	a1,a1
80005442:	1d7d                	addi	s10,s10,-1
80005444:	4625                	li	a2,9
80005446:	04b66263          	bltu	a2,a1,8000548a <__SEGGER_RTL_vfprintf+0x10e>
8000544a:	4581                	li	a1,0
8000544c:	0ff57613          	zext.b	a2,a0
80005450:	000d4503          	lbu	a0,0(s10)
80005454:	033585b3          	mul	a1,a1,s3
80005458:	95b2                	add	a1,a1,a2
8000545a:	fd058593          	addi	a1,a1,-48 # 7fd0 <__FLASH_segment_used_size__+0x2388>
8000545e:	fd050613          	addi	a2,a0,-48
80005462:	0ff67613          	zext.b	a2,a2
80005466:	0d05                	addi	s10,s10,1
80005468:	ff3662e3          	bltu	a2,s3,8000544c <__SEGGER_RTL_vfprintf+0xd0>
8000546c:	a005                	j	8000548c <__SEGGER_RTL_vfprintf+0x110>
8000546e:	408c                	lw	a1,0(s1)
80005470:	0491                	addi	s1,s1,4
80005472:	fffd4503          	lbu	a0,-1(s10)
80005476:	01b5d693          	srli	a3,a1,0x1b
8000547a:	8ac1                	andi	a3,a3,16
8000547c:	0176ebb3          	or	s7,a3,s7
80005480:	41f5d693          	srai	a3,a1,0x1f
80005484:	8db5                	xor	a1,a1,a3
80005486:	8d95                	sub	a1,a1,a3
80005488:	a011                	j	8000548c <__SEGGER_RTL_vfprintf+0x110>
8000548a:	4581                	li	a1,0
8000548c:	02e00613          	li	a2,46
80005490:	00c51f63          	bne	a0,a2,800054ae <__SEGGER_RTL_vfprintf+0x132>
80005494:	000d4503          	lbu	a0,0(s10)
80005498:	02a00613          	li	a2,42
8000549c:	00c51b63          	bne	a0,a2,800054b2 <__SEGGER_RTL_vfprintf+0x136>
800054a0:	0004ab03          	lw	s6,0(s1)
800054a4:	001d4503          	lbu	a0,1(s10)
800054a8:	0491                	addi	s1,s1,4
800054aa:	0d09                	addi	s10,s10,2
800054ac:	a825                	j	800054e4 <__SEGGER_RTL_vfprintf+0x168>
800054ae:	4b01                	li	s6,0
800054b0:	a099                	j	800054f6 <__SEGGER_RTL_vfprintf+0x17a>
800054b2:	fd050613          	addi	a2,a0,-48
800054b6:	0ff67613          	zext.b	a2,a2
800054ba:	0d05                	addi	s10,s10,1
800054bc:	4b01                	li	s6,0
800054be:	46a5                	li	a3,9
800054c0:	02c6e963          	bltu	a3,a2,800054f2 <__SEGGER_RTL_vfprintf+0x176>
800054c4:	0ff57613          	zext.b	a2,a0
800054c8:	000d4503          	lbu	a0,0(s10)
800054cc:	033b06b3          	mul	a3,s6,s3
800054d0:	9636                	add	a2,a2,a3
800054d2:	fd060b13          	addi	s6,a2,-48
800054d6:	fd050613          	addi	a2,a0,-48
800054da:	0ff67613          	zext.b	a2,a2
800054de:	0d05                	addi	s10,s10,1
800054e0:	ff3662e3          	bltu	a2,s3,800054c4 <__SEGGER_RTL_vfprintf+0x148>
800054e4:	fffb4613          	not	a2,s6
800054e8:	827d                	srli	a2,a2,0x1f
800054ea:	0622                	slli	a2,a2,0x8
800054ec:	00cbebb3          	or	s7,s7,a2
800054f0:	a019                	j	800054f6 <__SEGGER_RTL_vfprintf+0x17a>
800054f2:	100beb93          	ori	s7,s7,256
800054f6:	f9850613          	addi	a2,a0,-104
800054fa:	00761693          	slli	a3,a2,0x7
800054fe:	0662                	slli	a2,a2,0x18
80005500:	8265                	srli	a2,a2,0x19
80005502:	8e55                	or	a2,a2,a3
80005504:	0ff67613          	zext.b	a2,a2
80005508:	46a5                	li	a3,9
8000550a:	04c6ef63          	bltu	a3,a2,80005568 <__SEGGER_RTL_vfprintf+0x1ec>
8000550e:	060a                	slli	a2,a2,0x2
80005510:	e5c18693          	addi	a3,gp,-420 # 800036ec <.LJTI0_1>
80005514:	9636                	add	a2,a2,a3
80005516:	4210                	lw	a2,0(a2)
80005518:	8602                	jr	a2
8000551a:	000d4503          	lbu	a0,0(s10)
8000551e:	0d05                	addi	s10,s10,1
80005520:	a0a1                	j	80005568 <__SEGGER_RTL_vfprintf+0x1ec>
80005522:	000d4503          	lbu	a0,0(s10)
80005526:	06c00613          	li	a2,108
8000552a:	02c51863          	bne	a0,a2,8000555a <__SEGGER_RTL_vfprintf+0x1de>
8000552e:	001d4503          	lbu	a0,1(s10)
80005532:	0d09                	addi	s10,s10,2
80005534:	a005                	j	80005554 <__SEGGER_RTL_vfprintf+0x1d8>
80005536:	000d4503          	lbu	a0,0(s10)
8000553a:	06800613          	li	a2,104
8000553e:	02c51263          	bne	a0,a2,80005562 <__SEGGER_RTL_vfprintf+0x1e6>
80005542:	001d4503          	lbu	a0,1(s10)
80005546:	0d09                	addi	s10,s10,2
80005548:	008beb93          	ori	s7,s7,8
8000554c:	a831                	j	80005568 <__SEGGER_RTL_vfprintf+0x1ec>
8000554e:	000d4503          	lbu	a0,0(s10)
80005552:	0d05                	addi	s10,s10,1
80005554:	002beb93          	ori	s7,s7,2
80005558:	a801                	j	80005568 <__SEGGER_RTL_vfprintf+0x1ec>
8000555a:	0d05                	addi	s10,s10,1
8000555c:	001beb93          	ori	s7,s7,1
80005560:	a021                	j	80005568 <__SEGGER_RTL_vfprintf+0x1ec>
80005562:	0d05                	addi	s10,s10,1
80005564:	004beb93          	ori	s7,s7,4
80005568:	00b02633          	sgtz	a2,a1
8000556c:	40c00633          	neg	a2,a2
80005570:	00b67ab3          	and	s5,a2,a1
80005574:	04600593          	li	a1,70
80005578:	02a5d363          	bge	a1,a0,8000559e <__SEGGER_RTL_vfprintf+0x222>
8000557c:	f9d50593          	addi	a1,a0,-99
80005580:	4655                	li	a2,21
80005582:	04b66663          	bltu	a2,a1,800055ce <__SEGGER_RTL_vfprintf+0x252>
80005586:	058a                	slli	a1,a1,0x2
80005588:	e8418613          	addi	a2,gp,-380 # 80003714 <.LJTI0_2>
8000558c:	95b2                	add	a1,a1,a2
8000558e:	418c                	lw	a1,0(a1)
80005590:	8582                	jr	a1
80005592:	d456                	sw	s5,40(sp)
80005594:	d202                	sw	zero,36(sp)
80005596:	6591                	lui	a1,0x4
80005598:	00bbeab3          	or	s5,s7,a1
8000559c:	a219                	j	800056a2 <__SEGGER_RTL_vfprintf+0x326>
8000559e:	04400593          	li	a1,68
800055a2:	02a5d163          	bge	a1,a0,800055c4 <__SEGGER_RTL_vfprintf+0x248>
800055a6:	04500593          	li	a1,69
800055aa:	04b50663          	beq	a0,a1,800055f6 <__SEGGER_RTL_vfprintf+0x27a>
800055ae:	04600593          	li	a1,70
800055b2:	e2b516e3          	bne	a0,a1,800053de <__SEGGER_RTL_vfprintf+0x62>
800055b6:	6509                	lui	a0,0x2
800055b8:	00abebb3          	or	s7,s7,a0
800055bc:	5502                	lw	a0,32(sp)
800055be:	c0050513          	addi	a0,a0,-1024 # 1c00 <__NOR_CFG_OPTION_segment_size__+0x1000>
800055c2:	a4fd                	j	800058b0 <__SEGGER_RTL_vfprintf+0x534>
800055c4:	5b951f63          	bne	a0,s9,80005b82 <__SEGGER_RTL_vfprintf+0x806>
800055c8:	02500593          	li	a1,37
800055cc:	b505                	j	800053ec <__SEGGER_RTL_vfprintf+0x70>
800055ce:	04700593          	li	a1,71
800055d2:	2cb50b63          	beq	a0,a1,800058a8 <__SEGGER_RTL_vfprintf+0x52c>
800055d6:	05800593          	li	a1,88
800055da:	e0b512e3          	bne	a0,a1,800053de <__SEGGER_RTL_vfprintf+0x62>
800055de:	6589                	lui	a1,0x2
800055e0:	00bbebb3          	or	s7,s7,a1
800055e4:	07800593          	li	a1,120
800055e8:	d456                	sw	s5,40(sp)
800055ea:	08b50e63          	beq	a0,a1,80005686 <__SEGGER_RTL_vfprintf+0x30a>
800055ee:	658d                	lui	a1,0x3
800055f0:	05858593          	addi	a1,a1,88 # 3058 <__BOOT_HEADER_segment_size__+0x1058>
800055f4:	a861                	j	8000568c <__SEGGER_RTL_vfprintf+0x310>
800055f6:	6509                	lui	a0,0x2
800055f8:	00abebb3          	or	s7,s7,a0
800055fc:	400bec93          	ori	s9,s7,1024
80005600:	ac55                	j	800058b4 <__SEGGER_RTL_vfprintf+0x538>
80005602:	100bf593          	andi	a1,s7,256
80005606:	d456                	sw	s5,40(sp)
80005608:	c199                	beqz	a1,8000560e <__SEGGER_RTL_vfprintf+0x292>
8000560a:	dffbfb93          	andi	s7,s7,-513
8000560e:	d202                	sw	zero,36(sp)
80005610:	8ade                	mv	s5,s7
80005612:	a841                	j	800056a2 <__SEGGER_RTL_vfprintf+0x326>
80005614:	d456                	sw	s5,40(sp)
80005616:	4c01                	li	s8,0
80005618:	0004ac83          	lw	s9,0(s1)
8000561c:	0491                	addi	s1,s1,4
8000561e:	018b9593          	slli	a1,s7,0x18
80005622:	85fd                	srai	a1,a1,0x1f
80005624:	0235f413          	andi	s0,a1,35
80005628:	100bea93          	ori	s5,s7,256
8000562c:	4b21                	li	s6,8
8000562e:	ac39                	j	8000584c <__SEGGER_RTL_vfprintf+0x4d0>
80005630:	8b26                	mv	s6,s1
80005632:	0004c483          	lbu	s1,0(s1)
80005636:	0b11                	addi	s6,s6,4
80005638:	1afd                	addi	s5,s5,-1
8000563a:	8552                	mv	a0,s4
8000563c:	85de                	mv	a1,s7
8000563e:	8656                	mv	a2,s5
80005640:	39a1                	jal	80005298 <__SEGGER_RTL_pre_padding>
80005642:	8552                	mv	a0,s4
80005644:	85a6                	mv	a1,s1
80005646:	3eb1                	jal	800051a2 <__SEGGER_RTL_putc>
80005648:	84da                	mv	s1,s6
8000564a:	a641                	j	800059ca <__SEGGER_RTL_vfprintf+0x64e>
8000564c:	4088                	lw	a0,0(s1)
8000564e:	008bf593          	andi	a1,s7,8
80005652:	52059b63          	bnez	a1,80005b88 <__SEGGER_RTL_vfprintf+0x80c>
80005656:	000a2583          	lw	a1,0(s4)
8000565a:	002bf413          	andi	s0,s7,2
8000565e:	58041263          	bnez	s0,80005be2 <__SEGGER_RTL_vfprintf+0x866>
80005662:	c10c                	sw	a1,0(a0)
80005664:	a351                	j	80005be8 <__SEGGER_RTL_vfprintf+0x86c>
80005666:	4088                	lw	a0,0(s1)
80005668:	0491                	addi	s1,s1,4
8000566a:	ae09                	j	8000597c <__SEGGER_RTL_vfprintf+0x600>
8000566c:	d456                	sw	s5,40(sp)
8000566e:	100bf593          	andi	a1,s7,256
80005672:	8ade                	mv	s5,s7
80005674:	c199                	beqz	a1,8000567a <__SEGGER_RTL_vfprintf+0x2fe>
80005676:	dffbfa93          	andi	s5,s7,-513
8000567a:	0be2                	slli	s7,s7,0x18
8000567c:	405bd593          	srai	a1,s7,0x5
80005680:	81f9                	srli	a1,a1,0x1e
80005682:	0592                	slli	a1,a1,0x4
80005684:	a831                	j	800056a0 <__SEGGER_RTL_vfprintf+0x324>
80005686:	658d                	lui	a1,0x3
80005688:	07858593          	addi	a1,a1,120 # 3078 <__BOOT_HEADER_segment_size__+0x1078>
8000568c:	100bf613          	andi	a2,s7,256
80005690:	8ade                	mv	s5,s7
80005692:	c219                	beqz	a2,80005698 <__SEGGER_RTL_vfprintf+0x31c>
80005694:	dffbfa93          	andi	s5,s7,-513
80005698:	0be2                	slli	s7,s7,0x18
8000569a:	41fbd613          	srai	a2,s7,0x1f
8000569e:	8df1                	and	a1,a1,a2
800056a0:	d22e                	sw	a1,36(sp)
800056a2:	002af613          	andi	a2,s5,2
800056a6:	011a9693          	slli	a3,s5,0x11
800056aa:	004af593          	andi	a1,s5,4
800056ae:	0006c663          	bltz	a3,800056ba <__SEGGER_RTL_vfprintf+0x33e>
800056b2:	e20d                	bnez	a2,800056d4 <__SEGGER_RTL_vfprintf+0x358>
800056b4:	00448693          	addi	a3,s1,4
800056b8:	a02d                	j	800056e2 <__SEGGER_RTL_vfprintf+0x366>
800056ba:	e229                	bnez	a2,800056fc <__SEGGER_RTL_vfprintf+0x380>
800056bc:	0004ac83          	lw	s9,0(s1)
800056c0:	00448693          	addi	a3,s1,4
800056c4:	41fcdc13          	srai	s8,s9,0x1f
800056c8:	c5a1                	beqz	a1,80005710 <__SEGGER_RTL_vfprintf+0x394>
800056ca:	010c9593          	slli	a1,s9,0x10
800056ce:	4105dc93          	srai	s9,a1,0x10
800056d2:	a0b1                	j	8000571e <__SEGGER_RTL_vfprintf+0x3a2>
800056d4:	00748613          	addi	a2,s1,7
800056d8:	ff867493          	andi	s1,a2,-8
800056dc:	40d0                	lw	a2,4(s1)
800056de:	00848693          	addi	a3,s1,8
800056e2:	0004ac83          	lw	s9,0(s1)
800056e6:	e9a9                	bnez	a1,80005738 <__SEGGER_RTL_vfprintf+0x3bc>
800056e8:	008af593          	andi	a1,s5,8
800056ec:	c199                	beqz	a1,800056f2 <__SEGGER_RTL_vfprintf+0x376>
800056ee:	0ffcfc93          	zext.b	s9,s9
800056f2:	818d                	srli	a1,a1,0x3
800056f4:	15fd                	addi	a1,a1,-1
800056f6:	00c5fc33          	and	s8,a1,a2
800056fa:	a095                	j	8000575e <__SEGGER_RTL_vfprintf+0x3e2>
800056fc:	00748613          	addi	a2,s1,7
80005700:	9a61                	andi	a2,a2,-8
80005702:	00062c83          	lw	s9,0(a2)
80005706:	00462c03          	lw	s8,4(a2)
8000570a:	00860693          	addi	a3,a2,8
8000570e:	fdd5                	bnez	a1,800056ca <__SEGGER_RTL_vfprintf+0x34e>
80005710:	008af593          	andi	a1,s5,8
80005714:	c599                	beqz	a1,80005722 <__SEGGER_RTL_vfprintf+0x3a6>
80005716:	018c9593          	slli	a1,s9,0x18
8000571a:	4185dc93          	srai	s9,a1,0x18
8000571e:	41f5dc13          	srai	s8,a1,0x1f
80005722:	020c4063          	bltz	s8,80005742 <__SEGGER_RTL_vfprintf+0x3c6>
80005726:	020af593          	andi	a1,s5,32
8000572a:	e59d                	bnez	a1,80005758 <__SEGGER_RTL_vfprintf+0x3dc>
8000572c:	040af593          	andi	a1,s5,64
80005730:	c59d                	beqz	a1,8000575e <__SEGGER_RTL_vfprintf+0x3e2>
80005732:	02000593          	li	a1,32
80005736:	a01d                	j	8000575c <__SEGGER_RTL_vfprintf+0x3e0>
80005738:	4c01                	li	s8,0
8000573a:	0cc2                	slli	s9,s9,0x10
8000573c:	010cdc93          	srli	s9,s9,0x10
80005740:	a839                	j	8000575e <__SEGGER_RTL_vfprintf+0x3e2>
80005742:	019035b3          	snez	a1,s9
80005746:	41900cb3          	neg	s9,s9
8000574a:	41800633          	neg	a2,s8
8000574e:	40b60c33          	sub	s8,a2,a1
80005752:	02d00593          	li	a1,45
80005756:	a019                	j	8000575c <__SEGGER_RTL_vfprintf+0x3e0>
80005758:	02b00593          	li	a1,43
8000575c:	d22e                	sw	a1,36(sp)
8000575e:	100af593          	andi	a1,s5,256
80005762:	c199                	beqz	a1,80005768 <__SEGGER_RTL_vfprintf+0x3ec>
80005764:	dffafa93          	andi	s5,s5,-513
80005768:	100af593          	andi	a1,s5,256
8000576c:	e191                	bnez	a1,80005770 <__SEGGER_RTL_vfprintf+0x3f4>
8000576e:	4b05                	li	s6,1
80005770:	f9c50593          	addi	a1,a0,-100 # 1f9c <__NOR_CFG_OPTION_segment_size__+0x139c>
80005774:	4651                	li	a2,20
80005776:	0cb66563          	bltu	a2,a1,80005840 <__SEGGER_RTL_vfprintf+0x4c4>
8000577a:	4672                	lw	a2,28(sp)
8000577c:	00b65633          	srl	a2,a2,a1
80005780:	8a05                	andi	a2,a2,1
80005782:	ea31                	bnez	a2,800057d6 <__SEGGER_RTL_vfprintf+0x45a>
80005784:	00101637          	lui	a2,0x101
80005788:	00b65633          	srl	a2,a2,a1
8000578c:	8a05                	andi	a2,a2,1
8000578e:	ee4d                	bnez	a2,80005848 <__SEGGER_RTL_vfprintf+0x4cc>
80005790:	462d                	li	a2,11
80005792:	0ac59763          	bne	a1,a2,80005840 <__SEGGER_RTL_vfprintf+0x4c4>
80005796:	8736                	mv	a4,a3
80005798:	4b81                	li	s7,0
8000579a:	018ce533          	or	a0,s9,s8
8000579e:	c915                	beqz	a0,800057d2 <__SEGGER_RTL_vfprintf+0x456>
800057a0:	003cd513          	srli	a0,s9,0x3
800057a4:	01dc1593          	slli	a1,s8,0x1d
800057a8:	8dc9                	or	a1,a1,a0
800057aa:	04610513          	addi	a0,sp,70
800057ae:	007cf613          	andi	a2,s9,7
800057b2:	8cae                	mv	s9,a1
800057b4:	0b85                	addi	s7,s7,1
800057b6:	003c5c13          	srli	s8,s8,0x3
800057ba:	818d                	srli	a1,a1,0x3
800057bc:	03060613          	addi	a2,a2,48 # 101030 <_flash_size+0x1030>
800057c0:	018ce6b3          	or	a3,s9,s8
800057c4:	00c50023          	sb	a2,0(a0)
800057c8:	01dc1613          	slli	a2,s8,0x1d
800057cc:	8dd1                	or	a1,a1,a2
800057ce:	0505                	addi	a0,a0,1
800057d0:	fef9                	bnez	a3,800057ae <__SEGGER_RTL_vfprintf+0x432>
800057d2:	d63a                	sw	a4,44(sp)
800057d4:	acbd                	j	80005a52 <__SEGGER_RTL_vfprintf+0x6d6>
800057d6:	d636                	sw	a3,44(sp)
800057d8:	4b81                	li	s7,0
800057da:	018ce533          	or	a0,s9,s8
800057de:	26050a63          	beqz	a0,80005a52 <__SEGGER_RTL_vfprintf+0x6d6>
800057e2:	6521                	lui	a0,0x8
800057e4:	00aaf4b3          	and	s1,s5,a0
800057e8:	c085                	beqz	s1,80005808 <__SEGGER_RTL_vfprintf+0x48c>
800057ea:	003bf513          	andi	a0,s7,3
800057ee:	458d                	li	a1,3
800057f0:	00b51c63          	bne	a0,a1,80005808 <__SEGGER_RTL_vfprintf+0x48c>
800057f4:	04610413          	addi	s0,sp,70
800057f8:	01740533          	add	a0,s0,s7
800057fc:	02c00593          	li	a1,44
80005800:	00b50023          	sb	a1,0(a0) # 8000 <__AHB_SRAM_segment_size__>
80005804:	0b85                	addi	s7,s7,1
80005806:	a019                	j	8000580c <__SEGGER_RTL_vfprintf+0x490>
80005808:	04610413          	addi	s0,sp,70
8000580c:	4629                	li	a2,10
8000580e:	8566                	mv	a0,s9
80005810:	85e2                	mv	a1,s8
80005812:	4681                	li	a3,0
80005814:	1ac020ef          	jal	800079c0 <__udivdi3>
80005818:	001c3613          	seqz	a2,s8
8000581c:	033506b3          	mul	a3,a0,s3
80005820:	01740733          	add	a4,s0,s7
80005824:	40dc86b3          	sub	a3,s9,a3
80005828:	00acb793          	sltiu	a5,s9,10
8000582c:	8e7d                	and	a2,a2,a5
8000582e:	0306e693          	ori	a3,a3,48
80005832:	00d70023          	sb	a3,0(a4)
80005836:	0b85                	addi	s7,s7,1
80005838:	8caa                	mv	s9,a0
8000583a:	8c2e                	mv	s8,a1
8000583c:	d655                	beqz	a2,800057e8 <__SEGGER_RTL_vfprintf+0x46c>
8000583e:	ac11                	j	80005a52 <__SEGGER_RTL_vfprintf+0x6d6>
80005840:	05800593          	li	a1,88
80005844:	20b51563          	bne	a0,a1,80005a4e <__SEGGER_RTL_vfprintf+0x6d2>
80005848:	84b6                	mv	s1,a3
8000584a:	5412                	lw	s0,36(sp)
8000584c:	018ce533          	or	a0,s9,s8
80005850:	d626                	sw	s1,44(sp)
80005852:	c929                	beqz	a0,800058a4 <__SEGGER_RTL_vfprintf+0x528>
80005854:	012a9593          	slli	a1,s5,0x12
80005858:	80008537          	lui	a0,0x80008
8000585c:	5c550513          	addi	a0,a0,1477 # 800085c5 <__SEGGER_RTL_hex_lc>
80005860:	0005d663          	bgez	a1,8000586c <__SEGGER_RTL_vfprintf+0x4f0>
80005864:	80008537          	lui	a0,0x80008
80005868:	5b550513          	addi	a0,a0,1461 # 800085b5 <__SEGGER_RTL_hex_uc>
8000586c:	4b81                	li	s7,0
8000586e:	004cd593          	srli	a1,s9,0x4
80005872:	01cc1613          	slli	a2,s8,0x1c
80005876:	8e4d                	or	a2,a2,a1
80005878:	04610593          	addi	a1,sp,70
8000587c:	00fcf693          	andi	a3,s9,15
80005880:	8cb2                	mv	s9,a2
80005882:	004c5c13          	srli	s8,s8,0x4
80005886:	8211                	srli	a2,a2,0x4
80005888:	96aa                	add	a3,a3,a0
8000588a:	018ce733          	or	a4,s9,s8
8000588e:	0006c683          	lbu	a3,0(a3)
80005892:	01cc1793          	slli	a5,s8,0x1c
80005896:	8e5d                	or	a2,a2,a5
80005898:	0b85                	addi	s7,s7,1
8000589a:	00d58023          	sb	a3,0(a1)
8000589e:	0585                	addi	a1,a1,1
800058a0:	ff71                	bnez	a4,8000587c <__SEGGER_RTL_vfprintf+0x500>
800058a2:	aa4d                	j	80005a54 <__SEGGER_RTL_vfprintf+0x6d8>
800058a4:	4b81                	li	s7,0
800058a6:	a27d                	j	80005a54 <__SEGGER_RTL_vfprintf+0x6d8>
800058a8:	6509                	lui	a0,0x2
800058aa:	00abebb3          	or	s7,s7,a0
800058ae:	5502                	lw	a0,32(sp)
800058b0:	00abecb3          	or	s9,s7,a0
800058b4:	002cf513          	andi	a0,s9,2
800058b8:	ed01                	bnez	a0,800058d0 <__SEGGER_RTL_vfprintf+0x554>
800058ba:	00748513          	addi	a0,s1,7
800058be:	ff857613          	andi	a2,a0,-8
800058c2:	4208                	lw	a0,0(a2)
800058c4:	424c                	lw	a1,4(a2)
800058c6:	00860493          	addi	s1,a2,8
800058ca:	ef6ff0ef          	jal	80004fc0 <__truncdfsf2>
800058ce:	a831                	j	800058ea <__SEGGER_RTL_vfprintf+0x56e>
800058d0:	4088                	lw	a0,0(s1)
800058d2:	410c                	lw	a1,0(a0)
800058d4:	4150                	lw	a2,4(a0)
800058d6:	4514                	lw	a3,8(a0)
800058d8:	4558                	lw	a4,12(a0)
800058da:	0491                	addi	s1,s1,4
800058dc:	1808                	addi	a0,sp,48
800058de:	d82e                	sw	a1,48(sp)
800058e0:	da32                	sw	a2,52(sp)
800058e2:	dc36                	sw	a3,56(sp)
800058e4:	de3a                	sw	a4,60(sp)
800058e6:	691010ef          	jal	80007776 <__trunctfsf2>
800058ea:	842a                	mv	s0,a0
800058ec:	100cf513          	andi	a0,s9,256
800058f0:	e111                	bnez	a0,800058f4 <__SEGGER_RTL_vfprintf+0x578>
800058f2:	4b19                	li	s6,6
800058f4:	000b1863          	bnez	s6,80005904 <__SEGGER_RTL_vfprintf+0x588>
800058f8:	5582                	lw	a1,32(sp)
800058fa:	00bcf533          	and	a0,s9,a1
800058fe:	8d2d                	xor	a0,a0,a1
80005900:	00153b13          	seqz	s6,a0
80005904:	8522                	mv	a0,s0
80005906:	697010ef          	jal	8000779c <__SEGGER_RTL_float32_isinf>
8000590a:	c505                	beqz	a0,80005932 <__SEGGER_RTL_vfprintf+0x5b6>
8000590c:	8522                	mv	a0,s0
8000590e:	4581                	li	a1,0
80005910:	d5cff0ef          	jal	80004e6c <__ltsf2>
80005914:	6589                	lui	a1,0x2
80005916:	00bcf5b3          	and	a1,s9,a1
8000591a:	02055d63          	bgez	a0,80005954 <__SEGGER_RTL_vfprintf+0x5d8>
8000591e:	80008537          	lui	a0,0x80008
80005922:	53850513          	addi	a0,a0,1336 # 80008538 <.L.str.2>
80005926:	c5b9                	beqz	a1,80005974 <__SEGGER_RTL_vfprintf+0x5f8>
80005928:	80008537          	lui	a0,0x80008
8000592c:	53350513          	addi	a0,a0,1331 # 80008533 <.L.str.1>
80005930:	a091                	j	80005974 <__SEGGER_RTL_vfprintf+0x5f8>
80005932:	8522                	mv	a0,s0
80005934:	65d010ef          	jal	80007790 <__SEGGER_RTL_float32_isnan>
80005938:	c15d                	beqz	a0,800059de <__SEGGER_RTL_vfprintf+0x662>
8000593a:	012c9593          	slli	a1,s9,0x12
8000593e:	80008537          	lui	a0,0x80008
80005942:	5d950513          	addi	a0,a0,1497 # 800085d9 <.L.str.6>
80005946:	0205d763          	bgez	a1,80005974 <__SEGGER_RTL_vfprintf+0x5f8>
8000594a:	80008537          	lui	a0,0x80008
8000594e:	5d550513          	addi	a0,a0,1493 # 800085d5 <.L.str.5>
80005952:	a00d                	j	80005974 <__SEGGER_RTL_vfprintf+0x5f8>
80005954:	c591                	beqz	a1,80005960 <__SEGGER_RTL_vfprintf+0x5e4>
80005956:	800085b7          	lui	a1,0x80008
8000595a:	53d58593          	addi	a1,a1,1341 # 8000853d <.L.str.3>
8000595e:	a029                	j	80005968 <__SEGGER_RTL_vfprintf+0x5ec>
80005960:	800085b7          	lui	a1,0x80008
80005964:	54258593          	addi	a1,a1,1346 # 80008542 <.L.str.4>
80005968:	00158513          	addi	a0,a1,1
8000596c:	020cf613          	andi	a2,s9,32
80005970:	c211                	beqz	a2,80005974 <__SEGGER_RTL_vfprintf+0x5f8>
80005972:	852e                	mv	a0,a1
80005974:	effcfb93          	andi	s7,s9,-257
80005978:	02500c93          	li	s9,37
8000597c:	0f118413          	addi	s0,gp,241 # 80003981 <.L.str>
80005980:	c111                	beqz	a0,80005984 <__SEGGER_RTL_vfprintf+0x608>
80005982:	842a                	mv	s0,a0
80005984:	100bf513          	andi	a0,s7,256
80005988:	e509                	bnez	a0,80005992 <__SEGGER_RTL_vfprintf+0x616>
8000598a:	8522                	mv	a0,s0
8000598c:	189020ef          	jal	80008314 <strlen>
80005990:	a029                	j	8000599a <__SEGGER_RTL_vfprintf+0x61e>
80005992:	8522                	mv	a0,s0
80005994:	85da                	mv	a1,s6
80005996:	f6eff0ef          	jal	80005104 <strnlen>
8000599a:	8b2a                	mv	s6,a0
8000599c:	dffbfb93          	andi	s7,s7,-513
800059a0:	40aa8ab3          	sub	s5,s5,a0
800059a4:	8552                	mv	a0,s4
800059a6:	85de                	mv	a1,s7
800059a8:	8656                	mv	a2,s5
800059aa:	30fd                	jal	80005298 <__SEGGER_RTL_pre_padding>
800059ac:	000b0f63          	beqz	s6,800059ca <__SEGGER_RTL_vfprintf+0x64e>
800059b0:	8c26                	mv	s8,s1
800059b2:	9b22                	add	s6,s6,s0
800059b4:	00044583          	lbu	a1,0(s0)
800059b8:	00140493          	addi	s1,s0,1
800059bc:	8552                	mv	a0,s4
800059be:	fe4ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
800059c2:	8426                	mv	s0,s1
800059c4:	ff6498e3          	bne	s1,s6,800059b4 <__SEGGER_RTL_vfprintf+0x638>
800059c8:	84e2                	mv	s1,s8
800059ca:	010bf413          	andi	s0,s7,16
800059ce:	a00408e3          	beqz	s0,800053de <__SEGGER_RTL_vfprintf+0x62>
800059d2:	02000593          	li	a1,32
800059d6:	8552                	mv	a0,s4
800059d8:	8656                	mv	a2,s5
800059da:	3069                	jal	80005264 <__SEGGER_RTL_print_padding>
800059dc:	b409                	j	800053de <__SEGGER_RTL_vfprintf+0x62>
800059de:	d456                	sw	s5,40(sp)
800059e0:	8522                	mv	a0,s0
800059e2:	5cb010ef          	jal	800077ac <__SEGGER_RTL_float32_isnormal>
800059e6:	00153513          	seqz	a0,a0
800059ea:	157d                	addi	a0,a0,-1
800059ec:	00857bb3          	and	s7,a0,s0
800059f0:	855e                	mv	a0,s7
800059f2:	5d3010ef          	jal	800077c4 <__SEGGER_RTL_float32_signbit>
800059f6:	8aaa                	mv	s5,a0
800059f8:	00a03533          	snez	a0,a0
800059fc:	057e                	slli	a0,a0,0x1f
800059fe:	00abc433          	xor	s0,s7,a0
80005a02:	08ec                	addi	a1,sp,92
80005a04:	8522                	mv	a0,s0
80005a06:	e40ff0ef          	jal	80005046 <frexpf>
80005a0a:	4576                	lw	a0,92(sp)
80005a0c:	00151593          	slli	a1,a0,0x1
80005a10:	952e                	add	a0,a0,a1
80005a12:	45e2                	lw	a1,24(sp)
80005a14:	02b51533          	mulh	a0,a0,a1
80005a18:	01f55c13          	srli	s8,a0,0x1f
80005a1c:	8509                	srai	a0,a0,0x2
80005a1e:	9c2a                	add	s8,s8,a0
80005a20:	cee2                	sw	s8,92(sp)
80005a22:	855e                	mv	a0,s7
80005a24:	4581                	li	a1,0
80005a26:	45d010ef          	jal	80007682 <__eqsf2>
80005a2a:	0e050963          	beqz	a0,80005b1c <__SEGGER_RTL_vfprintf+0x7a0>
80005a2e:	001c0513          	addi	a0,s8,1
80005a32:	14b020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005a36:	85aa                	mv	a1,a0
80005a38:	8522                	mv	a0,s0
80005a3a:	c6cff0ef          	jal	80004ea6 <__gtsf2>
80005a3e:	0ca05263          	blez	a0,80005b02 <__SEGGER_RTL_vfprintf+0x786>
80005a42:	4576                	lw	a0,92(sp)
80005a44:	00150593          	addi	a1,a0,1
80005a48:	ceae                	sw	a1,92(sp)
80005a4a:	0509                	addi	a0,a0,2
80005a4c:	b7dd                	j	80005a32 <__SEGGER_RTL_vfprintf+0x6b6>
80005a4e:	4b81                	li	s7,0
80005a50:	d636                	sw	a3,44(sp)
80005a52:	5412                	lw	s0,36(sp)
80005a54:	417b0533          	sub	a0,s6,s7
80005a58:	10043593          	sltiu	a1,s0,256
80005a5c:	8ca2                	mv	s9,s0
80005a5e:	00143613          	seqz	a2,s0
80005a62:	15f9                	addi	a1,a1,-2
80005a64:	167d                	addi	a2,a2,-1
80005a66:	8df1                	and	a1,a1,a2
80005a68:	00a02633          	sgtz	a2,a0
80005a6c:	40c004b3          	neg	s1,a2
80005a70:	8ce9                	and	s1,s1,a0
80005a72:	009b8533          	add	a0,s7,s1
80005a76:	5422                	lw	s0,40(sp)
80005a78:	8c09                	sub	s0,s0,a0
80005a7a:	200af513          	andi	a0,s5,512
80005a7e:	00b40b33          	add	s6,s0,a1
80005a82:	4c05                	li	s8,1
80005a84:	e511                	bnez	a0,80005a90 <__SEGGER_RTL_vfprintf+0x714>
80005a86:	8552                	mv	a0,s4
80005a88:	85d6                	mv	a1,s5
80005a8a:	865a                	mv	a2,s6
80005a8c:	3031                	jal	80005298 <__SEGGER_RTL_pre_padding>
80005a8e:	4b01                	li	s6,0
80005a90:	04510413          	addi	s0,sp,69
80005a94:	10000513          	li	a0,256
80005a98:	00ace963          	bltu	s9,a0,80005aaa <__SEGGER_RTL_vfprintf+0x72e>
80005a9c:	008cd593          	srli	a1,s9,0x8
80005aa0:	8552                	mv	a0,s4
80005aa2:	f00ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80005aa6:	85e6                	mv	a1,s9
80005aa8:	a021                	j	80005ab0 <__SEGGER_RTL_vfprintf+0x734>
80005aaa:	85e6                	mv	a1,s9
80005aac:	000c8563          	beqz	s9,80005ab6 <__SEGGER_RTL_vfprintf+0x73a>
80005ab0:	8552                	mv	a0,s4
80005ab2:	ef0ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80005ab6:	8552                	mv	a0,s4
80005ab8:	85d6                	mv	a1,s5
80005aba:	865a                	mv	a2,s6
80005abc:	fdcff0ef          	jal	80005298 <__SEGGER_RTL_pre_padding>
80005ac0:	03000593          	li	a1,48
80005ac4:	8552                	mv	a0,s4
80005ac6:	8626                	mv	a2,s1
80005ac8:	f9cff0ef          	jal	80005264 <__SEGGER_RTL_print_padding>
80005acc:	01705d63          	blez	s7,80005ae6 <__SEGGER_RTL_vfprintf+0x76a>
80005ad0:	84de                	mv	s1,s7
80005ad2:	01740533          	add	a0,s0,s7
80005ad6:	00054583          	lbu	a1,0(a0)
80005ada:	1bfd                	addi	s7,s7,-1
80005adc:	8552                	mv	a0,s4
80005ade:	ec4ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80005ae2:	fe9c67e3          	bltu	s8,s1,80005ad0 <__SEGGER_RTL_vfprintf+0x754>
80005ae6:	010af513          	andi	a0,s5,16
80005aea:	54b2                	lw	s1,44(sp)
80005aec:	02500c93          	li	s9,37
80005af0:	8e0507e3          	beqz	a0,800053de <__SEGGER_RTL_vfprintf+0x62>
80005af4:	02000593          	li	a1,32
80005af8:	8552                	mv	a0,s4
80005afa:	865a                	mv	a2,s6
80005afc:	f68ff0ef          	jal	80005264 <__SEGGER_RTL_print_padding>
80005b00:	b8f9                	j	800053de <__SEGGER_RTL_vfprintf+0x62>
80005b02:	4576                	lw	a0,92(sp)
80005b04:	079020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005b08:	85aa                	mv	a1,a0
80005b0a:	8522                	mv	a0,s0
80005b0c:	b60ff0ef          	jal	80004e6c <__ltsf2>
80005b10:	00055663          	bgez	a0,80005b1c <__SEGGER_RTL_vfprintf+0x7a0>
80005b14:	4576                	lw	a0,92(sp)
80005b16:	157d                	addi	a0,a0,-1
80005b18:	ceaa                	sw	a0,92(sp)
80005b1a:	b7ed                	j	80005b04 <__SEGGER_RTL_vfprintf+0x788>
80005b1c:	001ab513          	seqz	a0,s5
80005b20:	157d                	addi	a0,a0,-1
80005b22:	06057593          	andi	a1,a0,96
80005b26:	4576                	lw	a0,92(sp)
80005b28:	00bcec33          	or	s8,s9,a1
80005b2c:	5582                	lw	a1,32(sp)
80005b2e:	00bc7ab3          	and	s5,s8,a1
80005b32:	40000593          	li	a1,1024
80005b36:	d626                	sw	s1,44(sp)
80005b38:	02ba8a63          	beq	s5,a1,80005b6c <__SEGGER_RTL_vfprintf+0x7f0>
80005b3c:	5582                	lw	a1,32(sp)
80005b3e:	00ba9763          	bne	s5,a1,80005b4c <__SEGGER_RTL_vfprintf+0x7d0>
80005b42:	03655563          	bge	a0,s6,80005b6c <__SEGGER_RTL_vfprintf+0x7f0>
80005b46:	55ed                	li	a1,-5
80005b48:	02a5d263          	bge	a1,a0,80005b6c <__SEGGER_RTL_vfprintf+0x7f0>
80005b4c:	400c7593          	andi	a1,s8,1024
80005b50:	080c7693          	andi	a3,s8,128
80005b54:	ca36                	sw	a3,20(sp)
80005b56:	80003ab7          	lui	s5,0x80003
80005b5a:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
80005b5e:	0c058b63          	beqz	a1,80005c34 <__SEGGER_RTL_vfprintf+0x8b8>
80005b62:	45b9                	li	a1,14
80005b64:	08a5d563          	bge	a1,a0,80005bee <__SEGGER_RTL_vfprintf+0x872>
80005b68:	4b01                	li	s6,0
80005b6a:	a0e9                	j	80005c34 <__SEGGER_RTL_vfprintf+0x8b8>
80005b6c:	02500c93          	li	s9,37
80005b70:	02600593          	li	a1,38
80005b74:	00b51f63          	bne	a0,a1,80005b92 <__SEGGER_RTL_vfprintf+0x816>
80005b78:	8522                	mv	a0,s0
80005b7a:	45b2                	lw	a1,12(sp)
80005b7c:	207010ef          	jal	80007582 <__divsf3>
80005b80:	a00d                	j	80005ba2 <__SEGGER_RTL_vfprintf+0x826>
80005b82:	84051ee3          	bnez	a0,800053de <__SEGGER_RTL_vfprintf+0x62>
80005b86:	a509                	j	80006188 <__SEGGER_RTL_vfprintf+0xe0c>
80005b88:	000a2583          	lw	a1,0(s4)
80005b8c:	00b50023          	sb	a1,0(a0)
80005b90:	a8a1                	j	80005be8 <__SEGGER_RTL_vfprintf+0x86c>
80005b92:	40a00533          	neg	a0,a0
80005b96:	7e6020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005b9a:	85aa                	mv	a1,a0
80005b9c:	8522                	mv	a0,s0
80005b9e:	135010ef          	jal	800074d2 <__mulsf3>
80005ba2:	842a                	mv	s0,a0
80005ba4:	4581                	li	a1,0
80005ba6:	2dd010ef          	jal	80007682 <__eqsf2>
80005baa:	1a050c63          	beqz	a0,80005d62 <__SEGGER_RTL_vfprintf+0x9e6>
80005bae:	8522                	mv	a0,s0
80005bb0:	3ed010ef          	jal	8000779c <__SEGGER_RTL_float32_isinf>
80005bb4:	14050c63          	beqz	a0,80005d0c <__SEGGER_RTL_vfprintf+0x990>
80005bb8:	8522                	mv	a0,s0
80005bba:	4581                	li	a1,0
80005bbc:	ab0ff0ef          	jal	80004e6c <__ltsf2>
80005bc0:	6589                	lui	a1,0x2
80005bc2:	00bc75b3          	and	a1,s8,a1
80005bc6:	54055d63          	bgez	a0,80006120 <__SEGGER_RTL_vfprintf+0xda4>
80005bca:	80008537          	lui	a0,0x80008
80005bce:	53850513          	addi	a0,a0,1336 # 80008538 <.L.str.2>
80005bd2:	5aa2                	lw	s5,40(sp)
80005bd4:	56058763          	beqz	a1,80006142 <__SEGGER_RTL_vfprintf+0xdc6>
80005bd8:	80008537          	lui	a0,0x80008
80005bdc:	53350513          	addi	a0,a0,1331 # 80008533 <.L.str.1>
80005be0:	a38d                	j	80006142 <__SEGGER_RTL_vfprintf+0xdc6>
80005be2:	c10c                	sw	a1,0(a0)
80005be4:	00052223          	sw	zero,4(a0)
80005be8:	0491                	addi	s1,s1,4
80005bea:	ff4ff06f          	j	800053de <__SEGGER_RTL_vfprintf+0x62>
80005bee:	fff54593          	not	a1,a0
80005bf2:	95da                	add	a1,a1,s6
80005bf4:	4641                	li	a2,16
80005bf6:	8b2e                	mv	s6,a1
80005bf8:	00c5c363          	blt	a1,a2,80005bfe <__SEGGER_RTL_vfprintf+0x882>
80005bfc:	4b41                	li	s6,16
80005bfe:	ea9d                	bnez	a3,80005c34 <__SEGGER_RTL_vfprintf+0x8b8>
80005c00:	c995                	beqz	a1,80005c34 <__SEGGER_RTL_vfprintf+0x8b8>
80005c02:	855a                	mv	a0,s6
80005c04:	778020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005c08:	85aa                	mv	a1,a0
80005c0a:	8522                	mv	a0,s0
80005c0c:	0c7010ef          	jal	800074d2 <__mulsf3>
80005c10:	3f0005b7          	lui	a1,0x3f000
80005c14:	8aaff0ef          	jal	80004cbe <__addsf3>
80005c18:	541010ef          	jal	80007958 <floorf>
80005c1c:	412005b7          	lui	a1,0x41200
80005c20:	3ed010ef          	jal	8000780c <fmodf>
80005c24:	4581                	li	a1,0
80005c26:	25d010ef          	jal	80007682 <__eqsf2>
80005c2a:	e501                	bnez	a0,80005c32 <__SEGGER_RTL_vfprintf+0x8b6>
80005c2c:	1b7d                	addi	s6,s6,-1
80005c2e:	fc0b1ae3          	bnez	s6,80005c02 <__SEGGER_RTL_vfprintf+0x886>
80005c32:	4576                	lw	a0,92(sp)
80005c34:	416005b3          	neg	a1,s6
80005c38:	1541                	addi	a0,a0,-16
80005c3a:	00a5c363          	blt	a1,a0,80005c40 <__SEGGER_RTL_vfprintf+0x8c4>
80005c3e:	852e                	mv	a0,a1
80005c40:	73c020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005c44:	55fd                	li	a1,-1
80005c46:	383010ef          	jal	800077c8 <ldexpf>
80005c4a:	85aa                	mv	a1,a0
80005c4c:	8522                	mv	a0,s0
80005c4e:	870ff0ef          	jal	80004cbe <__addsf3>
80005c52:	8baa                	mv	s7,a0
80005c54:	4576                	lw	a0,92(sp)
80005c56:	0505                	addi	a0,a0,1
80005c58:	724020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005c5c:	85aa                	mv	a1,a0
80005c5e:	855e                	mv	a0,s7
80005c60:	a78ff0ef          	jal	80004ed8 <__gesf2>
80005c64:	45f6                	lw	a1,92(sp)
80005c66:	00052513          	slti	a0,a0,0
80005c6a:	00154513          	xori	a0,a0,1
80005c6e:	952e                	add	a0,a0,a1
80005c70:	02054663          	bltz	a0,80005c9c <__SEGGER_RTL_vfprintf+0x920>
80005c74:	45c5                	li	a1,17
80005c76:	02b56863          	bltu	a0,a1,80005ca6 <__SEGGER_RTL_vfprintf+0x92a>
80005c7a:	ff050593          	addi	a1,a0,-16
80005c7e:	ceae                	sw	a1,92(sp)
80005c80:	40ad8533          	sub	a0,s11,a0
80005c84:	6f8020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005c88:	85aa                	mv	a1,a0
80005c8a:	855e                	mv	a0,s7
80005c8c:	047010ef          	jal	800074d2 <__mulsf3>
80005c90:	21f010ef          	jal	800076ae <__fixunssfdi>
80005c94:	842a                	mv	s0,a0
80005c96:	84ae                	mv	s1,a1
80005c98:	d202                	sw	zero,36(sp)
80005c9a:	a01d                	j	80005cc0 <__SEGGER_RTL_vfprintf+0x944>
80005c9c:	d25e                	sw	s7,36(sp)
80005c9e:	4401                	li	s0,0
80005ca0:	4481                	li	s1,0
80005ca2:	ce82                	sw	zero,92(sp)
80005ca4:	a831                	j	80005cc0 <__SEGGER_RTL_vfprintf+0x944>
80005ca6:	ce82                	sw	zero,92(sp)
80005ca8:	855e                	mv	a0,s7
80005caa:	205010ef          	jal	800076ae <__fixunssfdi>
80005cae:	842a                	mv	s0,a0
80005cb0:	84ae                	mv	s1,a1
80005cb2:	a64ff0ef          	jal	80004f16 <__floatundisf>
80005cb6:	85aa                	mv	a1,a0
80005cb8:	855e                	mv	a0,s7
80005cba:	ffdfe0ef          	jal	80004cb6 <__subsf3>
80005cbe:	d22a                	sw	a0,36(sp)
80005cc0:	4c81                	li	s9,0
80005cc2:	bffc7b93          	andi	s7,s8,-1025
80005cc6:	5522                	lw	a0,40(sp)
80005cc8:	40ab0533          	sub	a0,s6,a0
80005ccc:	008a8593          	addi	a1,s5,8
80005cd0:	46d2                	lw	a3,20(sp)
80005cd2:	41d0                	lw	a2,4(a1)
80005cd4:	00c48563          	beq	s1,a2,80005cde <__SEGGER_RTL_vfprintf+0x962>
80005cd8:	00c4b633          	sltu	a2,s1,a2
80005cdc:	a021                	j	80005ce4 <__SEGGER_RTL_vfprintf+0x968>
80005cde:	4190                	lw	a2,0(a1)
80005ce0:	00c43633          	sltu	a2,s0,a2
80005ce4:	0505                	addi	a0,a0,1
80005ce6:	0c85                	addi	s9,s9,1
80005ce8:	05a1                	addi	a1,a1,8 # 41200008 <_flash_size+0x41100008>
80005cea:	d665                	beqz	a2,80005cd2 <__SEGGER_RTL_vfprintf+0x956>
80005cec:	45f6                	lw	a1,92(sp)
80005cee:	00db6633          	or	a2,s6,a3
80005cf2:	060c7693          	andi	a3,s8,96
80005cf6:	00163613          	seqz	a2,a2
80005cfa:	00d036b3          	snez	a3,a3
80005cfe:	fff6c693          	not	a3,a3
80005d02:	9636                	add	a2,a2,a3
80005d04:	8e0d                	sub	a2,a2,a1
80005d06:	40a60ab3          	sub	s5,a2,a0
80005d0a:	a2e9                	j	80005ed4 <__SEGGER_RTL_vfprintf+0xb58>
80005d0c:	44f6                	lw	s1,92(sp)
80005d0e:	412005b7          	lui	a1,0x41200
80005d12:	8522                	mv	a0,s0
80005d14:	9c4ff0ef          	jal	80004ed8 <__gesf2>
80005d18:	02054063          	bltz	a0,80005d38 <__SEGGER_RTL_vfprintf+0x9bc>
80005d1c:	412005b7          	lui	a1,0x41200
80005d20:	8522                	mv	a0,s0
80005d22:	061010ef          	jal	80007582 <__divsf3>
80005d26:	842a                	mv	s0,a0
80005d28:	0485                	addi	s1,s1,1
80005d2a:	412005b7          	lui	a1,0x41200
80005d2e:	9aaff0ef          	jal	80004ed8 <__gesf2>
80005d32:	fe0555e3          	bgez	a0,80005d1c <__SEGGER_RTL_vfprintf+0x9a0>
80005d36:	cea6                	sw	s1,92(sp)
80005d38:	3f8005b7          	lui	a1,0x3f800
80005d3c:	8522                	mv	a0,s0
80005d3e:	92eff0ef          	jal	80004e6c <__ltsf2>
80005d42:	02055063          	bgez	a0,80005d62 <__SEGGER_RTL_vfprintf+0x9e6>
80005d46:	412005b7          	lui	a1,0x41200
80005d4a:	8522                	mv	a0,s0
80005d4c:	786010ef          	jal	800074d2 <__mulsf3>
80005d50:	842a                	mv	s0,a0
80005d52:	14fd                	addi	s1,s1,-1
80005d54:	3f8005b7          	lui	a1,0x3f800
80005d58:	914ff0ef          	jal	80004e6c <__ltsf2>
80005d5c:	fe0545e3          	bltz	a0,80005d46 <__SEGGER_RTL_vfprintf+0x9ca>
80005d60:	cea6                	sw	s1,92(sp)
80005d62:	001b3513          	seqz	a0,s6
80005d66:	5582                	lw	a1,32(sp)
80005d68:	00bac5b3          	xor	a1,s5,a1
80005d6c:	0015b593          	seqz	a1,a1
80005d70:	40bb0b33          	sub	s6,s6,a1
80005d74:	157d                	addi	a0,a0,-1
80005d76:	01657bb3          	and	s7,a0,s6
80005d7a:	41700533          	neg	a0,s7
80005d7e:	5fe020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005d82:	55fd                	li	a1,-1
80005d84:	245010ef          	jal	800077c8 <ldexpf>
80005d88:	85aa                	mv	a1,a0
80005d8a:	8522                	mv	a0,s0
80005d8c:	f33fe0ef          	jal	80004cbe <__addsf3>
80005d90:	8caa                	mv	s9,a0
80005d92:	412005b7          	lui	a1,0x41200
80005d96:	942ff0ef          	jal	80004ed8 <__gesf2>
80005d9a:	00054b63          	bltz	a0,80005db0 <__SEGGER_RTL_vfprintf+0xa34>
80005d9e:	4576                	lw	a0,92(sp)
80005da0:	0505                	addi	a0,a0,1
80005da2:	ceaa                	sw	a0,92(sp)
80005da4:	412005b7          	lui	a1,0x41200
80005da8:	8566                	mv	a0,s9
80005daa:	7d8010ef          	jal	80007582 <__divsf3>
80005dae:	8caa                	mv	s9,a0
80005db0:	5aa2                	lw	s5,40(sp)
80005db2:	060b8563          	beqz	s7,80005e1c <__SEGGER_RTL_vfprintf+0xaa0>
80005db6:	5502                	lw	a0,32(sp)
80005db8:	c8050513          	addi	a0,a0,-896
80005dbc:	00ac7533          	and	a0,s8,a0
80005dc0:	4592                	lw	a1,4(sp)
80005dc2:	04b51e63          	bne	a0,a1,80005e1e <__SEGGER_RTL_vfprintf+0xaa2>
80005dc6:	4541                	li	a0,16
80005dc8:	00abc363          	blt	s7,a0,80005dce <__SEGGER_RTL_vfprintf+0xa52>
80005dcc:	4bc1                	li	s7,16
80005dce:	855e                	mv	a0,s7
80005dd0:	5ac020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005dd4:	85aa                	mv	a1,a0
80005dd6:	8566                	mv	a0,s9
80005dd8:	6fa010ef          	jal	800074d2 <__mulsf3>
80005ddc:	0d3010ef          	jal	800076ae <__fixunssfdi>
80005de0:	842a                	mv	s0,a0
80005de2:	8d4d                	or	a0,a0,a1
80005de4:	cd05                	beqz	a0,80005e1c <__SEGGER_RTL_vfprintf+0xaa0>
80005de6:	84ae                	mv	s1,a1
80005de8:	4629                	li	a2,10
80005dea:	8522                	mv	a0,s0
80005dec:	85a6                	mv	a1,s1
80005dee:	4681                	li	a3,0
80005df0:	3d1010ef          	jal	800079c0 <__udivdi3>
80005df4:	03358633          	mul	a2,a1,s3
80005df8:	033536b3          	mulhu	a3,a0,s3
80005dfc:	9636                	add	a2,a2,a3
80005dfe:	033506b3          	mul	a3,a0,s3
80005e02:	8c91                	sub	s1,s1,a2
80005e04:	00d43633          	sltu	a2,s0,a3
80005e08:	8c91                	sub	s1,s1,a2
80005e0a:	8c15                	sub	s0,s0,a3
80005e0c:	8c45                	or	s0,s0,s1
80005e0e:	32041e63          	bnez	s0,8000614a <__SEGGER_RTL_vfprintf+0xdce>
80005e12:	1bfd                	addi	s7,s7,-1
80005e14:	842a                	mv	s0,a0
80005e16:	84ae                	mv	s1,a1
80005e18:	fc0b98e3          	bnez	s7,80005de8 <__SEGGER_RTL_vfprintf+0xa6c>
80005e1c:	4b01                	li	s6,0
80005e1e:	d266                	sw	s9,36(sp)
80005e20:	080c7513          	andi	a0,s8,128
80005e24:	416a85b3          	sub	a1,s5,s6
80005e28:	4476                	lw	s0,92(sp)
80005e2a:	00ab6533          	or	a0,s6,a0
80005e2e:	00a03533          	snez	a0,a0
80005e32:	8d89                	sub	a1,a1,a0
80005e34:	013c1513          	slli	a0,s8,0x13
80005e38:	ffb58a93          	addi	s5,a1,-5 # 411ffffb <_flash_size+0x410ffffb>
80005e3c:	00054463          	bltz	a0,80005e44 <__SEGGER_RTL_vfprintf+0xac8>
80005e40:	4c85                	li	s9,1
80005e42:	a891                	j	80005e96 <__SEGGER_RTL_vfprintf+0xb1a>
80005e44:	4502                	lw	a0,0(sp)
80005e46:	02a41533          	mulh	a0,s0,a0
80005e4a:	01f55593          	srli	a1,a0,0x1f
80005e4e:	952e                	add	a0,a0,a1
80005e50:	00151593          	slli	a1,a0,0x1
80005e54:	40a40533          	sub	a0,s0,a0
80005e58:	8d0d                	sub	a0,a0,a1
80005e5a:	0509                	addi	a0,a0,2
80005e5c:	050a                	slli	a0,a0,0x2
80005e5e:	edc18593          	addi	a1,gp,-292 # 8000376c <.LJTI0_3>
80005e62:	952e                	add	a0,a0,a1
80005e64:	4108                	lw	a0,0(a0)
80005e66:	4b89                	li	s7,2
80005e68:	54fd                	li	s1,-1
80005e6a:	412005b7          	lui	a1,0x41200
80005e6e:	4c85                	li	s9,1
80005e70:	8502                	jr	a0
80005e72:	4b8d                	li	s7,3
80005e74:	54f9                	li	s1,-2
80005e76:	42c805b7          	lui	a1,0x42c80
80005e7a:	5512                	lw	a0,36(sp)
80005e7c:	656010ef          	jal	800074d2 <__mulsf3>
80005e80:	d22a                	sw	a0,36(sp)
80005e82:	9426                	add	s0,s0,s1
80005e84:	cea2                	sw	s0,92(sp)
80005e86:	9aa6                	add	s5,s5,s1
80005e88:	8cde                	mv	s9,s7
80005e8a:	01602533          	sgtz	a0,s6
80005e8e:	40a00533          	neg	a0,a0
80005e92:	01657b33          	and	s6,a0,s6
80005e96:	4542                	lw	a0,16(sp)
80005e98:	00ac7bb3          	and	s7,s8,a0
80005e9c:	060c7513          	andi	a0,s8,96
80005ea0:	00a03533          	snez	a0,a0
80005ea4:	40aa84b3          	sub	s1,s5,a0
80005ea8:	8522                	mv	a0,s0
80005eaa:	9caff0ef          	jal	80005074 <abs>
80005eae:	06452513          	slti	a0,a0,100
80005eb2:	00154513          	xori	a0,a0,1
80005eb6:	40a48ab3          	sub	s5,s1,a0
80005eba:	5c12                	lw	s8,36(sp)
80005ebc:	8562                	mv	a0,s8
80005ebe:	7f0010ef          	jal	800076ae <__fixunssfdi>
80005ec2:	842a                	mv	s0,a0
80005ec4:	84ae                	mv	s1,a1
80005ec6:	850ff0ef          	jal	80004f16 <__floatundisf>
80005eca:	85aa                	mv	a1,a0
80005ecc:	8562                	mv	a0,s8
80005ece:	de9fe0ef          	jal	80004cb6 <__subsf3>
80005ed2:	d22a                	sw	a0,36(sp)
80005ed4:	01502533          	sgtz	a0,s5
80005ed8:	40a00533          	neg	a0,a0
80005edc:	210bf593          	andi	a1,s7,528
80005ee0:	01557c33          	and	s8,a0,s5
80005ee4:	e999                	bnez	a1,80005efa <__SEGGER_RTL_vfprintf+0xb7e>
80005ee6:	01505a63          	blez	s5,80005efa <__SEGGER_RTL_vfprintf+0xb7e>
80005eea:	1c7d                	addi	s8,s8,-1
80005eec:	02000593          	li	a1,32
80005ef0:	8552                	mv	a0,s4
80005ef2:	ab0ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80005ef6:	fe0c1ae3          	bnez	s8,80005eea <__SEGGER_RTL_vfprintf+0xb6e>
80005efa:	80003ab7          	lui	s5,0x80003
80005efe:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
80005f02:	020bf593          	andi	a1,s7,32
80005f06:	040bf513          	andi	a0,s7,64
80005f0a:	e589                	bnez	a1,80005f14 <__SEGGER_RTL_vfprintf+0xb98>
80005f0c:	cd09                	beqz	a0,80005f26 <__SEGGER_RTL_vfprintf+0xbaa>
80005f0e:	02000593          	li	a1,32
80005f12:	a039                	j	80005f20 <__SEGGER_RTL_vfprintf+0xba4>
80005f14:	c501                	beqz	a0,80005f1c <__SEGGER_RTL_vfprintf+0xba0>
80005f16:	02d00593          	li	a1,45
80005f1a:	a019                	j	80005f20 <__SEGGER_RTL_vfprintf+0xba4>
80005f1c:	02b00593          	li	a1,43
80005f20:	8552                	mv	a0,s4
80005f22:	a80ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80005f26:	010bf513          	andi	a0,s7,16
80005f2a:	e919                	bnez	a0,80005f40 <__SEGGER_RTL_vfprintf+0xbc4>
80005f2c:	000c0a63          	beqz	s8,80005f40 <__SEGGER_RTL_vfprintf+0xbc4>
80005f30:	1c7d                	addi	s8,s8,-1
80005f32:	03000593          	li	a1,48
80005f36:	8552                	mv	a0,s4
80005f38:	a6aff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80005f3c:	fe0c1ae3          	bnez	s8,80005f30 <__SEGGER_RTL_vfprintf+0xbb4>
80005f40:	1cfd                	addi	s9,s9,-1
80005f42:	003c9513          	slli	a0,s9,0x3
80005f46:	00aa85b3          	add	a1,s5,a0
80005f4a:	41c8                	lw	a0,4(a1)
80005f4c:	418c                	lw	a1,0(a1)
80005f4e:	02a48863          	beq	s1,a0,80005f7e <__SEGGER_RTL_vfprintf+0xc02>
80005f52:	00a4b633          	sltu	a2,s1,a0
80005f56:	e61d                	bnez	a2,80005f84 <__SEGGER_RTL_vfprintf+0xc08>
80005f58:	03000613          	li	a2,48
80005f5c:	00b436b3          	sltu	a3,s0,a1
80005f60:	8c89                	sub	s1,s1,a0
80005f62:	8c95                	sub	s1,s1,a3
80005f64:	8c0d                	sub	s0,s0,a1
80005f66:	00a48563          	beq	s1,a0,80005f70 <__SEGGER_RTL_vfprintf+0xbf4>
80005f6a:	00a4b6b3          	sltu	a3,s1,a0
80005f6e:	a019                	j	80005f74 <__SEGGER_RTL_vfprintf+0xbf8>
80005f70:	00b436b3          	sltu	a3,s0,a1
80005f74:	0605                	addi	a2,a2,1
80005f76:	d2fd                	beqz	a3,80005f5c <__SEGGER_RTL_vfprintf+0xbe0>
80005f78:	0ff67593          	zext.b	a1,a2
80005f7c:	a031                	j	80005f88 <__SEGGER_RTL_vfprintf+0xc0c>
80005f7e:	00b43633          	sltu	a2,s0,a1
80005f82:	da79                	beqz	a2,80005f58 <__SEGGER_RTL_vfprintf+0xbdc>
80005f84:	03000593          	li	a1,48
80005f88:	8552                	mv	a0,s4
80005f8a:	a18ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80005f8e:	fa0c99e3          	bnez	s9,80005f40 <__SEGGER_RTL_vfprintf+0xbc4>
80005f92:	5502                	lw	a0,32(sp)
80005f94:	c0050513          	addi	a0,a0,-1024
80005f98:	00abf433          	and	s0,s7,a0
80005f9c:	cc01                	beqz	s0,80005fb4 <__SEGGER_RTL_vfprintf+0xc38>
80005f9e:	4576                	lw	a0,92(sp)
80005fa0:	00a05a63          	blez	a0,80005fb4 <__SEGGER_RTL_vfprintf+0xc38>
80005fa4:	157d                	addi	a0,a0,-1
80005fa6:	ceaa                	sw	a0,92(sp)
80005fa8:	03000593          	li	a1,48
80005fac:	8552                	mv	a0,s4
80005fae:	9f4ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80005fb2:	b7f5                	j	80005f9e <__SEGGER_RTL_vfprintf+0xc22>
80005fb4:	080bf513          	andi	a0,s7,128
80005fb8:	00ab6533          	or	a0,s6,a0
80005fbc:	54b2                	lw	s1,44(sp)
80005fbe:	cd55                	beqz	a0,8000607a <__SEGGER_RTL_vfprintf+0xcfe>
80005fc0:	02e00593          	li	a1,46
80005fc4:	8552                	mv	a0,s4
80005fc6:	9dcff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80005fca:	45c1                	li	a1,16
80005fcc:	855a                	mv	a0,s6
80005fce:	00bb4363          	blt	s6,a1,80005fd4 <__SEGGER_RTL_vfprintf+0xc58>
80005fd2:	4541                	li	a0,16
80005fd4:	00a025b3          	sgtz	a1,a0
80005fd8:	4676                	lw	a2,92(sp)
80005fda:	40b005b3          	neg	a1,a1
80005fde:	00a5fcb3          	and	s9,a1,a0
80005fe2:	00143513          	seqz	a0,s0
80005fe6:	157d                	addi	a0,a0,-1
80005fe8:	8d71                	and	a0,a0,a2
80005fea:	40ac8533          	sub	a0,s9,a0
80005fee:	38e020ef          	jal	8000837c <__SEGGER_RTL_pow10f>
80005ff2:	07605763          	blez	s6,80006060 <__SEGGER_RTL_vfprintf+0xce4>
80005ff6:	85aa                	mv	a1,a0
80005ff8:	5512                	lw	a0,36(sp)
80005ffa:	4d8010ef          	jal	800074d2 <__mulsf3>
80005ffe:	6b0010ef          	jal	800076ae <__fixunssfdi>
80006002:	842a                	mv	s0,a0
80006004:	84ae                	mv	s1,a1
80006006:	8ae6                	mv	s5,s9
80006008:	1afd                	addi	s5,s5,-1
8000600a:	003a9513          	slli	a0,s5,0x3
8000600e:	800035b7          	lui	a1,0x80003
80006012:	06858593          	addi	a1,a1,104 # 80003068 <__SEGGER_RTL_ipow10>
80006016:	95aa                	add	a1,a1,a0
80006018:	41c8                	lw	a0,4(a1)
8000601a:	418c                	lw	a1,0(a1)
8000601c:	02a48863          	beq	s1,a0,8000604c <__SEGGER_RTL_vfprintf+0xcd0>
80006020:	00a4b633          	sltu	a2,s1,a0
80006024:	e61d                	bnez	a2,80006052 <__SEGGER_RTL_vfprintf+0xcd6>
80006026:	03000613          	li	a2,48
8000602a:	00b436b3          	sltu	a3,s0,a1
8000602e:	8c89                	sub	s1,s1,a0
80006030:	8c95                	sub	s1,s1,a3
80006032:	8c0d                	sub	s0,s0,a1
80006034:	00a48563          	beq	s1,a0,8000603e <__SEGGER_RTL_vfprintf+0xcc2>
80006038:	00a4b6b3          	sltu	a3,s1,a0
8000603c:	a019                	j	80006042 <__SEGGER_RTL_vfprintf+0xcc6>
8000603e:	00b436b3          	sltu	a3,s0,a1
80006042:	0605                	addi	a2,a2,1
80006044:	d2fd                	beqz	a3,8000602a <__SEGGER_RTL_vfprintf+0xcae>
80006046:	0ff67593          	zext.b	a1,a2
8000604a:	a031                	j	80006056 <__SEGGER_RTL_vfprintf+0xcda>
8000604c:	00b43633          	sltu	a2,s0,a1
80006050:	da79                	beqz	a2,80006026 <__SEGGER_RTL_vfprintf+0xcaa>
80006052:	03000593          	li	a1,48
80006056:	8552                	mv	a0,s4
80006058:	94aff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
8000605c:	fa0a96e3          	bnez	s5,80006008 <__SEGGER_RTL_vfprintf+0xc8c>
80006060:	419b0533          	sub	a0,s6,s9
80006064:	54b2                	lw	s1,44(sp)
80006066:	c911                	beqz	a0,8000607a <__SEGGER_RTL_vfprintf+0xcfe>
80006068:	416c8433          	sub	s0,s9,s6
8000606c:	03000593          	li	a1,48
80006070:	8552                	mv	a0,s4
80006072:	930ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80006076:	0405                	addi	s0,s0,1
80006078:	f875                	bnez	s0,8000606c <__SEGGER_RTL_vfprintf+0xcf0>
8000607a:	400bf513          	andi	a0,s7,1024
8000607e:	02500c93          	li	s9,37
80006082:	c969                	beqz	a0,80006154 <__SEGGER_RTL_vfprintf+0xdd8>
80006084:	0bca                	slli	s7,s7,0x12
80006086:	41fbd513          	srai	a0,s7,0x1f
8000608a:	9901                	andi	a0,a0,-32
8000608c:	06550593          	addi	a1,a0,101
80006090:	8552                	mv	a0,s4
80006092:	910ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80006096:	4576                	lw	a0,92(sp)
80006098:	00054963          	bltz	a0,800060aa <__SEGGER_RTL_vfprintf+0xd2e>
8000609c:	02b00593          	li	a1,43
800060a0:	8552                	mv	a0,s4
800060a2:	900ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
800060a6:	4576                	lw	a0,92(sp)
800060a8:	a811                	j	800060bc <__SEGGER_RTL_vfprintf+0xd40>
800060aa:	02d00593          	li	a1,45
800060ae:	8552                	mv	a0,s4
800060b0:	8f2ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
800060b4:	4576                	lw	a0,92(sp)
800060b6:	40a00533          	neg	a0,a0
800060ba:	ceaa                	sw	a0,92(sp)
800060bc:	06400493          	li	s1,100
800060c0:	02954663          	blt	a0,s1,800060ec <__SEGGER_RTL_vfprintf+0xd70>
800060c4:	4422                	lw	s0,8(sp)
800060c6:	02853533          	mulhu	a0,a0,s0
800060ca:	8115                	srli	a0,a0,0x5
800060cc:	03050593          	addi	a1,a0,48
800060d0:	8552                	mv	a0,s4
800060d2:	8d0ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
800060d6:	4576                	lw	a0,92(sp)
800060d8:	028515b3          	mulh	a1,a0,s0
800060dc:	01f5d613          	srli	a2,a1,0x1f
800060e0:	8595                	srai	a1,a1,0x5
800060e2:	95b2                	add	a1,a1,a2
800060e4:	029585b3          	mul	a1,a1,s1
800060e8:	8d0d                	sub	a0,a0,a1
800060ea:	ceaa                	sw	a0,92(sp)
800060ec:	54b2                	lw	s1,44(sp)
800060ee:	4462                	lw	s0,24(sp)
800060f0:	02851533          	mulh	a0,a0,s0
800060f4:	01f55593          	srli	a1,a0,0x1f
800060f8:	8509                	srai	a0,a0,0x2
800060fa:	952e                	add	a0,a0,a1
800060fc:	03050593          	addi	a1,a0,48
80006100:	8552                	mv	a0,s4
80006102:	8a0ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80006106:	4576                	lw	a0,92(sp)
80006108:	028515b3          	mulh	a1,a0,s0
8000610c:	01f5d613          	srli	a2,a1,0x1f
80006110:	8589                	srai	a1,a1,0x2
80006112:	95b2                	add	a1,a1,a2
80006114:	033585b3          	mul	a1,a1,s3
80006118:	8d0d                	sub	a0,a0,a1
8000611a:	03050593          	addi	a1,a0,48
8000611e:	a805                	j	8000614e <__SEGGER_RTL_vfprintf+0xdd2>
80006120:	5aa2                	lw	s5,40(sp)
80006122:	c591                	beqz	a1,8000612e <__SEGGER_RTL_vfprintf+0xdb2>
80006124:	800085b7          	lui	a1,0x80008
80006128:	53d58593          	addi	a1,a1,1341 # 8000853d <.L.str.3>
8000612c:	a029                	j	80006136 <__SEGGER_RTL_vfprintf+0xdba>
8000612e:	800085b7          	lui	a1,0x80008
80006132:	54258593          	addi	a1,a1,1346 # 80008542 <.L.str.4>
80006136:	00158513          	addi	a0,a1,1
8000613a:	020c7613          	andi	a2,s8,32
8000613e:	c211                	beqz	a2,80006142 <__SEGGER_RTL_vfprintf+0xdc6>
80006140:	852e                	mv	a0,a1
80006142:	effc7b93          	andi	s7,s8,-257
80006146:	837ff06f          	j	8000597c <__SEGGER_RTL_vfprintf+0x600>
8000614a:	8b5e                	mv	s6,s7
8000614c:	b9c9                	j	80005e1e <__SEGGER_RTL_vfprintf+0xaa2>
8000614e:	8552                	mv	a0,s4
80006150:	852ff0ef          	jal	800051a2 <__SEGGER_RTL_putc>
80006154:	a80c0563          	beqz	s8,800053de <__SEGGER_RTL_vfprintf+0x62>
80006158:	1c7d                	addi	s8,s8,-1
8000615a:	02000593          	li	a1,32
8000615e:	bfc5                	j	8000614e <__SEGGER_RTL_vfprintf+0xdd2>
80006160:	00ca2503          	lw	a0,12(s4)
80006164:	c911                	beqz	a0,80006178 <__SEGGER_RTL_vfprintf+0xdfc>
80006166:	000a2583          	lw	a1,0(s4)
8000616a:	004a2603          	lw	a2,4(s4)
8000616e:	00c5f563          	bgeu	a1,a2,80006178 <__SEGGER_RTL_vfprintf+0xdfc>
80006172:	952e                	add	a0,a0,a1
80006174:	00050023          	sb	zero,0(a0)
80006178:	8552                	mv	a0,s4
8000617a:	8c8ff0ef          	jal	80005242 <__SEGGER_RTL_prin_flush>
8000617e:	000a2503          	lw	a0,0(s4)
80006182:	6125                	addi	sp,sp,96
80006184:	2320106f          	j	800073b6 <__riscv_restore_12>
80006188:	8552                	mv	a0,s4
8000618a:	8b8ff0ef          	jal	80005242 <__SEGGER_RTL_prin_flush>
8000618e:	557d                	li	a0,-1
80006190:	bfcd                	j	80006182 <__SEGGER_RTL_vfprintf+0xe06>

Disassembly of section .segger.init.__SEGGER_init_heap:

80006192 <__SEGGER_init_heap>:
80006192:	00080537          	lui	a0,0x80
80006196:	36050513          	addi	a0,a0,864 # 80360 <__heap_start__>

8000619a <.Lpcrel_hi1>:
8000619a:	000845b7          	lui	a1,0x84
8000619e:	36058593          	addi	a1,a1,864 # 84360 <__heap_end__>
800061a2:	8d89                	sub	a1,a1,a0
800061a4:	a009                	j	800061a6 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

800061a6 <__SEGGER_RTL_init_heap>:
800061a6:	4621                	li	a2,8
800061a8:	00c5e963          	bltu	a1,a2,800061ba <__SEGGER_RTL_init_heap+0x14>
800061ac:	00080637          	lui	a2,0x80
800061b0:	34a62623          	sw	a0,844(a2) # 8034c <__SEGGER_RTL_heap_globals.0>
800061b4:	00052023          	sw	zero,0(a0)
800061b8:	c14c                	sw	a1,4(a0)
800061ba:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

800061bc <__SEGGER_RTL_ascii_toupper>:
800061bc:	f9f50593          	addi	a1,a0,-97
800061c0:	01a5b593          	sltiu	a1,a1,26
800061c4:	40b005b3          	neg	a1,a1
800061c8:	9981                	andi	a1,a1,-32
800061ca:	952e                	add	a0,a0,a1
800061cc:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

800061ce <__SEGGER_RTL_ascii_tolower>:
800061ce:	fbf50593          	addi	a1,a0,-65
800061d2:	01a5b593          	sltiu	a1,a1,26
800061d6:	0596                	slli	a1,a1,0x5
800061d8:	8d4d                	or	a0,a0,a1
800061da:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

800061dc <__SEGGER_RTL_ascii_towupper>:
800061dc:	f9f50593          	addi	a1,a0,-97
800061e0:	01a5b593          	sltiu	a1,a1,26
800061e4:	40b005b3          	neg	a1,a1
800061e8:	9981                	andi	a1,a1,-32
800061ea:	952e                	add	a0,a0,a1
800061ec:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

800061ee <__SEGGER_RTL_ascii_towlower>:
800061ee:	fbf50593          	addi	a1,a0,-65
800061f2:	01a5b593          	sltiu	a1,a1,26
800061f6:	0596                	slli	a1,a1,0x5
800061f8:	8d4d                	or	a0,a0,a1
800061fa:	8082                	ret

Disassembly of section .text.uart_enable_irq:

800061fc <uart_enable_irq>:
{
800061fc:	1141                	addi	sp,sp,-16
800061fe:	c62a                	sw	a0,12(sp)
80006200:	c42e                	sw	a1,8(sp)
    ptr->IER |= irq_mask;
80006202:	47b2                	lw	a5,12(sp)
80006204:	53d8                	lw	a4,36(a5)
80006206:	47a2                	lw	a5,8(sp)
80006208:	8f5d                	or	a4,a4,a5
8000620a:	47b2                	lw	a5,12(sp)
8000620c:	d3d8                	sw	a4,36(a5)
}
8000620e:	0001                	nop
80006210:	0141                	addi	sp,sp,16
80006212:	8082                	ret

Disassembly of section .text.gptmr_enable_irq:

80006214 <gptmr_enable_irq>:
{
80006214:	1141                	addi	sp,sp,-16
80006216:	c62a                	sw	a0,12(sp)
80006218:	c42e                	sw	a1,8(sp)
    ptr->IRQEN |= irq_mask;
8000621a:	47b2                	lw	a5,12(sp)
8000621c:	2047a703          	lw	a4,516(a5)
80006220:	47a2                	lw	a5,8(sp)
80006222:	8f5d                	or	a4,a4,a5
80006224:	47b2                	lw	a5,12(sp)
80006226:	20e7a223          	sw	a4,516(a5)
}
8000622a:	0001                	nop
8000622c:	0141                	addi	sp,sp,16
8000622e:	8082                	ret

Disassembly of section .text.gptmr_check_status:

80006230 <gptmr_check_status>:
{
80006230:	1141                	addi	sp,sp,-16
80006232:	c62a                	sw	a0,12(sp)
80006234:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
80006236:	47b2                	lw	a5,12(sp)
80006238:	2007a703          	lw	a4,512(a5)
8000623c:	47a2                	lw	a5,8(sp)
8000623e:	8ff9                	and	a5,a5,a4
80006240:	4722                	lw	a4,8(sp)
80006242:	40f707b3          	sub	a5,a4,a5
80006246:	0017b793          	seqz	a5,a5
8000624a:	0ff7f793          	zext.b	a5,a5
}
8000624e:	853e                	mv	a0,a5
80006250:	0141                	addi	sp,sp,16
80006252:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

80006254 <gptmr_clear_status>:
{
80006254:	1141                	addi	sp,sp,-16
80006256:	c62a                	sw	a0,12(sp)
80006258:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
8000625a:	47b2                	lw	a5,12(sp)
8000625c:	4722                	lw	a4,8(sp)
8000625e:	20e7a023          	sw	a4,512(a5)
}
80006262:	0001                	nop
80006264:	0141                	addi	sp,sp,16
80006266:	8082                	ret

Disassembly of section .text.gptmr_start_counter:

80006268 <gptmr_start_counter>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] ch_index channel index
 */
static inline void gptmr_start_counter(GPTMR_Type *ptr, uint8_t ch_index)
{
80006268:	1101                	addi	sp,sp,-32
8000626a:	ce06                	sw	ra,28(sp)
8000626c:	c62a                	sw	a0,12(sp)
8000626e:	87ae                	mv	a5,a1
80006270:	00f105a3          	sb	a5,11(sp)
#if defined(HPM_IP_FEATURE_GPTMR_OP_MODE) && (HPM_IP_FEATURE_GPTMR_OP_MODE  == 1)
    /* if support opmode, should clear CEN and set CEN */
     if (gptmr_channel_is_opmode(ptr, ch_index) == true) {
80006274:	00b14783          	lbu	a5,11(sp)
80006278:	85be                	mv	a1,a5
8000627a:	4532                	lw	a0,12(sp)
8000627c:	f5efd0ef          	jal	800039da <gptmr_channel_is_opmode>
80006280:	87aa                	mv	a5,a0
80006282:	cf99                	beqz	a5,800062a0 <.L17>
        ptr->CHANNEL[ch_index].CR &= ~GPTMR_CHANNEL_CR_CEN_MASK;
80006284:	00b14783          	lbu	a5,11(sp)
80006288:	4732                	lw	a4,12(sp)
8000628a:	079a                	slli	a5,a5,0x6
8000628c:	97ba                	add	a5,a5,a4
8000628e:	4398                	lw	a4,0(a5)
80006290:	00b14783          	lbu	a5,11(sp)
80006294:	bff77713          	andi	a4,a4,-1025
80006298:	46b2                	lw	a3,12(sp)
8000629a:	079a                	slli	a5,a5,0x6
8000629c:	97b6                	add	a5,a5,a3
8000629e:	c398                	sw	a4,0(a5)

800062a0 <.L17>:
     }
#endif
    ptr->CHANNEL[ch_index].CR |= GPTMR_CHANNEL_CR_CEN_MASK;
800062a0:	00b14783          	lbu	a5,11(sp)
800062a4:	4732                	lw	a4,12(sp)
800062a6:	079a                	slli	a5,a5,0x6
800062a8:	97ba                	add	a5,a5,a4
800062aa:	4398                	lw	a4,0(a5)
800062ac:	00b14783          	lbu	a5,11(sp)
800062b0:	40076713          	ori	a4,a4,1024
800062b4:	46b2                	lw	a3,12(sp)
800062b6:	079a                	slli	a5,a5,0x6
800062b8:	97b6                	add	a5,a5,a3
800062ba:	c398                	sw	a4,0(a5)
}
800062bc:	0001                	nop
800062be:	40f2                	lw	ra,28(sp)
800062c0:	6105                	addi	sp,sp,32
800062c2:	8082                	ret

Disassembly of section .text.reset_handler:

800062c4 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
800062c4:	1141                	addi	sp,sp,-16
800062c6:	c606                	sw	ra,12(sp)
    fencei();
800062c8:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
800062cc:	999fd0ef          	jal	80003c64 <system_init>

    /* Entry function */
    MAIN_ENTRY();
800062d0:	f38fd0ef          	jal	80003a08 <main>
}
800062d4:	0001                	nop
800062d6:	40b2                	lw	ra,12(sp)
800062d8:	0141                	addi	sp,sp,16
800062da:	8082                	ret

Disassembly of section .text._init:

800062dc <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
800062dc:	0001                	nop
800062de:	8082                	ret

Disassembly of section .text.mchtmr_isr:

800062e0 <mchtmr_isr>:
}
800062e0:	0001                	nop
800062e2:	8082                	ret

Disassembly of section .text.swi_isr:

800062e4 <swi_isr>:
}
800062e4:	0001                	nop
800062e6:	8082                	ret

Disassembly of section .text.exception_handler:

800062e8 <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
800062e8:	1141                	addi	sp,sp,-16
800062ea:	c62a                	sw	a0,12(sp)
800062ec:	c42e                	sw	a1,8(sp)
    switch (cause) {
800062ee:	4732                	lw	a4,12(sp)
800062f0:	47bd                	li	a5,15
800062f2:	00e7ea63          	bltu	a5,a4,80006306 <.L23>
800062f6:	47b2                	lw	a5,12(sp)
800062f8:	00279713          	slli	a4,a5,0x2
800062fc:	87818793          	addi	a5,gp,-1928 # 80003108 <.L7>
80006300:	97ba                	add	a5,a5,a4
80006302:	439c                	lw	a5,0(a5)
80006304:	8782                	jr	a5

80006306 <.L23>:
    case MCAUSE_LOAD_PAGE_FAULT:
        break;
    case MCAUSE_STORE_AMO_PAGE_FAULT:
        break;
    default:
        break;
80006306:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
80006308:	47a2                	lw	a5,8(sp)
}
8000630a:	853e                	mv	a0,a5
8000630c:	0141                	addi	sp,sp,16
8000630e:	8082                	ret

Disassembly of section .text.enable_plic_feature:

80006310 <enable_plic_feature>:
{
80006310:	1141                	addi	sp,sp,-16
    uint32_t plic_feature = 0;
80006312:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
80006314:	47b2                	lw	a5,12(sp)
80006316:	0027e793          	ori	a5,a5,2
8000631a:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
8000631c:	47b2                	lw	a5,12(sp)
8000631e:	0017e793          	ori	a5,a5,1
80006322:	c63e                	sw	a5,12(sp)
80006324:	e40007b7          	lui	a5,0xe4000
80006328:	c43e                	sw	a5,8(sp)
8000632a:	47b2                	lw	a5,12(sp)
8000632c:	c23e                	sw	a5,4(sp)

8000632e <.LBB14>:
    *(volatile uint32_t *) (base + HPM_PLIC_FEATURE_OFFSET) = feature;
8000632e:	47a2                	lw	a5,8(sp)
80006330:	4712                	lw	a4,4(sp)
80006332:	c398                	sw	a4,0(a5)
}
80006334:	0001                	nop

80006336 <.LBE14>:
}
80006336:	0001                	nop
80006338:	0141                	addi	sp,sp,16
8000633a:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

8000633c <sysctl_enable_group_resource>:
{
8000633c:	7179                	addi	sp,sp,-48
8000633e:	d606                	sw	ra,44(sp)
80006340:	c62a                	sw	a0,12(sp)
80006342:	87ae                	mv	a5,a1
80006344:	8736                	mv	a4,a3
80006346:	00f105a3          	sb	a5,11(sp)
8000634a:	87b2                	mv	a5,a2
8000634c:	00f11423          	sh	a5,8(sp)
80006350:	87ba                	mv	a5,a4
80006352:	00f10523          	sb	a5,10(sp)
    if (resource < sysctl_resource_linkable_start) {
80006356:	00815703          	lhu	a4,8(sp)
8000635a:	0ff00793          	li	a5,255
8000635e:	00e7e463          	bltu	a5,a4,80006366 <.L55>
        return status_invalid_argument;
80006362:	4789                	li	a5,2
80006364:	a851                	j	800063f8 <.L56>

80006366 <.L55>:
    index = (resource - sysctl_resource_linkable_start) / 32;
80006366:	00815783          	lhu	a5,8(sp)
8000636a:	f0078793          	addi	a5,a5,-256 # e3ffff00 <__FLASH_segment_end__+0x63efff00>
8000636e:	41f7d713          	srai	a4,a5,0x1f
80006372:	8b7d                	andi	a4,a4,31
80006374:	97ba                	add	a5,a5,a4
80006376:	8795                	srai	a5,a5,0x5
80006378:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
8000637a:	00815783          	lhu	a5,8(sp)
8000637e:	f0078713          	addi	a4,a5,-256
80006382:	41f75793          	srai	a5,a4,0x1f
80006386:	83ed                	srli	a5,a5,0x1b
80006388:	973e                	add	a4,a4,a5
8000638a:	8b7d                	andi	a4,a4,31
8000638c:	40f707b3          	sub	a5,a4,a5
80006390:	cc3e                	sw	a5,24(sp)
    switch (group) {
80006392:	00b14783          	lbu	a5,11(sp)
80006396:	efa9                	bnez	a5,800063f0 <.L57>
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset)) | (enable ? (1UL << offset) : 0);
80006398:	4732                	lw	a4,12(sp)
8000639a:	47f2                	lw	a5,28(sp)
8000639c:	08078793          	addi	a5,a5,128
800063a0:	0792                	slli	a5,a5,0x4
800063a2:	97ba                	add	a5,a5,a4
800063a4:	4398                	lw	a4,0(a5)
800063a6:	47e2                	lw	a5,24(sp)
800063a8:	4685                	li	a3,1
800063aa:	00f697b3          	sll	a5,a3,a5
800063ae:	fff7c793          	not	a5,a5
800063b2:	8f7d                	and	a4,a4,a5
800063b4:	00a14783          	lbu	a5,10(sp)
800063b8:	c791                	beqz	a5,800063c4 <.L58>
800063ba:	47e2                	lw	a5,24(sp)
800063bc:	4685                	li	a3,1
800063be:	00f697b3          	sll	a5,a3,a5
800063c2:	a011                	j	800063c6 <.L59>

800063c4 <.L58>:
800063c4:	4781                	li	a5,0

800063c6 <.L59>:
800063c6:	8f5d                	or	a4,a4,a5
800063c8:	46b2                	lw	a3,12(sp)
800063ca:	47f2                	lw	a5,28(sp)
800063cc:	08078793          	addi	a5,a5,128
800063d0:	0792                	slli	a5,a5,0x4
800063d2:	97b6                	add	a5,a5,a3
800063d4:	c398                	sw	a4,0(a5)
        if (enable) {
800063d6:	00a14783          	lbu	a5,10(sp)
800063da:	cf89                	beqz	a5,800063f4 <.L63>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
800063dc:	0001                	nop

800063de <.L61>:
800063de:	00815783          	lhu	a5,8(sp)
800063e2:	85be                	mv	a1,a5
800063e4:	4532                	lw	a0,12(sp)
800063e6:	8d5fd0ef          	jal	80003cba <sysctl_resource_target_is_busy>
800063ea:	87aa                	mv	a5,a0
800063ec:	fbed                	bnez	a5,800063de <.L61>
        break;
800063ee:	a019                	j	800063f4 <.L63>

800063f0 <.L57>:
        return status_invalid_argument;
800063f0:	4789                	li	a5,2
800063f2:	a019                	j	800063f8 <.L56>

800063f4 <.L63>:
        break;
800063f4:	0001                	nop
    return status_success;
800063f6:	4781                	li	a5,0

800063f8 <.L56>:
}
800063f8:	853e                	mv	a0,a5
800063fa:	50b2                	lw	ra,44(sp)
800063fc:	6145                	addi	sp,sp,48
800063fe:	8082                	ret

Disassembly of section .text.sysctl_check_group_resource_enable:

80006400 <sysctl_check_group_resource_enable>:
{
80006400:	1101                	addi	sp,sp,-32
80006402:	c62a                	sw	a0,12(sp)
80006404:	87ae                	mv	a5,a1
80006406:	8732                	mv	a4,a2
80006408:	00f105a3          	sb	a5,11(sp)
8000640c:	87ba                	mv	a5,a4
8000640e:	00f11423          	sh	a5,8(sp)
    index = (resource - sysctl_resource_linkable_start) / 32;
80006412:	00815783          	lhu	a5,8(sp)
80006416:	f0078793          	addi	a5,a5,-256
8000641a:	41f7d713          	srai	a4,a5,0x1f
8000641e:	8b7d                	andi	a4,a4,31
80006420:	97ba                	add	a5,a5,a4
80006422:	8795                	srai	a5,a5,0x5
80006424:	cc3e                	sw	a5,24(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
80006426:	00815783          	lhu	a5,8(sp)
8000642a:	f0078713          	addi	a4,a5,-256
8000642e:	41f75793          	srai	a5,a4,0x1f
80006432:	83ed                	srli	a5,a5,0x1b
80006434:	973e                	add	a4,a4,a5
80006436:	8b7d                	andi	a4,a4,31
80006438:	40f707b3          	sub	a5,a4,a5
8000643c:	ca3e                	sw	a5,20(sp)
    switch (group) {
8000643e:	00b14783          	lbu	a5,11(sp)
80006442:	e38d                	bnez	a5,80006464 <.L65>
        enable = ((ptr->GROUP0[index].VALUE & (1UL << offset)) != 0) ? true : false;
80006444:	4732                	lw	a4,12(sp)
80006446:	47e2                	lw	a5,24(sp)
80006448:	08078793          	addi	a5,a5,128
8000644c:	0792                	slli	a5,a5,0x4
8000644e:	97ba                	add	a5,a5,a4
80006450:	4398                	lw	a4,0(a5)
80006452:	47d2                	lw	a5,20(sp)
80006454:	00f757b3          	srl	a5,a4,a5
80006458:	8b85                	andi	a5,a5,1
8000645a:	00f037b3          	snez	a5,a5
8000645e:	00f10fa3          	sb	a5,31(sp)
        break;
80006462:	a021                	j	8000646a <.L66>

80006464 <.L65>:
        enable =  false;
80006464:	00010fa3          	sb	zero,31(sp)
        break;
80006468:	0001                	nop

8000646a <.L66>:
    return enable;
8000646a:	01f14783          	lbu	a5,31(sp)
}
8000646e:	853e                	mv	a0,a5
80006470:	6105                	addi	sp,sp,32
80006472:	8082                	ret

Disassembly of section .text.sysctl_config_cpu0_domain_clock:

80006474 <sysctl_config_cpu0_domain_clock>:

hpm_stat_t sysctl_config_cpu0_domain_clock(SYSCTL_Type *ptr,
                                           clock_source_t source,
                                           uint32_t cpu_div,
                                           uint32_t ahb_sub_div)
{
80006474:	7179                	addi	sp,sp,-48
80006476:	d606                	sw	ra,44(sp)
80006478:	c62a                	sw	a0,12(sp)
8000647a:	87ae                	mv	a5,a1
8000647c:	c232                	sw	a2,4(sp)
8000647e:	c036                	sw	a3,0(sp)
80006480:	00f105a3          	sb	a5,11(sp)
    if (source >= clock_source_general_source_end) {
80006484:	00b14703          	lbu	a4,11(sp)
80006488:	479d                	li	a5,7
8000648a:	00e7f463          	bgeu	a5,a4,80006492 <.L86>
        return status_invalid_argument;
8000648e:	4789                	li	a5,2
80006490:	a849                	j	80006522 <.L87>

80006492 <.L86>:
    }

    uint32_t origin_cpu_div = SYSCTL_CLOCK_CPU_DIV_GET(ptr->CLOCK_CPU[0]) + 1U;
80006492:	4732                	lw	a4,12(sp)
80006494:	6789                	lui	a5,0x2
80006496:	97ba                	add	a5,a5,a4
80006498:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
8000649c:	0ff7f793          	zext.b	a5,a5
800064a0:	0785                	addi	a5,a5,1
800064a2:	ce3e                	sw	a5,28(sp)
    if (origin_cpu_div == cpu_div) {
800064a4:	4772                	lw	a4,28(sp)
800064a6:	4792                	lw	a5,4(sp)
800064a8:	02f71e63          	bne	a4,a5,800064e4 <.L88>
        ptr->CLOCK_CPU[0] = SYSCTL_CLOCK_CPU_MUX_SET(source) | SYSCTL_CLOCK_CPU_DIV_SET(cpu_div) | SYSCTL_CLOCK_CPU_SUB0_DIV_SET(ahb_sub_div - 1);
800064ac:	00b14783          	lbu	a5,11(sp)
800064b0:	07a2                	slli	a5,a5,0x8
800064b2:	7007f713          	andi	a4,a5,1792
800064b6:	4792                	lw	a5,4(sp)
800064b8:	0ff7f793          	zext.b	a5,a5
800064bc:	8f5d                	or	a4,a4,a5
800064be:	4782                	lw	a5,0(sp)
800064c0:	17fd                	addi	a5,a5,-1
800064c2:	01079693          	slli	a3,a5,0x10
800064c6:	000f07b7          	lui	a5,0xf0
800064ca:	8ff5                	and	a5,a5,a3
800064cc:	8f5d                	or	a4,a4,a5
800064ce:	46b2                	lw	a3,12(sp)
800064d0:	6789                	lui	a5,0x2
800064d2:	97b6                	add	a5,a5,a3
800064d4:	80e7a023          	sw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
        while (sysctl_cpu_clock_any_is_busy(ptr)) {
800064d8:	0001                	nop

800064da <.L89>:
800064da:	4532                	lw	a0,12(sp)
800064dc:	809fd0ef          	jal	80003ce4 <sysctl_cpu_clock_any_is_busy>
800064e0:	87aa                	mv	a5,a0
800064e2:	ffe5                	bnez	a5,800064da <.L89>

800064e4 <.L88>:
        }
    }
    ptr->CLOCK_CPU[0] = SYSCTL_CLOCK_CPU_MUX_SET(source) | SYSCTL_CLOCK_CPU_DIV_SET(cpu_div - 1) | SYSCTL_CLOCK_CPU_SUB0_DIV_SET(ahb_sub_div - 1);
800064e4:	00b14783          	lbu	a5,11(sp)
800064e8:	07a2                	slli	a5,a5,0x8
800064ea:	7007f713          	andi	a4,a5,1792
800064ee:	4792                	lw	a5,4(sp)
800064f0:	17fd                	addi	a5,a5,-1
800064f2:	0ff7f793          	zext.b	a5,a5
800064f6:	8f5d                	or	a4,a4,a5
800064f8:	4782                	lw	a5,0(sp)
800064fa:	17fd                	addi	a5,a5,-1
800064fc:	01079693          	slli	a3,a5,0x10
80006500:	000f07b7          	lui	a5,0xf0
80006504:	8ff5                	and	a5,a5,a3
80006506:	8f5d                	or	a4,a4,a5
80006508:	46b2                	lw	a3,12(sp)
8000650a:	6789                	lui	a5,0x2
8000650c:	97b6                	add	a5,a5,a3
8000650e:	80e7a023          	sw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>

    while (sysctl_cpu_clock_any_is_busy(ptr)) {
80006512:	0001                	nop

80006514 <.L90>:
80006514:	4532                	lw	a0,12(sp)
80006516:	fcefd0ef          	jal	80003ce4 <sysctl_cpu_clock_any_is_busy>
8000651a:	87aa                	mv	a5,a0
8000651c:	ffe5                	bnez	a5,80006514 <.L90>
    }

    clock_update_core_clock();
8000651e:	24c5                	jal	800067fe <clock_update_core_clock>

    return status_success;
80006520:	4781                	li	a5,0

80006522 <.L87>:
}
80006522:	853e                	mv	a0,a5
80006524:	50b2                	lw	ra,44(sp)
80006526:	6145                	addi	sp,sp,48
80006528:	8082                	ret

Disassembly of section .text.clock_get_frequency:

8000652a <clock_get_frequency>:
{
8000652a:	7179                	addi	sp,sp,-48
8000652c:	d606                	sw	ra,44(sp)
8000652e:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80006530:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80006532:	47b2                	lw	a5,12(sp)
80006534:	83a1                	srli	a5,a5,0x8
80006536:	0ff7f793          	zext.b	a5,a5
8000653a:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
8000653c:	47b2                	lw	a5,12(sp)
8000653e:	0ff7f793          	zext.b	a5,a5
80006542:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80006544:	4762                	lw	a4,24(sp)
80006546:	47ad                	li	a5,11
80006548:	06e7e963          	bltu	a5,a4,800065ba <.L16>
8000654c:	47e2                	lw	a5,24(sp)
8000654e:	00279713          	slli	a4,a5,0x2
80006552:	8c018793          	addi	a5,gp,-1856 # 80003150 <.L18>
80006556:	97ba                	add	a5,a5,a4
80006558:	439c                	lw	a5,0(a5)
8000655a:	8782                	jr	a5

8000655c <.L26>:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
8000655c:	47d2                	lw	a5,20(sp)
8000655e:	0ff7f793          	zext.b	a5,a5
80006562:	853e                	mv	a0,a5
80006564:	907fd0ef          	jal	80003e6a <get_frequency_for_ip_in_common_group>
80006568:	ce2a                	sw	a0,28(sp)
        break;
8000656a:	a891                	j	800065be <.L27>

8000656c <.L25>:
        clk_freq = get_frequency_for_adc(CLK_SRC_GROUP_ADC, node_or_instance);
8000656c:	45d2                	lw	a1,20(sp)
8000656e:	4505                	li	a0,1
80006570:	967fd0ef          	jal	80003ed6 <get_frequency_for_adc>
80006574:	ce2a                	sw	a0,28(sp)
        break;
80006576:	a0a1                	j	800065be <.L27>

80006578 <.L21>:
        clk_freq = get_frequency_for_dac(node_or_instance);
80006578:	4552                	lw	a0,20(sp)
8000657a:	20b9                	jal	800065c8 <.LFE116>
8000657c:	ce2a                	sw	a0,28(sp)
        break;
8000657e:	a081                	j	800065be <.L27>

80006580 <.L24>:
        clk_freq = get_frequency_for_ewdg(node_or_instance);
80006580:	4552                	lw	a0,20(sp)
80006582:	9edfd0ef          	jal	80003f6e <get_frequency_for_ewdg>
80006586:	ce2a                	sw	a0,28(sp)
        break;
80006588:	a81d                	j	800065be <.L27>

8000658a <.L17>:
        clk_freq = get_frequency_for_pewdg();
8000658a:	20f1                	jal	80006656 <get_frequency_for_pewdg>
8000658c:	ce2a                	sw	a0,28(sp)
        break;
8000658e:	a805                	j	800065be <.L27>

80006590 <.L23>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80006590:	016e37b7          	lui	a5,0x16e3
80006594:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006598:	ce3e                	sw	a5,28(sp)
        break;
8000659a:	a015                	j	800065be <.L27>

8000659c <.L20>:
        clk_freq = get_frequency_for_cpu();
8000659c:	a05fd0ef          	jal	80003fa0 <get_frequency_for_cpu>
800065a0:	ce2a                	sw	a0,28(sp)
        break;
800065a2:	a831                	j	800065be <.L27>

800065a4 <.L22>:
        clk_freq = get_frequency_for_ahb();
800065a4:	28e9                	jal	8000667e <get_frequency_for_ahb>
800065a6:	ce2a                	sw	a0,28(sp)
        break;
800065a8:	a819                	j	800065be <.L27>

800065aa <.L19>:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
800065aa:	47d2                	lw	a5,20(sp)
800065ac:	0ff7f793          	zext.b	a5,a5
800065b0:	853e                	mv	a0,a5
800065b2:	80bfd0ef          	jal	80003dbc <get_frequency_for_source>
800065b6:	ce2a                	sw	a0,28(sp)
        break;
800065b8:	a019                	j	800065be <.L27>

800065ba <.L16>:
        clk_freq = 0UL;
800065ba:	ce02                	sw	zero,28(sp)
        break;
800065bc:	0001                	nop

800065be <.L27>:
    return clk_freq;
800065be:	47f2                	lw	a5,28(sp)
}
800065c0:	853e                	mv	a0,a5
800065c2:	50b2                	lw	ra,44(sp)
800065c4:	6145                	addi	sp,sp,48
800065c6:	8082                	ret

Disassembly of section .text.get_frequency_for_dac:

800065c8 <get_frequency_for_dac>:
{
800065c8:	7179                	addi	sp,sp,-48
800065ca:	d606                	sw	ra,44(sp)
800065cc:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
800065ce:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
800065d0:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
800065d4:	02800793          	li	a5,40
800065d8:	00f10d23          	sb	a5,26(sp)
    if (instance < DAC_INSTANCE_NUM) {
800065dc:	4732                	lw	a4,12(sp)
800065de:	4785                	li	a5,1
800065e0:	02e7ec63          	bltu	a5,a4,80006618 <.L51>

800065e4 <.LBB8>:
        uint32_t mux_in_reg = SYSCTL_DACCLK_MUX_GET(HPM_SYSCTL->DACCLK[instance]);
800065e4:	f4000737          	lui	a4,0xf4000
800065e8:	47b2                	lw	a5,12(sp)
800065ea:	70078793          	addi	a5,a5,1792
800065ee:	078a                	slli	a5,a5,0x2
800065f0:	97ba                	add	a5,a5,a4
800065f2:	479c                	lw	a5,8(a5)
800065f4:	83a1                	srli	a5,a5,0x8
800065f6:	8b85                	andi	a5,a5,1
800065f8:	ca3e                	sw	a5,20(sp)
        if (mux_in_reg < ARRAY_SIZE(s_dac_clk_mux_node)) {
800065fa:	4752                	lw	a4,20(sp)
800065fc:	4785                	li	a5,1
800065fe:	00e7ed63          	bltu	a5,a4,80006618 <.L51>
            node = s_dac_clk_mux_node[mux_in_reg];
80006602:	04018713          	addi	a4,gp,64 # 800038d0 <s_dac_clk_mux_node>
80006606:	47d2                	lw	a5,20(sp)
80006608:	97ba                	add	a5,a5,a4
8000660a:	0007c783          	lbu	a5,0(a5)
8000660e:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
80006612:	4785                	li	a5,1
80006614:	00f10da3          	sb	a5,27(sp)

80006618 <.L51>:
    if (is_mux_valid) {
80006618:	01b14783          	lbu	a5,27(sp)
8000661c:	cb85                	beqz	a5,8000664c <.L52>
        if (node == clock_node_ahb) {
8000661e:	01a14703          	lbu	a4,26(sp)
80006622:	0fe00793          	li	a5,254
80006626:	00f71563          	bne	a4,a5,80006630 <.L53>
            clk_freq = get_frequency_for_ahb();
8000662a:	2891                	jal	8000667e <get_frequency_for_ahb>
8000662c:	ce2a                	sw	a0,28(sp)
8000662e:	a839                	j	8000664c <.L52>

80006630 <.L53>:
            node += instance;
80006630:	47b2                	lw	a5,12(sp)
80006632:	0ff7f793          	zext.b	a5,a5
80006636:	01a14703          	lbu	a4,26(sp)
8000663a:	97ba                	add	a5,a5,a4
8000663c:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
80006640:	01a14783          	lbu	a5,26(sp)
80006644:	853e                	mv	a0,a5
80006646:	825fd0ef          	jal	80003e6a <get_frequency_for_ip_in_common_group>
8000664a:	ce2a                	sw	a0,28(sp)

8000664c <.L52>:
    return clk_freq;
8000664c:	47f2                	lw	a5,28(sp)
}
8000664e:	853e                	mv	a0,a5
80006650:	50b2                	lw	ra,44(sp)
80006652:	6145                	addi	sp,sp,48
80006654:	8082                	ret

Disassembly of section .text.get_frequency_for_pewdg:

80006656 <get_frequency_for_pewdg>:
{
80006656:	1141                	addi	sp,sp,-16
    if (EWDG_CTRL0_CLK_SEL_GET(HPM_PEWDG->CTRL0) == 0) {
80006658:	f41287b7          	lui	a5,0xf4128
8000665c:	4398                	lw	a4,0(a5)
8000665e:	200007b7          	lui	a5,0x20000
80006662:	8ff9                	and	a5,a5,a4
80006664:	e799                	bnez	a5,80006672 <.L60>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
80006666:	016e37b7          	lui	a5,0x16e3
8000666a:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
8000666e:	c63e                	sw	a5,12(sp)
80006670:	a019                	j	80006676 <.L61>

80006672 <.L60>:
        freq_in_hz = FREQ_32KHz;
80006672:	67a1                	lui	a5,0x8
80006674:	c63e                	sw	a5,12(sp)

80006676 <.L61>:
    return freq_in_hz;
80006676:	47b2                	lw	a5,12(sp)
}
80006678:	853e                	mv	a0,a5
8000667a:	0141                	addi	sp,sp,16
8000667c:	8082                	ret

Disassembly of section .text.get_frequency_for_ahb:

8000667e <get_frequency_for_ahb>:
{
8000667e:	1101                	addi	sp,sp,-32
80006680:	ce06                	sw	ra,28(sp)
    uint32_t div = SYSCTL_CLOCK_CPU_SUB0_DIV_GET(HPM_SYSCTL->CLOCK_CPU[0]) + 1U;
80006682:	f4000737          	lui	a4,0xf4000
80006686:	6789                	lui	a5,0x2
80006688:	97ba                	add	a5,a5,a4
8000668a:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
8000668e:	83c1                	srli	a5,a5,0x10
80006690:	8bbd                	andi	a5,a5,15
80006692:	0785                	addi	a5,a5,1
80006694:	c63e                	sw	a5,12(sp)
    return (get_frequency_for_cpu() / div);
80006696:	90bfd0ef          	jal	80003fa0 <get_frequency_for_cpu>
8000669a:	872a                	mv	a4,a0
8000669c:	47b2                	lw	a5,12(sp)
8000669e:	02f757b3          	divu	a5,a4,a5
}
800066a2:	853e                	mv	a0,a5
800066a4:	40f2                	lw	ra,28(sp)
800066a6:	6105                	addi	sp,sp,32
800066a8:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

800066aa <clock_set_source_divider>:
{
800066aa:	7139                	addi	sp,sp,-64
800066ac:	de06                	sw	ra,60(sp)
800066ae:	c62a                	sw	a0,12(sp)
800066b0:	87ae                	mv	a5,a1
800066b2:	c232                	sw	a2,4(sp)
800066b4:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
800066b8:	d602                	sw	zero,44(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
800066ba:	47b2                	lw	a5,12(sp)
800066bc:	83a1                	srli	a5,a5,0x8
800066be:	0ff7f793          	zext.b	a5,a5
800066c2:	d43e                	sw	a5,40(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
800066c4:	47b2                	lw	a5,12(sp)
800066c6:	0ff7f793          	zext.b	a5,a5
800066ca:	d23e                	sw	a5,36(sp)
    switch (clk_src_type) {
800066cc:	5722                	lw	a4,40(sp)
800066ce:	47ad                	li	a5,11
800066d0:	0ce7e263          	bltu	a5,a4,80006794 <.L132>
800066d4:	57a2                	lw	a5,40(sp)
800066d6:	00279713          	slli	a4,a5,0x2
800066da:	91018793          	addi	a5,gp,-1776 # 800031a0 <.L134>
800066de:	97ba                	add	a5,a5,a4
800066e0:	439c                	lw	a5,0(a5)
800066e2:	8782                	jr	a5

800066e4 <.L138>:
        if ((div < 1U) || (div > 256U)) {
800066e4:	4792                	lw	a5,4(sp)
800066e6:	c791                	beqz	a5,800066f2 <.L139>
800066e8:	4712                	lw	a4,4(sp)
800066ea:	10000793          	li	a5,256
800066ee:	00e7f763          	bgeu	a5,a4,800066fc <.L140>

800066f2 <.L139>:
            status = status_clk_div_invalid;
800066f2:	6795                	lui	a5,0x5
800066f4:	5f078793          	addi	a5,a5,1520 # 55f0 <__HEAPSIZE__+0x15f0>
800066f8:	d63e                	sw	a5,44(sp)
        break;
800066fa:	a055                	j	8000679e <.L142>

800066fc <.L140>:
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
800066fc:	00b14783          	lbu	a5,11(sp)
80006700:	8bbd                	andi	a5,a5,15
80006702:	00f10da3          	sb	a5,27(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
80006706:	5792                	lw	a5,36(sp)
80006708:	0ff7f793          	zext.b	a5,a5
8000670c:	01b14703          	lbu	a4,27(sp)
80006710:	4692                	lw	a3,4(sp)
80006712:	863a                	mv	a2,a4
80006714:	85be                	mv	a1,a5
80006716:	f4000537          	lui	a0,0xf4000
8000671a:	e1afd0ef          	jal	80003d34 <sysctl_config_clock>

8000671e <.LBE13>:
        break;
8000671e:	a041                	j	8000679e <.L142>

80006720 <.L133>:
        status = status_clk_operation_unsupported;
80006720:	6795                	lui	a5,0x5
80006722:	5f378793          	addi	a5,a5,1523 # 55f3 <__HEAPSIZE__+0x15f3>
80006726:	d63e                	sw	a5,44(sp)
        break;
80006728:	a89d                	j	8000679e <.L142>

8000672a <.L137>:
        status = status_clk_fixed;
8000672a:	6795                	lui	a5,0x5
8000672c:	5fa78793          	addi	a5,a5,1530 # 55fa <__HEAPSIZE__+0x15fa>
80006730:	d63e                	sw	a5,44(sp)
        break;
80006732:	a0b5                	j	8000679e <.L142>

80006734 <.L136>:
        status = status_clk_shared_cpu0;
80006734:	6795                	lui	a5,0x5
80006736:	5f878793          	addi	a5,a5,1528 # 55f8 <__HEAPSIZE__+0x15f8>
8000673a:	d63e                	sw	a5,44(sp)
        break;
8000673c:	a08d                	j	8000679e <.L142>

8000673e <.L135>:
        if (node_or_instance == clock_node_cpu0) {
8000673e:	5712                	lw	a4,36(sp)
80006740:	0fc00793          	li	a5,252
80006744:	04f71363          	bne	a4,a5,8000678a <.L143>

80006748 <.LBB14>:
            uint32_t expected_freq = get_frequency_for_source((clock_source_t) src) / div;
80006748:	00b14783          	lbu	a5,11(sp)
8000674c:	853e                	mv	a0,a5
8000674e:	e6efd0ef          	jal	80003dbc <get_frequency_for_source>
80006752:	872a                	mv	a4,a0
80006754:	4792                	lw	a5,4(sp)
80006756:	02f757b3          	divu	a5,a4,a5
8000675a:	d03e                	sw	a5,32(sp)
            uint32_t ahb_sub_div = (expected_freq + BUS_FREQ_MAX - 1U) / BUS_FREQ_MAX;
8000675c:	5702                	lw	a4,32(sp)
8000675e:	0bebc7b7          	lui	a5,0xbebc
80006762:	1ff78793          	addi	a5,a5,511 # bebc1ff <_flash_size+0xbdbc1ff>
80006766:	973e                	add	a4,a4,a5
80006768:	55e647b7          	lui	a5,0x55e64
8000676c:	b8978793          	addi	a5,a5,-1143 # 55e63b89 <_flash_size+0x55d63b89>
80006770:	02f737b3          	mulhu	a5,a4,a5
80006774:	83e9                	srli	a5,a5,0x1a
80006776:	ce3e                	sw	a5,28(sp)
            sysctl_config_cpu0_domain_clock(HPM_SYSCTL, (clock_source_t) src, div, ahb_sub_div);
80006778:	00b14783          	lbu	a5,11(sp)
8000677c:	46f2                	lw	a3,28(sp)
8000677e:	4612                	lw	a2,4(sp)
80006780:	85be                	mv	a1,a5
80006782:	f4000537          	lui	a0,0xf4000
80006786:	31fd                	jal	80006474 <sysctl_config_cpu0_domain_clock>

80006788 <.LBE14>:
        break;
80006788:	a819                	j	8000679e <.L142>

8000678a <.L143>:
            status = status_clk_shared_cpu0;
8000678a:	6795                	lui	a5,0x5
8000678c:	5f878793          	addi	a5,a5,1528 # 55f8 <__HEAPSIZE__+0x15f8>
80006790:	d63e                	sw	a5,44(sp)
        break;
80006792:	a031                	j	8000679e <.L142>

80006794 <.L132>:
        status = status_clk_src_invalid;
80006794:	6795                	lui	a5,0x5
80006796:	5f178793          	addi	a5,a5,1521 # 55f1 <__HEAPSIZE__+0x15f1>
8000679a:	d63e                	sw	a5,44(sp)
        break;
8000679c:	0001                	nop

8000679e <.L142>:
    return status;
8000679e:	57b2                	lw	a5,44(sp)
}
800067a0:	853e                	mv	a0,a5
800067a2:	50f2                	lw	ra,60(sp)
800067a4:	6121                	addi	sp,sp,64
800067a6:	8082                	ret

Disassembly of section .text.clock_check_in_group:

800067a8 <clock_check_in_group>:

bool clock_check_in_group(clock_name_t clock_name, uint32_t group)
{
800067a8:	7179                	addi	sp,sp,-48
800067aa:	d606                	sw	ra,44(sp)
800067ac:	c62a                	sw	a0,12(sp)
800067ae:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
800067b0:	47b2                	lw	a5,12(sp)
800067b2:	83c1                	srli	a5,a5,0x10
800067b4:	ce3e                	sw	a5,28(sp)

    return sysctl_check_group_resource_enable(HPM_SYSCTL, group, resource);
800067b6:	47a2                	lw	a5,8(sp)
800067b8:	0ff7f793          	zext.b	a5,a5
800067bc:	4772                	lw	a4,28(sp)
800067be:	08074733          	zext.h	a4,a4
800067c2:	863a                	mv	a2,a4
800067c4:	85be                	mv	a1,a5
800067c6:	f4000537          	lui	a0,0xf4000
800067ca:	391d                	jal	80006400 <sysctl_check_group_resource_enable>
800067cc:	87aa                	mv	a5,a0
}
800067ce:	853e                	mv	a0,a5
800067d0:	50b2                	lw	ra,44(sp)
800067d2:	6145                	addi	sp,sp,48
800067d4:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

800067d6 <clock_connect_group_to_cpu>:

void clock_connect_group_to_cpu(uint32_t group, uint32_t cpu)
{
800067d6:	1141                	addi	sp,sp,-16
800067d8:	c62a                	sw	a0,12(sp)
800067da:	c42e                	sw	a1,8(sp)
    if (cpu == 0U) {
800067dc:	47a2                	lw	a5,8(sp)
800067de:	ef89                	bnez	a5,800067f8 <.L163>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
800067e0:	f40006b7          	lui	a3,0xf4000
800067e4:	47b2                	lw	a5,12(sp)
800067e6:	4705                	li	a4,1
800067e8:	00f71733          	sll	a4,a4,a5
800067ec:	47a2                	lw	a5,8(sp)
800067ee:	09078793          	addi	a5,a5,144
800067f2:	0792                	slli	a5,a5,0x4
800067f4:	97b6                	add	a5,a5,a3
800067f6:	c3d8                	sw	a4,4(a5)

800067f8 <.L163>:
    }
}
800067f8:	0001                	nop
800067fa:	0141                	addi	sp,sp,16
800067fc:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

800067fe <clock_update_core_clock>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_update_core_clock(void)
{
800067fe:	1141                	addi	sp,sp,-16
80006800:	c606                	sw	ra,12(sp)
    hpm_core_clock = clock_get_frequency(clock_cpu0);
80006802:	6785                	lui	a5,0x1
80006804:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x4b2>
80006808:	330d                	jal	8000652a <clock_get_frequency>
8000680a:	872a                	mv	a4,a0
8000680c:	000807b7          	lui	a5,0x80
80006810:	32e7ae23          	sw	a4,828(a5) # 8033c <hpm_core_clock>
}
80006814:	0001                	nop
80006816:	40b2                	lw	ra,12(sp)
80006818:	0141                	addi	sp,sp,16
8000681a:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

8000681c <l1c_dc_invalidate_all>:
{
8000681c:	1141                	addi	sp,sp,-16
8000681e:	47dd                	li	a5,23
80006820:	00f107a3          	sb	a5,15(sp)

80006824 <.LBB68>:
}

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
80006824:	00f14783          	lbu	a5,15(sp)
80006828:	7cc79073          	csrw	0x7cc,a5
}
8000682c:	0001                	nop

8000682e <.LBE68>:
}
8000682e:	0001                	nop
80006830:	0141                	addi	sp,sp,16
80006832:	8082                	ret

Disassembly of section .text.init_py_pins_as_pgpio:

80006834 <init_py_pins_as_pgpio>:
    HPM_PIOC->PAD[IOC_PAD_PY00].FUNC_CTL = PIOC_PY00_FUNC_CTL_PGPIO_Y_00;
80006834:	f4118737          	lui	a4,0xf4118
80006838:	6785                	lui	a5,0x1
8000683a:	97ba                	add	a5,a5,a4
8000683c:	e007a023          	sw	zero,-512(a5) # e00 <__NOR_CFG_OPTION_segment_size__+0x200>
    HPM_PIOC->PAD[IOC_PAD_PY01].FUNC_CTL = PIOC_PY01_FUNC_CTL_PGPIO_Y_01;
80006840:	f4118737          	lui	a4,0xf4118
80006844:	6785                	lui	a5,0x1
80006846:	97ba                	add	a5,a5,a4
80006848:	e007a423          	sw	zero,-504(a5) # e08 <__NOR_CFG_OPTION_segment_size__+0x208>
    HPM_PIOC->PAD[IOC_PAD_PY02].FUNC_CTL = PIOC_PY02_FUNC_CTL_PGPIO_Y_02;
8000684c:	f4118737          	lui	a4,0xf4118
80006850:	6785                	lui	a5,0x1
80006852:	97ba                	add	a5,a5,a4
80006854:	e007a823          	sw	zero,-496(a5) # e10 <__NOR_CFG_OPTION_segment_size__+0x210>
    HPM_PIOC->PAD[IOC_PAD_PY03].FUNC_CTL = PIOC_PY03_FUNC_CTL_PGPIO_Y_03;
80006858:	f4118737          	lui	a4,0xf4118
8000685c:	6785                	lui	a5,0x1
8000685e:	97ba                	add	a5,a5,a4
80006860:	e007ac23          	sw	zero,-488(a5) # e18 <__NOR_CFG_OPTION_segment_size__+0x218>
    HPM_PIOC->PAD[IOC_PAD_PY04].FUNC_CTL = PIOC_PY04_FUNC_CTL_PGPIO_Y_04;
80006864:	f4118737          	lui	a4,0xf4118
80006868:	6785                	lui	a5,0x1
8000686a:	97ba                	add	a5,a5,a4
8000686c:	e207a023          	sw	zero,-480(a5) # e20 <__NOR_CFG_OPTION_segment_size__+0x220>
    HPM_PIOC->PAD[IOC_PAD_PY05].FUNC_CTL = PIOC_PY05_FUNC_CTL_PGPIO_Y_05;
80006870:	f4118737          	lui	a4,0xf4118
80006874:	6785                	lui	a5,0x1
80006876:	97ba                	add	a5,a5,a4
80006878:	e207a423          	sw	zero,-472(a5) # e28 <__NOR_CFG_OPTION_segment_size__+0x228>
}
8000687c:	0001                	nop
8000687e:	8082                	ret

Disassembly of section .text.init_uart0_pins:

80006880 <init_uart0_pins>:
    HPM_IOC->PAD[IOC_PAD_PA00].FUNC_CTL = IOC_PA00_FUNC_CTL_UART0_TXD;
80006880:	f40407b7          	lui	a5,0xf4040
80006884:	4709                	li	a4,2
80006886:	c398                	sw	a4,0(a5)
    HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
80006888:	f40407b7          	lui	a5,0xf4040
8000688c:	4709                	li	a4,2
8000688e:	c798                	sw	a4,8(a5)
}
80006890:	0001                	nop
80006892:	8082                	ret

Disassembly of section .text.init_uart3_pins:

80006894 <init_uart3_pins>:

void init_uart3_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PA14].FUNC_CTL = IOC_PA14_FUNC_CTL_UART3_RXD;
80006894:	f40407b7          	lui	a5,0xf4040
80006898:	4709                	li	a4,2
8000689a:	dbb8                	sw	a4,112(a5)

    HPM_IOC->PAD[IOC_PAD_PA15].FUNC_CTL = IOC_PA15_FUNC_CTL_UART3_TXD;
8000689c:	f40407b7          	lui	a5,0xf4040
800068a0:	4709                	li	a4,2
800068a2:	dfb8                	sw	a4,120(a5)
}
800068a4:	0001                	nop
800068a6:	8082                	ret

Disassembly of section .text.init_led_pins_as_gpio:

800068a8 <init_led_pins_as_gpio>:
    HPM_PIOC->PAD[IOC_PAD_PY05].FUNC_CTL = PIOC_PY05_FUNC_CTL_SOC_GPIO_Y_05;
}

void init_led_pins_as_gpio(void)
{
    HPM_IOC->PAD[IOC_PAD_PA23].FUNC_CTL = IOC_PA23_FUNC_CTL_GPIO_A_23;
800068a8:	f40407b7          	lui	a5,0xf4040
800068ac:	0a07ac23          	sw	zero,184(a5) # f40400b8 <__AHB_SRAM_segment_end__+0x3c380b8>
}
800068b0:	0001                	nop
800068b2:	8082                	ret

Disassembly of section .text.sysctl_resource_any_is_busy:

800068b4 <sysctl_resource_any_is_busy>:
{
800068b4:	1141                	addi	sp,sp,-16
800068b6:	c62a                	sw	a0,12(sp)
    return ptr->RESOURCE[0] & SYSCTL_RESOURCE_GLB_BUSY_MASK;
800068b8:	47b2                	lw	a5,12(sp)
800068ba:	4398                	lw	a4,0(a5)
800068bc:	800007b7          	lui	a5,0x80000
800068c0:	8ff9                	and	a5,a5,a4
800068c2:	00f037b3          	snez	a5,a5
800068c6:	0ff7f793          	zext.b	a5,a5
}
800068ca:	853e                	mv	a0,a5
800068cc:	0141                	addi	sp,sp,16
800068ce:	8082                	ret

Disassembly of section .text.gptmr_check_status:

800068d0 <gptmr_check_status>:
{
800068d0:	1141                	addi	sp,sp,-16
800068d2:	c62a                	sw	a0,12(sp)
800068d4:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
800068d6:	47b2                	lw	a5,12(sp)
800068d8:	2007a703          	lw	a4,512(a5) # 80000200 <_flash_size+0x7ff00200>
800068dc:	47a2                	lw	a5,8(sp)
800068de:	8ff9                	and	a5,a5,a4
800068e0:	4722                	lw	a4,8(sp)
800068e2:	40f707b3          	sub	a5,a4,a5
800068e6:	0017b793          	seqz	a5,a5
800068ea:	0ff7f793          	zext.b	a5,a5
}
800068ee:	853e                	mv	a0,a5
800068f0:	0141                	addi	sp,sp,16
800068f2:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

800068f4 <gptmr_clear_status>:
{
800068f4:	1141                	addi	sp,sp,-16
800068f6:	c62a                	sw	a0,12(sp)
800068f8:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
800068fa:	47b2                	lw	a5,12(sp)
800068fc:	4722                	lw	a4,8(sp)
800068fe:	20e7a023          	sw	a4,512(a5)
}
80006902:	0001                	nop
80006904:	0141                	addi	sp,sp,16
80006906:	8082                	ret

Disassembly of section .text.usb_phy_disable_dp_dm_pulldown:

80006908 <usb_phy_disable_dp_dm_pulldown>:
 * @brief USB phy disconnect dp/dm pins pulldown resistance
 *
 * @param[in] ptr A USB peripheral base address
 */
static inline void usb_phy_disable_dp_dm_pulldown(USB_Type *ptr)
{
80006908:	1141                	addi	sp,sp,-16
8000690a:	c62a                	sw	a0,12(sp)
    ptr->PHY_CTRL0 |= 0x001000E0u;
8000690c:	47b2                	lw	a5,12(sp)
8000690e:	2107a703          	lw	a4,528(a5)
80006912:	001007b7          	lui	a5,0x100
80006916:	0e078793          	addi	a5,a5,224 # 1000e0 <_flash_size+0xe0>
8000691a:	8f5d                	or	a4,a4,a5
8000691c:	47b2                	lw	a5,12(sp)
8000691e:	20e7a823          	sw	a4,528(a5)
}
80006922:	0001                	nop
80006924:	0141                	addi	sp,sp,16
80006926:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_is_enabled:

80006928 <pllctlv2_xtal_is_enabled>:
{
80006928:	1141                	addi	sp,sp,-16
8000692a:	c62a                	sw	a0,12(sp)
    return IS_HPM_BITMASK_SET(ptr->XTAL, PLLCTLV2_XTAL_ENABLE_MASK);
8000692c:	47b2                	lw	a5,12(sp)
8000692e:	4398                	lw	a4,0(a5)
80006930:	100007b7          	lui	a5,0x10000
80006934:	8ff9                	and	a5,a5,a4
80006936:	00f037b3          	snez	a5,a5
8000693a:	0ff7f793          	zext.b	a5,a5
}
8000693e:	853e                	mv	a0,a5
80006940:	0141                	addi	sp,sp,16
80006942:	8082                	ret

Disassembly of section .text.board_init_console:

80006944 <board_init_console>:
{
80006944:	1101                	addi	sp,sp,-32
80006946:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
80006948:	f0040537          	lui	a0,0xf0040
8000694c:	2259                	jal	80006ad2 <init_uart_pins>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
8000694e:	4581                	li	a1,0
80006950:	011907b7          	lui	a5,0x1190
80006954:	01578513          	addi	a0,a5,21 # 1190015 <_flash_size+0x1090015>
80006958:	e8cfd0ef          	jal	80003fe4 <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
8000695c:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t)BOARD_CONSOLE_UART_BASE;
8000695e:	f00407b7          	lui	a5,0xf0040
80006962:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
80006964:	011907b7          	lui	a5,0x1190
80006968:	01578513          	addi	a0,a5,21 # 1190015 <_flash_size+0x1090015>
8000696c:	3e7d                	jal	8000652a <clock_get_frequency>
8000696e:	87aa                	mv	a5,a0
80006970:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
80006972:	67f1                	lui	a5,0x1c
80006974:	20078793          	addi	a5,a5,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80006978:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
8000697a:	878a                	mv	a5,sp
8000697c:	853e                	mv	a0,a5
8000697e:	0e9000ef          	jal	80007266 <console_init>
80006982:	87aa                	mv	a5,a0
80006984:	c391                	beqz	a5,80006988 <.L45>

80006986 <.L44>:
        while (1) {
80006986:	a001                	j	80006986 <.L44>

80006988 <.L45>:
}
80006988:	0001                	nop
8000698a:	40f2                	lw	ra,28(sp)
8000698c:	6105                	addi	sp,sp,32
8000698e:	8082                	ret

Disassembly of section .text.board_init:

80006990 <board_init>:
{
80006990:	1141                	addi	sp,sp,-16
80006992:	c606                	sw	ra,12(sp)
    init_py_pins_as_pgpio();
80006994:	3545                	jal	80006834 <init_py_pins_as_pgpio>
    board_init_usb_dp_dm_pins();
80006996:	931fd0ef          	jal	800042c6 <board_init_usb_dp_dm_pins>
    board_init_clock();
8000699a:	2819                	jal	800069b0 <.LFE358>
    board_init_console();
8000699c:	3765                	jal	80006944 <board_init_console>
    board_init_pmp();
8000699e:	2a05                	jal	80006ace <board_init_pmp>
    board_print_clock_freq();
800069a0:	89dfd0ef          	jal	8000423c <board_print_clock_freq>
    board_print_banner();
800069a4:	857fd0ef          	jal	800041fa <board_print_banner>
}
800069a8:	0001                	nop
800069aa:	40b2                	lw	ra,12(sp)
800069ac:	0141                	addi	sp,sp,16
800069ae:	8082                	ret

Disassembly of section .text.board_init_clock:

800069b0 <board_init_clock>:
{
800069b0:	1101                	addi	sp,sp,-32
800069b2:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
800069b4:	6785                	lui	a5,0x1
800069b6:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x4b2>
800069ba:	3e85                	jal	8000652a <clock_get_frequency>
800069bc:	c62a                	sw	a0,12(sp)
    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
800069be:	4732                	lw	a4,12(sp)
800069c0:	016e37b7          	lui	a5,0x16e3
800069c4:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
800069c8:	00f71f63          	bne	a4,a5,800069e6 <.L57>
        pllctlv2_xtal_set_rampup_time(HPM_PLLCTLV2, 32UL * 1000UL * 9U);
800069cc:	000467b7          	lui	a5,0x46
800069d0:	50078593          	addi	a1,a5,1280 # 46500 <__ILM_segment_end__+0x26500>
800069d4:	f40c0537          	lui	a0,0xf40c0
800069d8:	ffcfd0ef          	jal	800041d4 <pllctlv2_xtal_set_rampup_time>
        sysctl_clock_set_preset(HPM_SYSCTL, 2);
800069dc:	4589                	li	a1,2
800069de:	f4000537          	lui	a0,0xf4000
800069e2:	f92fd0ef          	jal	80004174 <sysctl_clock_set_preset>

800069e6 <.L57>:
    clock_add_to_group(clock_cpu0, 0);
800069e6:	4581                	li	a1,0
800069e8:	6785                	lui	a5,0x1
800069ea:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x4b2>
800069ee:	df6fd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_add_to_group(clock_ahb, 0);
800069f2:	4581                	li	a1,0
800069f4:	fffd07b7          	lui	a5,0xfffd0
800069f8:	5fe78513          	addi	a0,a5,1534 # fffd05fe <__AHB_SRAM_segment_end__+0xfbc85fe>
800069fc:	de8fd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
80006a00:	4581                	li	a1,0
80006a02:	010117b7          	lui	a5,0x1011
80006a06:	90078513          	addi	a0,a5,-1792 # 1010900 <_flash_size+0xf10900>
80006a0a:	ddafd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
80006a0e:	4581                	li	a1,0
80006a10:	01020537          	lui	a0,0x1020
80006a14:	dd0fd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_add_to_group(clock_rom, 0);
80006a18:	4581                	li	a1,0
80006a1a:	010307b7          	lui	a5,0x1030
80006a1e:	50b78513          	addi	a0,a5,1291 # 103050b <_flash_size+0xf3050b>
80006a22:	dc2fd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_add_to_group(clock_mot0, 0);
80006a26:	4581                	li	a1,0
80006a28:	012d07b7          	lui	a5,0x12d0
80006a2c:	50578513          	addi	a0,a5,1285 # 12d0505 <_flash_size+0x11d0505>
80006a30:	db4fd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
80006a34:	4581                	li	a1,0
80006a36:	013107b7          	lui	a5,0x1310
80006a3a:	50978513          	addi	a0,a5,1289 # 1310509 <_flash_size+0x1210509>
80006a3e:	da6fd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
80006a42:	4581                	li	a1,0
80006a44:	013207b7          	lui	a5,0x1320
80006a48:	50a78513          	addi	a0,a5,1290 # 132050a <_flash_size+0x122050a>
80006a4c:	d98fd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
80006a50:	4581                	li	a1,0
80006a52:	013307b7          	lui	a5,0x1330
80006a56:	01d78513          	addi	a0,a5,29 # 133001d <_flash_size+0x123001d>
80006a5a:	d8afd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
80006a5e:	4581                	li	a1,0
80006a60:	010807b7          	lui	a5,0x1080
80006a64:	50e78513          	addi	a0,a5,1294 # 108050e <_flash_size+0xf8050e>
80006a68:	d7cfd0ef          	jal	80003fe4 <clock_add_to_group>
    clock_connect_group_to_cpu(0, 0);
80006a6c:	4581                	li	a1,0
80006a6e:	4501                	li	a0,0
80006a70:	339d                	jal	800067d6 <clock_connect_group_to_cpu>
    pcfg_dcdc_set_voltage(HPM_PCFG, 1275);
80006a72:	4fb00593          	li	a1,1275
80006a76:	f4104537          	lui	a0,0xf4104
80006a7a:	2755                	jal	8000721e <pcfg_dcdc_set_voltage>
    sysctl_config_cpu0_domain_clock(HPM_SYSCTL, clock_source_pll0_clk0, 2, 3);
80006a7c:	468d                	li	a3,3
80006a7e:	4609                	li	a2,2
80006a80:	4585                	li	a1,1
80006a82:	f4000537          	lui	a0,0xf4000
80006a86:	32fd                	jal	80006474 <sysctl_config_cpu0_domain_clock>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0, pllctlv2_div_1p0);    /* PLL0CLK0: 960MHz */
80006a88:	4681                	li	a3,0
80006a8a:	4601                	li	a2,0
80006a8c:	4581                	li	a1,0
80006a8e:	f40c0537          	lui	a0,0xf40c0
80006a92:	2305                	jal	80006fb2 <pllctlv2_set_postdiv>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1, pllctlv2_div_1p6);    /* PLL0CLK1: 600MHz */
80006a94:	468d                	li	a3,3
80006a96:	4605                	li	a2,1
80006a98:	4581                	li	a1,0
80006a9a:	f40c0537          	lui	a0,0xf40c0
80006a9e:	2b11                	jal	80006fb2 <pllctlv2_set_postdiv>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk2, pllctlv2_div_2p4);    /* PLL0CLK2: 400MHz */
80006aa0:	469d                	li	a3,7
80006aa2:	4609                	li	a2,2
80006aa4:	4581                	li	a1,0
80006aa6:	f40c0537          	lui	a0,0xf40c0
80006aaa:	2321                	jal	80006fb2 <pllctlv2_set_postdiv>
    pllctlv2_init_pll_with_freq(HPM_PLLCTLV2, pllctlv2_pll0, 960000000);
80006aac:	39387637          	lui	a2,0x39387
80006ab0:	4581                	li	a1,0
80006ab2:	f40c0537          	lui	a0,0xf40c0
80006ab6:	884fe0ef          	jal	80004b3a <pllctlv2_init_pll_with_freq>
    clock_update_core_clock();
80006aba:	3391                	jal	800067fe <clock_update_core_clock>
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
80006abc:	4605                	li	a2,1
80006abe:	4581                	li	a1,0
80006ac0:	01020537          	lui	a0,0x1020
80006ac4:	36dd                	jal	800066aa <clock_set_source_divider>
}
80006ac6:	0001                	nop
80006ac8:	40f2                	lw	ra,28(sp)
80006aca:	6105                	addi	sp,sp,32
80006acc:	8082                	ret

Disassembly of section .text.board_init_pmp:

80006ace <board_init_pmp>:

void board_init_pmp(void)
{
}
80006ace:	0001                	nop
80006ad0:	8082                	ret

Disassembly of section .text.init_uart_pins:

80006ad2 <init_uart_pins>:
    }
    return freq;
}

void init_uart_pins(UART_Type *ptr)
{
80006ad2:	1101                	addi	sp,sp,-32
80006ad4:	ce06                	sw	ra,28(sp)
80006ad6:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
80006ad8:	4732                	lw	a4,12(sp)
80006ada:	f00407b7          	lui	a5,0xf0040
80006ade:	00f71463          	bne	a4,a5,80006ae6 <.L153>
        init_uart0_pins();
80006ae2:	3b79                	jal	80006880 <init_uart0_pins>
        /* using for uart_lin function */
        init_uart3_pins();
    } else {
        ;
    }
}
80006ae4:	a839                	j	80006b02 <.L156>

80006ae6 <.L153>:
    } else if (ptr == HPM_UART2) {
80006ae6:	4732                	lw	a4,12(sp)
80006ae8:	f00487b7          	lui	a5,0xf0048
80006aec:	00f71563          	bne	a4,a5,80006af6 <.L155>
        init_uart2_pins();
80006af0:	dd4fd0ef          	jal	800040c4 <init_uart2_pins>
}
80006af4:	a039                	j	80006b02 <.L156>

80006af6 <.L155>:
    } else if (ptr == HPM_UART3) {
80006af6:	4732                	lw	a4,12(sp)
80006af8:	f004c7b7          	lui	a5,0xf004c
80006afc:	00f71363          	bne	a4,a5,80006b02 <.L156>
        init_uart3_pins();
80006b00:	3b51                	jal	80006894 <init_uart3_pins>

80006b02 <.L156>:
}
80006b02:	0001                	nop
80006b04:	40f2                	lw	ra,28(sp)
80006b06:	6105                	addi	sp,sp,32
80006b08:	8082                	ret

Disassembly of section .text.uart_modem_config:

80006b0a <uart_modem_config>:
{
80006b0a:	1141                	addi	sp,sp,-16
80006b0c:	c62a                	sw	a0,12(sp)
80006b0e:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80006b10:	47a2                	lw	a5,8(sp)
80006b12:	0007c783          	lbu	a5,0(a5) # f004c000 <__FLASH_segment_end__+0x6ff4c000>
80006b16:	0796                	slli	a5,a5,0x5
80006b18:	0207f713          	andi	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
80006b1c:	47a2                	lw	a5,8(sp)
80006b1e:	0017c783          	lbu	a5,1(a5)
80006b22:	0792                	slli	a5,a5,0x4
80006b24:	8bc1                	andi	a5,a5,16
80006b26:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
80006b28:	47a2                	lw	a5,8(sp)
80006b2a:	0027c783          	lbu	a5,2(a5)
80006b2e:	0017c793          	xori	a5,a5,1
80006b32:	0ff7f793          	zext.b	a5,a5
80006b36:	0786                	slli	a5,a5,0x1
80006b38:	8b89                	andi	a5,a5,2
80006b3a:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80006b3c:	47b2                	lw	a5,12(sp)
80006b3e:	db98                	sw	a4,48(a5)
}
80006b40:	0001                	nop
80006b42:	0141                	addi	sp,sp,16
80006b44:	8082                	ret

Disassembly of section .text.uart_disable_irq:

80006b46 <uart_disable_irq>:
{
80006b46:	1141                	addi	sp,sp,-16
80006b48:	c62a                	sw	a0,12(sp)
80006b4a:	c42e                	sw	a1,8(sp)
    ptr->IER &= ~irq_mask;
80006b4c:	47b2                	lw	a5,12(sp)
80006b4e:	53d8                	lw	a4,36(a5)
80006b50:	47a2                	lw	a5,8(sp)
80006b52:	fff7c793          	not	a5,a5
80006b56:	8f7d                	and	a4,a4,a5
80006b58:	47b2                	lw	a5,12(sp)
80006b5a:	d3d8                	sw	a4,36(a5)
}
80006b5c:	0001                	nop
80006b5e:	0141                	addi	sp,sp,16
80006b60:	8082                	ret

Disassembly of section .text.uart_enable_irq:

80006b62 <uart_enable_irq>:
{
80006b62:	1141                	addi	sp,sp,-16
80006b64:	c62a                	sw	a0,12(sp)
80006b66:	c42e                	sw	a1,8(sp)
    ptr->IER |= irq_mask;
80006b68:	47b2                	lw	a5,12(sp)
80006b6a:	53d8                	lw	a4,36(a5)
80006b6c:	47a2                	lw	a5,8(sp)
80006b6e:	8f5d                	or	a4,a4,a5
80006b70:	47b2                	lw	a5,12(sp)
80006b72:	d3d8                	sw	a4,36(a5)
}
80006b74:	0001                	nop
80006b76:	0141                	addi	sp,sp,16
80006b78:	8082                	ret

Disassembly of section .text.uart_default_config:

80006b7a <uart_default_config>:
{
80006b7a:	1141                	addi	sp,sp,-16
80006b7c:	c62a                	sw	a0,12(sp)
80006b7e:	c42e                	sw	a1,8(sp)
    config->baudrate = 115200;
80006b80:	47a2                	lw	a5,8(sp)
80006b82:	6771                	lui	a4,0x1c
80006b84:	20070713          	addi	a4,a4,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80006b88:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
80006b8a:	47a2                	lw	a5,8(sp)
80006b8c:	470d                	li	a4,3
80006b8e:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
80006b92:	47a2                	lw	a5,8(sp)
80006b94:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
80006b98:	47a2                	lw	a5,8(sp)
80006b9a:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
80006b9e:	47a2                	lw	a5,8(sp)
80006ba0:	4705                	li	a4,1
80006ba2:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
80006ba6:	47a2                	lw	a5,8(sp)
80006ba8:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
80006bac:	47a2                	lw	a5,8(sp)
80006bae:	473d                	li	a4,15
80006bb0:	00e785a3          	sb	a4,11(a5)
    config->dma_enable = false;
80006bb4:	47a2                	lw	a5,8(sp)
80006bb6:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
80006bba:	47a2                	lw	a5,8(sp)
80006bbc:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
80006bc0:	47a2                	lw	a5,8(sp)
80006bc2:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
80006bc6:	47a2                	lw	a5,8(sp)
80006bc8:	000788a3          	sb	zero,17(a5)
    config->rxidle_config.detect_enable = false;
80006bcc:	47a2                	lw	a5,8(sp)
80006bce:	00078923          	sb	zero,18(a5)
    config->rxidle_config.detect_irq_enable = false;
80006bd2:	47a2                	lw	a5,8(sp)
80006bd4:	000789a3          	sb	zero,19(a5)
    config->rxidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
80006bd8:	47a2                	lw	a5,8(sp)
80006bda:	00078a23          	sb	zero,20(a5)
    config->rxidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
80006bde:	47a2                	lw	a5,8(sp)
80006be0:	4729                	li	a4,10
80006be2:	00e78aa3          	sb	a4,21(a5)
    config->txidle_config.detect_enable = false;
80006be6:	47a2                	lw	a5,8(sp)
80006be8:	00078b23          	sb	zero,22(a5)
    config->txidle_config.detect_irq_enable = false;
80006bec:	47a2                	lw	a5,8(sp)
80006bee:	00078ba3          	sb	zero,23(a5)
    config->txidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
80006bf2:	47a2                	lw	a5,8(sp)
80006bf4:	00078c23          	sb	zero,24(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
80006bf8:	47a2                	lw	a5,8(sp)
80006bfa:	4729                	li	a4,10
80006bfc:	00e78ca3          	sb	a4,25(a5)
    config->rx_enable = true;
80006c00:	47a2                	lw	a5,8(sp)
80006c02:	4705                	li	a4,1
80006c04:	00e78d23          	sb	a4,26(a5)
}
80006c08:	0001                	nop
80006c0a:	0141                	addi	sp,sp,16
80006c0c:	8082                	ret

Disassembly of section .text.uart_flush:

80006c0e <uart_flush>:
{
80006c0e:	1101                	addi	sp,sp,-32
80006c10:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
80006c12:	ce02                	sw	zero,28(sp)
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80006c14:	a811                	j	80006c28 <.L60>

80006c16 <.L63>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
80006c16:	4772                	lw	a4,28(sp)
80006c18:	6785                	lui	a5,0x1
80006c1a:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80006c1e:	00e7eb63          	bltu	a5,a4,80006c34 <.L66>
        retry++;
80006c22:	47f2                	lw	a5,28(sp)
80006c24:	0785                	addi	a5,a5,1
80006c26:	ce3e                	sw	a5,28(sp)

80006c28 <.L60>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80006c28:	47b2                	lw	a5,12(sp)
80006c2a:	5bdc                	lw	a5,52(a5)
80006c2c:	0407f793          	andi	a5,a5,64
80006c30:	d3fd                	beqz	a5,80006c16 <.L63>
80006c32:	a011                	j	80006c36 <.L62>

80006c34 <.L66>:
            break;
80006c34:	0001                	nop

80006c36 <.L62>:
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
80006c36:	4772                	lw	a4,28(sp)
80006c38:	6785                	lui	a5,0x1
80006c3a:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80006c3e:	00e7f463          	bgeu	a5,a4,80006c46 <.L64>
        return status_timeout;
80006c42:	478d                	li	a5,3
80006c44:	a011                	j	80006c48 <.L65>

80006c46 <.L64>:
    return status_success;
80006c46:	4781                	li	a5,0

80006c48 <.L65>:
}
80006c48:	853e                	mv	a0,a5
80006c4a:	6105                	addi	sp,sp,32
80006c4c:	8082                	ret

Disassembly of section .text.uart_init_rxline_idle_detection:

80006c4e <uart_init_rxline_idle_detection>:
{
80006c4e:	1101                	addi	sp,sp,-32
80006c50:	ce06                	sw	ra,28(sp)
80006c52:	c62a                	sw	a0,12(sp)
80006c54:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_RX_IDLE_EN_MASK
80006c56:	47b2                	lw	a5,12(sp)
80006c58:	43dc                	lw	a5,4(a5)
80006c5a:	c007f713          	andi	a4,a5,-1024
80006c5e:	47b2                	lw	a5,12(sp)
80006c60:	c3d8                	sw	a4,4(a5)
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
80006c62:	47b2                	lw	a5,12(sp)
80006c64:	43d8                	lw	a4,4(a5)
80006c66:	00814783          	lbu	a5,8(sp)
80006c6a:	07a2                	slli	a5,a5,0x8
80006c6c:	1007f793          	andi	a5,a5,256
                    | UART_IDLE_CFG_RX_IDLE_THR_SET(rxidle_config.threshold)
80006c70:	00b14683          	lbu	a3,11(sp)
80006c74:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_RX_IDLE_COND_SET(rxidle_config.idle_cond);
80006c76:	00a14783          	lbu	a5,10(sp)
80006c7a:	07a6                	slli	a5,a5,0x9
80006c7c:	2007f793          	andi	a5,a5,512
80006c80:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
80006c82:	8f5d                	or	a4,a4,a5
80006c84:	47b2                	lw	a5,12(sp)
80006c86:	c3d8                	sw	a4,4(a5)
    if (rxidle_config.detect_irq_enable) {
80006c88:	00914783          	lbu	a5,9(sp)
80006c8c:	c791                	beqz	a5,80006c98 <.L93>
        uart_enable_irq(ptr, uart_intr_rx_line_idle);
80006c8e:	800005b7          	lui	a1,0x80000
80006c92:	4532                	lw	a0,12(sp)
80006c94:	35f9                	jal	80006b62 <uart_enable_irq>
80006c96:	a029                	j	80006ca0 <.L94>

80006c98 <.L93>:
        uart_disable_irq(ptr, uart_intr_rx_line_idle);
80006c98:	800005b7          	lui	a1,0x80000
80006c9c:	4532                	lw	a0,12(sp)
80006c9e:	3565                	jal	80006b46 <uart_disable_irq>

80006ca0 <.L94>:
    return status_success;
80006ca0:	4781                	li	a5,0
}
80006ca2:	853e                	mv	a0,a5
80006ca4:	40f2                	lw	ra,28(sp)
80006ca6:	6105                	addi	sp,sp,32
80006ca8:	8082                	ret

Disassembly of section .text.gptmr_channel_enable_monitor:

80006caa <gptmr_channel_enable_monitor>:
{
80006caa:	1141                	addi	sp,sp,-16
80006cac:	c62a                	sw	a0,12(sp)
80006cae:	87ae                	mv	a5,a1
80006cb0:	00f105a3          	sb	a5,11(sp)
    ptr->CHANNEL[ch_index].CR |= GPTMR_CHANNEL_CR_MONITOR_EN_MASK;
80006cb4:	00b14783          	lbu	a5,11(sp)
80006cb8:	4732                	lw	a4,12(sp)
80006cba:	079a                	slli	a5,a5,0x6
80006cbc:	97ba                	add	a5,a5,a4
80006cbe:	4394                	lw	a3,0(a5)
80006cc0:	00b14783          	lbu	a5,11(sp)
80006cc4:	6721                	lui	a4,0x8
80006cc6:	8f55                	or	a4,a4,a3
80006cc8:	46b2                	lw	a3,12(sp)
80006cca:	079a                	slli	a5,a5,0x6
80006ccc:	97b6                	add	a5,a5,a3
80006cce:	c398                	sw	a4,0(a5)
}
80006cd0:	0001                	nop
80006cd2:	0141                	addi	sp,sp,16
80006cd4:	8082                	ret

Disassembly of section .text.gptmr_channel_config:

80006cd6 <gptmr_channel_config>:

hpm_stat_t gptmr_channel_config(GPTMR_Type *ptr,
                         uint8_t ch_index,
                         gptmr_channel_config_t *config,
                         bool enable)
{
80006cd6:	7179                	addi	sp,sp,-48
80006cd8:	d606                	sw	ra,44(sp)
80006cda:	c62a                	sw	a0,12(sp)
80006cdc:	87ae                	mv	a5,a1
80006cde:	c232                	sw	a2,4(sp)
80006ce0:	8736                	mv	a4,a3
80006ce2:	00f105a3          	sb	a5,11(sp)
80006ce6:	87ba                	mv	a5,a4
80006ce8:	00f10523          	sb	a5,10(sp)
    uint32_t v = 0;
80006cec:	ce02                	sw	zero,28(sp)
    uint32_t tmp_value;

    if (config->enable_sync_follow_previous_channel && !ch_index) {
80006cee:	4792                	lw	a5,4(sp)
80006cf0:	0127c783          	lbu	a5,18(a5)
80006cf4:	c791                	beqz	a5,80006d00 <.L14>
80006cf6:	00b14783          	lbu	a5,11(sp)
80006cfa:	e399                	bnez	a5,80006d00 <.L14>
        return status_invalid_argument;
80006cfc:	4789                	li	a5,2
80006cfe:	aabd                	j	80006e7c <.L15>

80006d00 <.L14>:
    }

    if (config->dma_request_event != gptmr_dma_request_disabled) {
80006d00:	4792                	lw	a5,4(sp)
80006d02:	0017c703          	lbu	a4,1(a5)
80006d06:	0ff00793          	li	a5,255
80006d0a:	00f70d63          	beq	a4,a5,80006d24 <.L16>
        v |= GPTMR_CHANNEL_CR_DMAEN_MASK
            | GPTMR_CHANNEL_CR_DMASEL_SET(config->dma_request_event);
80006d0e:	4792                	lw	a5,4(sp)
80006d10:	0017c783          	lbu	a5,1(a5)
80006d14:	079a                	slli	a5,a5,0x6
80006d16:	0ff7f713          	zext.b	a4,a5
        v |= GPTMR_CHANNEL_CR_DMAEN_MASK
80006d1a:	47f2                	lw	a5,28(sp)
80006d1c:	8fd9                	or	a5,a5,a4
80006d1e:	0207e793          	ori	a5,a5,32
80006d22:	ce3e                	sw	a5,28(sp)

80006d24 <.L16>:
    }

    v |= GPTMR_CHANNEL_CR_CAPMODE_SET(config->mode)
80006d24:	4792                	lw	a5,4(sp)
80006d26:	0007c783          	lbu	a5,0(a5)
80006d2a:	0077f713          	andi	a4,a5,7
        | GPTMR_CHANNEL_CR_DBGPAUSE_SET(config->debug_mode)
80006d2e:	4792                	lw	a5,4(sp)
80006d30:	0147c783          	lbu	a5,20(a5)
80006d34:	078e                	slli	a5,a5,0x3
80006d36:	8ba1                	andi	a5,a5,8
80006d38:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_SWSYNCIEN_SET(config->enable_software_sync)
80006d3a:	4792                	lw	a5,4(sp)
80006d3c:	0137c783          	lbu	a5,19(a5)
80006d40:	0792                	slli	a5,a5,0x4
80006d42:	8bc1                	andi	a5,a5,16
80006d44:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_CMPINIT_SET(config->cmp_initial_polarity_high)
80006d46:	4792                	lw	a5,4(sp)
80006d48:	0107c783          	lbu	a5,16(a5)
80006d4c:	07a6                	slli	a5,a5,0x9
80006d4e:	2007f793          	andi	a5,a5,512
80006d52:	8f5d                	or	a4,a4,a5
        | GPTMR_CHANNEL_CR_SYNCFLW_SET(config->enable_sync_follow_previous_channel)
80006d54:	4792                	lw	a5,4(sp)
80006d56:	0127c783          	lbu	a5,18(a5)
80006d5a:	00d79693          	slli	a3,a5,0xd
80006d5e:	6789                	lui	a5,0x2
80006d60:	8ff5                	and	a5,a5,a3
80006d62:	8fd9                	or	a5,a5,a4
        | config->synci_edge;
80006d64:	4712                	lw	a4,4(sp)
80006d66:	00275703          	lhu	a4,2(a4) # 8002 <__AHB_SRAM_segment_size__+0x2>
80006d6a:	8fd9                	or	a5,a5,a4
    v |= GPTMR_CHANNEL_CR_CAPMODE_SET(config->mode)
80006d6c:	4772                	lw	a4,28(sp)
80006d6e:	8fd9                	or	a5,a5,a4
80006d70:	ce3e                	sw	a5,28(sp)
#if defined(HPM_IP_FEATURE_GPTMR_CNT_MODE) && (HPM_IP_FEATURE_GPTMR_CNT_MODE  == 1)
    v |= GPTMR_CHANNEL_CR_CNT_MODE_SET(config->counter_mode);
#endif
#if defined(HPM_IP_FEATURE_GPTMR_OP_MODE) && (HPM_IP_FEATURE_GPTMR_OP_MODE  == 1)
    v |= GPTMR_CHANNEL_CR_OPMODE_SET(config->enable_opmode);
80006d72:	4792                	lw	a5,4(sp)
80006d74:	0247c783          	lbu	a5,36(a5) # 2024 <__BOOT_HEADER_segment_size__+0x24>
80006d78:	01179713          	slli	a4,a5,0x11
80006d7c:	000207b7          	lui	a5,0x20
80006d80:	8ff9                	and	a5,a5,a4
80006d82:	4772                	lw	a4,28(sp)
80006d84:	8fd9                	or	a5,a5,a4
80006d86:	ce3e                	sw	a5,28(sp)

80006d88 <.LBB3>:
#endif
    for (uint8_t i = GPTMR_CH_CMP_COUNT; i > 0; i--) {
80006d88:	4789                	li	a5,2
80006d8a:	00f10ba3          	sb	a5,23(sp)
80006d8e:	a099                	j	80006dd4 <.L17>

80006d90 <.L19>:
        tmp_value = config->cmp[i - 1];
80006d90:	01714783          	lbu	a5,23(sp)
80006d94:	17fd                	addi	a5,a5,-1 # 1ffff <__DLM_segment_size__+0x2ff>
80006d96:	4712                	lw	a4,4(sp)
80006d98:	078a                	slli	a5,a5,0x2
80006d9a:	97ba                	add	a5,a5,a4
80006d9c:	43dc                	lw	a5,4(a5)
80006d9e:	cc3e                	sw	a5,24(sp)
        if ((tmp_value > 0)  && (tmp_value != 0xFFFFFFFFu)) {
80006da0:	47e2                	lw	a5,24(sp)
80006da2:	cb81                	beqz	a5,80006db2 <.L18>
80006da4:	4762                	lw	a4,24(sp)
80006da6:	57fd                	li	a5,-1
80006da8:	00f70563          	beq	a4,a5,80006db2 <.L18>
            tmp_value--;
80006dac:	47e2                	lw	a5,24(sp)
80006dae:	17fd                	addi	a5,a5,-1
80006db0:	cc3e                	sw	a5,24(sp)

80006db2 <.L18>:
        }
        ptr->CHANNEL[ch_index].CMP[i - 1] = GPTMR_CHANNEL_CMP_CMP_SET(tmp_value);
80006db2:	00b14683          	lbu	a3,11(sp)
80006db6:	01714783          	lbu	a5,23(sp)
80006dba:	17fd                	addi	a5,a5,-1
80006dbc:	4732                	lw	a4,12(sp)
80006dbe:	0692                	slli	a3,a3,0x4
80006dc0:	97b6                	add	a5,a5,a3
80006dc2:	078a                	slli	a5,a5,0x2
80006dc4:	97ba                	add	a5,a5,a4
80006dc6:	4762                	lw	a4,24(sp)
80006dc8:	c3d8                	sw	a4,4(a5)
    for (uint8_t i = GPTMR_CH_CMP_COUNT; i > 0; i--) {
80006dca:	01714783          	lbu	a5,23(sp)
80006dce:	17fd                	addi	a5,a5,-1
80006dd0:	00f10ba3          	sb	a5,23(sp)

80006dd4 <.L17>:
80006dd4:	01714783          	lbu	a5,23(sp)
80006dd8:	ffc5                	bnez	a5,80006d90 <.L19>

80006dda <.LBE3>:
    }
    tmp_value = config->reload;
80006dda:	4792                	lw	a5,4(sp)
80006ddc:	47dc                	lw	a5,12(a5)
80006dde:	cc3e                	sw	a5,24(sp)
    if ((tmp_value > 0) && (tmp_value != 0xFFFFFFFFu)) {
80006de0:	47e2                	lw	a5,24(sp)
80006de2:	cb81                	beqz	a5,80006df2 <.L20>
80006de4:	4762                	lw	a4,24(sp)
80006de6:	57fd                	li	a5,-1
80006de8:	00f70563          	beq	a4,a5,80006df2 <.L20>
        tmp_value--;
80006dec:	47e2                	lw	a5,24(sp)
80006dee:	17fd                	addi	a5,a5,-1
80006df0:	cc3e                	sw	a5,24(sp)

80006df2 <.L20>:
    }
    ptr->CHANNEL[ch_index].RLD = GPTMR_CHANNEL_RLD_RLD_SET(tmp_value);
80006df2:	00b14783          	lbu	a5,11(sp)
80006df6:	4732                	lw	a4,12(sp)
80006df8:	079a                	slli	a5,a5,0x6
80006dfa:	97ba                	add	a5,a5,a4
80006dfc:	4762                	lw	a4,24(sp)
80006dfe:	c7d8                	sw	a4,12(a5)
    ptr->CHANNEL[ch_index].CR = v;
80006e00:	00b14783          	lbu	a5,11(sp)
80006e04:	4732                	lw	a4,12(sp)
80006e06:	079a                	slli	a5,a5,0x6
80006e08:	97ba                	add	a5,a5,a4
80006e0a:	4772                	lw	a4,28(sp)
80006e0c:	c398                	sw	a4,0(a5)
    /* the initial polarity must be configured before enabling the output compare function */
    if (config->enable_cmp_output == true) {
80006e0e:	4792                	lw	a5,4(sp)
80006e10:	0117c783          	lbu	a5,17(a5)
80006e14:	c38d                	beqz	a5,80006e36 <.L21>
        v = ptr->CHANNEL[ch_index].CR | GPTMR_CHANNEL_CR_CMPEN_MASK | GPTMR_CHANNEL_CR_CEN_SET(enable);
80006e16:	00b14783          	lbu	a5,11(sp)
80006e1a:	4732                	lw	a4,12(sp)
80006e1c:	079a                	slli	a5,a5,0x6
80006e1e:	97ba                	add	a5,a5,a4
80006e20:	4398                	lw	a4,0(a5)
80006e22:	00a14783          	lbu	a5,10(sp)
80006e26:	07aa                	slli	a5,a5,0xa
80006e28:	4007f793          	andi	a5,a5,1024
80006e2c:	8fd9                	or	a5,a5,a4
80006e2e:	1007e793          	ori	a5,a5,256
80006e32:	ce3e                	sw	a5,28(sp)
80006e34:	a005                	j	80006e54 <.L22>

80006e36 <.L21>:
    } else {
        v = (ptr->CHANNEL[ch_index].CR & ~GPTMR_CHANNEL_CR_CMPEN_MASK) | GPTMR_CHANNEL_CR_CEN_SET(enable);
80006e36:	00b14783          	lbu	a5,11(sp)
80006e3a:	4732                	lw	a4,12(sp)
80006e3c:	079a                	slli	a5,a5,0x6
80006e3e:	97ba                	add	a5,a5,a4
80006e40:	439c                	lw	a5,0(a5)
80006e42:	eff7f713          	andi	a4,a5,-257
80006e46:	00a14783          	lbu	a5,10(sp)
80006e4a:	07aa                	slli	a5,a5,0xa
80006e4c:	4007f793          	andi	a5,a5,1024
80006e50:	8fd9                	or	a5,a5,a4
80006e52:	ce3e                	sw	a5,28(sp)

80006e54 <.L22>:
    }
    ptr->CHANNEL[ch_index].CR = v;
80006e54:	00b14783          	lbu	a5,11(sp)
80006e58:	4732                	lw	a4,12(sp)
80006e5a:	079a                	slli	a5,a5,0x6
80006e5c:	97ba                	add	a5,a5,a4
80006e5e:	4772                	lw	a4,28(sp)
80006e60:	c398                	sw	a4,0(a5)
#if defined(HPM_IP_FEATURE_GPTMR_MONITOR) && (HPM_IP_FEATURE_GPTMR_MONITOR  == 1)
    gptmr_channel_monitor_config(ptr, ch_index, &config->monitor_config, config->enable_monitor);
80006e62:	4792                	lw	a5,4(sp)
80006e64:	01878713          	addi	a4,a5,24
80006e68:	4792                	lw	a5,4(sp)
80006e6a:	0157c683          	lbu	a3,21(a5)
80006e6e:	00b14783          	lbu	a5,11(sp)
80006e72:	863a                	mv	a2,a4
80006e74:	85be                	mv	a1,a5
80006e76:	4532                	lw	a0,12(sp)
80006e78:	2035                	jal	80006ea4 <gptmr_channel_monitor_config>
#endif

    return status_success;
80006e7a:	4781                	li	a5,0

80006e7c <.L15>:
}
80006e7c:	853e                	mv	a0,a5
80006e7e:	50b2                	lw	ra,44(sp)
80006e80:	6145                	addi	sp,sp,48
80006e82:	8082                	ret

Disassembly of section .text.gptmr_channel_get_default_monitor_config:

80006e84 <gptmr_channel_get_default_monitor_config>:

#if defined(HPM_IP_FEATURE_GPTMR_MONITOR) && (HPM_IP_FEATURE_GPTMR_MONITOR  == 1)
void gptmr_channel_get_default_monitor_config(GPTMR_Type *ptr, gptmr_channel_monitor_config_t *config)
{
80006e84:	1141                	addi	sp,sp,-16
80006e86:	c62a                	sw	a0,12(sp)
80006e88:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->max_value = 0;
80006e8a:	47a2                	lw	a5,8(sp)
80006e8c:	0007a223          	sw	zero,4(a5)
    config->min_value = 0;
80006e90:	47a2                	lw	a5,8(sp)
80006e92:	0007a423          	sw	zero,8(a5)
    config->monitor_type = monitor_signal_high_level_time;
80006e96:	47a2                	lw	a5,8(sp)
80006e98:	4705                	li	a4,1
80006e9a:	00e78023          	sb	a4,0(a5)
}
80006e9e:	0001                	nop
80006ea0:	0141                	addi	sp,sp,16
80006ea2:	8082                	ret

Disassembly of section .text.gptmr_channel_monitor_config:

80006ea4 <gptmr_channel_monitor_config>:

hpm_stat_t gptmr_channel_monitor_config(GPTMR_Type *ptr, uint8_t ch_index, gptmr_channel_monitor_config_t *config, bool enable)
{
80006ea4:	1101                	addi	sp,sp,-32
80006ea6:	ce06                	sw	ra,28(sp)
80006ea8:	c62a                	sw	a0,12(sp)
80006eaa:	87ae                	mv	a5,a1
80006eac:	c232                	sw	a2,4(sp)
80006eae:	8736                	mv	a4,a3
80006eb0:	00f105a3          	sb	a5,11(sp)
80006eb4:	87ba                	mv	a5,a4
80006eb6:	00f10523          	sb	a5,10(sp)
    if ((ptr == NULL) || (config->max_value < config->min_value)) {
80006eba:	47b2                	lw	a5,12(sp)
80006ebc:	c799                	beqz	a5,80006eca <.L25>
80006ebe:	4792                	lw	a5,4(sp)
80006ec0:	43d8                	lw	a4,4(a5)
80006ec2:	4792                	lw	a5,4(sp)
80006ec4:	479c                	lw	a5,8(a5)
80006ec6:	00f77463          	bgeu	a4,a5,80006ece <.L26>

80006eca <.L25>:
        return status_invalid_argument;
80006eca:	4789                	li	a5,2
80006ecc:	a059                	j	80006f52 <.L27>

80006ece <.L26>:
    }
    if (enable == true) {
80006ece:	00a14783          	lbu	a5,10(sp)
80006ed2:	cbad                	beqz	a5,80006f44 <.L28>
        gptmr_channel_set_monitor_type(ptr, ch_index, config->monitor_type);
80006ed4:	4792                	lw	a5,4(sp)
80006ed6:	0007c703          	lbu	a4,0(a5)
80006eda:	00b14783          	lbu	a5,11(sp)
80006ede:	863a                	mv	a2,a4
80006ee0:	85be                	mv	a1,a5
80006ee2:	4532                	lw	a0,12(sp)
80006ee4:	b3dfd0ef          	jal	80004a20 <gptmr_channel_set_monitor_type>
        gptmr_update_cmp(ptr, ch_index, 0, config->min_value);
80006ee8:	4792                	lw	a5,4(sp)
80006eea:	4798                	lw	a4,8(a5)
80006eec:	00b14783          	lbu	a5,11(sp)
80006ef0:	86ba                	mv	a3,a4
80006ef2:	4601                	li	a2,0
80006ef4:	85be                	mv	a1,a5
80006ef6:	4532                	lw	a0,12(sp)
80006ef8:	a87fd0ef          	jal	8000497e <gptmr_update_cmp>
        gptmr_update_cmp(ptr, ch_index, 1, config->max_value);
80006efc:	4792                	lw	a5,4(sp)
80006efe:	43d8                	lw	a4,4(a5)
80006f00:	00b14783          	lbu	a5,11(sp)
80006f04:	86ba                	mv	a3,a4
80006f06:	4605                	li	a2,1
80006f08:	85be                	mv	a1,a5
80006f0a:	4532                	lw	a0,12(sp)
80006f0c:	a73fd0ef          	jal	8000497e <gptmr_update_cmp>
        gptmr_channel_config_update_reload(ptr, ch_index, 0xFFFFFFFF);
80006f10:	00b14783          	lbu	a5,11(sp)
80006f14:	567d                	li	a2,-1
80006f16:	85be                	mv	a1,a5
80006f18:	4532                	lw	a0,12(sp)
80006f1a:	aa7fd0ef          	jal	800049c0 <gptmr_channel_config_update_reload>
        gptmr_channel_set_capmode(ptr, ch_index, gptmr_work_mode_measure_width);
80006f1e:	00b14783          	lbu	a5,11(sp)
80006f22:	4611                	li	a2,4
80006f24:	85be                	mv	a1,a5
80006f26:	4532                	lw	a0,12(sp)
80006f28:	a19fd0ef          	jal	80004940 <gptmr_channel_set_capmode>
        gptmr_channel_reset_count(ptr, ch_index);
80006f2c:	00b14783          	lbu	a5,11(sp)
80006f30:	85be                	mv	a1,a5
80006f32:	4532                	lw	a0,12(sp)
80006f34:	9c3fd0ef          	jal	800048f6 <gptmr_channel_reset_count>
        gptmr_channel_enable_monitor(ptr, ch_index);
80006f38:	00b14783          	lbu	a5,11(sp)
80006f3c:	85be                	mv	a1,a5
80006f3e:	4532                	lw	a0,12(sp)
80006f40:	33ad                	jal	80006caa <gptmr_channel_enable_monitor>
80006f42:	a039                	j	80006f50 <.L29>

80006f44 <.L28>:
    } else {
        gptmr_channel_disable_monitor(ptr, ch_index);
80006f44:	00b14783          	lbu	a5,11(sp)
80006f48:	85be                	mv	a1,a5
80006f4a:	4532                	lw	a0,12(sp)
80006f4c:	aa7fd0ef          	jal	800049f2 <gptmr_channel_disable_monitor>

80006f50 <.L29>:
    }
    return status_success;
80006f50:	4781                	li	a5,0

80006f52 <.L27>:
}
80006f52:	853e                	mv	a0,a5
80006f54:	40f2                	lw	ra,28(sp)
80006f56:	6105                	addi	sp,sp,32
80006f58:	8082                	ret

Disassembly of section .text.pllctlv2_pll_clk_is_stable:

80006f5a <pllctlv2_pll_clk_is_stable>:
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @param [in] clk Post-divider output index (pllctlv2_clk0 through pllctlv2_clk3)
 * @return true if the PLL CLK is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_clk_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
80006f5a:	1101                	addi	sp,sp,-32
80006f5c:	c62a                	sw	a0,12(sp)
80006f5e:	87ae                	mv	a5,a1
80006f60:	8732                	mv	a4,a2
80006f62:	00f105a3          	sb	a5,11(sp)
80006f66:	87ba                	mv	a5,a4
80006f68:	00f10523          	sb	a5,10(sp)
    uint32_t status = ptr->PLL[pll].DIV[clk];
80006f6c:	00b14683          	lbu	a3,11(sp)
80006f70:	00a14783          	lbu	a5,10(sp)
80006f74:	4732                	lw	a4,12(sp)
80006f76:	0696                	slli	a3,a3,0x5
80006f78:	97b6                	add	a5,a5,a3
80006f7a:	03078793          	addi	a5,a5,48
80006f7e:	078a                	slli	a5,a5,0x2
80006f80:	97ba                	add	a5,a5,a4
80006f82:	439c                	lw	a5,0(a5)
80006f84:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_ENABLE_MASK)
80006f86:	4772                	lw	a4,28(sp)
80006f88:	100007b7          	lui	a5,0x10000
80006f8c:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_DIV_RESPONSE_MASK)));
80006f8e:	cb89                	beqz	a5,80006fa0 <.L7>
80006f90:	47f2                	lw	a5,28(sp)
80006f92:	0007c963          	bltz	a5,80006fa4 <.L8>
80006f96:	4772                	lw	a4,28(sp)
80006f98:	200007b7          	lui	a5,0x20000
80006f9c:	8ff9                	and	a5,a5,a4
80006f9e:	c399                	beqz	a5,80006fa4 <.L8>

80006fa0 <.L7>:
80006fa0:	4785                	li	a5,1
80006fa2:	a011                	j	80006fa6 <.L9>

80006fa4 <.L8>:
80006fa4:	4781                	li	a5,0

80006fa6 <.L9>:
80006fa6:	8b85                	andi	a5,a5,1
80006fa8:	0ff7f793          	zext.b	a5,a5
}
80006fac:	853e                	mv	a0,a5
80006fae:	6105                	addi	sp,sp,32
80006fb0:	8082                	ret

Disassembly of section .text.pllctlv2_set_postdiv:

80006fb2 <pllctlv2_set_postdiv>:
        ptr->PLL[pll].CONFIG |= PLLCTLV2_PLL_CONFIG_SPREAD_MASK;
    }
}

void pllctlv2_set_postdiv(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk, pllctlv2_div_t div_value)
{
80006fb2:	1101                	addi	sp,sp,-32
80006fb4:	ce06                	sw	ra,28(sp)
80006fb6:	c62a                	sw	a0,12(sp)
80006fb8:	87ae                	mv	a5,a1
80006fba:	8736                	mv	a4,a3
80006fbc:	00f105a3          	sb	a5,11(sp)
80006fc0:	87b2                	mv	a5,a2
80006fc2:	00f10523          	sb	a5,10(sp)
80006fc6:	87ba                	mv	a5,a4
80006fc8:	00f104a3          	sb	a5,9(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80006fcc:	47b2                	lw	a5,12(sp)
80006fce:	c7ad                	beqz	a5,80007038 <.L32>
80006fd0:	00b14703          	lbu	a4,11(sp)
80006fd4:	4785                	li	a5,1
80006fd6:	06e7e163          	bltu	a5,a4,80007038 <.L32>
        ptr->PLL[pll].DIV[clk] =
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
80006fda:	00b14683          	lbu	a3,11(sp)
80006fde:	00a14783          	lbu	a5,10(sp)
80006fe2:	4732                	lw	a4,12(sp)
80006fe4:	0696                	slli	a3,a3,0x5
80006fe6:	97b6                	add	a5,a5,a3
80006fe8:	03078793          	addi	a5,a5,48 # 20000030 <_flash_size+0x1ff00030>
80006fec:	078a                	slli	a5,a5,0x2
80006fee:	97ba                	add	a5,a5,a4
80006ff0:	439c                	lw	a5,0(a5)
80006ff2:	fc07f693          	andi	a3,a5,-64
80006ff6:	00914783          	lbu	a5,9(sp)
80006ffa:	03f7f713          	andi	a4,a5,63
        ptr->PLL[pll].DIV[clk] =
80006ffe:	00b14603          	lbu	a2,11(sp)
80007002:	00a14783          	lbu	a5,10(sp)
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
80007006:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].DIV[clk] =
80007008:	46b2                	lw	a3,12(sp)
8000700a:	0616                	slli	a2,a2,0x5
8000700c:	97b2                	add	a5,a5,a2
8000700e:	03078793          	addi	a5,a5,48
80007012:	078a                	slli	a5,a5,0x2
80007014:	97b6                	add	a5,a5,a3
80007016:	c398                	sw	a4,0(a5)

        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
80007018:	a011                	j	8000701c <.L30>

8000701a <.L31>:
            NOP();
8000701a:	0001                	nop

8000701c <.L30>:
        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
8000701c:	00a14703          	lbu	a4,10(sp)
80007020:	00b14783          	lbu	a5,11(sp)
80007024:	863a                	mv	a2,a4
80007026:	85be                	mv	a1,a5
80007028:	4532                	lw	a0,12(sp)
8000702a:	3f05                	jal	80006f5a <pllctlv2_pll_clk_is_stable>
8000702c:	87aa                	mv	a5,a0
8000702e:	0017c793          	xori	a5,a5,1
80007032:	0ff7f793          	zext.b	a5,a5
80007036:	f3f5                	bnez	a5,8000701a <.L31>

80007038 <.L32>:
        }
    }
}
80007038:	0001                	nop
8000703a:	40f2                	lw	ra,28(sp)
8000703c:	6105                	addi	sp,sp,32
8000703e:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_freq_in_hz:

80007040 <pllctlv2_get_pll_freq_in_hz>:

uint32_t pllctlv2_get_pll_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
80007040:	7139                	addi	sp,sp,-64
80007042:	de06                	sw	ra,60(sp)
80007044:	c62a                	sw	a0,12(sp)
80007046:	87ae                	mv	a5,a1
80007048:	00f105a3          	sb	a5,11(sp)
    uint32_t freq = 0;
8000704c:	d602                	sw	zero,44(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
8000704e:	47b2                	lw	a5,12(sp)
80007050:	12078963          	beqz	a5,80007182 <.L34>
80007054:	00b14703          	lbu	a4,11(sp)
80007058:	4785                	li	a5,1
8000705a:	12e7e463          	bltu	a5,a4,80007182 <.L34>

8000705e <.LBB3>:
        uint32_t mfi = PLLCTLV2_PLL_MFI_MFI_GET(ptr->PLL[pll].MFI);
8000705e:	00b14783          	lbu	a5,11(sp)
80007062:	4732                	lw	a4,12(sp)
80007064:	0785                	addi	a5,a5,1
80007066:	079e                	slli	a5,a5,0x7
80007068:	97ba                	add	a5,a5,a4
8000706a:	439c                	lw	a5,0(a5)
8000706c:	07f7f793          	andi	a5,a5,127
80007070:	d23e                	sw	a5,36(sp)
        uint32_t mfn = PLLCTLV2_PLL_MFN_MFN_GET(ptr->PLL[pll].MFN);
80007072:	00b14783          	lbu	a5,11(sp)
80007076:	4732                	lw	a4,12(sp)
80007078:	0785                	addi	a5,a5,1
8000707a:	079e                	slli	a5,a5,0x7
8000707c:	97ba                	add	a5,a5,a4
8000707e:	43d8                	lw	a4,4(a5)
80007080:	400007b7          	lui	a5,0x40000
80007084:	17fd                	addi	a5,a5,-1 # 3fffffff <_flash_size+0x3fefffff>
80007086:	8ff9                	and	a5,a5,a4
80007088:	d03e                	sw	a5,32(sp)
        uint32_t mfd = PLLCTLV2_PLL_MFD_MFD_GET(ptr->PLL[pll].MFD);
8000708a:	00b14783          	lbu	a5,11(sp)
8000708e:	4732                	lw	a4,12(sp)
80007090:	0785                	addi	a5,a5,1
80007092:	079e                	slli	a5,a5,0x7
80007094:	97ba                	add	a5,a5,a4
80007096:	4798                	lw	a4,8(a5)
80007098:	400007b7          	lui	a5,0x40000
8000709c:	17fd                	addi	a5,a5,-1 # 3fffffff <_flash_size+0x3fefffff>
8000709e:	8ff9                	and	a5,a5,a4
800070a0:	ce3e                	sw	a5,28(sp)
        /* Trade-off for avoiding the float computing.
         * Ensure both `mfd` and `PLLCTLV2_PLL_XTAL_FREQ` are n * `FREQ_1MHz`, n is a positive integer
         */
        assert((mfd / FREQ_1MHz) * FREQ_1MHz == mfd);
800070a2:	4772                	lw	a4,28(sp)
800070a4:	431be7b7          	lui	a5,0x431be
800070a8:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
800070ac:	02f737b3          	mulhu	a5,a4,a5
800070b0:	83c9                	srli	a5,a5,0x12
800070b2:	000f46b7          	lui	a3,0xf4
800070b6:	24068693          	addi	a3,a3,576 # f4240 <__DLM_segment_end__+0x54240>
800070ba:	02d787b3          	mul	a5,a5,a3
800070be:	40f707b3          	sub	a5,a4,a5
800070c2:	cb89                	beqz	a5,800070d4 <.L35>
800070c4:	06f00613          	li	a2,111
800070c8:	06418593          	addi	a1,gp,100 # 800038f4 <.LC0>
800070cc:	0cc18513          	addi	a0,gp,204 # 8000395c <.LC1>
800070d0:	b95fd0ef          	jal	80004c64 <__SEGGER_RTL_X_assert>

800070d4 <.L35>:
        assert((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * FREQ_1MHz == PLLCTLV2_PLL_XTAL_FREQ);

        uint32_t scaled_num;
        uint32_t scaled_denom;
        uint32_t shifted_mfn;
        uint32_t max_mfn = 0xFFFFFFFF / (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz);
800070d4:	0aaab7b7          	lui	a5,0xaaab
800070d8:	aaa78793          	addi	a5,a5,-1366 # aaaaaaa <_flash_size+0xa9aaaaa>
800070dc:	cc3e                	sw	a5,24(sp)
        if (mfn < max_mfn) {
800070de:	5702                	lw	a4,32(sp)
800070e0:	47e2                	lw	a5,24(sp)
800070e2:	02f77f63          	bgeu	a4,a5,80007120 <.L36>
            scaled_num =  (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * mfn;
800070e6:	5702                	lw	a4,32(sp)
800070e8:	87ba                	mv	a5,a4
800070ea:	0786                	slli	a5,a5,0x1
800070ec:	97ba                	add	a5,a5,a4
800070ee:	078e                	slli	a5,a5,0x3
800070f0:	c83e                	sw	a5,16(sp)
            scaled_denom = mfd / FREQ_1MHz;
800070f2:	4772                	lw	a4,28(sp)
800070f4:	431be7b7          	lui	a5,0x431be
800070f8:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
800070fc:	02f737b3          	mulhu	a5,a4,a5
80007100:	83c9                	srli	a5,a5,0x12
80007102:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + scaled_num / scaled_denom;
80007104:	5712                	lw	a4,36(sp)
80007106:	016e37b7          	lui	a5,0x16e3
8000710a:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
8000710e:	02f70733          	mul	a4,a4,a5
80007112:	46c2                	lw	a3,16(sp)
80007114:	47d2                	lw	a5,20(sp)
80007116:	02f6d7b3          	divu	a5,a3,a5
8000711a:	97ba                	add	a5,a5,a4
8000711c:	d63e                	sw	a5,44(sp)
8000711e:	a095                	j	80007182 <.L34>

80007120 <.L36>:
        } else {
            shifted_mfn = mfn;
80007120:	5782                	lw	a5,32(sp)
80007122:	d43e                	sw	a5,40(sp)
            while (shifted_mfn > max_mfn) {
80007124:	a021                	j	8000712c <.L37>

80007126 <.L38>:
                shifted_mfn >>= 1;
80007126:	57a2                	lw	a5,40(sp)
80007128:	8385                	srli	a5,a5,0x1
8000712a:	d43e                	sw	a5,40(sp)

8000712c <.L37>:
            while (shifted_mfn > max_mfn) {
8000712c:	5722                	lw	a4,40(sp)
8000712e:	47e2                	lw	a5,24(sp)
80007130:	fee7ebe3          	bltu	a5,a4,80007126 <.L38>
            }
            scaled_denom = mfd / FREQ_1MHz;
80007134:	4772                	lw	a4,28(sp)
80007136:	431be7b7          	lui	a5,0x431be
8000713a:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
8000713e:	02f737b3          	mulhu	a5,a4,a5
80007142:	83c9                	srli	a5,a5,0x12
80007144:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * shifted_mfn) / scaled_denom +  ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * (mfn - shifted_mfn)) / scaled_denom;
80007146:	5712                	lw	a4,36(sp)
80007148:	016e37b7          	lui	a5,0x16e3
8000714c:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80007150:	02f706b3          	mul	a3,a4,a5
80007154:	5722                	lw	a4,40(sp)
80007156:	87ba                	mv	a5,a4
80007158:	0786                	slli	a5,a5,0x1
8000715a:	97ba                	add	a5,a5,a4
8000715c:	078e                	slli	a5,a5,0x3
8000715e:	873e                	mv	a4,a5
80007160:	47d2                	lw	a5,20(sp)
80007162:	02f757b3          	divu	a5,a4,a5
80007166:	96be                	add	a3,a3,a5
80007168:	5702                	lw	a4,32(sp)
8000716a:	57a2                	lw	a5,40(sp)
8000716c:	8f1d                	sub	a4,a4,a5
8000716e:	87ba                	mv	a5,a4
80007170:	0786                	slli	a5,a5,0x1
80007172:	97ba                	add	a5,a5,a4
80007174:	078e                	slli	a5,a5,0x3
80007176:	873e                	mv	a4,a5
80007178:	47d2                	lw	a5,20(sp)
8000717a:	02f757b3          	divu	a5,a4,a5
8000717e:	97b6                	add	a5,a5,a3
80007180:	d63e                	sw	a5,44(sp)

80007182 <.L34>:
        }
    }
    return freq;
80007182:	57b2                	lw	a5,44(sp)
}
80007184:	853e                	mv	a0,a5
80007186:	50f2                	lw	ra,60(sp)
80007188:	6121                	addi	sp,sp,64
8000718a:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_postdiv_freq_in_hz:

8000718c <pllctlv2_get_pll_postdiv_freq_in_hz>:

uint32_t pllctlv2_get_pll_postdiv_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
8000718c:	7179                	addi	sp,sp,-48
8000718e:	d606                	sw	ra,44(sp)
80007190:	c62a                	sw	a0,12(sp)
80007192:	87ae                	mv	a5,a1
80007194:	8732                	mv	a4,a2
80007196:	00f105a3          	sb	a5,11(sp)
8000719a:	87ba                	mv	a5,a4
8000719c:	00f10523          	sb	a5,10(sp)
    uint32_t postdiv_freq = 0;
800071a0:	ce02                	sw	zero,28(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
800071a2:	47b2                	lw	a5,12(sp)
800071a4:	cba5                	beqz	a5,80007214 <.L41>
800071a6:	00b14703          	lbu	a4,11(sp)
800071aa:	4785                	li	a5,1
800071ac:	06e7e463          	bltu	a5,a4,80007214 <.L41>

800071b0 <.LBB4>:
        uint32_t postdiv = PLLCTLV2_PLL_DIV_DIV_GET(ptr->PLL[pll].DIV[clk]);
800071b0:	00b14683          	lbu	a3,11(sp)
800071b4:	00a14783          	lbu	a5,10(sp)
800071b8:	4732                	lw	a4,12(sp)
800071ba:	0696                	slli	a3,a3,0x5
800071bc:	97b6                	add	a5,a5,a3
800071be:	03078793          	addi	a5,a5,48
800071c2:	078a                	slli	a5,a5,0x2
800071c4:	97ba                	add	a5,a5,a4
800071c6:	439c                	lw	a5,0(a5)
800071c8:	03f7f793          	andi	a5,a5,63
800071cc:	cc3e                	sw	a5,24(sp)
        uint32_t pll_freq = pllctlv2_get_pll_freq_in_hz(ptr, pll);
800071ce:	00b14783          	lbu	a5,11(sp)
800071d2:	85be                	mv	a1,a5
800071d4:	4532                	lw	a0,12(sp)
800071d6:	35ad                	jal	80007040 <pllctlv2_get_pll_freq_in_hz>
800071d8:	ca2a                	sw	a0,20(sp)
        postdiv_freq = (uint32_t) (pll_freq / (100 + postdiv * 100 / 5U) * 100);
800071da:	4762                	lw	a4,24(sp)
800071dc:	87ba                	mv	a5,a4
800071de:	078a                	slli	a5,a5,0x2
800071e0:	97ba                	add	a5,a5,a4
800071e2:	00279713          	slli	a4,a5,0x2
800071e6:	97ba                	add	a5,a5,a4
800071e8:	078a                	slli	a5,a5,0x2
800071ea:	873e                	mv	a4,a5
800071ec:	ccccd7b7          	lui	a5,0xccccd
800071f0:	ccd78793          	addi	a5,a5,-819 # cccccccd <__FLASH_segment_end__+0x4cbccccd>
800071f4:	02f737b3          	mulhu	a5,a4,a5
800071f8:	8389                	srli	a5,a5,0x2
800071fa:	06478793          	addi	a5,a5,100
800071fe:	4752                	lw	a4,20(sp)
80007200:	02f75733          	divu	a4,a4,a5
80007204:	87ba                	mv	a5,a4
80007206:	078a                	slli	a5,a5,0x2
80007208:	97ba                	add	a5,a5,a4
8000720a:	00279713          	slli	a4,a5,0x2
8000720e:	97ba                	add	a5,a5,a4
80007210:	078a                	slli	a5,a5,0x2
80007212:	ce3e                	sw	a5,28(sp)

80007214 <.L41>:
    }

    return postdiv_freq;
80007214:	47f2                	lw	a5,28(sp)
}
80007216:	853e                	mv	a0,a5
80007218:	50b2                	lw	ra,44(sp)
8000721a:	6145                	addi	sp,sp,48
8000721c:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

8000721e <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
8000721e:	1101                	addi	sp,sp,-32
80007220:	c62a                	sw	a0,12(sp)
80007222:	87ae                	mv	a5,a1
80007224:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80007228:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
8000722a:	00a15703          	lhu	a4,10(sp)
8000722e:	25700793          	li	a5,599
80007232:	00e7f863          	bgeu	a5,a4,80007242 <.L26>
80007236:	00a15703          	lhu	a4,10(sp)
8000723a:	55f00793          	li	a5,1375
8000723e:	00e7f463          	bgeu	a5,a4,80007246 <.L27>

80007242 <.L26>:
        return status_invalid_argument;
80007242:	4789                	li	a5,2
80007244:	a831                	j	80007260 <.L28>

80007246 <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
80007246:	47b2                	lw	a5,12(sp)
80007248:	4b98                	lw	a4,16(a5)
8000724a:	77fd                	lui	a5,0xfffff
8000724c:	8f7d                	and	a4,a4,a5
8000724e:	00a15683          	lhu	a3,10(sp)
80007252:	6785                	lui	a5,0x1
80007254:	17fd                	addi	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
80007256:	8ff5                	and	a5,a5,a3
80007258:	8f5d                	or	a4,a4,a5
8000725a:	47b2                	lw	a5,12(sp)
8000725c:	cb98                	sw	a4,16(a5)
    return stat;
8000725e:	47f2                	lw	a5,28(sp)

80007260 <.L28>:
}
80007260:	853e                	mv	a0,a5
80007262:	6105                	addi	sp,sp,32
80007264:	8082                	ret

Disassembly of section .text.console_init:

80007266 <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
80007266:	7139                	addi	sp,sp,-64
80007268:	de06                	sw	ra,60(sp)
8000726a:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
8000726c:	4785                	li	a5,1
8000726e:	d63e                	sw	a5,44(sp)

    /* disable buffer in standard library */
    setvbuf(stdin, NULL, _IONBF, 0);
80007270:	000807b7          	lui	a5,0x80
80007274:	3587a783          	lw	a5,856(a5) # 80358 <stdin>
80007278:	4681                	li	a3,0
8000727a:	4609                	li	a2,2
8000727c:	4581                	li	a1,0
8000727e:	853e                	mv	a0,a5
80007280:	24b9                	jal	800074ce <setvbuf>
    setvbuf(stdout, NULL, _IONBF, 0);
80007282:	000807b7          	lui	a5,0x80
80007286:	3547a783          	lw	a5,852(a5) # 80354 <stdout>
8000728a:	4681                	li	a3,0
8000728c:	4609                	li	a2,2
8000728e:	4581                	li	a1,0
80007290:	853e                	mv	a0,a5
80007292:	2c35                	jal	800074ce <setvbuf>

    if (cfg->type == CONSOLE_TYPE_UART) {
80007294:	47b2                	lw	a5,12(sp)
80007296:	439c                	lw	a5,0(a5)
80007298:	e7b9                	bnez	a5,800072e6 <.L2>

8000729a <.LBB2>:
        uart_config_t config = {0};
8000729a:	c802                	sw	zero,16(sp)
8000729c:	ca02                	sw	zero,20(sp)
8000729e:	cc02                	sw	zero,24(sp)
800072a0:	ce02                	sw	zero,28(sp)
800072a2:	d002                	sw	zero,32(sp)
800072a4:	d202                	sw	zero,36(sp)
800072a6:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
800072a8:	47b2                	lw	a5,12(sp)
800072aa:	43dc                	lw	a5,4(a5)
800072ac:	873e                	mv	a4,a5
800072ae:	081c                	addi	a5,sp,16
800072b0:	85be                	mv	a1,a5
800072b2:	853a                	mv	a0,a4
800072b4:	30d9                	jal	80006b7a <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
800072b6:	47b2                	lw	a5,12(sp)
800072b8:	479c                	lw	a5,8(a5)
800072ba:	c83e                	sw	a5,16(sp)
        config.baudrate = cfg->baudrate;
800072bc:	47b2                	lw	a5,12(sp)
800072be:	47dc                	lw	a5,12(a5)
800072c0:	ca3e                	sw	a5,20(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
800072c2:	47b2                	lw	a5,12(sp)
800072c4:	43dc                	lw	a5,4(a5)
800072c6:	873e                	mv	a4,a5
800072c8:	081c                	addi	a5,sp,16
800072ca:	85be                	mv	a1,a5
800072cc:	853a                	mv	a0,a4
800072ce:	b2cfd0ef          	jal	800045fa <uart_init>
800072d2:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
800072d4:	57b2                	lw	a5,44(sp)
800072d6:	eb81                	bnez	a5,800072e6 <.L2>
            g_console_uart = (UART_Type *)cfg->base;
800072d8:	47b2                	lw	a5,12(sp)
800072da:	43dc                	lw	a5,4(a5)
800072dc:	873e                	mv	a4,a5
800072de:	000807b7          	lui	a5,0x80
800072e2:	34e7a023          	sw	a4,832(a5) # 80340 <g_console_uart>

800072e6 <.L2>:
        }
    }

    return stat;
800072e6:	57b2                	lw	a5,44(sp)
}
800072e8:	853e                	mv	a0,a5
800072ea:	50f2                	lw	ra,60(sp)
800072ec:	6121                	addi	sp,sp,64
800072ee:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

800072f0 <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
800072f0:	7179                	addi	sp,sp,-48
800072f2:	d606                	sw	ra,44(sp)
800072f4:	c62a                	sw	a0,12(sp)
800072f6:	c42e                	sw	a1,8(sp)
800072f8:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
800072fa:	ce02                	sw	zero,28(sp)
800072fc:	a0b9                	j	8000734a <.L13>

800072fe <.L17>:
        if (data[count] == '\n') {
800072fe:	4722                	lw	a4,8(sp)
80007300:	47f2                	lw	a5,28(sp)
80007302:	97ba                	add	a5,a5,a4
80007304:	0007c703          	lbu	a4,0(a5)
80007308:	47a9                	li	a5,10
8000730a:	00f71d63          	bne	a4,a5,80007324 <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
8000730e:	0001                	nop

80007310 <.L15>:
80007310:	000807b7          	lui	a5,0x80
80007314:	3407a783          	lw	a5,832(a5) # 80340 <g_console_uart>
80007318:	45b5                	li	a1,13
8000731a:	853e                	mv	a0,a5
8000731c:	ca8fd0ef          	jal	800047c4 <uart_send_byte>
80007320:	87aa                	mv	a5,a0
80007322:	f7fd                	bnez	a5,80007310 <.L15>

80007324 <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
80007324:	0001                	nop

80007326 <.L16>:
80007326:	000807b7          	lui	a5,0x80
8000732a:	3407a683          	lw	a3,832(a5) # 80340 <g_console_uart>
8000732e:	4722                	lw	a4,8(sp)
80007330:	47f2                	lw	a5,28(sp)
80007332:	97ba                	add	a5,a5,a4
80007334:	0007c783          	lbu	a5,0(a5)
80007338:	85be                	mv	a1,a5
8000733a:	8536                	mv	a0,a3
8000733c:	c88fd0ef          	jal	800047c4 <uart_send_byte>
80007340:	87aa                	mv	a5,a0
80007342:	f3f5                	bnez	a5,80007326 <.L16>
    for (count = 0; count < size; count++) {
80007344:	47f2                	lw	a5,28(sp)
80007346:	0785                	addi	a5,a5,1
80007348:	ce3e                	sw	a5,28(sp)

8000734a <.L13>:
8000734a:	4772                	lw	a4,28(sp)
8000734c:	4792                	lw	a5,4(sp)
8000734e:	faf768e3          	bltu	a4,a5,800072fe <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
80007352:	0001                	nop

80007354 <.L18>:
80007354:	000807b7          	lui	a5,0x80
80007358:	3407a783          	lw	a5,832(a5) # 80340 <g_console_uart>
8000735c:	853e                	mv	a0,a5
8000735e:	3845                	jal	80006c0e <uart_flush>
80007360:	87aa                	mv	a5,a0
80007362:	fbed                	bnez	a5,80007354 <.L18>
    }
    return count;
80007364:	47f2                	lw	a5,28(sp)

}
80007366:	853e                	mv	a0,a5
80007368:	50b2                	lw	ra,44(sp)
8000736a:	6145                	addi	sp,sp,48
8000736c:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

8000736e <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
8000736e:	1141                	addi	sp,sp,-16
80007370:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
80007372:	4781                	li	a5,0
}
80007374:	853e                	mv	a0,a5
80007376:	0141                	addi	sp,sp,16
80007378:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

8000737a <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
8000737a:	1141                	addi	sp,sp,-16
8000737c:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
8000737e:	4785                	li	a5,1
}
80007380:	853e                	mv	a0,a5
80007382:	0141                	addi	sp,sp,16
80007384:	8082                	ret

Disassembly of section .text.libc.__riscv_save_12:

80007386 <__riscv_save_12>:
80007386:	7139                	addi	sp,sp,-64
80007388:	4301                	li	t1,0
8000738a:	c66e                	sw	s11,12(sp)
8000738c:	a019                	j	80007392 <.L__riscv_save_s10_down>

8000738e <__riscv_save_10>:
8000738e:	7139                	addi	sp,sp,-64
80007390:	4341                	li	t1,16

80007392 <.L__riscv_save_s10_down>:
80007392:	c86a                	sw	s10,16(sp)
80007394:	ca66                	sw	s9,20(sp)
80007396:	cc62                	sw	s8,24(sp)
80007398:	ce5e                	sw	s7,28(sp)
8000739a:	a021                	j	800073a2 <.L__riscv_save_s6_down>

8000739c <__riscv_save_4>:
8000739c:	7139                	addi	sp,sp,-64
8000739e:	02000313          	li	t1,32

800073a2 <.L__riscv_save_s6_down>:
800073a2:	d05a                	sw	s6,32(sp)
800073a4:	d256                	sw	s5,36(sp)
800073a6:	d452                	sw	s4,40(sp)
800073a8:	d64e                	sw	s3,44(sp)
800073aa:	d84a                	sw	s2,48(sp)
800073ac:	da26                	sw	s1,52(sp)
800073ae:	dc22                	sw	s0,56(sp)
800073b0:	de06                	sw	ra,60(sp)
800073b2:	911a                	add	sp,sp,t1
800073b4:	8282                	jr	t0

Disassembly of section .text.libc.__riscv_restore_12:

800073b6 <__riscv_restore_12>:
800073b6:	4db2                	lw	s11,12(sp)
800073b8:	0141                	addi	sp,sp,16

800073ba <__riscv_restore_11>:
800073ba:	4d02                	lw	s10,0(sp)

800073bc <__riscv_restore_10>:
800073bc:	4c92                	lw	s9,4(sp)

800073be <__riscv_restore_9>:
800073be:	4c22                	lw	s8,8(sp)

800073c0 <__riscv_restore_8>:
800073c0:	4bb2                	lw	s7,12(sp)
800073c2:	0141                	addi	sp,sp,16

800073c4 <__riscv_restore_7>:
800073c4:	4b02                	lw	s6,0(sp)

800073c6 <__riscv_restore_6>:
800073c6:	4a92                	lw	s5,4(sp)

800073c8 <__riscv_restore_5>:
800073c8:	4a22                	lw	s4,8(sp)

800073ca <__riscv_restore_4>:
800073ca:	49b2                	lw	s3,12(sp)
800073cc:	0141                	addi	sp,sp,16

800073ce <__riscv_restore_3>:
800073ce:	4902                	lw	s2,0(sp)

800073d0 <__riscv_restore_2>:
800073d0:	4492                	lw	s1,4(sp)

800073d2 <__riscv_restore_1>:
800073d2:	4422                	lw	s0,8(sp)

800073d4 <__riscv_restore_0>:
800073d4:	40b2                	lw	ra,12(sp)
800073d6:	0141                	addi	sp,sp,16
800073d8:	8082                	ret

Disassembly of section .text.libc.itoa:

800073da <itoa>:
800073da:	1141                	addi	sp,sp,-16
800073dc:	c606                	sw	ra,12(sp)
800073de:	c422                	sw	s0,8(sp)
800073e0:	842e                	mv	s0,a1
800073e2:	00055963          	bgez	a0,800073f4 <itoa+0x1a>
800073e6:	45a9                	li	a1,10
800073e8:	00b61663          	bne	a2,a1,800073f4 <itoa+0x1a>
800073ec:	4629                	li	a2,10
800073ee:	4685                	li	a3,1
800073f0:	85a2                	mv	a1,s0
800073f2:	a019                	j	800073f8 <itoa+0x1e>
800073f4:	85a2                	mv	a1,s0
800073f6:	4681                	li	a3,0
800073f8:	803fd0ef          	jal	80004bfa <__SEGGER_RTL_xtoa>
800073fc:	8522                	mv	a0,s0
800073fe:	40b2                	lw	ra,12(sp)
80007400:	4422                	lw	s0,8(sp)
80007402:	0141                	addi	sp,sp,16
80007404:	8082                	ret

Disassembly of section .text.libc.abort:

80007406 <abort>:
80007406:	1141                	addi	sp,sp,-16
80007408:	c606                	sw	ra,12(sp)
8000740a:	4501                	li	a0,0
8000740c:	2011                	jal	80007410 <raise>
8000740e:	bff5                	j	8000740a <abort+0x4>

Disassembly of section .text.libc.raise:

80007410 <raise>:
80007410:	1141                	addi	sp,sp,-16
80007412:	c606                	sw	ra,12(sp)
80007414:	4615                	li	a2,5
80007416:	55fd                	li	a1,-1
80007418:	04a66163          	bltu	a2,a0,8000745a <raise+0x4a>
8000741c:	00251693          	slli	a3,a0,0x2
80007420:	00080637          	lui	a2,0x80
80007424:	31460613          	addi	a2,a2,788 # 80314 <__SEGGER_RTL_aSigTab>
80007428:	96b2                	add	a3,a3,a2
8000742a:	4290                	lw	a2,0(a3)
8000742c:	80005737          	lui	a4,0x80005
80007430:	cb470713          	addi	a4,a4,-844 # 80004cb4 <__SEGGER_RTL_SIGNAL_SIG_IGN>
80007434:	c298                	sw	a4,0(a3)
80007436:	c615                	beqz	a2,80007462 <raise+0x52>
80007438:	800057b7          	lui	a5,0x80005
8000743c:	cb278793          	addi	a5,a5,-846 # 80004cb2 <__SEGGER_RTL_SIGNAL_SIG_ERR>
80007440:	00f60d63          	beq	a2,a5,8000745a <raise+0x4a>
80007444:	00e60a63          	beq	a2,a4,80007458 <raise+0x48>
80007448:	800035b7          	lui	a1,0x80003
8000744c:	06658593          	addi	a1,a1,102 # 80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>
80007450:	00b60963          	beq	a2,a1,80007462 <raise+0x52>
80007454:	c28c                	sw	a1,0(a3)
80007456:	9602                	jalr	a2
80007458:	4581                	li	a1,0
8000745a:	852e                	mv	a0,a1
8000745c:	40b2                	lw	ra,12(sp)
8000745e:	0141                	addi	sp,sp,16
80007460:	8082                	ret
80007462:	4505                	li	a0,1
80007464:	bf7fb0ef          	jal	8000305a <exit>

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

80007468 <__SEGGER_RTL_puts_no_nl>:
80007468:	1141                	addi	sp,sp,-16
8000746a:	c606                	sw	ra,12(sp)
8000746c:	c422                	sw	s0,8(sp)
8000746e:	c226                	sw	s1,4(sp)
80007470:	000805b7          	lui	a1,0x80
80007474:	3545a403          	lw	s0,852(a1) # 80354 <stdout>
80007478:	84aa                	mv	s1,a0
8000747a:	69b000ef          	jal	80008314 <strlen>
8000747e:	862a                	mv	a2,a0
80007480:	8522                	mv	a0,s0
80007482:	85a6                	mv	a1,s1
80007484:	40b2                	lw	ra,12(sp)
80007486:	4422                	lw	s0,8(sp)
80007488:	4492                	lw	s1,4(sp)
8000748a:	0141                	addi	sp,sp,16
8000748c:	b595                	j	800072f0 <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.fwrite:

8000748e <fwrite>:
8000748e:	1101                	addi	sp,sp,-32
80007490:	ce06                	sw	ra,28(sp)
80007492:	cc22                	sw	s0,24(sp)
80007494:	ca26                	sw	s1,20(sp)
80007496:	c84a                	sw	s2,16(sp)
80007498:	c64e                	sw	s3,12(sp)
8000749a:	84b6                	mv	s1,a3
8000749c:	89b2                	mv	s3,a2
8000749e:	842e                	mv	s0,a1
800074a0:	892a                	mv	s2,a0
800074a2:	8536                	mv	a0,a3
800074a4:	35e9                	jal	8000736e <__SEGGER_RTL_X_file_stat>
800074a6:	00054663          	bltz	a0,800074b2 <fwrite+0x24>
800074aa:	02898633          	mul	a2,s3,s0
800074ae:	00867463          	bgeu	a2,s0,800074b6 <fwrite+0x28>
800074b2:	4501                	li	a0,0
800074b4:	a031                	j	800074c0 <fwrite+0x32>
800074b6:	8526                	mv	a0,s1
800074b8:	85ca                	mv	a1,s2
800074ba:	3d1d                	jal	800072f0 <__SEGGER_RTL_X_file_write>
800074bc:	02855533          	divu	a0,a0,s0
800074c0:	40f2                	lw	ra,28(sp)
800074c2:	4462                	lw	s0,24(sp)
800074c4:	44d2                	lw	s1,20(sp)
800074c6:	4942                	lw	s2,16(sp)
800074c8:	49b2                	lw	s3,12(sp)
800074ca:	6105                	addi	sp,sp,32
800074cc:	8082                	ret

Disassembly of section .text.libc.setvbuf:

800074ce <setvbuf>:
800074ce:	4501                	li	a0,0
800074d0:	8082                	ret

Disassembly of section .text.libc.__mulsf3:

800074d2 <__mulsf3>:
800074d2:	80000737          	lui	a4,0x80000
800074d6:	0ff00293          	li	t0,255
800074da:	00b547b3          	xor	a5,a0,a1
800074de:	8ff9                	and	a5,a5,a4
800074e0:	00151613          	slli	a2,a0,0x1
800074e4:	8261                	srli	a2,a2,0x18
800074e6:	00159693          	slli	a3,a1,0x1
800074ea:	82e1                	srli	a3,a3,0x18
800074ec:	ce29                	beqz	a2,80007546 <.L__mulsf3_lhs_zero_or_subnormal>
800074ee:	c6bd                	beqz	a3,8000755c <.L__mulsf3_rhs_zero_or_subnormal>
800074f0:	04560f63          	beq	a2,t0,8000754e <.L__mulsf3_lhs_inf_or_nan>
800074f4:	06568963          	beq	a3,t0,80007566 <.L__mulsf3_rhs_inf_or_nan>
800074f8:	9636                	add	a2,a2,a3
800074fa:	0522                	slli	a0,a0,0x8
800074fc:	8d59                	or	a0,a0,a4
800074fe:	05a2                	slli	a1,a1,0x8
80007500:	8dd9                	or	a1,a1,a4
80007502:	02b506b3          	mul	a3,a0,a1
80007506:	02b53533          	mulhu	a0,a0,a1
8000750a:	00d036b3          	snez	a3,a3
8000750e:	8d55                	or	a0,a0,a3
80007510:	00054463          	bltz	a0,80007518 <.L__mulsf3_normalized>
80007514:	0506                	slli	a0,a0,0x1
80007516:	167d                	addi	a2,a2,-1

80007518 <.L__mulsf3_normalized>:
80007518:	f8160613          	addi	a2,a2,-127
8000751c:	04064863          	bltz	a2,8000756c <.L__mulsf3_zero_or_underflow>
80007520:	12fd                	addi	t0,t0,-1 # ffffffff <__AHB_SRAM_segment_end__+0xfbf7fff>
80007522:	00565f63          	bge	a2,t0,80007540 <.L__mulsf3_inf>
80007526:	01851693          	slli	a3,a0,0x18
8000752a:	8121                	srli	a0,a0,0x8
8000752c:	065e                	slli	a2,a2,0x17
8000752e:	9532                	add	a0,a0,a2
80007530:	0006d663          	bgez	a3,8000753c <.L__mulsf3_apply_sign>
80007534:	0505                	addi	a0,a0,1 # 1020001 <_flash_size+0xf20001>
80007536:	0686                	slli	a3,a3,0x1
80007538:	e291                	bnez	a3,8000753c <.L__mulsf3_apply_sign>
8000753a:	9979                	andi	a0,a0,-2

8000753c <.L__mulsf3_apply_sign>:
8000753c:	8d5d                	or	a0,a0,a5
8000753e:	8082                	ret

80007540 <.L__mulsf3_inf>:
80007540:	7f800537          	lui	a0,0x7f800
80007544:	bfe5                	j	8000753c <.L__mulsf3_apply_sign>

80007546 <.L__mulsf3_lhs_zero_or_subnormal>:
80007546:	00568d63          	beq	a3,t0,80007560 <.L__mulsf3_nan>

8000754a <.L__mulsf3_signed_zero>:
8000754a:	853e                	mv	a0,a5
8000754c:	8082                	ret

8000754e <.L__mulsf3_lhs_inf_or_nan>:
8000754e:	0526                	slli	a0,a0,0x9
80007550:	e901                	bnez	a0,80007560 <.L__mulsf3_nan>
80007552:	fe5697e3          	bne	a3,t0,80007540 <.L__mulsf3_inf>
80007556:	05a6                	slli	a1,a1,0x9
80007558:	e581                	bnez	a1,80007560 <.L__mulsf3_nan>
8000755a:	b7dd                	j	80007540 <.L__mulsf3_inf>

8000755c <.L__mulsf3_rhs_zero_or_subnormal>:
8000755c:	fe5617e3          	bne	a2,t0,8000754a <.L__mulsf3_signed_zero>

80007560 <.L__mulsf3_nan>:
80007560:	7fc00537          	lui	a0,0x7fc00
80007564:	8082                	ret

80007566 <.L__mulsf3_rhs_inf_or_nan>:
80007566:	05a6                	slli	a1,a1,0x9
80007568:	fde5                	bnez	a1,80007560 <.L__mulsf3_nan>
8000756a:	bfd9                	j	80007540 <.L__mulsf3_inf>

8000756c <.L__mulsf3_zero_or_underflow>:
8000756c:	0605                	addi	a2,a2,1
8000756e:	fe71                	bnez	a2,8000754a <.L__mulsf3_signed_zero>
80007570:	8521                	srai	a0,a0,0x8
80007572:	00150293          	addi	t0,a0,1 # 7fc00001 <_flash_size+0x7fb00001>
80007576:	0509                	addi	a0,a0,2
80007578:	fc0299e3          	bnez	t0,8000754a <.L__mulsf3_signed_zero>
8000757c:	00800537          	lui	a0,0x800
80007580:	bf75                	j	8000753c <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__divsf3:

80007582 <__divsf3>:
80007582:	0ff00293          	li	t0,255
80007586:	00151713          	slli	a4,a0,0x1
8000758a:	8361                	srli	a4,a4,0x18
8000758c:	00159793          	slli	a5,a1,0x1
80007590:	83e1                	srli	a5,a5,0x18
80007592:	00b54333          	xor	t1,a0,a1
80007596:	01f35313          	srli	t1,t1,0x1f
8000759a:	037e                	slli	t1,t1,0x1f
8000759c:	cf4d                	beqz	a4,80007656 <.L__divsf3_lhs_zero_or_subnormal>
8000759e:	cbe9                	beqz	a5,80007670 <.L__divsf3_rhs_zero_or_subnormal>
800075a0:	0c570363          	beq	a4,t0,80007666 <.L__divsf3_lhs_inf_or_nan>
800075a4:	0c578b63          	beq	a5,t0,8000767a <.L__divsf3_rhs_inf_or_nan>
800075a8:	8f1d                	sub	a4,a4,a5

800075aa <.Lpcrel_hi0>:
800075aa:	d0018293          	addi	t0,gp,-768 # 80003590 <__SEGGER_RTL_fdiv_reciprocal_table>
800075ae:	00f5d693          	srli	a3,a1,0xf
800075b2:	0fc6f693          	andi	a3,a3,252
800075b6:	9696                	add	a3,a3,t0
800075b8:	429c                	lw	a5,0(a3)
800075ba:	4187d613          	srai	a2,a5,0x18
800075be:	00f59693          	slli	a3,a1,0xf
800075c2:	82e1                	srli	a3,a3,0x18
800075c4:	0016f293          	andi	t0,a3,1
800075c8:	8285                	srli	a3,a3,0x1
800075ca:	fc068693          	addi	a3,a3,-64
800075ce:	9696                	add	a3,a3,t0
800075d0:	02d60633          	mul	a2,a2,a3
800075d4:	07a2                	slli	a5,a5,0x8
800075d6:	83a1                	srli	a5,a5,0x8
800075d8:	963e                	add	a2,a2,a5
800075da:	05a2                	slli	a1,a1,0x8
800075dc:	81a1                	srli	a1,a1,0x8
800075de:	008007b7          	lui	a5,0x800
800075e2:	8ddd                	or	a1,a1,a5
800075e4:	02c586b3          	mul	a3,a1,a2
800075e8:	0522                	slli	a0,a0,0x8
800075ea:	8121                	srli	a0,a0,0x8
800075ec:	8d5d                	or	a0,a0,a5
800075ee:	02c697b3          	mulh	a5,a3,a2
800075f2:	00b532b3          	sltu	t0,a0,a1
800075f6:	00551533          	sll	a0,a0,t0
800075fa:	40570733          	sub	a4,a4,t0
800075fe:	01465693          	srli	a3,a2,0x14
80007602:	8a85                	andi	a3,a3,1
80007604:	0016c693          	xori	a3,a3,1
80007608:	062e                	slli	a2,a2,0xb
8000760a:	8e1d                	sub	a2,a2,a5
8000760c:	8e15                	sub	a2,a2,a3
8000760e:	050a                	slli	a0,a0,0x2
80007610:	02a617b3          	mulh	a5,a2,a0
80007614:	07e70613          	addi	a2,a4,126 # 8000007e <_flash_size+0x7ff0007e>
80007618:	055a                	slli	a0,a0,0x16
8000761a:	8d0d                	sub	a0,a0,a1
8000761c:	02b786b3          	mul	a3,a5,a1
80007620:	0fe00293          	li	t0,254
80007624:	00567f63          	bgeu	a2,t0,80007642 <.L__divsf3_underflow_or_overflow>
80007628:	40a68533          	sub	a0,a3,a0
8000762c:	000522b3          	sltz	t0,a0
80007630:	9796                	add	a5,a5,t0
80007632:	0017f513          	andi	a0,a5,1
80007636:	8385                	srli	a5,a5,0x1
80007638:	953e                	add	a0,a0,a5
8000763a:	065e                	slli	a2,a2,0x17
8000763c:	9532                	add	a0,a0,a2
8000763e:	951a                	add	a0,a0,t1
80007640:	8082                	ret

80007642 <.L__divsf3_underflow_or_overflow>:
80007642:	851a                	mv	a0,t1
80007644:	00564563          	blt	a2,t0,8000764e <.L__divsf3_done>
80007648:	7f800337          	lui	t1,0x7f800

8000764c <.L__divsf3_apply_sign>:
8000764c:	951a                	add	a0,a0,t1

8000764e <.L__divsf3_done>:
8000764e:	8082                	ret

80007650 <.L__divsf3_inf>:
80007650:	7f800537          	lui	a0,0x7f800
80007654:	bfe5                	j	8000764c <.L__divsf3_apply_sign>

80007656 <.L__divsf3_lhs_zero_or_subnormal>:
80007656:	c789                	beqz	a5,80007660 <.L__divsf3_nan>
80007658:	02579363          	bne	a5,t0,8000767e <.L__divsf3_signed_zero>
8000765c:	05a6                	slli	a1,a1,0x9
8000765e:	c185                	beqz	a1,8000767e <.L__divsf3_signed_zero>

80007660 <.L__divsf3_nan>:
80007660:	7fc00537          	lui	a0,0x7fc00
80007664:	8082                	ret

80007666 <.L__divsf3_lhs_inf_or_nan>:
80007666:	0526                	slli	a0,a0,0x9
80007668:	fd65                	bnez	a0,80007660 <.L__divsf3_nan>
8000766a:	fe5793e3          	bne	a5,t0,80007650 <.L__divsf3_inf>
8000766e:	bfcd                	j	80007660 <.L__divsf3_nan>

80007670 <.L__divsf3_rhs_zero_or_subnormal>:
80007670:	fe5710e3          	bne	a4,t0,80007650 <.L__divsf3_inf>
80007674:	0526                	slli	a0,a0,0x9
80007676:	f56d                	bnez	a0,80007660 <.L__divsf3_nan>
80007678:	bfe1                	j	80007650 <.L__divsf3_inf>

8000767a <.L__divsf3_rhs_inf_or_nan>:
8000767a:	05a6                	slli	a1,a1,0x9
8000767c:	f1f5                	bnez	a1,80007660 <.L__divsf3_nan>

8000767e <.L__divsf3_signed_zero>:
8000767e:	851a                	mv	a0,t1
80007680:	8082                	ret

Disassembly of section .text.libc.__eqsf2:

80007682 <__eqsf2>:
80007682:	ff000637          	lui	a2,0xff000
80007686:	00151693          	slli	a3,a0,0x1
8000768a:	02d66063          	bltu	a2,a3,800076aa <.L__eqsf2_one>
8000768e:	00159693          	slli	a3,a1,0x1
80007692:	00d66c63          	bltu	a2,a3,800076aa <.L__eqsf2_one>
80007696:	00b56633          	or	a2,a0,a1
8000769a:	0606                	slli	a2,a2,0x1
8000769c:	c609                	beqz	a2,800076a6 <.L__eqsf2_zero>
8000769e:	8d0d                	sub	a0,a0,a1
800076a0:	00a03533          	snez	a0,a0
800076a4:	8082                	ret

800076a6 <.L__eqsf2_zero>:
800076a6:	4501                	li	a0,0
800076a8:	8082                	ret

800076aa <.L__eqsf2_one>:
800076aa:	4505                	li	a0,1
800076ac:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

800076ae <__fixunssfdi>:
800076ae:	04054a63          	bltz	a0,80007702 <.L__fixunssfdi_zero_result>
800076b2:	00151613          	slli	a2,a0,0x1
800076b6:	8261                	srli	a2,a2,0x18
800076b8:	f8160613          	addi	a2,a2,-127 # feffff81 <__AHB_SRAM_segment_end__+0xebf7f81>
800076bc:	04064363          	bltz	a2,80007702 <.L__fixunssfdi_zero_result>
800076c0:	800006b7          	lui	a3,0x80000
800076c4:	02000293          	li	t0,32
800076c8:	00565b63          	bge	a2,t0,800076de <.L__fixunssfdi_long_shift>
800076cc:	40c00633          	neg	a2,a2
800076d0:	067d                	addi	a2,a2,31
800076d2:	0522                	slli	a0,a0,0x8
800076d4:	8d55                	or	a0,a0,a3
800076d6:	00c55533          	srl	a0,a0,a2
800076da:	4581                	li	a1,0
800076dc:	8082                	ret

800076de <.L__fixunssfdi_long_shift>:
800076de:	40c00633          	neg	a2,a2
800076e2:	03f60613          	addi	a2,a2,63
800076e6:	02064163          	bltz	a2,80007708 <.L__fixunssfdi_overflow_result>
800076ea:	00851593          	slli	a1,a0,0x8
800076ee:	8dd5                	or	a1,a1,a3
800076f0:	4501                	li	a0,0
800076f2:	c619                	beqz	a2,80007700 <.L__fixunssfdi_shift_32>
800076f4:	40c006b3          	neg	a3,a2
800076f8:	00d59533          	sll	a0,a1,a3
800076fc:	00c5d5b3          	srl	a1,a1,a2

80007700 <.L__fixunssfdi_shift_32>:
80007700:	8082                	ret

80007702 <.L__fixunssfdi_zero_result>:
80007702:	4501                	li	a0,0
80007704:	4581                	li	a1,0
80007706:	8082                	ret

80007708 <.L__fixunssfdi_overflow_result>:
80007708:	557d                	li	a0,-1
8000770a:	55fd                	li	a1,-1
8000770c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

8000770e <__SEGGER_RTL_ldouble_to_double>:
8000770e:	00169793          	slli	a5,a3,0x1
80007712:	453d                	li	a0,15
80007714:	83c5                	srli	a5,a5,0x11
80007716:	052a                	slli	a0,a0,0xa
80007718:	80000837          	lui	a6,0x80000
8000771c:	00f56663          	bltu	a0,a5,80007728 <__SEGGER_RTL_ldouble_to_double+0x1a>
80007720:	4501                	li	a0,0
80007722:	0106f5b3          	and	a1,a3,a6
80007726:	8082                	ret
80007728:	5545                	li	a0,-15
8000772a:	6711                	lui	a4,0x4
8000772c:	052a                	slli	a0,a0,0xa
8000772e:	953e                	add	a0,a0,a5
80007730:	3ff70713          	addi	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
80007734:	83a9                	srli	a5,a5,0xa
80007736:	00e50963          	beq	a0,a4,80007748 <__SEGGER_RTL_ldouble_to_double+0x3a>
8000773a:	0117b713          	sltiu	a4,a5,17
8000773e:	40e00733          	neg	a4,a4
80007742:	8ef9                	and	a3,a3,a4
80007744:	8e79                	and	a2,a2,a4
80007746:	8df9                	and	a1,a1,a4
80007748:	4741                	li	a4,16
8000774a:	00f77463          	bgeu	a4,a5,80007752 <__SEGGER_RTL_ldouble_to_double+0x44>
8000774e:	7ff00513          	li	a0,2047
80007752:	0106f733          	and	a4,a3,a6
80007756:	0552                	slli	a0,a0,0x14
80007758:	8d59                	or	a0,a0,a4
8000775a:	01c65713          	srli	a4,a2,0x1c
8000775e:	0692                	slli	a3,a3,0x4
80007760:	0612                	slli	a2,a2,0x4
80007762:	01c5d793          	srli	a5,a1,0x1c
80007766:	8ed9                	or	a3,a3,a4
80007768:	06b2                	slli	a3,a3,0xc
8000776a:	00c6d593          	srli	a1,a3,0xc
8000776e:	8dc9                	or	a1,a1,a0
80007770:	00f66533          	or	a0,a2,a5
80007774:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

80007776 <__trunctfsf2>:
80007776:	1141                	addi	sp,sp,-16
80007778:	c606                	sw	ra,12(sp)
8000777a:	4118                	lw	a4,0(a0)
8000777c:	414c                	lw	a1,4(a0)
8000777e:	4510                	lw	a2,8(a0)
80007780:	4554                	lw	a3,12(a0)
80007782:	853a                	mv	a0,a4
80007784:	3769                	jal	8000770e <__SEGGER_RTL_ldouble_to_double>
80007786:	83bfd0ef          	jal	80004fc0 <__truncdfsf2>
8000778a:	40b2                	lw	ra,12(sp)
8000778c:	0141                	addi	sp,sp,16
8000778e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

80007790 <__SEGGER_RTL_float32_isnan>:
80007790:	0506                	slli	a0,a0,0x1
80007792:	ff0005b7          	lui	a1,0xff000
80007796:	00a5b533          	sltu	a0,a1,a0
8000779a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

8000779c <__SEGGER_RTL_float32_isinf>:
8000779c:	0506                	slli	a0,a0,0x1
8000779e:	8105                	srli	a0,a0,0x1
800077a0:	7f8005b7          	lui	a1,0x7f800
800077a4:	8d2d                	xor	a0,a0,a1
800077a6:	00153513          	seqz	a0,a0
800077aa:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

800077ac <__SEGGER_RTL_float32_isnormal>:
800077ac:	00151593          	slli	a1,a0,0x1
800077b0:	7f800637          	lui	a2,0x7f800
800077b4:	81e1                	srli	a1,a1,0x18
800077b6:	8d71                	and	a0,a0,a2
800077b8:	0ff5b593          	sltiu	a1,a1,255
800077bc:	00a03533          	snez	a0,a0
800077c0:	8d6d                	and	a0,a0,a1
800077c2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

800077c4 <__SEGGER_RTL_float32_signbit>:
800077c4:	817d                	srli	a0,a0,0x1f
800077c6:	8082                	ret

Disassembly of section .text.libc.ldexpf:

800077c8 <ldexpf>:
800077c8:	00151613          	slli	a2,a0,0x1
800077cc:	8261                	srli	a2,a2,0x18
800077ce:	f0160693          	addi	a3,a2,-255 # 7f7fff01 <_flash_size+0x7f6fff01>
800077d2:	f0200713          	li	a4,-254
800077d6:	02e6ea63          	bltu	a3,a4,8000780a <ldexpf+0x42>
800077da:	95b2                	add	a1,a1,a2
800077dc:	fff58613          	addi	a2,a1,-1 # 7f7fffff <_flash_size+0x7f6fffff>
800077e0:	0fd00693          	li	a3,253
800077e4:	00c6e963          	bltu	a3,a2,800077f6 <ldexpf+0x2e>
800077e8:	80800637          	lui	a2,0x80800
800077ec:	167d                	addi	a2,a2,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
800077ee:	8d71                	and	a0,a0,a2
800077f0:	05de                	slli	a1,a1,0x17
800077f2:	8d4d                	or	a0,a0,a1
800077f4:	8082                	ret
800077f6:	0015a593          	slti	a1,a1,1
800077fa:	80000637          	lui	a2,0x80000
800077fe:	8d71                	and	a0,a0,a2
80007800:	15fd                	addi	a1,a1,-1
80007802:	7f800637          	lui	a2,0x7f800
80007806:	8df1                	and	a1,a1,a2
80007808:	8d4d                	or	a0,a0,a1
8000780a:	8082                	ret

Disassembly of section .text.libc.fmodf:

8000780c <fmodf>:
8000780c:	b91ff2ef          	jal	t0,8000739c <__riscv_save_4>
80007810:	84aa                	mv	s1,a0
80007812:	01755993          	srli	s3,a0,0x17
80007816:	fff98513          	addi	a0,s3,-1
8000781a:	0fd00613          	li	a2,253
8000781e:	0ea66363          	bltu	a2,a0,80007904 <fmodf+0xf8>
80007822:	0175d513          	srli	a0,a1,0x17
80007826:	f0150513          	addi	a0,a0,-255 # 7fbfff01 <_flash_size+0x7fafff01>
8000782a:	f0200613          	li	a2,-254
8000782e:	0cc56b63          	bltu	a0,a2,80007904 <fmodf+0xf8>
80007832:	00149413          	slli	s0,s1,0x1
80007836:	8005                	srli	s0,s0,0x1
80007838:	80000537          	lui	a0,0x80000
8000783c:	00a4f933          	and	s2,s1,a0
80007840:	1085f063          	bgeu	a1,s0,80007940 <fmodf+0x134>
80007844:	00800637          	lui	a2,0x800
80007848:	0ff9f513          	zext.b	a0,s3
8000784c:	fff60693          	addi	a3,a2,-1 # 7fffff <_flash_size+0x6fffff>
80007850:	c509                	beqz	a0,8000785a <fmodf+0x4e>
80007852:	00d4f433          	and	s0,s1,a3
80007856:	8c51                	or	s0,s0,a2
80007858:	a831                	j	80007874 <fmodf+0x68>
8000785a:	01745513          	srli	a0,s0,0x17
8000785e:	e911                	bnez	a0,80007872 <fmodf+0x66>
80007860:	8622                	mv	a2,s0
80007862:	00161413          	slli	s0,a2,0x1
80007866:	01665713          	srli	a4,a2,0x16
8000786a:	157d                	addi	a0,a0,-1 # 7fffffff <_flash_size+0x7fefffff>
8000786c:	8622                	mv	a2,s0
8000786e:	db75                	beqz	a4,80007862 <fmodf+0x56>
80007870:	a011                	j	80007874 <fmodf+0x68>
80007872:	4501                	li	a0,0
80007874:	00159613          	slli	a2,a1,0x1
80007878:	8261                	srli	a2,a2,0x18
8000787a:	ca01                	beqz	a2,8000788a <fmodf+0x7e>
8000787c:	8df5                	and	a1,a1,a3
8000787e:	008006b7          	lui	a3,0x800
80007882:	8dd5                	or	a1,a1,a3
80007884:	02a64063          	blt	a2,a0,800078a4 <fmodf+0x98>
80007888:	a081                	j	800078c8 <fmodf+0xbc>
8000788a:	0175d613          	srli	a2,a1,0x17
8000788e:	ea15                	bnez	a2,800078c2 <fmodf+0xb6>
80007890:	86ae                	mv	a3,a1
80007892:	00169593          	slli	a1,a3,0x1
80007896:	0166d713          	srli	a4,a3,0x16
8000789a:	167d                	addi	a2,a2,-1
8000789c:	86ae                	mv	a3,a1
8000789e:	db75                	beqz	a4,80007892 <fmodf+0x86>
800078a0:	02a65463          	bge	a2,a0,800078c8 <fmodf+0xbc>
800078a4:	40b406b3          	sub	a3,s0,a1
800078a8:	0006c563          	bltz	a3,800078b2 <fmodf+0xa6>
800078ac:	04b40a63          	beq	s0,a1,80007900 <fmodf+0xf4>
800078b0:	a011                	j	800078b4 <fmodf+0xa8>
800078b2:	86a2                	mv	a3,s0
800078b4:	157d                	addi	a0,a0,-1
800078b6:	00169413          	slli	s0,a3,0x1
800078ba:	fea645e3          	blt	a2,a0,800078a4 <fmodf+0x98>
800078be:	8532                	mv	a0,a2
800078c0:	a021                	j	800078c8 <fmodf+0xbc>
800078c2:	4601                	li	a2,0
800078c4:	fea040e3          	bgtz	a0,800078a4 <fmodf+0x98>
800078c8:	40b40633          	sub	a2,s0,a1
800078cc:	00064563          	bltz	a2,800078d6 <fmodf+0xca>
800078d0:	00b41463          	bne	s0,a1,800078d8 <fmodf+0xcc>
800078d4:	a035                	j	80007900 <fmodf+0xf4>
800078d6:	8622                	mv	a2,s0
800078d8:	01765593          	srli	a1,a2,0x17
800078dc:	e989                	bnez	a1,800078ee <fmodf+0xe2>
800078de:	00161593          	slli	a1,a2,0x1
800078e2:	01665693          	srli	a3,a2,0x16
800078e6:	157d                	addi	a0,a0,-1
800078e8:	862e                	mv	a2,a1
800078ea:	daf5                	beqz	a3,800078de <fmodf+0xd2>
800078ec:	a011                	j	800078f0 <fmodf+0xe4>
800078ee:	85b2                	mv	a1,a2
800078f0:	04a05c63          	blez	a0,80007948 <fmodf+0x13c>
800078f4:	fff50613          	addi	a2,a0,-1
800078f8:	065e                	slli	a2,a2,0x17
800078fa:	964a                	add	a2,a2,s2
800078fc:	00c58933          	add	s2,a1,a2
80007900:	854a                	mv	a0,s2
80007902:	b4d9                	j	800073c8 <__riscv_restore_5>
80007904:	00149413          	slli	s0,s1,0x1
80007908:	ff000537          	lui	a0,0xff000
8000790c:	02856c63          	bltu	a0,s0,80007944 <fmodf+0x138>
80007910:	00159a13          	slli	s4,a1,0x1
80007914:	05456063          	bltu	a0,s4,80007954 <fmodf+0x148>
80007918:	8005                	srli	s0,s0,0x1
8000791a:	7f800537          	lui	a0,0x7f800
8000791e:	7fc00937          	lui	s2,0x7fc00
80007922:	fca40fe3          	beq	s0,a0,80007900 <fmodf+0xf4>
80007926:	e409                	bnez	s0,80007930 <fmodf+0x124>
80007928:	852e                	mv	a0,a1
8000792a:	4581                	li	a1,0
8000792c:	3b99                	jal	80007682 <__eqsf2>
8000792e:	e919                	bnez	a0,80007944 <fmodf+0x138>
80007930:	001a5593          	srli	a1,s4,0x1
80007934:	d5f1                	beqz	a1,80007900 <fmodf+0xf4>
80007936:	7f800537          	lui	a0,0x7f800
8000793a:	eea59fe3          	bne	a1,a0,80007838 <fmodf+0x2c>
8000793e:	a019                	j	80007944 <fmodf+0x138>
80007940:	fc8580e3          	beq	a1,s0,80007900 <fmodf+0xf4>
80007944:	8926                	mv	s2,s1
80007946:	bf6d                	j	80007900 <fmodf+0xf4>
80007948:	4601                	li	a2,0
8000794a:	4685                	li	a3,1
8000794c:	8e89                	sub	a3,a3,a0
8000794e:	00d5d5b3          	srl	a1,a1,a3
80007952:	b75d                	j	800078f8 <fmodf+0xec>
80007954:	892e                	mv	s2,a1
80007956:	b76d                	j	80007900 <fmodf+0xf4>

Disassembly of section .text.libc.floorf:

80007958 <floorf>:
80007958:	00151593          	slli	a1,a0,0x1
8000795c:	81e1                	srli	a1,a1,0x18
8000795e:	fff58613          	addi	a2,a1,-1
80007962:	0fe00693          	li	a3,254
80007966:	04d67963          	bgeu	a2,a3,800079b8 <floorf+0x60>
8000796a:	07e00613          	li	a2,126
8000796e:	00b66763          	bltu	a2,a1,8000797c <floorf+0x24>
80007972:	857d                	srai	a0,a0,0x1f
80007974:	bf8005b7          	lui	a1,0xbf800
80007978:	8d6d                	and	a0,a0,a1
8000797a:	8082                	ret
8000797c:	09500613          	li	a2,149
80007980:	02b66b63          	bltu	a2,a1,800079b6 <floorf+0x5e>
80007984:	f8158593          	addi	a1,a1,-127 # bf7fff81 <__FLASH_segment_end__+0x3f6fff81>
80007988:	ff800637          	lui	a2,0xff800
8000798c:	00052693          	slti	a3,a0,0
80007990:	40b65633          	sra	a2,a2,a1
80007994:	8e69                	and	a2,a2,a0
80007996:	00b51533          	sll	a0,a0,a1
8000799a:	0016c693          	xori	a3,a3,1
8000799e:	0526                	slli	a0,a0,0x9
800079a0:	8125                	srli	a0,a0,0x9
800079a2:	00153513          	seqz	a0,a0
800079a6:	8d55                	or	a0,a0,a3
800079a8:	008006b7          	lui	a3,0x800
800079ac:	00b6d5b3          	srl	a1,a3,a1
800079b0:	157d                	addi	a0,a0,-1 # 7f7fffff <_flash_size+0x7f6fffff>
800079b2:	8d6d                	and	a0,a0,a1
800079b4:	9532                	add	a0,a0,a2
800079b6:	8082                	ret
800079b8:	fdfd                	bnez	a1,800079b6 <floorf+0x5e>
800079ba:	800005b7          	lui	a1,0x80000
800079be:	bf6d                	j	80007978 <floorf+0x20>

Disassembly of section .text.libc.__udivdi3:

800079c0 <__udivdi3>:
800079c0:	872e                	mv	a4,a1
800079c2:	e2b1                	bnez	a3,80007a06 <__udivdi3+0x46>
800079c4:	2a070863          	beqz	a4,80007c74 <__udivdi3+0x2b4>
800079c8:	01865793          	srli	a5,a2,0x18
800079cc:	8fd5                	or	a5,a5,a3
800079ce:	ef85                	bnez	a5,80007a06 <__udivdi3+0x46>
800079d0:	00563813          	sltiu	a6,a2,5
800079d4:	0016b793          	seqz	a5,a3
800079d8:	0107f7b3          	and	a5,a5,a6
800079dc:	3c078363          	beqz	a5,80007da2 <__udivdi3+0x3e2>
800079e0:	4689                	li	a3,2
800079e2:	3ec6ce63          	blt	a3,a2,80007dde <__udivdi3+0x41e>
800079e6:	4785                	li	a5,1
800079e8:	86aa                	mv	a3,a0
800079ea:	28f60f63          	beq	a2,a5,80007c88 <__udivdi3+0x2c8>
800079ee:	4681                	li	a3,0
800079f0:	4789                	li	a5,2
800079f2:	4701                	li	a4,0
800079f4:	28f61a63          	bne	a2,a5,80007c88 <__udivdi3+0x2c8>
800079f8:	8105                	srli	a0,a0,0x1
800079fa:	01f59693          	slli	a3,a1,0x1f
800079fe:	8ec9                	or	a3,a3,a0
80007a00:	0015d713          	srli	a4,a1,0x1
80007a04:	a451                	j	80007c88 <__udivdi3+0x2c8>
80007a06:	14068e63          	beqz	a3,80007b62 <__udivdi3+0x1a2>
80007a0a:	0106d813          	srli	a6,a3,0x10
80007a0e:	00155293          	srli	t0,a0,0x1
80007a12:	01f59713          	slli	a4,a1,0x1f
80007a16:	0015d893          	srli	a7,a1,0x1
80007a1a:	00165313          	srli	t1,a2,0x1
80007a1e:	800083b7          	lui	t2,0x80008
80007a22:	eac38393          	addi	t2,t2,-340 # 80007eac <__SEGGER_RTL_Moeller_inverse_lut>
80007a26:	00183793          	seqz	a5,a6
80007a2a:	00e2e2b3          	or	t0,t0,a4
80007a2e:	00479813          	slli	a6,a5,0x4
80007a32:	010697b3          	sll	a5,a3,a6
80007a36:	0187d713          	srli	a4,a5,0x18
80007a3a:	00173713          	seqz	a4,a4
80007a3e:	070e                	slli	a4,a4,0x3
80007a40:	00e79e33          	sll	t3,a5,a4
80007a44:	00e86833          	or	a6,a6,a4
80007a48:	01ce5793          	srli	a5,t3,0x1c
80007a4c:	0017b793          	seqz	a5,a5
80007a50:	078a                	slli	a5,a5,0x2
80007a52:	00fe1e33          	sll	t3,t3,a5
80007a56:	00f86833          	or	a6,a6,a5
80007a5a:	01ee5713          	srli	a4,t3,0x1e
80007a5e:	00173713          	seqz	a4,a4
80007a62:	0706                	slli	a4,a4,0x1
80007a64:	00ee17b3          	sll	a5,t3,a4
80007a68:	00e86733          	or	a4,a6,a4
80007a6c:	fff7c793          	not	a5,a5
80007a70:	83fd                	srli	a5,a5,0x1f
80007a72:	8f5d                	or	a4,a4,a5
80007a74:	00e697b3          	sll	a5,a3,a4
80007a78:	01f74813          	xori	a6,a4,31
80007a7c:	01035733          	srl	a4,t1,a6
80007a80:	00e7efb3          	or	t6,a5,a4
80007a84:	001ff313          	andi	t1,t6,1
80007a88:	016fd713          	srli	a4,t6,0x16
80007a8c:	0706                	slli	a4,a4,0x1
80007a8e:	971e                	add	a4,a4,t2
80007a90:	c0075383          	lhu	t2,-1024(a4)
80007a94:	00bfd713          	srli	a4,t6,0xb
80007a98:	001fde13          	srli	t3,t6,0x1
80007a9c:	00170e93          	addi	t4,a4,1
80007aa0:	02738733          	mul	a4,t2,t2
80007aa4:	03d73eb3          	mulhu	t4,a4,t4
80007aa8:	8f7e                	mv	t5,t6
80007aaa:	9e1a                	add	t3,t3,t1
80007aac:	40600333          	neg	t1,t1
80007ab0:	0392                	slli	t2,t2,0x4
80007ab2:	fffec713          	not	a4,t4
80007ab6:	93ba                	add	t2,t2,a4
80007ab8:	0013d713          	srli	a4,t2,0x1
80007abc:	00e37333          	and	t1,t1,a4
80007ac0:	87fe                	mv	a5,t6
80007ac2:	03c38733          	mul	a4,t2,t3
80007ac6:	40e30733          	sub	a4,t1,a4
80007aca:	00f39313          	slli	t1,t2,0xf
80007ace:	02e3b733          	mulhu	a4,t2,a4
80007ad2:	8305                	srli	a4,a4,0x1
80007ad4:	00e30e33          	add	t3,t1,a4
80007ad8:	03fe0333          	mul	t1,t3,t6
80007adc:	03fe33b3          	mulhu	t2,t3,t6
80007ae0:	9f1a                	add	t5,t5,t1
80007ae2:	006f3733          	sltu	a4,t5,t1
80007ae6:	97ba                	add	a5,a5,a4
80007ae8:	979e                	add	a5,a5,t2
80007aea:	40fe0733          	sub	a4,t3,a5
80007aee:	03173333          	mulhu	t1,a4,a7
80007af2:	03170733          	mul	a4,a4,a7
80007af6:	00e283b3          	add	t2,t0,a4
80007afa:	0053b7b3          	sltu	a5,t2,t0
80007afe:	989a                	add	a7,a7,t1
80007b00:	00f88333          	add	t1,a7,a5
80007b04:	00130893          	addi	a7,t1,1 # 7f800001 <_flash_size+0x7f700001>
80007b08:	03f887b3          	mul	a5,a7,t6
80007b0c:	40f287b3          	sub	a5,t0,a5
80007b10:	00f3b733          	sltu	a4,t2,a5
80007b14:	40e00733          	neg	a4,a4
80007b18:	01f772b3          	and	t0,a4,t6
80007b1c:	92be                	add	t0,t0,a5
80007b1e:	00f3e363          	bltu	t2,a5,80007b24 <__udivdi3+0x164>
80007b22:	8346                	mv	t1,a7
80007b24:	01f2b733          	sltu	a4,t0,t6
80007b28:	00174713          	xori	a4,a4,1
80007b2c:	971a                	add	a4,a4,t1
80007b2e:	01075733          	srl	a4,a4,a6
80007b32:	fff70793          	addi	a5,a4,-1
80007b36:	00f73733          	sltu	a4,a4,a5
80007b3a:	177d                	addi	a4,a4,-1
80007b3c:	8ff9                	and	a5,a5,a4
80007b3e:	02f68833          	mul	a6,a3,a5
80007b42:	02f638b3          	mulhu	a7,a2,a5
80007b46:	02f60733          	mul	a4,a2,a5
80007b4a:	9846                	add	a6,a6,a7
80007b4c:	41058833          	sub	a6,a1,a6
80007b50:	00e535b3          	sltu	a1,a0,a4
80007b54:	40b805b3          	sub	a1,a6,a1
80007b58:	12d58163          	beq	a1,a3,80007c7a <__udivdi3+0x2ba>
80007b5c:	00d5b533          	sltu	a0,a1,a3
80007b60:	a205                	j	80007c80 <__udivdi3+0x2c0>
80007b62:	10070963          	beqz	a4,80007c74 <__udivdi3+0x2b4>
80007b66:	12c77463          	bgeu	a4,a2,80007c8e <__udivdi3+0x2ce>
80007b6a:	01065693          	srli	a3,a2,0x10
80007b6e:	00155893          	srli	a7,a0,0x1
80007b72:	80008837          	lui	a6,0x80008
80007b76:	eac80813          	addi	a6,a6,-340 # 80007eac <__SEGGER_RTL_Moeller_inverse_lut>
80007b7a:	0016b693          	seqz	a3,a3
80007b7e:	0692                	slli	a3,a3,0x4
80007b80:	00d61733          	sll	a4,a2,a3
80007b84:	01875793          	srli	a5,a4,0x18
80007b88:	0017b793          	seqz	a5,a5
80007b8c:	078e                	slli	a5,a5,0x3
80007b8e:	00f71733          	sll	a4,a4,a5
80007b92:	8edd                	or	a3,a3,a5
80007b94:	01c75793          	srli	a5,a4,0x1c
80007b98:	0017b793          	seqz	a5,a5
80007b9c:	078a                	slli	a5,a5,0x2
80007b9e:	00f71733          	sll	a4,a4,a5
80007ba2:	8edd                	or	a3,a3,a5
80007ba4:	01e75793          	srli	a5,a4,0x1e
80007ba8:	0017b793          	seqz	a5,a5
80007bac:	0786                	slli	a5,a5,0x1
80007bae:	00f71733          	sll	a4,a4,a5
80007bb2:	8edd                	or	a3,a3,a5
80007bb4:	fff74713          	not	a4,a4
80007bb8:	837d                	srli	a4,a4,0x1f
80007bba:	8ed9                	or	a3,a3,a4
80007bbc:	00d59733          	sll	a4,a1,a3
80007bc0:	01f6c793          	xori	a5,a3,31
80007bc4:	00d512b3          	sll	t0,a0,a3
80007bc8:	00d616b3          	sll	a3,a2,a3
80007bcc:	00f8d633          	srl	a2,a7,a5
80007bd0:	0016f593          	andi	a1,a3,1
80007bd4:	00b6d793          	srli	a5,a3,0xb
80007bd8:	0166d513          	srli	a0,a3,0x16
80007bdc:	0506                	slli	a0,a0,0x1
80007bde:	9542                	add	a0,a0,a6
80007be0:	c0055503          	lhu	a0,-1024(a0)
80007be4:	0016d813          	srli	a6,a3,0x1
80007be8:	00c768b3          	or	a7,a4,a2
80007bec:	0785                	addi	a5,a5,1 # 800001 <_flash_size+0x700001>
80007bee:	02a50733          	mul	a4,a0,a0
80007bf2:	02f73733          	mulhu	a4,a4,a5
80007bf6:	87b6                	mv	a5,a3
80007bf8:	982e                	add	a6,a6,a1
80007bfa:	40b005b3          	neg	a1,a1
80007bfe:	0512                	slli	a0,a0,0x4
80007c00:	fff74713          	not	a4,a4
80007c04:	953a                	add	a0,a0,a4
80007c06:	00155713          	srli	a4,a0,0x1
80007c0a:	8df9                	and	a1,a1,a4
80007c0c:	8736                	mv	a4,a3
80007c0e:	03050633          	mul	a2,a0,a6
80007c12:	8d91                	sub	a1,a1,a2
80007c14:	00f51613          	slli	a2,a0,0xf
80007c18:	02b53533          	mulhu	a0,a0,a1
80007c1c:	8105                	srli	a0,a0,0x1
80007c1e:	9532                	add	a0,a0,a2
80007c20:	02d505b3          	mul	a1,a0,a3
80007c24:	02d53633          	mulhu	a2,a0,a3
80007c28:	97ae                	add	a5,a5,a1
80007c2a:	00b7b5b3          	sltu	a1,a5,a1
80007c2e:	972e                	add	a4,a4,a1
80007c30:	9732                	add	a4,a4,a2
80007c32:	8d19                	sub	a0,a0,a4
80007c34:	031535b3          	mulhu	a1,a0,a7
80007c38:	03150533          	mul	a0,a0,a7
80007c3c:	00a28733          	add	a4,t0,a0
80007c40:	00573533          	sltu	a0,a4,t0
80007c44:	95c6                	add	a1,a1,a7
80007c46:	952e                	add	a0,a0,a1
80007c48:	00150613          	addi	a2,a0,1
80007c4c:	02d605b3          	mul	a1,a2,a3
80007c50:	40b287b3          	sub	a5,t0,a1
80007c54:	00f735b3          	sltu	a1,a4,a5
80007c58:	40b005b3          	neg	a1,a1
80007c5c:	8df5                	and	a1,a1,a3
80007c5e:	95be                	add	a1,a1,a5
80007c60:	00f76363          	bltu	a4,a5,80007c66 <__udivdi3+0x2a6>
80007c64:	8532                	mv	a0,a2
80007c66:	4701                	li	a4,0
80007c68:	00d5b5b3          	sltu	a1,a1,a3
80007c6c:	0015c693          	xori	a3,a1,1
80007c70:	96aa                	add	a3,a3,a0
80007c72:	a819                	j	80007c88 <__udivdi3+0x2c8>
80007c74:	02c556b3          	divu	a3,a0,a2
80007c78:	a801                	j	80007c88 <__udivdi3+0x2c8>
80007c7a:	8d19                	sub	a0,a0,a4
80007c7c:	00c53533          	sltu	a0,a0,a2
80007c80:	4701                	li	a4,0
80007c82:	00154693          	xori	a3,a0,1
80007c86:	96be                	add	a3,a3,a5
80007c88:	8536                	mv	a0,a3
80007c8a:	85ba                	mv	a1,a4
80007c8c:	8082                	ret
80007c8e:	02c758b3          	divu	a7,a4,a2
80007c92:	01065693          	srli	a3,a2,0x10
80007c96:	00155293          	srli	t0,a0,0x1
80007c9a:	80008837          	lui	a6,0x80008
80007c9e:	eac80813          	addi	a6,a6,-340 # 80007eac <__SEGGER_RTL_Moeller_inverse_lut>
80007ca2:	0016b693          	seqz	a3,a3
80007ca6:	02c885b3          	mul	a1,a7,a2
80007caa:	0692                	slli	a3,a3,0x4
80007cac:	8f0d                	sub	a4,a4,a1
80007cae:	00d617b3          	sll	a5,a2,a3
80007cb2:	0187d593          	srli	a1,a5,0x18
80007cb6:	0015b593          	seqz	a1,a1
80007cba:	058e                	slli	a1,a1,0x3
80007cbc:	00b797b3          	sll	a5,a5,a1
80007cc0:	8dd5                	or	a1,a1,a3
80007cc2:	01c7d693          	srli	a3,a5,0x1c
80007cc6:	0016b693          	seqz	a3,a3
80007cca:	068a                	slli	a3,a3,0x2
80007ccc:	00d797b3          	sll	a5,a5,a3
80007cd0:	8dd5                	or	a1,a1,a3
80007cd2:	01e7d693          	srli	a3,a5,0x1e
80007cd6:	0016b693          	seqz	a3,a3
80007cda:	0686                	slli	a3,a3,0x1
80007cdc:	00d797b3          	sll	a5,a5,a3
80007ce0:	8dd5                	or	a1,a1,a3
80007ce2:	fff7c693          	not	a3,a5
80007ce6:	82fd                	srli	a3,a3,0x1f
80007ce8:	8dd5                	or	a1,a1,a3
80007cea:	00b71733          	sll	a4,a4,a1
80007cee:	01f5c793          	xori	a5,a1,31
80007cf2:	00b51333          	sll	t1,a0,a1
80007cf6:	00b61633          	sll	a2,a2,a1
80007cfa:	00f2d5b3          	srl	a1,t0,a5
80007cfe:	00167693          	andi	a3,a2,1
80007d02:	00b65793          	srli	a5,a2,0xb
80007d06:	01665513          	srli	a0,a2,0x16
80007d0a:	0506                	slli	a0,a0,0x1
80007d0c:	9542                	add	a0,a0,a6
80007d0e:	c0055503          	lhu	a0,-1024(a0)
80007d12:	00165813          	srli	a6,a2,0x1
80007d16:	00b762b3          	or	t0,a4,a1
80007d1a:	0785                	addi	a5,a5,1
80007d1c:	02a50733          	mul	a4,a0,a0
80007d20:	02f73733          	mulhu	a4,a4,a5
80007d24:	87b2                	mv	a5,a2
80007d26:	9836                	add	a6,a6,a3
80007d28:	40d006b3          	neg	a3,a3
80007d2c:	0512                	slli	a0,a0,0x4
80007d2e:	fff74713          	not	a4,a4
80007d32:	953a                	add	a0,a0,a4
80007d34:	00155713          	srli	a4,a0,0x1
80007d38:	8ef9                	and	a3,a3,a4
80007d3a:	8732                	mv	a4,a2
80007d3c:	030505b3          	mul	a1,a0,a6
80007d40:	8e8d                	sub	a3,a3,a1
80007d42:	00f51593          	slli	a1,a0,0xf
80007d46:	02d53533          	mulhu	a0,a0,a3
80007d4a:	8105                	srli	a0,a0,0x1
80007d4c:	952e                	add	a0,a0,a1
80007d4e:	02c505b3          	mul	a1,a0,a2
80007d52:	02c536b3          	mulhu	a3,a0,a2
80007d56:	97ae                	add	a5,a5,a1
80007d58:	00b7b5b3          	sltu	a1,a5,a1
80007d5c:	972e                	add	a4,a4,a1
80007d5e:	9736                	add	a4,a4,a3
80007d60:	8d19                	sub	a0,a0,a4
80007d62:	025535b3          	mulhu	a1,a0,t0
80007d66:	02550533          	mul	a0,a0,t0
80007d6a:	00a307b3          	add	a5,t1,a0
80007d6e:	0067b533          	sltu	a0,a5,t1
80007d72:	9596                	add	a1,a1,t0
80007d74:	952e                	add	a0,a0,a1
80007d76:	00150713          	addi	a4,a0,1
80007d7a:	02c705b3          	mul	a1,a4,a2
80007d7e:	40b305b3          	sub	a1,t1,a1
80007d82:	00b7b6b3          	sltu	a3,a5,a1
80007d86:	40d006b3          	neg	a3,a3
80007d8a:	8ef1                	and	a3,a3,a2
80007d8c:	96ae                	add	a3,a3,a1
80007d8e:	00b7e363          	bltu	a5,a1,80007d94 <__udivdi3+0x3d4>
80007d92:	853a                	mv	a0,a4
80007d94:	00c6b5b3          	sltu	a1,a3,a2
80007d98:	0015c693          	xori	a3,a1,1
80007d9c:	96aa                	add	a3,a3,a0
80007d9e:	8746                	mv	a4,a7
80007da0:	b5e5                	j	80007c88 <__udivdi3+0x2c8>
80007da2:	01065793          	srli	a5,a2,0x10
80007da6:	02c5d733          	divu	a4,a1,a2
80007daa:	8edd                	or	a3,a3,a5
80007dac:	02c707b3          	mul	a5,a4,a2
80007db0:	8d9d                	sub	a1,a1,a5
80007db2:	e6a9                	bnez	a3,80007dfc <__udivdi3+0x43c>
80007db4:	01055693          	srli	a3,a0,0x10
80007db8:	05c2                	slli	a1,a1,0x10
80007dba:	0542                	slli	a0,a0,0x10
80007dbc:	8dd5                	or	a1,a1,a3
80007dbe:	8141                	srli	a0,a0,0x10
80007dc0:	02c5d5b3          	divu	a1,a1,a2
80007dc4:	02c587b3          	mul	a5,a1,a2
80007dc8:	8e9d                	sub	a3,a3,a5
80007dca:	06c2                	slli	a3,a3,0x10
80007dcc:	8d55                	or	a0,a0,a3
80007dce:	02c556b3          	divu	a3,a0,a2
80007dd2:	05c2                	slli	a1,a1,0x10
80007dd4:	96ae                	add	a3,a3,a1
80007dd6:	00b6b533          	sltu	a0,a3,a1
80007dda:	972a                	add	a4,a4,a0
80007ddc:	b575                	j	80007c88 <__udivdi3+0x2c8>
80007dde:	468d                	li	a3,3
80007de0:	06d60d63          	beq	a2,a3,80007e5a <__udivdi3+0x49a>
80007de4:	4681                	li	a3,0
80007de6:	4791                	li	a5,4
80007de8:	4701                	li	a4,0
80007dea:	e8f61fe3          	bne	a2,a5,80007c88 <__udivdi3+0x2c8>
80007dee:	8109                	srli	a0,a0,0x2
80007df0:	01e59693          	slli	a3,a1,0x1e
80007df4:	8ec9                	or	a3,a3,a0
80007df6:	0025d713          	srli	a4,a1,0x2
80007dfa:	b579                	j	80007c88 <__udivdi3+0x2c8>
80007dfc:	01855813          	srli	a6,a0,0x18
80007e00:	05a2                	slli	a1,a1,0x8
80007e02:	00851793          	slli	a5,a0,0x8
80007e06:	01051693          	slli	a3,a0,0x10
80007e0a:	0ff57893          	zext.b	a7,a0
80007e0e:	0105e5b3          	or	a1,a1,a6
80007e12:	83e1                	srli	a5,a5,0x18
80007e14:	0186d813          	srli	a6,a3,0x18
80007e18:	02c5d533          	divu	a0,a1,a2
80007e1c:	02c506b3          	mul	a3,a0,a2
80007e20:	0562                	slli	a0,a0,0x18
80007e22:	8d95                	sub	a1,a1,a3
80007e24:	05a2                	slli	a1,a1,0x8
80007e26:	8ddd                	or	a1,a1,a5
80007e28:	02c5d6b3          	divu	a3,a1,a2
80007e2c:	02c687b3          	mul	a5,a3,a2
80007e30:	06c2                	slli	a3,a3,0x10
80007e32:	8d9d                	sub	a1,a1,a5
80007e34:	9536                	add	a0,a0,a3
80007e36:	05a2                	slli	a1,a1,0x8
80007e38:	0105e5b3          	or	a1,a1,a6
80007e3c:	02c5d6b3          	divu	a3,a1,a2
80007e40:	02c687b3          	mul	a5,a3,a2
80007e44:	06a2                	slli	a3,a3,0x8
80007e46:	8d9d                	sub	a1,a1,a5
80007e48:	05a2                	slli	a1,a1,0x8
80007e4a:	0115e5b3          	or	a1,a1,a7
80007e4e:	02c5d5b3          	divu	a1,a1,a2
80007e52:	9536                	add	a0,a0,a3
80007e54:	00b506b3          	add	a3,a0,a1
80007e58:	bd05                	j	80007c88 <__udivdi3+0x2c8>
80007e5a:	555555b7          	lui	a1,0x55555
80007e5e:	55558593          	addi	a1,a1,1365 # 55555555 <_flash_size+0x55455555>
80007e62:	02a5b633          	mulhu	a2,a1,a0
80007e66:	02a58533          	mul	a0,a1,a0
80007e6a:	02e5b6b3          	mulhu	a3,a1,a4
80007e6e:	02e585b3          	mul	a1,a1,a4
80007e72:	962e                	add	a2,a2,a1
80007e74:	00b635b3          	sltu	a1,a2,a1
80007e78:	9532                	add	a0,a0,a2
80007e7a:	95b6                	add	a1,a1,a3
80007e7c:	00c536b3          	sltu	a3,a0,a2
80007e80:	96ae                	add	a3,a3,a1
80007e82:	00d60733          	add	a4,a2,a3
80007e86:	9536                	add	a0,a0,a3
80007e88:	00c73633          	sltu	a2,a4,a2
80007e8c:	00d536b3          	sltu	a3,a0,a3
80007e90:	0505                	addi	a0,a0,1
80007e92:	95b2                	add	a1,a1,a2
80007e94:	00d70633          	add	a2,a4,a3
80007e98:	00153693          	seqz	a3,a0
80007e9c:	00e63533          	sltu	a0,a2,a4
80007ea0:	96b2                	add	a3,a3,a2
80007ea2:	952e                	add	a0,a0,a1
80007ea4:	00c6b733          	sltu	a4,a3,a2
80007ea8:	972a                	add	a4,a4,a0
80007eaa:	bbf9                	j	80007c88 <__udivdi3+0x2c8>

Disassembly of section .text.libc.memset:

800082ac <memset>:
800082ac:	872a                	mv	a4,a0
800082ae:	c22d                	beqz	a2,80008310 <.Lmemset_memset_end>

800082b0 <.Lmemset_unaligned_byte_set_loop>:
800082b0:	01e51693          	slli	a3,a0,0x1e
800082b4:	c699                	beqz	a3,800082c2 <.Lmemset_fast_set>
800082b6:	00b50023          	sb	a1,0(a0)
800082ba:	0505                	addi	a0,a0,1
800082bc:	167d                	addi	a2,a2,-1 # ff7fffff <__AHB_SRAM_segment_end__+0xf3f7fff>
800082be:	fa6d                	bnez	a2,800082b0 <.Lmemset_unaligned_byte_set_loop>
800082c0:	a881                	j	80008310 <.Lmemset_memset_end>

800082c2 <.Lmemset_fast_set>:
800082c2:	0ff5f593          	zext.b	a1,a1
800082c6:	00859693          	slli	a3,a1,0x8
800082ca:	8dd5                	or	a1,a1,a3
800082cc:	01059693          	slli	a3,a1,0x10
800082d0:	8dd5                	or	a1,a1,a3
800082d2:	02000693          	li	a3,32
800082d6:	00d66f63          	bltu	a2,a3,800082f4 <.Lmemset_word_set>

800082da <.Lmemset_fast_set_loop>:
800082da:	c10c                	sw	a1,0(a0)
800082dc:	c14c                	sw	a1,4(a0)
800082de:	c50c                	sw	a1,8(a0)
800082e0:	c54c                	sw	a1,12(a0)
800082e2:	c90c                	sw	a1,16(a0)
800082e4:	c94c                	sw	a1,20(a0)
800082e6:	cd0c                	sw	a1,24(a0)
800082e8:	cd4c                	sw	a1,28(a0)
800082ea:	9536                	add	a0,a0,a3
800082ec:	8e15                	sub	a2,a2,a3
800082ee:	fed676e3          	bgeu	a2,a3,800082da <.Lmemset_fast_set_loop>
800082f2:	ce19                	beqz	a2,80008310 <.Lmemset_memset_end>

800082f4 <.Lmemset_word_set>:
800082f4:	4691                	li	a3,4
800082f6:	00d66863          	bltu	a2,a3,80008306 <.Lmemset_byte_set_loop>

800082fa <.Lmemset_word_set_loop>:
800082fa:	c10c                	sw	a1,0(a0)
800082fc:	9536                	add	a0,a0,a3
800082fe:	8e15                	sub	a2,a2,a3
80008300:	fed67de3          	bgeu	a2,a3,800082fa <.Lmemset_word_set_loop>
80008304:	c611                	beqz	a2,80008310 <.Lmemset_memset_end>

80008306 <.Lmemset_byte_set_loop>:
80008306:	00b50023          	sb	a1,0(a0)
8000830a:	0505                	addi	a0,a0,1
8000830c:	167d                	addi	a2,a2,-1
8000830e:	fe65                	bnez	a2,80008306 <.Lmemset_byte_set_loop>

80008310 <.Lmemset_memset_end>:
80008310:	853a                	mv	a0,a4
80008312:	8082                	ret

Disassembly of section .text.libc.strlen:

80008314 <strlen>:
80008314:	85aa                	mv	a1,a0
80008316:	00357693          	andi	a3,a0,3
8000831a:	c29d                	beqz	a3,80008340 <.Lstrlen_aligned>
8000831c:	00054603          	lbu	a2,0(a0)
80008320:	ce21                	beqz	a2,80008378 <.Lstrlen_done>
80008322:	0505                	addi	a0,a0,1
80008324:	00357693          	andi	a3,a0,3
80008328:	ce81                	beqz	a3,80008340 <.Lstrlen_aligned>
8000832a:	00054603          	lbu	a2,0(a0)
8000832e:	c629                	beqz	a2,80008378 <.Lstrlen_done>
80008330:	0505                	addi	a0,a0,1
80008332:	00357693          	andi	a3,a0,3
80008336:	c689                	beqz	a3,80008340 <.Lstrlen_aligned>
80008338:	00054603          	lbu	a2,0(a0)
8000833c:	ce15                	beqz	a2,80008378 <.Lstrlen_done>
8000833e:	0505                	addi	a0,a0,1

80008340 <.Lstrlen_aligned>:
80008340:	01010637          	lui	a2,0x1010
80008344:	10160613          	addi	a2,a2,257 # 1010101 <_flash_size+0xf10101>
80008348:	00761693          	slli	a3,a2,0x7

8000834c <.Lstrlen_wordstrlen>:
8000834c:	4118                	lw	a4,0(a0)
8000834e:	0511                	addi	a0,a0,4
80008350:	40c707b3          	sub	a5,a4,a2
80008354:	fff74713          	not	a4,a4
80008358:	8ff9                	and	a5,a5,a4
8000835a:	8ff5                	and	a5,a5,a3
8000835c:	dbe5                	beqz	a5,8000834c <.Lstrlen_wordstrlen>
8000835e:	1571                	addi	a0,a0,-4
80008360:	01879713          	slli	a4,a5,0x18
80008364:	eb11                	bnez	a4,80008378 <.Lstrlen_done>
80008366:	0505                	addi	a0,a0,1
80008368:	01079713          	slli	a4,a5,0x10
8000836c:	e711                	bnez	a4,80008378 <.Lstrlen_done>
8000836e:	0505                	addi	a0,a0,1
80008370:	00879713          	slli	a4,a5,0x8
80008374:	e311                	bnez	a4,80008378 <.Lstrlen_done>
80008376:	0505                	addi	a0,a0,1

80008378 <.Lstrlen_done>:
80008378:	8d0d                	sub	a0,a0,a1
8000837a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

8000837c <__SEGGER_RTL_pow10f>:
8000837c:	1101                	addi	sp,sp,-32
8000837e:	ce06                	sw	ra,28(sp)
80008380:	cc22                	sw	s0,24(sp)
80008382:	ca26                	sw	s1,20(sp)
80008384:	c84a                	sw	s2,16(sp)
80008386:	c64e                	sw	s3,12(sp)
80008388:	892a                	mv	s2,a0
8000838a:	c515                	beqz	a0,800083b6 <__SEGGER_RTL_pow10f+0x3a>
8000838c:	41f95513          	srai	a0,s2,0x1f
80008390:	e0018413          	addi	s0,gp,-512 # 80003690 <__SEGGER_RTL_aPower2f>
80008394:	00a944b3          	xor	s1,s2,a0
80008398:	8c89                	sub	s1,s1,a0
8000839a:	3f8009b7          	lui	s3,0x3f800
8000839e:	0014f513          	andi	a0,s1,1
800083a2:	c511                	beqz	a0,800083ae <__SEGGER_RTL_pow10f+0x32>
800083a4:	400c                	lw	a1,0(s0)
800083a6:	854e                	mv	a0,s3
800083a8:	92aff0ef          	jal	800074d2 <__mulsf3>
800083ac:	89aa                	mv	s3,a0
800083ae:	8085                	srli	s1,s1,0x1
800083b0:	0411                	addi	s0,s0,4
800083b2:	f4f5                	bnez	s1,8000839e <__SEGGER_RTL_pow10f+0x22>
800083b4:	a019                	j	800083ba <__SEGGER_RTL_pow10f+0x3e>
800083b6:	3f8009b7          	lui	s3,0x3f800
800083ba:	3f800537          	lui	a0,0x3f800
800083be:	85ce                	mv	a1,s3
800083c0:	9c2ff0ef          	jal	80007582 <__divsf3>
800083c4:	00094363          	bltz	s2,800083ca <__SEGGER_RTL_pow10f+0x4e>
800083c8:	854e                	mv	a0,s3
800083ca:	40f2                	lw	ra,28(sp)
800083cc:	4462                	lw	s0,24(sp)
800083ce:	44d2                	lw	s1,20(sp)
800083d0:	4942                	lw	s2,16(sp)
800083d2:	49b2                	lw	s3,12(sp)
800083d4:	6105                	addi	sp,sp,32
800083d6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

800083d8 <__SEGGER_RTL_current_locale>:
800083d8:	00080537          	lui	a0,0x80
800083dc:	32c52503          	lw	a0,812(a0) # 8032c <__SEGGER_RTL_locale_ptr>
800083e0:	e509                	bnez	a0,800083ea <__SEGGER_RTL_current_locale+0x12>
800083e2:	00080537          	lui	a0,0x80
800083e6:	30050513          	addi	a0,a0,768 # 80300 <__RAL_global_locale>
800083ea:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

800083ec <__SEGGER_RTL_ascii_mbtowc>:
800083ec:	4701                	li	a4,0
800083ee:	c19d                	beqz	a1,80008414 <__SEGGER_RTL_ascii_mbtowc+0x28>
800083f0:	c215                	beqz	a2,80008414 <__SEGGER_RTL_ascii_mbtowc+0x28>
800083f2:	0005c603          	lbu	a2,0(a1)
800083f6:	01861593          	slli	a1,a2,0x18
800083fa:	0005cc63          	bltz	a1,80008412 <__SEGGER_RTL_ascii_mbtowc+0x26>
800083fe:	85e1                	srai	a1,a1,0x18
80008400:	c111                	beqz	a0,80008404 <__SEGGER_RTL_ascii_mbtowc+0x18>
80008402:	c110                	sw	a2,0(a0)
80008404:	0006a023          	sw	zero,0(a3) # 800000 <_flash_size+0x700000>
80008408:	0006a223          	sw	zero,4(a3)
8000840c:	00b03733          	snez	a4,a1
80008410:	a011                	j	80008414 <__SEGGER_RTL_ascii_mbtowc+0x28>
80008412:	5779                	li	a4,-2
80008414:	853a                	mv	a0,a4
80008416:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

80008418 <__SEGGER_RTL_ascii_wctomb>:
80008418:	07f00613          	li	a2,127
8000841c:	00b67463          	bgeu	a2,a1,80008424 <__SEGGER_RTL_ascii_wctomb+0xc>
80008420:	5579                	li	a0,-2
80008422:	8082                	ret
80008424:	00b50023          	sb	a1,0(a0)
80008428:	4505                	li	a0,1
8000842a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

8000842c <__SEGGER_RTL_ascii_isctype>:
8000842c:	07f00613          	li	a2,127
80008430:	02a66263          	bltu	a2,a0,80008454 <__SEGGER_RTL_ascii_isctype+0x28>
80008434:	80008637          	lui	a2,0x80008
80008438:	5dd60613          	addi	a2,a2,1501 # 800085dd <__SEGGER_RTL_ascii_ctype_map>
8000843c:	9532                	add	a0,a0,a2
8000843e:	80008637          	lui	a2,0x80008
80008442:	5a860613          	addi	a2,a2,1448 # 800085a8 <__SEGGER_RTL_ascii_ctype_mask>
80008446:	95b2                	add	a1,a1,a2
80008448:	00054503          	lbu	a0,0(a0)
8000844c:	0005c583          	lbu	a1,0(a1)
80008450:	8d6d                	and	a0,a0,a1
80008452:	8082                	ret
80008454:	4501                	li	a0,0
80008456:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

80008458 <__SEGGER_RTL_ascii_iswctype>:
80008458:	07f00613          	li	a2,127
8000845c:	02a66263          	bltu	a2,a0,80008480 <__SEGGER_RTL_ascii_iswctype+0x28>
80008460:	80008637          	lui	a2,0x80008
80008464:	5dd60613          	addi	a2,a2,1501 # 800085dd <__SEGGER_RTL_ascii_ctype_map>
80008468:	9532                	add	a0,a0,a2
8000846a:	80008637          	lui	a2,0x80008
8000846e:	5a860613          	addi	a2,a2,1448 # 800085a8 <__SEGGER_RTL_ascii_ctype_mask>
80008472:	95b2                	add	a1,a1,a2
80008474:	00054503          	lbu	a0,0(a0)
80008478:	0005c583          	lbu	a1,0(a1)
8000847c:	8d6d                	and	a0,a0,a1
8000847e:	8082                	ret
80008480:	4501                	li	a0,0
80008482:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

80008c18 <__SEGGER_init_zero>:
80008c18:	4008                	lw	a0,0(s0)
80008c1a:	404c                	lw	a1,4(s0)
80008c1c:	0421                	addi	s0,s0,8
80008c1e:	c591                	beqz	a1,80008c2a <.L__SEGGER_init_zero_Done>

80008c20 <.L__SEGGER_init_zero_Loop>:
80008c20:	00050023          	sb	zero,0(a0)
80008c24:	0505                	addi	a0,a0,1
80008c26:	15fd                	addi	a1,a1,-1
80008c28:	fde5                	bnez	a1,80008c20 <.L__SEGGER_init_zero_Loop>

80008c2a <.L__SEGGER_init_zero_Done>:
80008c2a:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

80008c2c <__SEGGER_init_copy>:
80008c2c:	4008                	lw	a0,0(s0)
80008c2e:	404c                	lw	a1,4(s0)
80008c30:	4410                	lw	a2,8(s0)
80008c32:	0431                	addi	s0,s0,12
80008c34:	ca09                	beqz	a2,80008c46 <.L__SEGGER_init_copy_Done>

80008c36 <.L__SEGGER_init_copy_Loop>:
80008c36:	00058683          	lb	a3,0(a1)
80008c3a:	00d50023          	sb	a3,0(a0)
80008c3e:	0505                	addi	a0,a0,1
80008c40:	0585                	addi	a1,a1,1
80008c42:	167d                	addi	a2,a2,-1
80008c44:	fa6d                	bnez	a2,80008c36 <.L__SEGGER_init_copy_Loop>

80008c46 <.L__SEGGER_init_copy_Done>:
80008c46:	8082                	ret
