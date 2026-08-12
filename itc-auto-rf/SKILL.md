---
name: itc-auto-rf
description: "将 markdown、txt、Excel 用例文档转换为 Robot Framework（.robot）自动化脚本，并在 CBG 设备环境运行、并输出结果。用于：用例转脚本、md/txt/xlsx 转 Robot、CBG 自动化用例生成与调试。"
version: 1.1
author: 阮学勇
argument-hint: "提供用例文档路径、业务组件、目标脚本类型，以及可用的测试床或 topo 信息"
---

# CBG 自动化用例自动生成

这个 skill 将markdown, txt, excel格式的用例文档，转化成robot framework自动化用例脚本； 根据用例脚本运行测试，输出结果。

## 适用场景

- 需要把 `.md` 或 `.txt` 用例说明转换为 `.robot`。
- 需要把 `.xlsx` 或 `.xls` 用例转换为自动化脚本。
- 需要在 CBG 测试床执行用例脚本，并输出结果。

## 输入与输出

开始前确认以下输入：

- 用例文档路径。
- 业务组件，例如路由、二层、安全。
- 目标脚本类型；未指定时默认生成 `.robot`。
- 是否需要实际运行；如需运行，必须提供或确认测试床和 topo 信息。

运行后的输出包括：

- 用例需要保存在 `autotest/auto-case/<组件>/script/` 目录下。
- 执行命令、结果摘要。

## 自动化环境说明

用例脚本要能够连接设备并运行，离不开一套自动化环境。自动化环境仓库为 `D:/CI`，该仓库一些关键的，常用的目录以及文件说明如下：
- `.venv/` 目录存放自动化环境所需的脚本和库，运行时优先使用其中的工具链（如 `.venv\Scripts\python.exe`、`.venv\Scripts\robot.exe`）。关键运行自动化脚本步骤如下：
```
1. 激活虚拟环境
./.venv/Scripts/activate.ps1

2. 使用虚拟环境的python执行脚本
python -m robot autotest/auto-case/<组件>/script/<用例名>.robot
```
- `autotest/resource/` 存放Robot资源、关键字层、Python辅助库以及配置信息。
- `autotest/resource/testbedlib/` 存放测试床相关库。
- `autotest/resource/rglib/` 存放自动化脚本通用Python库；最原生的通用的接口会封装成python库信息，放到这里。
- `autotest/resource/rgkw/` 存放自动化脚本通用Robot关键字，通用的操作会封装成关联字保存到这里, 通常会对`autotest/resource/rglib/`通用库信息封装一层。
- `autotest/resource/setting/` 存放测试床、DUT、Tester 及端口映射 yaml 配置。
- `autotest/resource/resource.robot` 是自动化用例运行入口，提供测试床信息。
- `autotest/case/` 目录存在大量业务用例脚本，按不同类别存放。其中 CBG 事业部 DCN 部门的用例存放在 `component_cbg/dcn/` 目录下。
- `autotest/auto-case/` 存放通过该技能自动生成的用例。

## 用例转换流程

### 1. 解析输入文档

- `.md` 或 `.txt`：直接解析用例名称、前置条件、测试步骤和预期结果。
- `.xlsx` 或 `.xls`：先使用 `xlsx-to-case` 转换为 markdown，再继续处理。
- 目标脚本保存到 `autotest/auto-case/<组件>/script/`；例如路由脚本保存到 `autotest/auto-case/route/script/`。

### 2. 判断步骤执行对象

- `DUT`、`被测设备`：表示对被测设备配置或查询。
- `Tester`、`测试仪`：表示对测试仪配置、打流或统计。
- 文档未标注执行对象时，根据命令语义和同组件样本判断；仍无法可靠判断时，向用户确认，不得随意下发到设备。
例如：
```
#步骤1
DUT：
config
ip route 1.1.1.1 255.255.255.255 10.0.0.2
```

### 3. 查找并复用现有实现

