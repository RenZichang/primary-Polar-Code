function info_index = getInfoIndex(L_word, L_info)
%GETINFOINDEX 指定极化码的码长和码率，给出信息比特位的索引
%   input: L_word, 极化码的码长
%          L_info, 极化码的信息位长
%   output: info_index, 信息位索引，是一个长度等于码长的逻辑索引数组

% 初始化
N_level = log2(L_word);
beta = 2 ^ 0.25;
% 极化重量
huawei_pws = zeros(1, L_word);
for iter_bit = 1:L_word
    huawei_pws(iter_bit) = dec2bit(iter_bit-1, N_level) * beta.^(0:N_level-1).';
end
% 在极化重量高的比特位传输信息
[~, info_pos] = maxk(huawei_pws, L_info);
info_index = false(1, L_word);
info_index(info_pos) = true;
end

