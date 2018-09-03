# 启动时长优化分析及评估 v1.0


#### 测试启动时长定义-标准描述：
> 不考虑开屏广告的情况下，用户冷启动应用程序，可见第一个界面为计时点。打点时机：页面ViewDidAppear函数执行。

#### 标签说明

FL0  |  FL1  |  VDL0  |  VDL1  |  VDAP 
------|------|------|------|-------
进finisLanch函数 |出finisLanch函数| 进ViewDidload | 出ViewDidload | ViewDidAppear


## 1. device1

### 1. 设备信息：
Model: iPhone 6: | iOS 11.0.1 (15A402) | Capacity: 26.7 GB (15.12 GB available)

### 2. target:
sdsp-ext3:com.ysdqTV.iphone.client

### 3. pre-main time：
Total pre-main time: 1.3 seconds (100.0%)
         dylib loading time: 176.68 milliseconds (12.8%)
        rebase/binding time: 185.90 milliseconds (13.5%)
            ObjC setup time: 244.58 milliseconds (17.7%)
           initializer time: 768.44 milliseconds (55.8%)
           slowest intializers :
             libSystem.B.dylib :  22.00 milliseconds (1.5%)
    libMainThreadChecker.dylib :  90.87 milliseconds (6.6%)
           FunTVServiceDynamic : 175.15 milliseconds (12.7%)
                       PPTVSdk :  81.80 milliseconds (5.9%)
                     sdsp-ext3 : 770.07 milliseconds (55.9%)

Total pre-main time: 768.41 milliseconds (100.0%)
         dylib loading time: 111.18 milliseconds (14.4%)
        rebase/binding time:  97.59 milliseconds (12.7%)
            ObjC setup time: 110.15 milliseconds (14.3%)
           initializer time: 449.27 milliseconds (58.4%)
           slowest intializers :
             libSystem.B.dylib :  15.37 milliseconds (2.0%)
    libMainThreadChecker.dylib :  37.24 milliseconds (4.8%)
           FunTVServiceDynamic : 114.50 milliseconds (14.9%)
                       PPTVSdk :  65.23 milliseconds (8.4%)
                     sdsp-ext3 : 379.36 milliseconds (49.3%)

Total pre-main time: 668.54 milliseconds (100.0%)
         dylib loading time: 135.66 milliseconds (20.2%)
        rebase/binding time:  69.51 milliseconds (10.3%)
            ObjC setup time: 101.27 milliseconds (15.1%)
           initializer time: 361.92 milliseconds (54.1%)
           slowest intializers :
             libSystem.B.dylib :  15.56 milliseconds (2.3%)
    libMainThreadChecker.dylib :  24.77 milliseconds (3.7%)
           FunTVServiceDynamic :  93.59 milliseconds (14.0%)
                       PPTVSdk :  48.54 milliseconds (7.2%)
                     sdsp-ext3 : 333.87 milliseconds (49.9%)

Total pre-main time: 578.20 milliseconds (100.0%)
         dylib loading time: 106.41 milliseconds (18.4%)
        rebase/binding time:  65.46 milliseconds (11.3%)
            ObjC setup time:  69.97 milliseconds (12.1%)
           initializer time: 336.18 milliseconds (58.1%)
           slowest intializers :
             libSystem.B.dylib :   8.48 milliseconds (1.4%)
    libMainThreadChecker.dylib :  22.61 milliseconds (3.9%)
           FunTVServiceDynamic :  91.33 milliseconds (15.7%)
                       PPTVSdk :  48.07 milliseconds (8.3%)
                     sdsp-ext3 : 315.87 milliseconds (54.6%)

Total pre-main time: 581.61 milliseconds (100.0%)
         dylib loading time: 106.18 milliseconds (18.2%)
        rebase/binding time:  64.24 milliseconds (11.0%)
            ObjC setup time:  72.13 milliseconds (12.4%)
           initializer time: 338.87 milliseconds (58.2%)
           slowest intializers :
             libSystem.B.dylib :   8.56 milliseconds (1.4%)
    libMainThreadChecker.dylib :  23.32 milliseconds (4.0%)
           FunTVServiceDynamic :  92.73 milliseconds (15.9%)
                       PPTVSdk :  48.27 milliseconds (8.2%)
                     sdsp-ext3 : 313.35 milliseconds (53.8%)

