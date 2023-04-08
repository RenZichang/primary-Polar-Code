%% 固定码率，绘制 Eb/N0 - BLER 曲线
clear; clc; close all;
%% 初始化
L_word = 1024;
L_info = 512;
info_index = getInfoIndex(L_word, L_info);
EbN0_dBs = linspace(0, 7, 8);
% (SNR_linear) = (Eb/N0_linear) * (nBits=1) * (CodeRate) / (1/2) / (SampleRate=1)
sigma2s = 1 ./ (10 .^ (EbN0_dBs / 10) * L_info / L_word * 2);
%% 仿真多次取平均
blers = zeros(size(EbN0_dBs));
N_test = 1e4; test_step = 1e2;
parfor_progress(N_test / test_step);
parfor iter_test = 1:N_test
    blers_hold = zeros(size(EbN0_dBs));
    sigma2s_hold = sigma2s;
    for iter_noi = 1:numel(EbN0_dBs)
        blers_hold(iter_noi) = getPerfDot(info_index, sigma2s_hold(iter_noi), "hard");
    end
    blers = blers + blers_hold / N_test;
    % 更新进度条
    if mod(iter_test, test_step) == 0
        parfor_progress;
    end
end
parfor_progress(0);
%% 可视化仿真结果
semilogy(EbN0_dBs, blers); grid on;
xlabel("E_b/N_0 [dB]"); ylabel("BLER");






