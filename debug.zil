<GLOBAL DEBUG <>>
<GLOBAL HDEBUG <>>
<GLOBAL GDEBUG <>>
<GLOBAL EDEBUG <>>
<GLOBAL SHADOW <>>
<GLOBAL GOSSIP <>>
<GLOBAL IDEBUG <>>

<SYNTAX $DEBUG = V-$DEBUG>
<SYNTAX $HANDLE = V-$HANDLE>
<SYNTAX $NEXT = V-$NEXT>
<SYNTAX $GOAL = V-$GOAL>
<SYNTAX $TRS = V-$TANDY>
<SYNTAX $WHERE = V-$WHERE>
<SYNTAX $WHERE OBJECT = V-$WHERE>
<SYNTAX $WHERE OBJECT OBJECT = V-$WHERE>
<SYNTAX $TABLE OBJECT = V-$TABLE>
<SYNTAX $FOLLOW OBJECT = V-$FOLLOW>
<SYNTAX $ESTABLISH OBJECT = V-$ESTABLISH>
<SYNTAX $SCORE = V-$SCORE>
<SYNTAX $TOLD = V-$TOLD>
<SYNTAX $IT = V-$IT>

<ROUTINE V-$DEBUG ()
	 <COND (<SETG DEBUG <NOT ,DEBUG>>
		<TELL "Find them bugs, boss!" CR>)
	       (T <TELL "No bugs left, eh?" CR>)>>

<ROUTINE TELL-UNKNOWN (STR)
	 <TELL
"Sorry, but the word \"" .STR "\" is not in the vocabulary that
you can use." CR>>

<ROUTINE V-$HANDLE ()
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$ha">
		<RTRUE>)>
	 <COND (<SETG HDEBUG <NOT ,HDEBUG>>
		<TELL "Watch perform." CR>)
	       (T <TELL "No performance." CR>)>>

<ROUTINE V-$GOAL ()
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$go">
		<RTRUE>)
	       (<SETG GDEBUG <NOT ,GDEBUG>>
		<TELL "Showing goals." CR>)
	       (T <TELL "No more goals." CR>)>>

<ROUTINE V-$TANDY ("AUX" X)
	<COND (<NOT ,DEBUG>
	       <TELL-UNKNOWN "$ta">
	       <RTRUE>)>
	<SET X <GETB 0 1>>
	<COND (<==? <BAND .X 8> 0>
	       <PUTB 0 1 <BOR .X 8>>
	       <TELL "[on]" CR>)
	      (T
	       <PUTB 0 1 <BAND .X -9>>
	       <TELL "[off]" CR>)>>

<ROUTINE V-$NEXT ("AUX" (CNT 0) O L NUM RM)
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$ne">
		<RTRUE>)>
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX>
			<RETURN>)
		       (<SET O <GET ,CHARACTER-TABLE .CNT>>
			<SET L <GET ,MOVEMENT-GOALS .CNT>>
			<REPEAT ()
				<COND (<0? <SET NUM <GET .L ,MG-TIME>>>
				       <RETURN>)
				      (<SET RM <GET .L 3>>
				       <TELL
CD .O " will go in " N .NUM " minutes to " THE .RM "." CR>
				       <SET L <REST .L ,MG-LENGTH>>)>>)>>>

<ROUTINE V-$WHERE ("AUX" (CNT 0) O L)
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$wh">)
	       (,PRSI <MOVE ,PRSI ,PRSO>)
	       (,PRSO <GOTO ,PRSO>)
	       (T
		<REPEAT ()
			<COND (<SET O <GET ,CHARACTER-TABLE .CNT>>
			       <SET L <LOC .O>>
			       <TELL CD .O " is ">
			       <COND (.L
				      <TELL "in " THE .L "."CR>)
				     (T  <TELL "nowhere." CR>)>)>
			<COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX>
			       <RETURN>)>>)>>

