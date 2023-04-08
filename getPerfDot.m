function bler = getPerfDot(info_index, sigma2, judge_type)
%GETPERFDOT 仿真实数信道下，极化码的单点性能
%   input: info_index, 信息位索引
%          sigma2, 在调制方式为{0 -> +1, 1 -> -1}的情况下，信道的噪声方差
%          judge_type, 译码算法按纯软的"soft"还是纯硬的"hard"
%   output: bler, 误块率，由于是仿真单点性能，因此将只取值于0或1

% 编码、传输
info_bits = randi([0, 1], 1, numel(find(info_index)));
code_bits = polarEncode(info_index, info_bits);
tx_symbs = 1 - 2 * code_bits;
rx_llrs = (tx_symbs + randn(size(tx_symbs)) * sqrt(sigma2)) * 2 / sigma2;
% 获得误符号率
dcd_bits = polarDecode(info_index, rx_llrs, judge_type);
bler = double(mean(dcd_bits(info_index) ~= info_bits) > 0);
end

