// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMBacktrace.h"
#import "OMLogMoudle.h"
#import <mach/mach.h>
#include <dlfcn.h>
#include <pthread.h>
#include <sys/types.h>
#include <limits.h>
#include <string.h>
#include <mach-o/dyld.h>
#include <mach-o/nlist.h>


#if defined(__arm64__)
#define OM_DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(3UL))
#define OM_THREAD_STATE_COUNT ARM_THREAD_STATE64_COUNT
#define OM_THREAD_STATE ARM_THREAD_STATE64
#define OM_FRAME_POINTER __fp
#define OM_STACK_POINTER __sp
#define OM_INSTRUCTION_ADDRESS __pc

#elif defined(__arm__)
#define OM_DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(1UL))
#define OM_THREAD_STATE_COUNT ARM_THREAD_STATE_COUNT
#define OM_THREAD_STATE ARM_THREAD_STATE
#define OM_FRAME_POINTER __r[7]
#define OM_STACK_POINTER __sp
#define OM_INSTRUCTION_ADDRESS __pc

#elif defined(__x86_64__)
#define OM_DETAG_INSTRUCTION_ADDRESS(A) (A)
#define OM_THREAD_STATE_COUNT x86_THREAD_STATE64_COUNT
#define OM_THREAD_STATE x86_THREAD_STATE64
#define OM_FRAME_POINTER __rbp
#define OM_STACK_POINTER __rsp
#define OM_INSTRUCTION_ADDRESS __rip

#elif defined(__i386__)
#define OM_DETAG_INSTRUCTION_ADDRESS(A) (A)
#define OM_THREAD_STATE_COUNT x86_THREAD_STATE32_COUNT
#define OM_THREAD_STATE x86_THREAD_STATE32
#define OM_FRAME_POINTER __ebp
#define OM_STACK_POINTER __esp
#define OM_INSTRUCTION_ADDRESS __eip

#endif

#define OM_CALL_INSTRUCTION_FROM_RETURN_ADDRESS(A) (OM_DETAG_INSTRUCTION_ADDRESS((A)) - 1)

#if defined(__LP64__)
#define OM_NLIST struct nlist_64
#else
#define OM_NLIST struct nlist
#endif

#define OMPACStrippingMask_ARM64e 0x0000000fffffffff

#define OM_CSTRING_TO_NSSTRING(s) (s==NULL?@"":[NSString stringWithFormat:@"%s",s])

typedef struct OMStackFrameEntry{
    const struct OMStackFrameEntry *const previous;
    const uintptr_t return_address;
} OMStackFrameEntry;



@implementation OMBacktrace

+ (NSArray *)allThreadBacktrace {
    thread_act_array_t threads;
    mach_msg_type_number_t thread_count = 0;
    const task_t this_task = mach_task_self();
    
    NSMutableArray *threadsBacktrace = [NSMutableArray array];
    
    kern_return_t kr = task_threads(this_task, &threads, &thread_count);
    if (kr != KERN_SUCCESS) {
        return [threadsBacktrace copy];
    }
    
    OMLogD(@"Call Backtrace of %u threads:\n",thread_count);

    for(int i = 0; i < thread_count; i++) {
        NSMutableDictionary *threadDic = [NSMutableDictionary dictionary];
        [threadDic setObject:OMBacktraceOfThread(threads[i]) forKey:@"backtrace"];
        [threadsBacktrace addObject:threadDic];
    }
    return [threadsBacktrace copy];
}


NSArray *OMBacktraceOfThread(thread_t thread) {
    uintptr_t backtraceBuffer[50];
    int i = 0;
    
    NSMutableArray *btArray = [NSMutableArray array];
    
    OMLogD(@"Backtrace of Thread %u:\n",thread);
    
    _STRUCT_MCONTEXT machineContext;
    if (!OMFillThreadStateIntoMachineContext(thread, &machineContext)) {
        OMLogD(@"Fail to get information about thread: %u",thread);
        return [btArray copy];
    }
    
    const uintptr_t instructionAddress = OMMachInstructionAddress(&machineContext);
    backtraceBuffer[i] = OMNormaliseInstructionPointer(instructionAddress);
    ++i;
    
    uintptr_t linkRegister = OMMachLinkRegister(&machineContext);
    if (linkRegister) {
        backtraceBuffer[i] = OMNormaliseInstructionPointer(linkRegister);
        i++;
    }
    
    if (instructionAddress == 0) {
        OMLogD(@"Fail to get instruction address");
        return [btArray copy];
    }
    
    OMStackFrameEntry frame = {0};
    const uintptr_t framePtr = OMMachFramePointer(&machineContext);
    if (framePtr == 0 ||
       OMMachCopyMem((void *)framePtr, &frame, sizeof(frame)) != KERN_SUCCESS) {
        OMLogD( @"Fail to get frame pointer");
        return [btArray copy];
    }
    
    for(; i < 50; i++) {
        backtraceBuffer[i] = OMNormaliseInstructionPointer(frame.return_address);
        if (backtraceBuffer[i] == 0 ||
           frame.previous == 0 ||
           OMMachCopyMem(frame.previous, &frame, sizeof(frame)) != KERN_SUCCESS) {
            break;
        }
    }
    
    int backtraceLength = i;
    Dl_info symbolicated[backtraceLength];
    OMSymbolicate(backtraceBuffer, symbolicated, backtraceLength, 0);
    for (int i = 0; i < backtraceLength; ++i) {
        [btArray addObject:OMBacktraceEntry(i, backtraceBuffer[i], &symbolicated[i])];
    }

    return [btArray copy];
}


