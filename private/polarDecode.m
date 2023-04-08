function dcd_word = polarDecode(info_index, llrs, judge_type)
%POLARDECODE 给定信息比特位索引以及对数似然比，返回极化码译码结果
%   input: info_index, 信息比特位
%          llrs, 对数似然比
%          judge_type, 译码算法采用软判决"soft"，还是硬判决"hard"
%   output: dcd_word, 译码结果-整个码字

% 初始化
L_word = numel(info_index);
N_level = log2(L_word);
pin_data = [llrs.', nan(L_word, N_level-1), inf(L_word, 1)];
pin_data(info_index, end) = nan;
arikan_F = @(X1, X2) 2 * atanh(tanh(X1 / 2) * tanh(X2 / 2));
minsum_func = @(X1, X2) sign(X1 * X2) * min(abs(X1), abs(X2));
if judge_type == "soft"
    judge_func = arikan_F;
else
    judge_func = minsum_func;
end
% SC译码，迭代更新引脚上的数据
iter_level = 1;
iter_node = 1;
while true
    % 当前节点是否存在Ch？是：
    if iter_level <= N_level
        polar_group = reshape(1:L_word, 2^(N_level-iter_level), 2, 2^(iter_level-1));
        node_group = polar_group(:, :, iter_node);
        % 当前节点的L-Ch未曾计算？是：计算并跳转到L-Ch
        if isnan(pin_data(node_group(1), iter_level + 1))
            for iter_group = 1:size(node_group, 1)
                Y1 = pin_data(node_group(iter_group, 1), iter_level);
                Y2 = pin_data(node_group(iter_group, 2), iter_level);
                U1 = judge_func(Y1, Y2);
                pin_data(node_group(iter_group, 1), iter_level + 1) = U1;
            end
            iter_node = iter_node * 2 - 1;
            iter_level = iter_level + 1;
        % 否：当前节点的R-Ch未曾计算？是：计算并跳转到R-Ch
        elseif isnan(pin_data(node_group(end), iter_level + 1))
            for iter_group = 1:size(node_group, 1)
                Y1 = pin_data(node_group(iter_group, 1), iter_level);
                Y2 = pin_data(node_group(iter_group, 2), iter_level);
                U1 = pin_data(node_group(iter_group, 1), iter_level + 1);
                U2 = judge_func(U1, Y1) + Y2;
                pin_data(node_group(iter_group, 2), iter_level + 1) = U2;
            end
            iter_node = iter_node * 2;
            iter_level = iter_level + 1;
        % 否：计算本节点并跳转到父节点
        else
            for iter_group = 1:size(node_group, 1)
                U1 = pin_data(node_group(iter_group, 1), iter_level + 1);
                U2 = pin_data(node_group(iter_group, 2), iter_level + 1);
                Y1 = judge_func(U1, U2);
                Y2 = U2;
                pin_data(node_group(iter_group, 1), iter_level) = Y1;
                pin_data(node_group(iter_group, 2), iter_level) = Y2;
            end
            iter_node = ceil(iter_node / 2);
            iter_level = iter_level - 1;
        end
    % 否：跳转到父节点
    elseif iter_node == L_word
        break;
    else
        if judge_type == "hard"
            pin_data(iter_node, iter_level) = inf * pin_data(iter_node, iter_level);
        end
        iter_node = ceil(iter_node / 2);
        iter_level = iter_level - 1;
    end
end
dcd_word = (1 - sign(pin_data(:, end).')) / 2;
end