Total pre-main time: 601.91 milliseconds (100.0%)
         dylib loading time: 109.02 milliseconds (18.1%)
        rebase/binding time:  71.58 milliseconds (11.8%)
            ObjC setup time:  73.55 milliseconds (12.2%)
           initializer time: 347.58 milliseconds (57.7%)
           slowest intializers :
             libSystem.B.dylib :  13.54 milliseconds (2.2%)
    libMainThreadChecker.dylib :  22.68 milliseconds (3.7%)
           FunTVServiceDynamic :  90.68 milliseconds (15.0%)
                       PPTVSdk :  48.32 milliseconds (8.0%)
                     sdsp-ext3 : 322.04 milliseconds (53.5%)

> Average:
Total pre-main time: 639.734

### 4. finishLaunch time 统计。
FL0    FL1    VDL0       VDL1    VDAP

0.2196 	2.4219	4.3877	4.6782	4.87240.3073 	3.0725	4.8486	5.7361	11.27520.3026 	2.7961	4.5444	5.4487	5.72230.3050 	2.8009	5.014	5.5055	5.74910.2970 	2.6891	4.7177	5.2097	5.51990.3094 	2.7897	4.6638	5.7346	6.0238				0.2626	2.5222	4.5048	4.8508	5.06890.2231	2.4872	4.0111	4.8049	5.08640.2128	2.2804	3.9483	4.6778	4.99160.2294	2.3952	3.9237	4.6597	4.96340.2273	2.4037	3.902	4.5666	4.8030.2276	2.339	4.227	4.7766	5.00050.2154	2.4907	4.0623	4.813	5.10050.2069	2.4209	4.3341	4.8617	5.05560.2222	2.4663	4.4309	4.895	5.12340.2183	2.3069	3.9369	4.5521	4.84450.2256	2.2729	4.2894	4.7371	4.95370.2201	2.3093	4.1237	4.5195	4.77070.2283	2.4421	3.88	4.6388	4.8888> Average:0.22458	2.39514	    4.12118	4.71951 4.9732 

## 2. device2

### 1. 设备信息：
Model: iPhone 6s Plus | iOS 11.3.1 (15E302) | Capacity: 26.39 GB (3.12 GB available)

### 2. target:
sdsp-ext3:com.ysdqTV.iphone.client

### 3. pre-main time：
Total pre-main time: 1.2 seconds (100.0%)
         dylib loading time:  99.83 milliseconds (7.7%)
        rebase/binding time:  80.91 milliseconds (6.2%)
            ObjC setup time: 220.36 milliseconds (17.0%)
           initializer time: 891.87 milliseconds (68.9%)
           slowest intializers :
             libSystem.B.dylib :  10.28 milliseconds (0.7%)
          libglInterpose.dylib : 188.25 milliseconds (14.5%)
           FunTVServiceDynamic :  54.63 milliseconds (4.2%)
                       PPTVSdk :  40.89 milliseconds (3.1%)
                     sdsp-ext3 : 1.0 seconds (80.0%)


Total pre-main time: 716.15 milliseconds (100.0%)
         dylib loading time:  98.89 milliseconds (13.8%)
        rebase/binding time:  53.06 milliseconds (7.4%)
            ObjC setup time: 152.55 milliseconds (21.3%)
           initializer time: 411.49 milliseconds (57.4%)
           slowest intializers :
             libSystem.B.dylib :  10.46 milliseconds (1.4%)
    libMainThreadChecker.dylib :  14.76 milliseconds (2.0%)
          libglInterpose.dylib :  96.56 milliseconds (13.4%)
         libMTLInterpose.dylib :  18.12 milliseconds (2.5%)
           FunTVServiceDynamic :  52.63 milliseconds (7.3%)
                       PPTVSdk :  42.00 milliseconds (5.8%)
                     sdsp-ext3 : 280.77 milliseconds (39.2%)

Total pre-main time: 533.56 milliseconds (100.0%)
         dylib loading time:  65.65 milliseconds (12.3%)
        rebase/binding time:  43.62 milliseconds (8.1%)
            ObjC setup time:  89.49 milliseconds (16.7%)
           initializer time: 334.66 milliseconds (62.7%)
           slowest intializers :
             libSystem.B.dylib :  10.13 milliseconds (1.8%)
    libMainThreadChecker.dylib :  12.64 milliseconds (2.3%)
          libglInterpose.dylib :  78.99 milliseconds (14.8%)
         libMTLInterpose.dylib :  15.91 milliseconds (2.9%)
           FunTVServiceDynamic :  77.68 milliseconds (14.5%)
                       PPTVSdk :  26.55 milliseconds (4.9%)
                     sdsp-ext3 : 222.98 milliseconds (41.7%)

