"MAIN for M3
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<GLOBAL P-WON <>>

<CONSTANT M-FATAL 2>

<CONSTANT M-HANDLED 1>   

;<CONSTANT M-NOT-HANDLED <>>   

<CONSTANT M-BEG 1>  

<CONSTANT M-END 6> 

<CONSTANT M-ENTER 2>

<CONSTANT M-LOOK 3> 

<CONSTANT M-FLASH 4>

<CONSTANT M-OBJDESC 5>

<ROUTINE GO ()
	 <SETG SCORE 21>
	 <SETG WINNER ,PLAYER>
	 <SETG HERE ,BALLROOM-9>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<QUEUE-MAIN-EVENTS>
		<START-MOVEMENT>
	 	<V-VERSION>
		<INTRO>)>
	 <THIS-IS-S-HE ,MICHAEL>
	 <MOVE ,PLAYER ,HERE>
	 <V-LOOK>
	 <I-WAVE>
	 <MAIN-LOOP>
	 <AGAIN>>    



<ROUTINE MAIN-LOOP ("AUX" ICNT OCNT NUM CNT OBJ TBL V PTBL OBJ1 TMP ACTED) 
   #DECL ((CNT OCNT ICNT NUM) FIX (V) <OR 'T FIX FALSE> (OBJ)<OR FALSE OBJECT>
	  (OBJ1) OBJECT (TBL) TABLE (PTBL) <OR FALSE ATOM>)
   <REPEAT ()
     <SET CNT 0>
     <SET OBJ <>>
     <SET PTBL T>
     <SET ACTED <>>
     <COND (<NOT <==? ,QCONTEXT-ROOM ,HERE>>
	    <SETG QCONTEXT <>>)>
     <SETG P-WALK-DIR <>> ;"8/24 PER JW"
     <COND (<SETG P-WON <PARSER>>
	    <SETG LAST-PLAYER-LOC <LOC ,PLAYER>>
	    <COND (<NOT <EQUAL? ,P-WON ,M-FATAL>>
		   <SET ICNT <GET ,P-PRSI ,P-MATCHLEN>>
		   <SET NUM
			<COND (<0? <SET OCNT <GET ,P-PRSO ,P-MATCHLEN>>> .OCNT)
			      (<G? .OCNT 1>
			       <SET TBL ,P-PRSO>
			       <COND (<0? .ICNT> <SET OBJ <>>)
				     (T <SET OBJ <GET ,P-PRSI 1>>)>
			       .OCNT)
			      (<G? .ICNT 1>
			       <SET PTBL <>>
			       <SET TBL ,P-PRSI>
			       <SET OBJ <GET ,P-PRSO 1>>
			       .ICNT)
			      (T 1)>>
		   <COND (<AND <NOT .OBJ> <1? .ICNT>>
			  <SET OBJ <GET ,P-PRSI 1>>)>)
		  (ELSE <SET NUM 0>)>
	    <COND (<AND <==? ,PRSA ,V?WALK> ,P-WALK-DIR>
		   <SET V <PERFORM ,PRSA ,PRSO>>)
		  (<0? .NUM>
		   <COND (<OR <EQUAL? ,PRSA ,V?CONTINUE>
			      <0? <BAND <GETB ,P-SYNTAX ,P-SBITS> ,P-SONUMS>>>
			  <SET V <PERFORM ,PRSA>>
			  <SETG PRSO <>>)
			 (T
			  <TELL-NOTHING-TO>
			  <SET V <>>)>)
		  (<AND .PTBL
			<G? .NUM 1>
			<VERB? ARREST COMPARE EXAMINE>>
		   <SET V <PERFORM ,PRSA ,OBJECT-PAIR>>)
		  (T
		   <SET TMP 0>
		   <REPEAT ()
		    <COND (<G? <SET CNT <+ .CNT 1>> .NUM>
			   <COND (<G? .TMP 0>
				  <TELL "The other object">
				  <COND (<NOT <EQUAL? .TMP 1>>
					 <TELL "s">)>
				  <TELL " that you mentioned ">
				  <COND (<NOT <EQUAL? .TMP 1>>
					 <TELL "are">)
					(T <TELL "is">)>
				  <TELL "n't">
				  <TELL-HERE>)
				 (<NOT .ACTED>
				  <TELL-NOTHING-TO>)>
			   <RETURN>)
			  (T
			   <COND (.PTBL <SET OBJ1 <GET ,P-PRSO .CNT>>)
				 (T <SET OBJ1 <GET ,P-PRSI .CNT>>)>
			   <COND (<G? .NUM 1>
;"start of reformatted shit"
<COND (<==? .OBJ1 ,NOT-HERE-OBJECT>
       <SET TMP <+ .TMP 1>>
       <AGAIN>)
      (<EQUAL? ,P-GETFLAGS ,P-ALL>
       <COND (<AND <VERB? TAKE>
		   <OR <AND <NOT <EQUAL? <LOC .OBJ1>
					 ,WINNER ,HERE .OBJ>>
			    <NOT <FSET? <LOC .OBJ1> ,SURFACEBIT>>>
		       <AND <NOT <FSET? .OBJ1 ,TAKEBIT>>
			    <NOT <FSET? .OBJ1 ,TRYTAKEBIT>>>>>
	      <AGAIN>)
	     (<AND <VERB? TAKE>
		   .OBJ
		   <OR <==? .OBJ .OBJ1>
		       <NOT <IN? .OBJ1 .OBJ>>>>
	      <AGAIN>)
	     (<AND <VERB? DROP>
		   <NOT <IN? .OBJ1 ,WINNER>>
		   ;"next frob semied by JW"
		   ;<NOT <IN? ,P-IT-OBJECT
			      ,WINNER>>>
	      <AGAIN>)
	     (<AND <VERB? PUT>
		   <HELD? .OBJ1 .OBJ>>
	      <AGAIN>)>)>
;"end of reformated shit"
				  <COND (<EQUAL? .OBJ1 ,IT>
					 <TELL D ,P-IT-OBJECT>)
					(T <TELL D .OBJ1>)>
				  <TELL ": ">)>
			   <SET V
				<QCONTEXT-CHECK
				 <COND (.PTBL .OBJ1) (T .OBJ)>
				 <COND (.PTBL .OBJ)(T .OBJ1)>>>
			   <SET ACTED T>
			   <SET V
				<PERFORM ,PRSA ;"? SETG PRSx to these?"
					 <COND (.PTBL .OBJ1) (T .OBJ)>
					 <COND (.PTBL .OBJ)(T .OBJ1)>>>
			   <COND (<==? .V ,M-FATAL> <RETURN>)>)>>)>
	    <COND (<==? .V ,M-FATAL> <SETG P-CONT <>>)>)
	   (T
	    <SETG P-CONT <>>)>
     <COND (,P-WON
	    %<DEBUG-CODE
	      <COND (<VERB? $NEXT $WHERE $DEBUG $TANDY $GOAL
			    $TABLE $FOLLOW $SCORE $HANDLE>
		     <AGAIN>)>>
	    <COND (<VERB? TELL
			  BRIEF SUPER-BRIEF VERBOSE
			  SAVE RESTORE RESTART
			  SPACE UNSPACE
			  SCRIPT UNSCRIPT
			  VERSION SCORE TIME
			  $VERIFY>
		   T)
		  (T
		   <SET V <CLOCKER>>)>)>>>

