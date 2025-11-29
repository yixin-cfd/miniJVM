// switch/main.c
#include <switch.h>
#include "jvm.h"
 
s32 main(int argc, const char *argv[]) {
    // 初始化 Switch 子系统
    socketInitializeDefault();
    nxlinkStdio();
    
    // 设置工作目录(Switch 的 romfs)
    Utf8String *startup_dir = utf8_create_c("romfs:/");
    
    // 设置主类名
    Utf8String *mainClassName = utf8_create_c("test.HelloWorld");
    
    // 运行 JVM
    s32 ret = jvm_run_main(mainClassName, startup_dir);
    
    // 清理
    utf8_destory(mainClassName);
    utf8_destory(startup_dir);
    socketExit();
    return ret;
}