NSString* OMBacktraceEntry(const int num,const uintptr_t address,const Dl_info* const dlInfo)
{

    NSString *btStr = [NSString stringWithFormat:@"frame #%d: 0x%lx %@ %@ + %lu",\
                     num,\
                     address,\
                     OM_CSTRING_TO_NSSTRING(OMLastPathEntry(dlInfo->dli_fname)),\
                     OM_CSTRING_TO_NSSTRING(dlInfo->dli_sname),\
                     address - (uintptr_t)dlInfo->dli_saddr];
    return btStr;

}


const char* OMLastPathEntry(const char* const path)
{
    if (path == NULL)
    {
        return NULL;
    }

    char* lastFile = strrchr(path, '/');
    return lastFile == NULL ? path : lastFile + 1;
}

#pragma -mark HandleMachineContext

uintptr_t OMNormaliseInstructionPointer(uintptr_t ip)
{
#if defined (__arm64__)
    ip = ip & OMPACStrippingMask_ARM64e;
#endif
    return ip;
}

bool OMFillThreadStateIntoMachineContext(thread_t thread, _STRUCT_MCONTEXT *machineContext) {
    mach_msg_type_number_t state_count = OM_THREAD_STATE_COUNT;
    kern_return_t kr = thread_get_state(thread, OM_THREAD_STATE, (thread_state_t)&machineContext->__ss, &state_count);
    return (kr == KERN_SUCCESS);
}

uintptr_t OMMachFramePointer(mcontext_t const machineContext) {
    return machineContext->__ss.OM_FRAME_POINTER;
}

uintptr_t OMMachStackPointer(mcontext_t const machineContext) {
    return machineContext->__ss.OM_STACK_POINTER;
}

uintptr_t OMMachInstructionAddress(mcontext_t const machineContext) {
    return machineContext->__ss.OM_INSTRUCTION_ADDRESS;
}

uintptr_t OMMachLinkRegister(mcontext_t const machineContext) {
#if defined(__i386__) || defined(__x86_64__)
    return 0;
#else
    return machineContext->__ss.__lr;
#endif
}

kern_return_t OMMachCopyMem(const void *const src, void *const dst, const size_t numBytes) {
    vm_size_t bytesCopied = 0;
    return vm_read_overwrite(mach_task_self(), (vm_address_t)src, (vm_size_t)numBytes, (vm_address_t)dst, &bytesCopied);
}

#pragma -mark Symbolicate
void OMSymbolicate(const uintptr_t* const backtraceBuffer,
                    Dl_info* const symbolsBuffer,
                    const int numEntries,
                    const int skippedEntries) {
    int i = 0;
    
    if (!skippedEntries && i < numEntries) {
        OMDlAddr(backtraceBuffer[i], &symbolsBuffer[i]);
        i++;
    }
    
    for(; i < numEntries; i++) {
        OMDlAddr(OM_CALL_INSTRUCTION_FROM_RETURN_ADDRESS(backtraceBuffer[i]), &symbolsBuffer[i]);
    }
}

