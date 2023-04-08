%% 绘制 BLER - Eb/N0 图像
clear; clc; close all;
figure(); subplot(111);
%% 对数纵轴
% 使用tanh运算计算的标准译码算法
standard_decode = load("Lword-1024_standard.mat");
% 使用近似运算的最小和译码算法
minsum_decode = load("Lword-1024_minsum.mat");
% 使用全纯软运算的译码算法
allsoft_decode = load("Lword-1024_allsoft.mat");
% 使用全纯硬运算的译码算法
allhard_decode = load("Lword-1024_allhard.mat");
% 没有任何编码的误块率
nocoding = load("Lword-1024_nocoding.mat");
% 绘图
semilogy(nocoding.EbN0_dBs, nocoding.blers, "-", ...
    standard_decode.EbN0_dBs, standard_decode.blers, "-o", ...
    minsum_decode.EbN0_dBs, minsum_decode.blers, "-x", ...
    allsoft_decode.EbN0_dBs, allsoft_decode.blers, "-s", ...
    allhard_decode.EbN0_dBs, allhard_decode.blers, "-^");
grid on;
legend(["no coding", "standard", "minsum", "allsoft", "allhard"]);
xlabel("E_b/N_0 [dB]"); ylabel("BLER");

