# NPU 计组实验 MIPS32位单周期CPU设计2

## 项目简介

本项目是**西北工业大学计算机学院**计组实验课程内容——MIPS32位单周期CPU设计的第二个项目。

在第一个项目（R-type指令）的基础上，本设计逐步扩展了 I-type 立即数指令、访存指令、分支跳转指令，最终实现了一个支持较完整 MIPS 指令子集的单周期CPU。完整的设计文件位于 `phase4` 目录中。

## 模块结构

| 模块 | 文件 | 功能描述 |
|------|------|----------|
| PC | `pc.v` | 程序计数器，支持PC+4、分支跳转、J跳转、jr跳转 |
| IM | `im.v` | 指令存储器（ROM） |
| Instr_decode | `instr_decode.v` | 指令译码，含立即数的零扩展与符号扩展 |
| GPR | `gpr.v` | 通用寄存器堆（32×32bit） |
| Control | `control.v` | 控制单元，产生全部控制信号 |
| ALU | `alu.v` | 算术逻辑单元 |
| DM | `dm.v` | 数据存储器（RAM），支持 lw/sw |
| s_cycle_cpu | `s_cycle_cpu.v` | 顶层模块 |
| tb_single_cycle_cpu1 | `tb_single_cycle_cpu1.v` | 测试激励模块 |

## 支持的指令

### 继承自设计1（R-type）
`addu`、`subu`、`add`、`and`、`or`、`slt`、`sll`

### 本设计新增
| 指令 | 类型 | 说明 |
|------|------|------|
| `addi` | I-type | 立即数加法 |
| `addiu` | I-type | 无符号立即数加法 |
| `andi` | I-type | 立即数与 |
| `ori` | I-type | 立即数或 |
| `lui` | I-type | 加载立即数到高位 |
| `lw` | I-type | 从内存加载字 |
| `sw` | I-type | 存储字到内存 |
| `beq` | I-type | 相等则分支 |
| `j` | J-type | 无条件跳转 |
| `jal` | J-type | 跳转并链接 |
| `jr` | R-type | 跳转到寄存器地址 |

## 实验阶段

- **Phase 1**：在 s_cycle_cpu1 基础上增加I-type指令支持（`addi`、`addiu`、`andi`、`ori`、`lui`）
- **Phase 2**：实现 DM 模块，增加访存指令支持（`lw`、`sw`）
- **Phase 3**：中间阶段工作
- **Phase 4**：增加分支跳转指令支持（`beq`、`j`、`jal`、`jr`），完成完整CPU集成与验证（最终版本）

## 开发环境

- 硬件描述语言：Verilog HDL
- 仿真工具：支持 Verilog 的任意仿真器（ModelSim / iverilog / Vivado Simulator 等）
- 测试方式：通过 testbench 加载 `.hex` 文件进行指令仿真

## 说明

本项目为西北工业大学计算机学院计算机组成原理实验课程内容，仅供学习参考。
