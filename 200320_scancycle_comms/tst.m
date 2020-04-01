function tst( tstId )
%
% Communication UnityPro-simulation <-> Matlab, does it occur in the
% execution time of the scan cycle?
%
% To run these experiments, do not forget to start & run in simulation "tst.stu"
%
% Stop these experiments with mouse pointer hovering the "start" button
%
% Usages:
% tst(1)
% tst(2)
% tst(3)

% 21.3.2020 JG

if nargin<1
    tstId= 0; %3; %1;
end

switch tstId
    case 0, tst0
    case 1, tst1
    case 2, tst2
    case 3, tst3
end


function tst1
% single modbus ini, multiple writes, single end
% Q: does the PLC receive messages in the middle of the scan cycle?
% A: experiments till now say no

m= mymodbus( 'ini' );
n= 0;
v0= 0;
tic
while 1
    v0= ~v0;
    mymodbus( 'write', m, 'coils', 0,double(v0) );

    if aborttst, break; end
    n= n+1;
    if rem(n,100)==0
        fprintf(1,'%d ', n);
        toc
    end
end
mymodbus( 'end', m );


function tst2
% every comm has modbus ini, write and end
n= 0;
v0= 0;
tic
while 1
    v0= ~v0;
    m= mymodbus( 'ini' );
    mymodbus( 'write', m, 'coils', 0,double(v0) );
    mymodbus( 'end', m );

    if aborttst, break; end
    n= n+1;
    if rem(n,100)==0
        fprintf(1,'%d ', n);
        toc
    end
end


function tst3
% single modbus ini, multiple reads, single end
% Q: does the PLC answer messages in the middle of the scan cycle?
% A: experiments till now say no

m= mymodbus( 'ini' );
n= 0;
v0= 0;
tic
buff= [];
while 1
    ret= mymodbus( 'read', m, 'coils', 1,1 );
    if isempty(buff)
        buff= ret;
    else
        % only save if there is a bit change
        if ret~=buff(end)
            buff(end+1)= ret;
            disp(buff)
        end
    end

    if aborttst, break; end
    n= n+1;
    if rem(n,100)==0
        fprintf(1,'%d ', n);
        toc
    end
end
mymodbus( 'end', m );
%buff


function tst0
m= mymodbus('ini'); mymodbus('write', m, 'holdingregs', 100, 0:4); mymodbus('end', m);
m= mymodbus('ini'); mymodbus('read', m, 'holdingregs', 100, 5), mymodbus('end', m);