<GLOBAL LAST-PLAYER-LOC <>>

<ROUTINE TELL-NOTHING-TO ("AUX" TMP)
	 <TELL "There isn't anything to ">
	 <SET TMP <GET ,P-ITBL ,P-VERBN>>
	 <COND (,P-MERGED
		<PRINTB <GET .TMP 0>>)
	       (T
		<WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>
	 <TELL "." CR>>

<ROUTINE QCONTEXT-CHECK (PRSO PRSI "AUX" OTHER (WHO <>) (N 0))
	 <COND (<VERB? TELL> <RFALSE>)
	       (<OR <VERB? HELP WHAT>
		    <AND <VERB? TELL-ME>
			 <EQUAL? .PRSO ,PLAYER ,ME>>
		    <AND <VERB? SHOW GIVE>
			 <EQUAL? .PRSI ,PLAYER ,ME>>>
		<SET OTHER <FIRST? ,HERE>>
		<REPEAT ()
			<COND (<NOT .OTHER> <RETURN>)
			      (<FSET? .OTHER ,PERSON>
			       <SET N <+ 1 .N>>
			       <SET WHO .OTHER>)>
			<SET OTHER <NEXT? .OTHER>>>
		<COND (<AND <==? 1 .N> <NOT ,QCONTEXT>>
		       <SAID-TO .WHO>)>
		<COND (<AND ,QCONTEXT
			    <IN? ,QCONTEXT ,HERE>
			    <==? ,QCONTEXT-ROOM ,HERE>
			    <==? ,WINNER ,PLAYER>> ;"? more?"
		       <SETG WINNER ,QCONTEXT>
		       <TELL "(said to " D ,QCONTEXT ")" CR>)>)>>

<ROUTINE SAID-TO (WHO)
 <SETG WINNER .WHO>
 <SETG QCONTEXT .WHO>
 <SETG QCONTEXT-ROOM ,HERE>>

<GLOBAL L-PRSA <>>  
 
<GLOBAL L-PRSO <>>  
 
<GLOBAL L-PRSI <>>  

<ROUTINE FAKE-ORPHAN ()
	 <ORPHAN ,P-SYNTAX <>>
	 <TELL "Be specific: ">
	 <VERB-PRINT ,P-OTBL>
	 <SETG P-OFLAG T>
	 <SETG P-WON <>>
	 <TELL " what object?" CR>>

<GLOBAL NOW-PRSI <>>

<ROUTINE NULL-F () <RFALSE>>

<ROUTINE PERFORM (A "OPTIONAL" (O <>) (I <>) "AUX" V OA OO OI WALK?) 
	#DECL ((A) FIX (O) <OR FALSE OBJECT FIX> (I) <OR FALSE OBJECT> (V)ANY)
	%<DEBUG-CODE
	  <COND (,HDEBUG
		 <TELL "[Perform: ">
		 %<COND (<GASSIGNED? PREDGEN> '<TELL N .A>)
			(T '<PRINT <SPNAME <NTH ,ACTIONS <+ <* .A 2> 1>>>>)>
		 <COND (.O
			<COND (<AND <==? .A ,V?WALK>
				    ,P-WALK-DIR>
			       <TELL "/" N .O>)
			      (ELSE
			       <TELL "/" D .O>)>)>
		 <COND (.I <TELL "/" D .I>)>
		 <TELL "]" CR>)>>
	<SET OA ,PRSA>
	<SET OO ,PRSO>
	<SET OI ,PRSI>
	<SETG PRSA .A>
	<SET WALK? <AND <VERB? WALK> ,P-WALK-DIR>>
	<COND (.WALK? T)
	      (<AND ,P-IT-OBJECT
		    <EQUAL? ,IT .I .O>
		    <NOT <EQUAL? ,P-IT-LOC ,HERE>>>
	       <COND (<NOT .I> <FAKE-ORPHAN>)
		     (T
		      <TELL CTHE ,P-IT-OBJECT ,ISNT-HERE CR>)>
	       <RFATAL>)
	      (<AND <EQUAL? ,HIM-HER .I .O>
		    <NOT <EQUAL? <META-LOC ,P-HIM-HER> ,HERE>>>
	       <THIS-IS-S-HE <CHARACTERIZE ,P-HIM-HER>>)>
	<COND (.WALK? T)
	      (<==? .O ,IT>
	       <COND (,P-IT-OBJECT <SET O ,P-IT-OBJECT>)
		     (ELSE <SET O ,P-HIM-HER>)>)
	      (<==? .O ,HIM-HER> <SET O ,P-HIM-HER>)>
	<COND (.WALK? T)
	      (<==? .I ,IT>
	       <COND (,P-IT-OBJECT <SET I ,P-IT-OBJECT>)
		     (ELSE <SET I ,P-HIM-HER>)>)
	      (<==? .I ,HIM-HER> <SET I ,P-HIM-HER>)>
	<SETG PRSO .O>
	<SETG PRSI .I>
	<COND (<AND ,PRSO
		    <NOT .WALK?>
		    <EQUAL? ,HERE <META-LOC ,WINNER>>>
	       <COND (<FSET? ,PRSO ,PERSON>
		      <COND (<EQUAL? ,PRSO ,CORPSE>
			     <THIS-IS-IT ,PRSO>)>
		      <THIS-IS-S-HE ,PRSO>)
		     (T
		      <THIS-IS-IT ,PRSO>)>)>
	<COND (<AND <NOT <VERB? AGAIN WALK $DISCOVER>>
		    <EQUAL? ,WINNER ,PLAYER>>
	       <SETG L-PRSA .A>
	       <SETG L-PRSO .O>
	       <SETG L-PRSI .I>)>
	<COND (<AND <NOT .WALK?>
		    <EQUAL? ,NOT-HERE-OBJECT ,PRSO ,PRSI>
		    <SET V
			 %<DEBUG-CODE
			   <D-APPLY "Not Here" ,NOT-HERE-OBJECT-F>
			   <APPLY ,NOT-HERE-OBJECT-F>>>>
	       .V)
	      (<AND <SET O ,PRSO> <SET I ,PRSI> <NULL-F>>
	       %<DEBUG-CODE
		 <TELL "[in case last clause changed PRSx]">>)
	      (<SET V
		    %<DEBUG-CODE
		      <DD-APPLY "Actor" ,WINNER <GETP ,WINNER ,P?ACTION>>
		      <APPLY <GETP ,WINNER ,P?ACTION>>>>
	       .V)
	      (<SET V
		    %<DEBUG-CODE
		      <D-APPLY "Room (M-BEG)"
			       <GETP <LOC ,WINNER> ,P?ACTION>
			       ,M-BEG>
		      <APPLY <GETP <LOC ,WINNER> ,P?ACTION>
			     ,M-BEG>>>
	       .V)
	      (<SET V
		    %<DEBUG-CODE
		      <D-APPLY "Preaction"
			       <GET ,PREACTIONS .A>>
		      <APPLY <GET ,PREACTIONS .A>>>>
	       .V)
	      (<AND .I
		    <SETG NOW-PRSI T>
		    <SET V
			 %<DEBUG-CODE
			   <D-APPLY "PRSI" <GETP .I ,P?ACTION>>
			   <APPLY <GETP .I ,P?ACTION>>>>>
	       .V)
	      (<AND <NOT <SETG NOW-PRSI <>>>
		    .O
		    <NOT .WALK?>
		    <LOC .O>
		    <GETP <LOC .O> ,P?CONTFCN>
		    <SET V
			 %<DEBUG-CODE
			   <DD-APPLY "Container" <LOC .O>
				     <GETP <LOC .O> ,P?CONTFCN>>
			   <APPLY <GETP <LOC .O> ,P?CONTFCN>>>>>
	       .V)
	      (<AND .O
		    <NOT .WALK?>
		    <SET V
			 %<DEBUG-CODE
			   <D-APPLY "PRSO"
				    <GETP .O ,P?ACTION>>
			   <APPLY <GETP .O ,P?ACTION>>>>>
	       .V)
	      (<SET V
		    %<DEBUG-CODE
		      <D-APPLY <>
			       <GET ,ACTIONS .A>>
		      <APPLY <GET ,ACTIONS .A>>>>
	       .V)>
	<COND (<NOT <==? .V ,M-FATAL>>
	       <COND (<==? <LOC ,WINNER> ,PRSO>	;"was not in compiled PERFORM"
		      <SETG PRSO <>>)>
	       <SET V
		    %<DEBUG-CODE
		      <D-APPLY "Room (M-END)"
			       <GETP <LOC ,WINNER> ,P?ACTION> ,M-END>
		      <APPLY <GETP <LOC ,WINNER> ,P?ACTION> ,M-END>>>)>
	<SETG PRSA .OA>
	<SETG PRSO .OO>
	<SETG PRSI .OI>
	.V>

%<DEBUG-CODE
  <ROUTINE DD-APPLY (STR OBJ FCN)
	   <COND (,HDEBUG <TELL "[" D .OBJ "=]">)>
	   <D-APPLY .STR .FCN>>>

%<DEBUG-CODE
  <ROUTINE D-APPLY (STR FCN "OPTIONAL" (FOO <>) "AUX" RES)
	<COND (<NOT .FCN> <>)
	      (T
	       <COND (,HDEBUG
		      <COND (<NOT .STR>
			     <TELL "[Action:]" CR>)
			    (T <TELL "[" .STR ": ">)>)>
	       <SET RES
		    <COND (.FOO <APPLY .FCN .FOO>)
			  (T <APPLY .FCN>)>>
	       %<DEBUG-CODE
		 <COND (<AND ,HDEBUG .STR>
			<COND (<==? .RES ,M-FATAL>
			       <TELL "Fatal]" CR>)
			      (<NOT .RES>
			       <TELL "Not handled]" CR>)
			      (T <TELL "Handled]" CR>)>)>>
	       .RES)>>>