Total pre-main time: 526.60 milliseconds (100.0%)
         dylib loading time:  96.14 milliseconds (18.2%)
        rebase/binding time:  42.97 milliseconds (8.1%)
            ObjC setup time:  78.96 milliseconds (14.9%)
           initializer time: 308.39 milliseconds (58.5%)
           slowest intializers :
             libSystem.B.dylib :   9.77 milliseconds (1.8%)
    libMainThreadChecker.dylib :  13.01 milliseconds (2.4%)
          libglInterpose.dylib :  82.79 milliseconds (15.7%)
         libMTLInterpose.dylib :  15.37 milliseconds (2.9%)
           FunTVServiceDynamic :  33.67 milliseconds (6.3%)
                       PPTVSdk :  25.35 milliseconds (4.8%)
                     sdsp-ext3 : 221.22 milliseconds (42.0%)

Total pre-main time: 553.71 milliseconds (100.0%)
         dylib loading time:  65.22 milliseconds (11.7%)
        rebase/binding time:  80.02 milliseconds (14.4%)
            ObjC setup time:  89.44 milliseconds (16.1%)
           initializer time: 318.89 milliseconds (57.5%)
           slowest intializers :
             libSystem.B.dylib :   9.35 milliseconds (1.6%)
    libMainThreadChecker.dylib :  12.97 milliseconds (2.3%)
          libglInterpose.dylib :  82.26 milliseconds (14.8%)
         libMTLInterpose.dylib :  25.34 milliseconds (4.5%)
           FunTVServiceDynamic :  32.63 milliseconds (5.8%)
                       PPTVSdk :  26.67 milliseconds (4.8%)
                     sdsp-ext3 : 221.13 milliseconds (39.9%)

> Average:
Total pre-main time: 582.505

### 4. finishLaunch time 统计。
FL0    FL1    VDL0       VDL1    VDAP
 
3.2784 	 5.5555 	 7.1235 	 7.6652    8.0213 
2.1543 	 3.9903 	 5.1059 	 5.5660    5.6885 
2.1505 	 3.7130 	 4.7058 	 4.9895    5.1802 
2.1377 	 3.6323 	 4.6782 	 5.1280    5.4020 
2.1261 	 3.6973 	 4.8148 	 5.3656    5.5216 
2.1149 	 3.5932 	 4.5314 	 4.9159    5.1520 

0.5521 	 1.7873 	 2.7558 	 3.0800    3.2291 
0.5654 	 1.8069 	 2.7670 	 3.0004    3.2562 
0.5588 	 1.7672 	 2.8366 	 3.1925    3.3447 
0.5687 	 1.7606 	 2.7734 	 3.1004    3.2524 
0.5685 	 1.7649 	 2.7068 	 3.0275    3.1818 
0.6095 	 1.9363 	 3.1530 	 3.4252    3.6266 
0.6435 	 1.9399 	 3.1201 	 3.4190    3.6297 
0.5437 	 1.6991 	 2.6439 	 2.9033    3.0967 
0.5462 	 1.7336 	 2.7827 	 3.1256    3.2733 
0.5401 	 1.7401 	 2.7050 	 3.0083    3.1766 

Average:
FL0        FL1        VDL0       VDL1       VDAP
2.32698	 4.03027	5.15993		5.605033333    5.82760.55877	 1.79359	2.82443		3.12822        3.30671


## 3. 对比程序（iphone6启动工程收集对比数据）
### 1. 设备信息：
Model: iPhone 6: | iOS 11.0.1 (15A402) | Capacity: 26.7 GB (15.12 GB available)

### 2. target:
fmy.DQUIViewlib 用于测试UI的Demo程序

### 3. pre-main time：
Total pre-main time:  95.29 milliseconds (100.0%)
         dylib loading time:  33.26 milliseconds (34.9%)
        rebase/binding time:   4.34 milliseconds (4.5%)
            ObjC setup time:  11.53 milliseconds (12.1%)
           initializer time:  46.02 milliseconds (48.2%)
           slowest intializers :
             libSystem.B.dylib :   6.16 milliseconds (6.4%)
   libBacktraceRecording.dylib :   5.89 milliseconds (6.1%)
    libMainThreadChecker.dylib :  17.96 milliseconds (18.8%)
                       ModelIO :   4.47 milliseconds (4.6%)
                 MediaServices :   2.96 milliseconds (3.1%)
                   DQUIViewlib :   1.91 milliseconds (2.0%)

Total pre-main time:  96.60 milliseconds (100.0%)
         dylib loading time:  32.18 milliseconds (33.3%)
        rebase/binding time:   1.93 milliseconds (2.0%)
            ObjC setup time:  10.67 milliseconds (11.0%)
           initializer time:  51.67 milliseconds (53.4%)
           slowest intializers :
             libSystem.B.dylib :   6.74 milliseconds (6.9%)
   libBacktraceRecording.dylib :   5.75 milliseconds (5.9%)
    libMainThreadChecker.dylib :  21.70 milliseconds (22.4%)
                       ModelIO :   5.27 milliseconds (5.4%)
                 MediaServices :   4.66 milliseconds (4.8%)