- 优先复用已有Robot关键字、Python库和资源文件，不从零重复实现。
- 次优先参考`autotest/case/component_cbg/dcn/`下同组件、同功能的最近样本。
- 最后文档缺少非关键细节时，可根据最近样本补齐；涉及拓扑、设备地址、端口或预期结果时必须向用户确认。
- 仅将`./assets/template.robot`作为骨架；资源引用、关键字命名、Setup/Teardown 和步骤风格以真实样本为准。

### 4. 生成脚本

- 将前置条件、测试步骤和预期结果完整映射到脚本，不遗漏清理步骤。
- 一个用例文档对应一个 `.robot` 脚本；一个脚本中可以包含多个用例。
- 在设备配置、Tester 配置、发流和结果校验等关键节点记录必要日志。

- 脚本转化时，引用代码优先级从高到低排序如下：
 1. python工具自带库, robot framework工具自带库，自带关键字。
 2. ruijie自研的robot关键字，路径为`autotest/resource/rgkw/`。
 3. ruijie自研的python库，路径为`autotest/resource/rglib/`，`autotest/resource/testbedlib/`。
 4. CBG事业群，DCN事业部自动化用例代码，路径为`autotest/case/component_cbg/dcn/`，不同组件需要参考对应组件代码，路径为`autotest/case/component_cbg/dcn/<组件>/`。
 
- dut设备连接操作，tester连接操作为自动化脚本频繁使用功能，用例转化时可优先参考`autotest/resource/rgkw/`路径下telnet.robot, tester.robot, dut.robot以及`autotest/resource/rglib/`路径下telnet.py, tester.py这几个文件关键字和库函数。

- 操作测试仪优先使用tester.robot关键字，操作设备优先使用dut.robot关键字。
**测试仪常用关键字**
1. 连接测试仪，断开测试仪连接。
2. 登录测试仪，退出登入。使用用户指定的登入名称，如果用户未提供，提示用户提供信息。
2. 关闭保活keep alive，保证测试仪不断连。
3. take ownership占用端口，clear ownership释放占用的端口
4. 端口复位，设置测试仪端口介质phy_mode，等config模式端口配置时，配置完都需要延迟5s生效，确保端口up。 使用用户指定测试仪端口介质，如果用户未提供，提示用户提供信息。 
6. 构造流量，删除流量
7. 发送流量，停止流量
8. 获取流量统计，清除流量统计
9. 抓包，停止抓包
**设备常用关键字**
1. 连接设备，端口连接
2. cli操作
3. shell操作

- 整套用例连续执行时，需要确保执行前后环境一致。
**Suite Setup**
1. 连接测试仪、根据用户名登入、登入后关闭keep alive保证测试仪不断连、take ownership占用端口、复位端口、设置测试仪端口介质；配置完后需要等待5s生效，确保端口up。
2. 连接设备
**Suite Teardown**
1. clear ownership 解除接口占用、退出登入、断开连接。
2. 连接设备

- 单个用例执行时，确保执行前后环境一致。
**Test Setup**
无
**Test Teardown**
1. 用户对设备的配置需要在执行后回滚掉。
2. 用户创建的流量需要在用例执行后删除掉。

- DUT 与 Tester 参数格式不同，不能原样复用。
```
# MAC：
  - DUT 静态 ARP 场景常见点分格式（示例：`0011.2233.4455`）
  - NT 打流接口常见冒号分隔格式（示例：`00:11:22:33:44:55`）
# IP/掩码：
  - DUT CLI 常见 `ip/mask` 或设备特定命令格式
  - NT 打流参数通常按工具库要求的字段写法（如 `intf_ip_addr`、`gateway`、`netmask`）
#测试仪IPv6要使用完整格式：
正确写法：
1000:0000:0000:0000:0000:0000:0000:0002
错误写法：
1000::2
```

- 端口代号 `<port1>`、`<port2>`、`<port3>`、`<port4>` 等必须使用变量。设备配置时映射到 DUT 端口，Tester 配置时映射到测试仪端口。

### 5. 静态验证

- `.robot` 脚本优先运行 Robot Framework dry-run，检查资源、关键字、变量和参数，命令如下：
```powershell
cd D:/CI
.\.venv\Scripts\Activate.ps1; python -m robot --dryrun autotest/auto-case/<组件>/script/<脚本名>.robot;
``` 
- 静态验证失败时先修复，再连接真实设备。

