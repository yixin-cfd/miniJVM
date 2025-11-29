#!/bin/bash
# Switch 专用构建脚本
DEVKITPRO=/opt/devkitpro
PORTLIBS_PREFIX=${DEVKITPRO}/portlibs/switch
TOOL_PREFIX=${DEVKITPRO}/devkitA64/bin/aarch64-none-elf-
 
# 生成 C 代码(复用现有逻辑)
${JAVA_HOME}/bin/java -cp tools/translator.jar com.ebsee.Main \
    ../../minijvm/java/src/main/java/:../../test/minijvm_test/src/main/java/ \
    ../app/generted/classes/ ../app/generted/c/
 
# 编译为 Switch 可执行文件
${TOOL_PREFIX}gcc -O3 -g -march=armv8-a+crc+crypto -mtune=cortex-a57 \
    -fPIE -I${PORTLIBS_PREFIX}/include \
    -D__SWITCH__ \
    -o miniJVM.elf \
    -I../app/generted/c -I../app/vm \
    ../app/vm/*.c ../app/generted/c/*.c \
    ../app/platform/switch/main.c \
    -L${PORTLIBS_PREFIX}/lib -lswitch
 
# 生成 NRO 文件
${DEVKITPRO}/tools/bin/elf2nro miniJVM.elf miniJVM.nro \
    --icon=icon.jpg --nacp=miniJVM.nacp