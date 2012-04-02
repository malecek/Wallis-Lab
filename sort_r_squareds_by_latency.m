function sorted_r_squareds = sort_r_squareds_by_latency(r_squareds, p_values)
% sorted_r_squareds = sort_r_squareds_by_latency(r_squareds, p_values)

for i = 1:size(r_squareds, 1)
    indices = find(p_values(i, :) < 0.001);
    latencies(i) = indices(1);
end
sorted_unique_latencies = sort(unique(latencies));
k = 1;
for i = 1:length(sorted_unique_latencies)
    indices = find(latencies == sorted_unique_latencies(i));
    for j = 1:length(indices)
        sorted_r_squareds(k, :) = r_squareds(indices(j), :);
        k = k + 1;
    end
end