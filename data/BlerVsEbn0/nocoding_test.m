%% 指定码长，没有编码时的误块率
clear; clc; close all;
%% 初始化
L_word = 1024;
L_info = L_word / 2;
EbN0_dBs = linspace(-1, 13, 30);
sigma2s = 1 ./ 10 .^ (EbN0_dBs / 10);
%% 仿真多次取平均
blers = zeros(size(EbN0_dBs));
N_test = 1e4; test_step = 1e2;
parfor_progress(N_test / test_step);
parfor iter_test = 1:N_test
    blers_hold = zeros(size(EbN0_dBs));
    sigma2s_hold = sigma2s;
    for iter_noi = 1:numel(EbN0_dBs)
        tx_symbs = 1 - 2 * randi([0, 1], 1, L_word);
        dcd_symbs = sign(tx_symbs + randn(size(tx_symbs)) * sqrt(sigma2s_hold(iter_noi)));
        blers_hold(iter_noi) = double(mean(dcd_symbs ~= tx_symbs) > 0);
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













