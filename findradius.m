function rad = findradius(Imbinary,y,x,rmin,rmax)
%
% Find the radius of the circle centered in (y,x) from a binary image.
%
%
% Usage: rad = findradius(Imbinary,y,x,rmin,rmax)
%	example: r = findradius(B2,y,x,10,20); 
%
%Arguments:
%       Imbinary - a binary image. image pixels that have value equal to 1 are
%                  interested pixels for the findcircle function.
%	y,x	 - coordinates of the center fo the circle (y - row, x - col)
%       rmin     - minimum radius of the circle.
%       rmax     - maximum radius of the circle.
%
%Returns:
%       rad	- the Radius of the circle
%===============================================================================

w = rmax-rmin+1;
acc= zeros(w,1);

% Find non-zero points, those are the edge points
[yIndex, xIndex] = find(Imbinary);

yIn=round(yIndex);
xIn=round(xIndex);

% loop through edge points
for cnt = 1:length(xIndex) 
%
  for l=1:w
	r1=sqrt((xIn(cnt)-x)^2 + (yIn(cnt)-y)^2);
	r=rmin+l-1;
	if abs(r1-r) < 3  acc(l) = acc(l)+1; end
  end
end

% Find the maximum acc(r), the cooresponding r will be treated as the
% radius
accm=0;
rad=0;
for l=1:w
     if acc(l) >= accm
        accm = acc(l);
        rad= l+rmin-1;     % record the radius
     end
end


