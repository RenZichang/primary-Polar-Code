function code_word = polarEncode(info_index, info_bits)
%POLARENCODE 指定码长、信息比特位与消息比特序列，进行2^n极化码编码
%   input: info_index, 信息比特位
%          info_bits, 消息比特序列
%   output: code_word, 极化码编码码字

% 初始化
L_word = numel(info_index);
N_level = log2(L_word);
code_word = zeros(1, L_word);
code_word(info_index) = info_bits;
% 分轮迭代
for iter_level = N_level:-1:1
    polar_groups = reshape(1:L_word, 2^(N_level-iter_level), 2, 2^(iter_level-1));
    code_word = reshape(pagemtimes(code_word(polar_groups), [1, 0; 1, 1]), 1, L_word);
end
code_word = mod(code_word, 2);
end