<ROUTINE V-$TABLE ("AUX" CH TAB X)
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$ta">)
	       (<AND ,PRSO <SET CH <GETP ,PRSO ,P?CHARACTER>>>
		<SET TAB <GET ,GOAL-TABLES .CH>>
		<TELL "[">
		<COND (<SET X <LOC <GET ,CHARACTER-TABLE .CH>>>
		       <TELL CD ,PRSO " in " D .X>
		       <COND (<SET X <GET .TAB ,GOAL-F>>
			      <COND (<NOT <EQUAL? .X <LOC ,PRSO>>>
				     <TELL " going to " D .X>)>)
			     (ELSE <TELL ", no goal">)>
		       <COND (<AND <GET .TAB ,GOAL-S>
				   <NOT <EQUAL? .X <GET .TAB ,GOAL-S>>>>
			      <TELL ", via " D <GET .TAB ,GOAL-S>>)>
		       <COND (<AND <SET X <GET .TAB ,GOAL-I>>
				   <SET X <GET ,TRANSFER-TABLE <+ .X 1>>>>
			      <TELL ", changing at " D .X>)>
		       <COND (<NOT <GET .TAB ,GOAL-ENABLE>>
			      <TELL ", stopped">)>
		       <COND (<SET X <GET .TAB ,GOAL-QUEUED>>
			      <TELL ", queued " D .X>)>
		       <COND (<NOT <GET .TAB ,GOAL-ENABLE>>
			      <TELL ", attention ">
			      <TELL N <GET .TAB ,ATTENTION-SPAN> ","
				    N <GET .TAB ,ATTENTION>>)>)
		      (ELSE <TELL "Nowhere.">)>
		<TELL "]" CR>)
	 (ELSE <TELL "Not a character?" CR>)>>

<ROUTINE V-$FOLLOW ("AUX" MSG)
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$fo">)
	       (T
		<SETG SHADOW <CHARACTERIZE? ,PRSO>>
		<COND (,SHADOW <TELL "[" CD ,SHADOW "]" CR>)
		      (ELSE <TELL "[Nobody]" CR>)>)>>

<ROUTINE V-$ESTABLISH ("AUX" MSG)
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$es">)
	       (ELSE
		<SETG EDEBUG <CHARACTERIZE? ,PRSO>>
		<COND (,EDEBUG <TELL "[" CD ,EDEBUG "]" CR>)
		      (ELSE <TELL "[Nobody]" CR>)>)>>

<ROUTINE V-$SCORE ()
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$sc">)
	       (T
		<TELL "[Missing ">
		<COND (<NOT ,DETECTIVE-SEEN-CORPSE?> <TELL "corpse, ">)>
		<COND (<NOT ,DETECTIVE-SEEN-ROPE?> <TELL "rope, ">)>
		<COND (<NOT ,DETECTIVE-SEEN-COAT?> <TELL "coat, ">)>
		<COND (<NOT ,DETECTIVE-TOLD-ABOUT-RAIN?> <TELL "rain, ">)>
		<COND (<NOT ,DETECTIVE-SEEN-GLASS?> <TELL "glass, ">)>
		<COND (<NOT ,DETECTIVE-SEEN-HAIR?> <TELL "hair, ">)>
		<COND (<NOT ,DETECTIVE-SEEN-CARD?> <TELL "card, ">)>
		<COND (<NOT ,DETECTIVE-SEEN-AGREEMENT?> <TELL "p&s, ">)>
		<COND (<NOT ,DETECTIVE-SEEN-TRUST-DOCUMENTS?> <TELL "trust, ">)>
		<COND (<NOT ,DETECTIVE-SEEN-LIST?> <TELL "list, ">)>
		<COND (<NOT ,GLASS-ANALYZED?> <TELL "glass(lab), ">)>
		<COND (<NOT ,GLASS-ANALYZED-FOR-PRINTS?> <TELL "glass(prints), ">)
		      (<FSET? ,GLASS ,TOUCHBIT>
		       <TELL "touched glass, ">)>
		<COND (<EQUAL? ,DETECTIVE-SEEN ,DETECTIVE-CONVINCED>
		       <TELL "nothing, ">)>
		<TELL "means " N ,DETECTIVE-SEEN "/" N ,DETECTIVE-CONVINCED " gotten.]" CR>)>>

<ROUTINE V-$TOLD ("AUX" (CNT 0) O L)
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$to">)
	       (,GOSSIP <SETG GOSSIP <>>)
	       (T
		<SETG GOSSIP T>
		<COND (,MURDER-PUBLIC?
		       <TELL CD ,MURDER-PUBLIC? " called police." CR>)>
		<REPEAT ()
			<COND (<SET O <GET ,CHARACTER-TABLE .CNT>>
			       <TELL CD .O>
			       <COND (<FSET? .O ,TOLD>
				      <TELL " knows." CR>)
				     (T
				      <TELL " doesn't know." CR>)>)>
			<COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX>
			       <RETURN>)>>)>>

<ROUTINE V-$IT ()
	 <COND (<NOT ,DEBUG>
		<TELL-UNKNOWN "$it">
		<RTRUE>)
	       (<SETG IDEBUG <NOT ,IDEBUG>>
		<TELL "Showing it." CR>)
	       (T <TELL "No more it." CR>)>>