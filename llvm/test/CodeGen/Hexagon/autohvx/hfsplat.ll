; RUN: llc -mtriple=hexagon < %s | FileCheck %s

; Check that the vsplat instruction is generated
; CHECK: r[[V:[0-9]+]] = #16752
; CHECK: vsplat(r[[V]])

target datalayout = "e-m:e-p:32:32:32-a:0-n16:32-i64:64:64-i32:32:32-i16:16:16-i1:8:8-f32:32:32-f64:64:64-v32:32:32-v64:64:64-v512:512:512-v1024:1024:1024-v2048:2048:2048"
target triple = "hexagon"
; Function Attrs: nofree norecurse nounwind writeonly
define dso_local i32 @foo(ptr nocapture %0, i32 %1) local_unnamed_addr #0 {
  %3 = icmp sgt i32 %1, 0
  br i1 %3, label %4, label %22

4:                                                ; preds = %2
  %5 = icmp ult i32 %1, 128
  br i1 %5, label %6, label %9

6:                                                ; preds = %20, %4
  %7 = phi ptr [ %0, %4 ], [ %11, %20 ]
  %8 = phi i32 [ 0, %4 ], [ %10, %20 ]
  br label %23

9:                                                ; preds = %4
  %10 = and i32 %1, -128
  %11 = getelementptr half, ptr %0, i32 %10
  br label %12

12:                                               ; preds = %12, %9
  %13 = phi i32 [ 0, %9 ], [ %18, %12 ]
  %14 = getelementptr half, ptr %0, i32 %13
  %15 = bitcast ptr %14 to ptr
  store <64 x half> <half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170>, ptr %15, align 2
  %16 = getelementptr half, ptr %14, i32 64
  %17 = bitcast ptr %16 to ptr
  store <64 x half> <half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170, half 0xH4170>, ptr %17, align 2
  %18 = add i32 %13, 128
  %19 = icmp eq i32 %18, %10
  br i1 %19, label %20, label %12

20:                                               ; preds = %12
  %21 = icmp eq i32 %10, %1
  br i1 %21, label %22, label %6

22:                                               ; preds = %23, %20, %2
  ret i32 0

23:                                               ; preds = %23, %6
  %24 = phi ptr [ %28, %23 ], [ %7, %6 ]
  %25 = phi i32 [ %26, %23 ], [ %8, %6 ]
  store half 0xH4170, ptr %24, align 2
  %26 = add nuw nsw i32 %25, 1
  %27 = icmp eq i32 %26, %1
  %28 = getelementptr half, ptr %24, i32 1
  br i1 %27, label %22, label %23
}

attributes #0 = { nofree norecurse nounwind writeonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="hexagonv69" "target-features"="+hvx-length128b,+hvxv69,+v69,-long-calls" "unsafe-fp-math"="false" "use-soft-float"="false" }
