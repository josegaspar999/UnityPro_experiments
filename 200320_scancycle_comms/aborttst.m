function abortFlag= aborttst(iniFlag)
%
% Checks the mouse position as an user indicator of abort state
%
% If iniFlag==1 then prints an info message and allows the user
% to clear a mistaken start in abort state
% [def: iniFlag=0]
%

% 2/5/00, 12.6.2012 (iniFlag=2), J. Gaspar

if nargin<1,
    iniFlag= 0;
end

abortFlag= 0;

if iniFlag==1,
    %
    % Emergency stop info (pause if in energency stop state):
    %
    if iniFlag == 1,
        fprintf(1,'\n---> For Emergency stop place mouse pointer close to screen bottom left corner <---\n\n')
    end
    
    mousePt= get(0,'PointerLocation');
    
    if max(mousePt)<100,
        fprintf(1,'\n*** EMERGENCY STOP DETECTED (mouse pointer in [0, 100, 0, 100]) ***\n\n');
        str= 'x';
        while ~strcmp(str,'') & ~strcmp(str,'a'),
            str= input('-- Ret to cont (''a'' to abort)... ','s');
        end
        if strcmp(str,'a'),
            abortFlag= 1;
        end
    end
    
elseif iniFlag==2
    %
    % Allow user to choose "break", "keyboard" or "continue"
    %
    mousePt= get(0,'PointerLocation');
    if max(mousePt)<100,
        fprintf(1,'\n*** EMERGENCY STOP DETECTED (mouse pointer in [0, 100, 0, 100]) ***\n\n');
        str= input('-- Break (b/ret), keyboard (k), continue (c)? ','s');
        if isempty(str) || strcmp(str, 'b')
            abortFlag= 1;
        elseif strcmp(str, 'k')
            keyboard
            % do nothing, abortFlag=0
        else
            % do nothing, abortFlag=0
        end
    end
    
else
    %
    % simply test emergency stop
    %
    mousePt= get(0,'PointerLocation');
    if max(mousePt)<100,
        fprintf(1,'\n*** EMERGENCY STOP DETECTED (mouse pointer in [0, 100, 0, 100]) ***\n\n');
        abortFlag= 1;
    end
end
