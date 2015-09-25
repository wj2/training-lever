editable('random_hold_mintime','random_hold_maxtime','release_time','num_rewards','reward_dur');



% bar touch
% random_hold_mintime = 0;
% random_hold_maxtime = 0;
% release_time = 0;


%{
% bar hold
random_hold_mintime = 1000;
random_hold_maxtime = 1000;
release_time = 0;
%}


% bar hold & release
random_hold_mintime = 200;
random_hold_maxtime = 200;
release_time = 5000;


wait_for_touch = 5000;
min_reaction_time = 0;

num_rewards = 1;
reward_dur = 120;

hotkey('r', 'goodmonkey(100);');

hold_time = ceil((random_hold_maxtime-random_hold_mintime)*rand())+random_hold_mintime;

[ontarget, rt] = eyejoytrack('acquiretouch', [1], [3.0], wait_for_touch);

if ~ontarget,
    trialerror(1); %no touch
    rt=NaN;
    return
end

eventmarker(7);  % bar down (hold)
%goodmonkey(reward_dur,num_rewards,120);
if hold_time == 0 % bar touch
    trialerror(0); %correct
    eventmarker(96); % reward given
    goodmonkey(reward_dur);
    return;
else % bar hold and bar hold & release
    toggleobject(1,'eventmarker',23); % turn on red square

    [ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], hold_time);

    if ~ontarget,
        eventmarker(4); %bar up (release)
        trialerror(5); %early
        toggleobject(1,'eventmarker',24);  % if error, turn off red square
        rt=NaN;
        return
    end

    toggleobject(1,'eventmarker',24);  % if monkey holds lever long enough, turn off red square
end

if release_time == 0 % bar hold
    trialerror(0); %correct
    eventmarker(96); % reward given
    goodmonkey(reward_dur);
    return;
else % bar hold & release
    toggleobject(2,'eventmarker',25);  % turn on green square

    [ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], min_reaction_time); %monkey has this long to release during green sq

    if ~ontarget,
        eventmarker(4); %bar up (release) during initial RT window
        trialerror(5); %early
        toggleobject(2,'eventmarker',26);  % if error, turn off green square
        rt=NaN;
        return
    end

    [ontarget, rt] = eyejoytrack('holdtouch', [1], [3.0], release_time-min_reaction_time); %monkey has this long to release during green sq

    rt=rt+min_reaction_time;

    if ontarget==0, % if monkey released bar in time
        eventmarker(4); % bar up (release)
        toggleobject(2,'eventmarker',26); % turn off green square
        trialerror(0); %correct
        eventmarker(96); % reward given
        goodmonkey(reward_dur);
    end

    if ontarget==1, % if monkey didn't release bar in time
        toggleobject(2,'eventmarker',26); %turn off green square
        trialerror(1); %no response
        rt=NaN;
        return
    end
end