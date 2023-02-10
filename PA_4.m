set(0,'DefaultFigureWindowStyle','docked')

%Dimensions & Variables
Nx = 100;
Ny = 100;
Lx = 1;
Ly = 1;

%Loop Variables
ni = 10000;
eps = 1.e-6;
dx = Lx/Nx;
dy = Ly/Ny;

nx = Nx+1;
ny = Ny+1;

%Gridpoint Indices
index_x = 2:nx-1;
index_y = 2:ny-1;Milesto

%Boundary Conditions
V = zeros(nx,ny);

V(:,1) = 0;     %bottom
V(1,:) = 1;     %left
V(:,ny) = 0;    %top
V(nx,:) = 0;    %right

V_prev = V;
error = 2*eps;
count_loop=0;

while (error > eps)
    count_loop = count_loop+1;

    V(index_x,index_y) = 0.25*(V(index_x+1, index_y) + V(index_x-1, index_y) + V(index_x, index_y+1) + V(index_x, index_y-1));
    
    error = max(abs(P(:) - V_prev(:)));
    V_prev = V;
end 
imboxfilt(V,3)
surf(V')

fprintf('\n count_loop = %g \n', count_loop);
[Ex, Ey] = gradient(V);

figure
quiver(-Ey', -Ex', 1)


