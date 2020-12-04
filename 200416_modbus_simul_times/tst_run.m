function tst_run(tstId)

% Log Modbus times when using myterminal4
% Required: having a PLC program runing in simulation

% Usage examples (assuming demo UnityPro progs of API):
% tst_run(0)
% tst_run(1)

% To use an empty UnityPro program:
% tst_run(2)
% tst_run(3)

% April 2020, JG

if nargin<1
    tstId= 4; %1; %0;
end
if length(tstId)>1
    for i= tstId
        tst_run( i );
    end
    return
end

switch tstId
    case -100
        % specific function debug
        str2double_tst(1);

    case {0, 1, 2, 3, 4, 5, 6, 7}
        % all modalities of tests, 0..7 represent three 0/1 flags
        x= dec2bin(tstId,3)-'0';
        startAtM0Flag= x(2);
        autoFlag=      x(1);
        stressFlag=    x(3);
        tst_run_main( autoFlag, startAtM0Flag, stressFlag );
end


% -------------------------------------------
function tst_run_main( autoFlag, startAtM0Flag, stressFlag )

% -- configuration commands
mymodbus2( 'db_level_set', 2 )
mymodbus2( 'db_level_lock', 1 )

if startAtM0Flag
    % if your UnityPro program does not copy m0..19 to/from m180..m199 :
    myterminal4_aux( 'mymenu2', 'Comms addr base set m0 mw180' );
end

if ~stressFlag
    myterminal4_aux( 'mymenu2', 'Refresh period 1sec' );
else
    myterminal4_aux( 'mymenu2', 'Refresh period 0.1sec' );
end

% -- launch the terminal (click the "Refresh" button)
myterminal4

% -- do the logging automatically (no clicks)
if autoFlag
    myterminal4_aux( 'refresh' );
    tst_show(0)
    tst_show(2)
    mymodbus2( 'db_level_lock', 0 )
    mymodbus2( 'db_level_set', 0 )
end


% -------------------------------------------
function str2double_tst(tstId)
% test: place a small string (<8chrs) in a double and get it back
% NOT used, delete?
if nargin<1
    tstId= 1;
end
switch tstId
    case 0, str2double_tst1( 1000, 'coils' )
    case 1, for str= {'coils', 'regs'}, str2double_tst1( 1, char(str) ); end
end


function str2double_tst1( N, str )
tic; for i=1:N, x= str2double(str); str2= double2str(x); end; toc
tic; for i=1:N, x= str2double(str); end; toc
tic; for i=1:N, x= str(1)+0; end; toc


function x= str2double( str )
if length(str)<1
    x= 0;
else
    p= 0:length(str)-1;
    x= sum((str+0).*(256.^p));
end


function str= double2str( x )
str= [];
while x>0
    str= [str rem(x,256)];
    x= floor(x/256);
end
str=char(str);
