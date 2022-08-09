function [Sp] = CardinalSpline(ord,c_pt_times_all,s)

lastknot = ord;
numknots = length(c_pt_times_all);

% Construct cardinal spline matrix
Sp = zeros(lastknot,numknots);
for i=1:lastknot
   nearest_c_pt_index = max(find(c_pt_times_all<i));
   nearest_c_pt_time = c_pt_times_all(nearest_c_pt_index);
   next_c_pt_time = c_pt_times_all(nearest_c_pt_index+1);
   prev_c_pt_time = c_pt_times_all(nearest_c_pt_index-1);
   next2 = c_pt_times_all(nearest_c_pt_index+2);
   u = (i-nearest_c_pt_time)/(next_c_pt_time-nearest_c_pt_time);
   l1 = (next_c_pt_time-prev_c_pt_time)/(next_c_pt_time-nearest_c_pt_time); % scale factors for non-uniform spacing 
   l2 = (next2-nearest_c_pt_time)/(next_c_pt_time-nearest_c_pt_time); % scale factors for non-uniform spacing
   p=[u^3 u^2 u 1]*[-s/l1 2-s/l2 s/l1-2 s/l2;2*s/l1 s/l2-3 3-2*s/l1 -s/l2;-s/l1 0 s/l1 0;0 1 0 0];
   Sp(i,nearest_c_pt_index-1:nearest_c_pt_index+2) = p;

end





end