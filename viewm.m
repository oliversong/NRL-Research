% Begin viewm.m
function  viewm(Data, x1, x2, y1, y2)
%=========================================================
% Examples of calling this script
% After the main process, we can view a square arround point 200,
% cnt=200;
% viewm(z, row(cnt)-2*r1, row(cnt)+2*r1, col(cnt)-2*r1, col(cnt)+2*r1) ;
% or
%  viewm(R, row(cnt)-2*r1, row(cnt)+2*r1, col(cnt)-2*r1, col(cnt)+2*r1) ;
% or
%  viewm(B2, row(cnt)-2*r1, row(cnt)+2*r1, col(cnt)-2*r1, col(cnt)+2*r1) ;
%=========================================================
%
Tmp = zeros(x2-x1+1, y2-y1+1); 
szd = size(Data) ;
 for i=1:x2-x1+1
 for j=1:y2-y1+1
  	k=x1+i-1;
  	l=y1+j-1;
  	if k<1 | k>szd(1)  continue; end   % if k is outside of the region, skip
   	if l<1 | l>szd(2) continue; end    % if l is outside of the region, skip
  	Tmp(i,j) = Data(k,l);              % assign the data in the square to the small matrix Tmp 
 end
 end
mesh(Tmp)
% End    viewm.m