Total pre-main time:  98.36 milliseconds (100.0%)
         dylib loading time:  36.11 milliseconds (36.7%)
        rebase/binding time:   1.95 milliseconds (1.9%)
            ObjC setup time:  11.31 milliseconds (11.5%)
           initializer time:  48.84 milliseconds (49.6%)
           slowest intializers :
             libSystem.B.dylib :   6.53 milliseconds (6.6%)
   libBacktraceRecording.dylib :   6.12 milliseconds (6.2%)
    libMainThreadChecker.dylib :  19.34 milliseconds (19.6%)
                       ModelIO :   5.77 milliseconds (5.8%)
                 MediaServices :   3.39 milliseconds (3.4%)

Total pre-main time:  85.39 milliseconds (100.0%)
         dylib loading time:  30.92 milliseconds (36.2%)
        rebase/binding time:   2.08 milliseconds (2.4%)
            ObjC setup time:  10.05 milliseconds (11.7%)
           initializer time:  42.19 milliseconds (49.4%)
           slowest intializers :
             libSystem.B.dylib :   5.11 milliseconds (5.9%)
   libBacktraceRecording.dylib :   5.63 milliseconds (6.5%)
    libMainThreadChecker.dylib :  17.32 milliseconds (20.2%)
                       ModelIO :   4.51 milliseconds (5.2%)
                 MediaServices :   2.72 milliseconds (3.1%)

> Average:
Total pre-main time: 93.91

### 4. finishLaunch time 统计。
FL0    FL1    VDL0       VDL1    VDAP

0.2784	0.318	0.3886	0.3993	0.44980.2719	0.3139	0.3816	0.3927	0.44410.2728	0.3176	0.3851	0.3958	0.44560.2911	0.3366	0.405	0.4162	0.46640.2816	0.3322	0.3995	0.4108	0.45930.2722	0.3252	0.392	0.4037	0.45360.2787	0.3348	0.4025	0.4131	0.46240.1808	0.2344	0.3126	0.3253	0.38480.1849	0.2348	0.3113	0.323	0.38340.1897	0.2404	0.317	0.3297	0.39220.26	0.3273	0.5117	0.551	0.82940.2487	0.3067	0.3853	0.3967	0.4534

> Average:0.2509	0.302 	0.38268 	0.396442	0.4687



## 4. 数据分析结果评估：
Average:
FL0        FL1        VDL0       VDL1       VDAP
0.2509	     0.302 	0.38268 	0.3964      0.4687

2.32698	 4.03027	5.15993		5.605033333    5.82760.55877	 1.79359	2.82443		3.12822        3.30671
0.22458	 2.39514	4.12118  	4.71951        4.9732 

> 备注： 以上数据以及以下分析，均基于抽样测试数据分析结果。

### 1. 整体对比
1. Model: iPhone 6s Plus | iOS 11.3.1 (15E302) | Capacity: 26.39 GB (3.12 GB available)
平均启动时长：
(pre-main time)[0.583] + (appfinishLaunch_time + viewShow_time)[3.30671] = 3.89s

2. Model: iPhone 6: | iOS 11.0.1 (15A402) | Capacity: 26.7 GB (15.12 GB available)
平均启动时长：(pre-main time)[0.64] + (appfinishLaunch_time + viewShow_time)[4.9732] = 5.62s

**对比demo程序数据统计效果**
Model: iPhone 6: | iOS 11.0.1 (15A402) | Capacity: 26.7 GB (15.12 GB available)
平均启动时长：(pre-main time)[0.1] + (appfinishLaunch_time + viewShow_time)[0.4687] = 0.57s。


### 2. 设备影响
不同设备及设备系统影响启动速度差异。有近两秒的差异
> 此处不再优化考虑范围内。

### 3. 对比规律可知 pre-main time ，除了第一次启动，两个设备的时长统计都在0.6s 左右。 
> 在优化考虑范围内，可优化空间较小
> 理论优化效果（ 100ms < optimize_time < 500ms ）。

### 4. appfinishLaunch之后，到定义的完成启动，耗启动总时长占比约 80%
> 在优化重点考虑范围内，可优化空间大 
> 理论优化效果 (0.57s < optimize_time < 5 s)。


## 5. 启动时长优化计划期望目标描述：

### 1. pre-main time: 
再减去100 ms
### 2. 程序函数执行优化部分:
同等设备条件下，消耗时长减半。


 






