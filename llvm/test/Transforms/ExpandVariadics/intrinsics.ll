; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=wasm32-unknown-unknown -S --passes=expand-variadics --expand-variadics-override=optimize < %s | FileCheck %s -check-prefixes=CHECK,OPT
; RUN: opt -mtriple=wasm32-unknown-unknown -S --passes=expand-variadics --expand-variadics-override=lowering < %s | FileCheck %s -check-prefixes=CHECK,ABI
; REQUIRES: webassembly-registered-target

declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture)

declare void @llvm.va_copy.p0(ptr, ptr)

declare void @valist(ptr noundef)

declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture)

declare void @llvm.va_start.p0(ptr)

declare void @llvm.va_end.p0(ptr)


define void @start_once(...) {
; OPT-LABEL: @start_once(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[VA_START:%.*]] = alloca ptr, align 4
; OPT-NEXT:    call void @llvm.lifetime.start.p0(i64 4, ptr [[VA_START]])
; OPT-NEXT:    call void @llvm.va_start.p0(ptr [[VA_START]])
; OPT-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[VA_START]], align 4
; OPT-NEXT:    call void @start_once.valist(ptr [[TMP0]])
; OPT-NEXT:    call void @llvm.lifetime.end.p0(i64 4, ptr [[VA_START]])
; OPT-NEXT:    ret void
;
; ABI-LABEL: @start_once(
; ABI-NEXT:  entry:
; ABI-NEXT:    [[S:%.*]] = alloca ptr, align 4
; ABI-NEXT:    call void @llvm.lifetime.start.p0(i64 4, ptr nonnull [[S]])
; ABI-NEXT:    store ptr [[VARARGS:%.*]], ptr [[S]], align 4
; ABI-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[S]], align 4
; ABI-NEXT:    call void @valist(ptr noundef [[TMP0]])
; ABI-NEXT:    call void @llvm.lifetime.end.p0(i64 4, ptr nonnull [[S]])
; ABI-NEXT:    ret void
;
entry:
  %s = alloca ptr, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %s)
  call void @llvm.va_start.p0(ptr nonnull %s)
  %0 = load ptr, ptr %s, align 4
  call void @valist(ptr noundef %0)
  call void @llvm.va_end.p0(ptr %s)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %s)
  ret void
}


define void @start_twice(...) {
; OPT-LABEL: @start_twice(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[VA_START:%.*]] = alloca ptr, align 4
; OPT-NEXT:    call void @llvm.lifetime.start.p0(i64 4, ptr [[VA_START]])
; OPT-NEXT:    call void @llvm.va_start.p0(ptr [[VA_START]])
; OPT-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[VA_START]], align 4
; OPT-NEXT:    call void @start_twice.valist(ptr [[TMP0]])
; OPT-NEXT:    call void @llvm.lifetime.end.p0(i64 4, ptr [[VA_START]])
; OPT-NEXT:    ret void
;
; ABI-LABEL: @start_twice(
; ABI-NEXT:  entry:
; ABI-NEXT:    [[S0:%.*]] = alloca ptr, align 4
; ABI-NEXT:    [[S1:%.*]] = alloca ptr, align 4
; ABI-NEXT:    call void @llvm.lifetime.start.p0(i64 4, ptr nonnull [[S0]])
; ABI-NEXT:    call void @llvm.lifetime.start.p0(i64 4, ptr nonnull [[S1]])
; ABI-NEXT:    store ptr [[VARARGS:%.*]], ptr [[S0]], align 4
; ABI-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[S0]], align 4
; ABI-NEXT:    call void @valist(ptr noundef [[TMP0]])
; ABI-NEXT:    store ptr [[VARARGS]], ptr [[S1]], align 4
; ABI-NEXT:    [[TMP1:%.*]] = load ptr, ptr [[S1]], align 4
; ABI-NEXT:    call void @valist(ptr noundef [[TMP1]])
; ABI-NEXT:    call void @llvm.lifetime.end.p0(i64 4, ptr nonnull [[S1]])
; ABI-NEXT:    call void @llvm.lifetime.end.p0(i64 4, ptr nonnull [[S0]])
; ABI-NEXT:    ret void
;
entry:
  %s0 = alloca ptr, align 4
  %s1 = alloca ptr, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %s0)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %s1)
  call void @llvm.va_start.p0(ptr nonnull %s0)
  %0 = load ptr, ptr %s0, align 4
  call void @valist(ptr noundef %0)
  call void @llvm.va_end.p0(ptr %s0)
  call void @llvm.va_start.p0(ptr nonnull %s1)
  %1 = load ptr, ptr %s1, align 4
  call void @valist(ptr noundef %1)
  call void @llvm.va_end.p0(ptr %s1)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %s1)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %s0)
  ret void
}

define void @copy(ptr noundef %va) {
; CHECK-LABEL: @copy(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VA_ADDR:%.*]] = alloca ptr, align 4
; CHECK-NEXT:    [[CP:%.*]] = alloca ptr, align 4
; CHECK-NEXT:    store ptr [[VA:%.*]], ptr [[VA_ADDR]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 4, ptr nonnull [[CP]])
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i32(ptr [[CP]], ptr [[VA_ADDR]], i32 4, i1 false)
; CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[CP]], align 4
; CHECK-NEXT:    call void @valist(ptr noundef [[TMP0]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 4, ptr nonnull [[CP]])
; CHECK-NEXT:    ret void
;
entry:
  %va.addr = alloca ptr, align 4
  %cp = alloca ptr, align 4
  store ptr %va, ptr %va.addr, align 4
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %cp)
  call void @llvm.va_copy.p0(ptr nonnull %cp, ptr nonnull %va.addr)
  %0 = load ptr, ptr %cp, align 4
  call void @valist(ptr noundef %0)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %cp)
  ret void
}
