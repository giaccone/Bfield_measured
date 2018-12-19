clear variables, close all

%% load data
npt = 343; % set to 343 or 64
data = load(strcat('Bmeasured_', num2str(npt), '_points.txt')); 


%% assign data to variables
Q = data(:, 1:3);
B = data(:, 4:6);
Bmod = sqrt(sum(abs(B).^2, 2));


%% plot magnitude of B
npt1 = int32(npt^(1/3));
h1 = figure; set(gcf, 'color', [1,1,1])
slice(reshape(Q(:,1), npt1, npt1, npt1), ...
    reshape(Q(:,2), npt1, npt1, npt1), ...
    reshape(Q(:,3), npt1, npt1, npt1), ...
    reshape(Bmod*1e6, npt1, npt1, npt1), 0.35, 0, 0);
shading interp
axis('equal')
cb = colorbar;
title(cb, '(\muT)')
hold on
% plot points
plot3(Q(:,1), Q(:,2), Q(:,3),'ko','markerfacecolor',[0, 0, 1],'markersize',4)
% plot coil
load('coil_geometry.mat');
plot_coil(P1,P2);
% plot inspection volume
plot_volume(Q);
% set other properties
set(gca, 'fontsize',18)
axis('equal')
xlabel('x axis (m)')
ylabel('y axis (m)')
zlabel('z axis (m)')
title(strcat('Number of points: ', num2str(npt))) 


%% plot B-field
h2 = figure; set(gcf, 'color', [1,1,1])
% plot points
plot3(Q(:,1), Q(:,2), Q(:,3),'ko','markerfacecolor',[0, 0, 1],'markersize',4)
% plot inspection volume
plot_volume(Q, 'color', [0    0.4470    0.7410]);
% plot coil
plot_coil(P1,P2);
% plot field
if npt == 343
    scale = 3;
else
    scale = 1;
end
hold on, quiver3(Q(:,1), Q(:,2), Q(:,3), B(:,1), B(:,2), B(:,3),scale,'r', 'linewidth',3)
% set other properties
axis('equal')
set(gca, 'fontsize',18)
xlabel('x axis (m)')
ylabel('y axis (m)')
zlabel('z axis (m)')
title(strcat('Number of points: ', num2str(npt)))

%% additional function

function plot_coil(P1, P2)
    % this function plot the coil

    n = size(P1,1);
    for k=1:n
        hline = line([P1(k,1) P2(k,1)], [P1(k,2), P2(k,2)], [P1(k,3) P2(k,3)]);
        set (hline, 'Color','k','Linewidth',2)
    end

end


function plot_volume(Q, varargin)
    % this function plot the inspection volume

    color = 'none';
    
    for k=1:2:length(varargin)
        if strcmpi(varargin{k}, 'color')
            color = varargin{k + 1};
        end
    end

    V = [min(Q(:,1)), min(Q(:,2)), min(Q(:,3));
         max(Q(:,1)), min(Q(:,2)), min(Q(:,3));
         max(Q(:,1)), max(Q(:,2)), min(Q(:,3));
         min(Q(:,1)), max(Q(:,2)), min(Q(:,3));
         min(Q(:,1)), min(Q(:,2)), max(Q(:,3));
         max(Q(:,1)), min(Q(:,2)), max(Q(:,3));
         max(Q(:,1)), max(Q(:,2)), max(Q(:,3));
         min(Q(:,1)), max(Q(:,2)), max(Q(:,3))];
    F = [1, 2, 3, 4;
        5, 6, 7, 8;
        1, 2, 6, 5;
        4, 3, 7, 8;
        2, 3, 7, 6;
        1, 4, 8, 5];

    patch('Faces',F, 'Vertices', V,'facecolor',color,'facealpha',0.2)
end



