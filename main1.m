% Begin main.m
% z is automatically imported from .txt file
% R is the gradient of z
% B1 is the binary of R
% B2 is the edge of B1
% zc is the ※cut-off§ z matrix
% meanB is the base height, stdB is the base standard deviation
% row, col are vectors store the coordinates of regional minima (the impact points)
% rowc, colc are vectors store the centers of circles detected by Hough Transform  
% S is Sobel operator
%
% Step 1 每 Finding the Gradient Using Sobel Method
S=[1 2 1; 0 0 0; -1 -2 -1];
DX=conv2(z, S,'same');     %  gradient  in x direction
% Mesh (DX)
DY=conv2(z,S','same');	%  gradient  in y direction
% Mesh(DY)
R=sqrt(DX.^2 + DY.^2);	%  gradient 
% Mesh(R)
%
% Step 2 - Convert R to binary data set B1  according to Threshold 
threshold = 0.5;	 	% Threshold can be set to different value
sz=size(z);
B1=zeros(sz);	% B1 is the binary matrix
for i=1:sz(1)
for j=1:sz(2)
if R(i,j) > threshold	
B1(i,j)=1;
end
end
end
%
% Step 3 - Estimate the base height of the substrate 
% Find the mean and std of the data set first 
V=z(:);
mean1 = mean(V);
std1 = std(V);
% Remove all data points outside of a certain number of standard deviations, to cut off craters. 
% For this algorithm 1 standard deviation was used.
B=V(abs(V-mean1)<std1);
%  Find out the base height and standard deviation
meanB = mean(B);
stdB = std(B);
%
% Step 4 每 Find the depth of each impact point
% The ※cut-off§ method for making the top level of the substrate flat to reduce noise
zc=zeros(sz);
for i=1:sz(1)
for j=1:sz(2)
if z(i,j)>meanB-stdB*0.6 zc(i,j)=meanB;
else zc(i,j)=z(i,j);
end
end
end
% Find regional mins
accbmin = imregionalmin(zc);
% Convert the mins to double matrix
accd = zeros(sz);
accd=double(accbmin);
% mesh(accd);
% List all nonzero values in mins matrix with coordinates 
% 每 those are the coordinates of regional minima (the impact points).
[row,col]=find(accd);
% Find the actual height and depth values from the original z matrix according to row and col 
zdep=zeros(sz);
zmin=zeros(sz);
for i=1:size(col)
zmin(row(i),col(i))=z(row(i),col(i));
zdep(row(i),col(i))=meanB - z(row(i),col(i));
end
%
% Step 5 每 Find the Incident Angles
% Find the edge of B1 Matrix
B2=edge(B1);
% find center of each circle and related incident angle
%
r1=17 ;  % this is the radius of the circle
theta=[];
rad=[];
rowc=[];
colc=[];
%
for cnt=1:size(col)
%
%cnt = 200;  % test
%
 buf = zeros(4*r1, 4*r1);  % search a square of 4r1x4r1
 for i=1:4*r1
 for j=1:4*r1
  	k=row(cnt)-2*r1+i;
  	l=col(cnt)-2*r1+j;
  	if k<1 || k>sz(1)  continue; end    % if k is outside of the region, skip
   	if l<1 || l>sz(2) continue; end    % if l is outside of the region, skip
  	buf(i,j) = B2db(k,l);                        % assign the data in the square to the small matrix buf 
 end
 end
 [y0,x0,acc0] = houghcircle(buf,r1,10);
%
% Find absolute maximum for this square.
ym=0; xm=0; accm=0;
for i=1:size(y0)
     if acc0(y0(i), x0(i)) >= accm
        accm = acc0(y0(i), x0(i));
        ym=y0(i);     % record the row and col index
        xm=x0(i);
    end
end
% print xm, ym, accm - this is the center of the circle, and its strength
 % Convert back to the index of the big B2 matrix
  ym=row(cnt)-2*r1+ym;
  xm=col(cnt)-2*r1+xm;
%
rowc(cnt) = ym;
colc(cnt) = xm; 
%
% Find the radius of the circle
rad(cnt) = findradius(buf,2*r1,2*r1, r1-10,r1+10);
%
% Find the incident angle
d=sqrt((row(cnt)-ym)^2 + (col(cnt)-xm)^2);
d = d*0.625;	% convert the pixel to the actual distance 
theta(cnt) = atan(d/zdep(row(cnt),col(cnt)));
end
theta=theta/pi*180;
%for making output table of (cnt, row, col, act-dep, rel-dep, theta, diameter)
finaldata=zeros(size(col),9);
for i=1:size(col)
finaldata(i,1) = i;
finaldata(i,2)=row(i);
finaldata(i,3)=col(i);
finaldata(i,4)=zmin(row(i),col(i));
finaldata(i,5)=zdep(row(i),col(i));
finaldata(i,6)=theta(i);
finaldata(i,7)=rad(i)*2*0.625;
finaldata(i,8)=rowc(i);
finaldata(i,9)=colc(i);
end
% End main.m