## 用例执行

### 1. 获取用户topo关系

执行用例前检查用户是否提供以下信息：
```
# 环境配置及topo描述

测试床名称(testbed): <testbed_name>
设备IP(DUT)：<device_name> <device_ip>
测试仪IP(Tester)：<tester_name> <tester_ip>
测试仪接口介质(phy_mode)：<phy_mode>
测试仪登入名(user)：<user>
组件：<组件>

设备(DUT) -- 测试仪(Tester) -- 端口代号
<device_port1> -- <tester_port1> -- <port1>
<device_port2> -- <tester_port2> -- <port2>
<device_port3> -- <tester_port3> -- <port3>
<device_port4> -- <tester_port4> -- <port4>
```
仅静态验证，不连接真实设备，可以不提供。需要连接正式设备时，必须提供topo映射关系，如未提供，需要提示用户补充topo信息；

### 2. 根据用户topo关系配置自动化环境topo

#### 2.1 指定使用的测试床

`autotest/resource/resource.robot`为自动化测试脚本入口文件，根据用户指定的测试床名称配置。如果用户未提供，提示用户提供信息。
```
${tbname}   <testbed_name>    # 测试床名称为 <trestbed_name>
```

#### 2.2 测试床配置

`autotest/resource/setting/testbed.yaml`描述不同测试床使用的设备和测试仪，根据用户提供的配置的信息填写即可，如果用户未提供，提示用户提供信息。
```
<testbed_name>:
  dut1: <device_name>.yaml
  tester: <tester_name>.yaml
```

#### 2.3 被测设备配置

`autotest/resource/setting/<device_name>.yaml` 描述设备IP地址, 端口代号和实际被测设备端口的映射关系, 根据用户提供的配置的信息填写即可，如果用户未提供，提示用户提供信息。
```
name: <device_name>
host: "<device_ip>"
port: 23
protocol: telnet
type: SWITCH
if1:
  name: <device_port1>
if2:
  name: <device_port2>
if3:
  name: <device_port3>
if4:
  name: <device_port4>
```

#### 2.3 测试仪配置

3. `autotest/resource/setting/<tester_name>.yaml` 描述测试仪IP地址，端口代号和实际测试仪端口的映射关系，根据用户提供的配置的信息填写即可，如果用户未提供，提示用户提供信息。
```
name: <tester_name>
host: "<tester_ip>"
port: 23
type: "nt"
if1:
  name: <tester_port1>
if2:
  name: <tester_port2>
if3:
  name: <tester_port3>
if4:
  name: <tester_port4>
```

#### 2.4 配置完检查topo是否和用户提供的一致

运行前确认`resource.robot`，`testbed.yaml`，`<device_name>.yaml` 和 `<tester_name>.yaml` 是否和用户配置的一致。

### 3. 运行并按日志修正

1. 使用 `.venv` 中的解释器或 Robot Framework 工具运行脚本。
```powershell 
cd D:/CI
./.venv/Scripts/activate.ps1
python -m robot autotest/auto-case/<组件>/<脚本名>.robot
```
2. 失败时先提取首个阻断错误，并区分脚本错误、关键字/参数错误、连接失败、topo 错误和设备行为异常，提示用户错误位置，错误log以及可能的原因。
3. 不能只根据“connect success”判断 Tester 可用，还要结合后续状态、超时和端口占用结果。

## 完成标准

- 脚本已保存到正确组件目录，命名符合同目录惯例。
- 用例步骤和预期结果均已转化，DUT/Tester 操作对象与参数格式正确。
- 要求真实执行时，至少完成一次设备环境运行并记录结果。
- 运行失败时，输出错误内容、判断依据、错误结果和仍缺少的外部条件。
- 所有用例运行完的log：output.xml，log.html，report.html汇总到D:/CI/autotest/log目录中

## 示例请求

- 把这个路由 markdown 用例转换成 Robot 脚本并执行。
- 将这份 Excel 用例先转成 markdown，再生成 Python 自动化脚本。
- 根据 txt 用例生成 CBG 测试脚本；缺少 topo 时先列出需要补充的信息。