bool OMDlAddr(const uintptr_t address, Dl_info* const info) {
    info->dli_fname = NULL;
    info->dli_fbase = NULL;
    info->dli_sname = NULL;
    info->dli_saddr = NULL;
    
    const uint32_t idx = OMImageIndexContainingAddress(address);
    if (idx == UINT_MAX) {
        return false;
    }
    const struct mach_header* header = _dyld_get_image_header(idx);
    const uintptr_t imageVMAddrSlide = (uintptr_t)_dyld_get_image_vmaddr_slide(idx);
    const uintptr_t addressWithSlide = address - imageVMAddrSlide;
    const uintptr_t segmentBase = OMSegmentBaseOfImageIndex(idx) + imageVMAddrSlide;
    if (segmentBase == 0) {
        return false;
    }
    
    info->dli_fname = _dyld_get_image_name(idx);
    info->dli_fbase = (void*)header;
    
    // Find symbol tables and get whichever symbol is closest to the address.
    const OM_NLIST* bestMatch = NULL;
    uintptr_t bestDistance = ULONG_MAX;
    uintptr_t cmdPtr = OMFirstCmdAfterHeader(header);
    if (cmdPtr == 0) {
        return false;
    }
    for(uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++) {
        const struct load_command* loadCmd = (struct load_command*)cmdPtr;
        if (loadCmd->cmd == LC_SYMTAB) {
            const struct symtab_command* symtabCmd = (struct symtab_command*)cmdPtr;
            const OM_NLIST* symbolTable = (OM_NLIST*)(segmentBase + symtabCmd->symoff);
            const uintptr_t stringTable = segmentBase + symtabCmd->stroff;
            
            for(uint32_t iSym = 0; iSym < symtabCmd->nsyms; iSym++) {
                // If n_value is 0, the symbol refers to an external object.
                if (symbolTable[iSym].n_value != 0) {
                    uintptr_t symbolBase = symbolTable[iSym].n_value;
                    uintptr_t currentDistance = addressWithSlide - symbolBase;
                    if ((addressWithSlide >= symbolBase) &&
                       (currentDistance <= bestDistance)) {
                        bestMatch = symbolTable + iSym;
                        bestDistance = currentDistance;
                    }
                }
            }
            if (bestMatch != NULL) {
                info->dli_saddr = (void*)(bestMatch->n_value + imageVMAddrSlide);
                info->dli_sname = (char*)((intptr_t)stringTable + (intptr_t)bestMatch->n_un.n_strx);
                if (*info->dli_sname == '_') {
                    info->dli_sname++;
                }
                // This happens if all symbols have been stripped.
                if (info->dli_saddr == info->dli_fbase && bestMatch->n_type == 3) {
                    info->dli_sname = NULL;
                }
                break;
            }
        }
        cmdPtr += loadCmd->cmdsize;
    }
    return true;
}

uintptr_t OMFirstCmdAfterHeader(const struct mach_header* const header) {
    switch(header->magic) {
        case MH_MAGIC:
        case MH_CIGAM:
            return (uintptr_t)(header + 1);
        case MH_MAGIC_64:
        case MH_CIGAM_64:
            return (uintptr_t)(((struct mach_header_64*)header) + 1);
        default:
            return 0;  // Header is corrupt
    }
}

uint32_t OMImageIndexContainingAddress(const uintptr_t address) {
    const uint32_t imageCount = _dyld_image_count();
    const struct mach_header* header = 0;
    
    for(uint32_t iImg = 0; iImg < imageCount; iImg++) {
        header = _dyld_get_image_header(iImg);
        if (header != NULL) {
            // Look for a segment command with this address within its range.
            uintptr_t addressWSlide = address - (uintptr_t)_dyld_get_image_vmaddr_slide(iImg);
            uintptr_t cmdPtr = OMFirstCmdAfterHeader(header);
            if (cmdPtr == 0) {
                continue;
            }
            for(uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++) {
                const struct load_command* loadCmd = (struct load_command*)cmdPtr;
                if (loadCmd->cmd == LC_SEGMENT) {
                    const struct segment_command* segCmd = (struct segment_command*)cmdPtr;
                    if (addressWSlide >= segCmd->vmaddr &&
                       addressWSlide < segCmd->vmaddr + segCmd->vmsize) {
                        return iImg;
                    }
                }
                else if (loadCmd->cmd == LC_SEGMENT_64) {
                    const struct segment_command_64* segCmd = (struct segment_command_64*)cmdPtr;
                    if (addressWSlide >= segCmd->vmaddr &&
                       addressWSlide < segCmd->vmaddr + segCmd->vmsize) {
                        return iImg;
                    }
                }
                cmdPtr += loadCmd->cmdsize;
            }
        }
    }
    return UINT_MAX;
}

uintptr_t OMSegmentBaseOfImageIndex(const uint32_t idx) {
    const struct mach_header* header = _dyld_get_image_header(idx);
    
    // Look for a segment command and return the file image address.
    uintptr_t cmdPtr = OMFirstCmdAfterHeader(header);
    if (cmdPtr == 0) {
        return 0;
    }
    for(uint32_t i = 0;i < header->ncmds; i++) {
        const struct load_command* loadCmd = (struct load_command*)cmdPtr;
        if (loadCmd->cmd == LC_SEGMENT) {
            const struct segment_command* segmentCmd = (struct segment_command*)cmdPtr;
            if (strcmp(segmentCmd->segname, SEG_LINKEDIT) == 0) {
                return segmentCmd->vmaddr - segmentCmd->fileoff;
            }
        }
        else if (loadCmd->cmd == LC_SEGMENT_64) {
            const struct segment_command_64* segmentCmd = (struct segment_command_64*)cmdPtr;
            if (strcmp(segmentCmd->segname, SEG_LINKEDIT) == 0) {
                return (uintptr_t)(segmentCmd->vmaddr - segmentCmd->fileoff);
            }
        }
        cmdPtr += loadCmd->cmdsize;
    }
    return 0;
}

@end

