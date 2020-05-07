function tst_show( tstId )
%
% Usage examples:
% tst_show(0)
% tst_show(1)
%
% Plot saved data:
% tst_show(-1)
% tst_show(-2)

% April 2020, JG

if nargin<1
    tstId= -2; %0;
end

switch tstId
    case 0
        % show and save Modbus timing data
        tst_show_global_var

    case 1
        % save Modbus timing data
        tst_show_save

    case 2
        % save Modbus timing data
        tst_show_save('y');

    case -1
        % show saved (on file) data
        for i=0:3
            figure(300+i); clf
            n= ['DBC_v' num2str(i)];
            x= load( 'tst_show_samples.mat', n );
            tst_show_main( getfield(x, n) )
        end
        
    case -2
        % show one file saved
        f= uigetfile('*.mat');
        if ischar(f)
            load( f, 'DBC' )
            tst_show_main(DBC);
        end
        
end


function tst_show_global_var
global DBC
% reset: global DBC; DBC=[];
figure(200); clf
tst_show_main( DBC )


function tst_show_save( s )
global DBC
if nargin<1
    s= input('-- Save data to file? [yN] ', 's');
end
if strcmpi(s, 'y')
    t= datevec( now ); t(1)= rem(t(1),100); t(6)= round(t(6));
    ofname= sprintf('tst_show_%02d%02d%02d_%02d%02d%02d.mat', t);
    try
        save( ofname, 'DBC' );
        DBC=[];
        fprintf(1, '   Saved data to file. Deleted data in memory.\n');
    catch
        fprintf(1, '** FAILED saving data to file.\n');
    end
end


function tst_show_main( DBC )
% plot( DBC(1,:), DBC(2,:)-DBC(1,:), '.-' )

[~,~,~,h1,m1,s1]= datevec( DBC(1,:) ); t1= 3600*h1 +60*m1 +s1;
[~,~,~,h2,m2,s2]= datevec( DBC(2,:) ); t2= 3600*h2 +60*m2 +s2;

subplot(211)
plot( t1-t1(1), 1000*(t2-t1), '.-' )
xlabel('t [sec]')
ylabel('t_2-t_1 [msec]')
title('Duration (time) of each modbus command')

subplot(212)
plot( t1-t1(1), 1000*[diff(t1) 0], '.-' )
xlabel('t [sec]')
ylabel('t_1 diff [msec]')
title('Time differences between modbus commands')

return
