# 一些关于本代码的说明

## 1. 一个描述约定

根据Arikan的“信道极化现象”理论，我们认为靠近信道的一侧为极化码的第1层极化，靠近编码器输入侧的为最后一层极化，如图所示：

![极化码编码器结构](https://i.328888.xyz/2023/04/08/i3OFDA.png)

## 2. 关于SC译码思路的简单阐述

译码过程并不是二叉树的前序/中序/后序遍历，而是一个独特的过程，需要自行编程实现，不能指望有人做轮子；其次，所有引脚上的数据都应该妥善保存，因此应该将所有引脚数据写成一个矩阵，然后迭代更新矩阵中每一个位置上的值。

伪代码：

``` matlab
while true
    % <当前节点>是否是最后一层？否：
        % 当前节点的<左-子节点>未曾计算？是：计算并跳转到<左-子节点>
        % 否：当前节点的<右-子节点>未曾计算？是：计算并跳转到<右-子节点>
        % 否：根据<左,右-子节点>更新<当前节点>并跳转到<父节点>
    % 是：如果是最后一个比特位则直接停止，否则跳转到<父节点>
end
```

除此以外，代码中使用了reshape函数，得到的东西相当于第一张图中的极化码编码器的“极化模块引脚号”。如果希望深入理解，自己手动reshape一下就明白了。

## 3. 文件目录以及简单解释

``` cmd
│  getPerfDot.m                     # 一个函数，用于仿真一次极化码的BLER性能，方便集成到其他更复杂脚本内
│  readme.md                        # 本文档
│  test_BlerVsEbn0.m                # 绘制BLER-EbN0曲线，也即最经典的编码性能曲线，注意只能使用EbN0而不能使用SNR，而仿真中用的一般都是噪声方差sigma2，因此需要进行简单的转换，详见脚本内部
│
├─appendix                         # 一些用于辅助说明的附件
│      长度为8的极化码编码器.png
│
├─data                             # 用于保存某次仿真所得到的结果
│  └─BlerVsEbn0                   # 这样命名清晰明了：这个文件夹下保存的是test_BlerVsEbn0.m脚本的运行结果
│          Lword-1024_allhard.mat   # 全部为硬判决的SC译码算法
│          Lword-1024_allsoft.mat   # 全部为软判决的SC译码算法
│          Lword-1024_minsum.mat    # 跟all_hard一样
│          Lword-1024_nocoding.mat  # 没有编码直接传输
│          Lword-1024_standard.mat  # 经典的Arikan原论文中的SC译码算法，二叉树下降时使用F,G函数，二叉树返回时对先前比特位进行硬判决（而非保留LLR）
│          nocoding_test.m          # 脚本，用于得到无编码传输的BLER数据
│          plot_BlerVsEbn0.m        # 脚本，用于可视化本文件夹下的数据
│
└─private                          # matlab的功能之一：本地函数。文件夹只能以private命名，内部放置一些不希望暴露在外的函数，可以使文件组织更整齐
        getInfoIndex.m               # 极化码信息比特位的索引
        polarDecode.m                # 极化码译码函数
        polarEncode.m                # 极化码编码函数
```

## 4. 如有疑问请提交issue
