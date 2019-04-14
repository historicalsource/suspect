"VERBS for M3
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<ROUTINE V-SCRIPT ()
	 <PUT 0 8 <BOR <GET 0 8> 1>>
	 <SCRIPT-STUFF "begins">
	 <V-VERSION>
	 <RTRUE>>

<ROUTINE V-UNSCRIPT ()
	 <SCRIPT-STUFF "ends">
	 <PUT 0 8 <BAND <GET 0 8> -2>>
	 <RTRUE>>

<ROUTINE SCRIPT-STUFF (STR)
	 <TELL "Script " .STR "." CR>>

<ROUTINE V-$VERIFY ()
	 <COND (<AND <EQUAL? ,PRSO ,INTNUM>
		     <EQUAL? ,P-NUMBER 1949>>
		<TELL N ,SERIAL CR>)
	       (,PRSO <TELL ,SORRY-I-DONT CR>)
	       (ELSE
		<TELL "Verifying disk..." CR>
		<COND (<VERIFY> <TELL "The disk is correct." CR>)
		      (T <TELL CR "** Disk Failure **" CR>)>)>>

""

"ZORK game commands"

"SUBTITLE SETTINGS FOR VARIOUS LEVELS OF DESCRIPTION"

<GLOBAL VERBOSE <>>
<GLOBAL SUPER-BRIEF <>>
<GDECL (VERBOSE SUPER-BRIEF) <OR ATOM FALSE>>

<ROUTINE V-AGAIN ("AUX" OBJ)
	 <COND (<NOT ,L-PRSA>
		<TELL "Not yet." CR>)
	       (<==? ,L-PRSA ,V?WALK>
		<PERFORM ,L-PRSA ,L-PRSO>)
	       (T
		<SET OBJ
		     <COND (<AND ,L-PRSO <NOT <LOC ,L-PRSO>>>
			    ,L-PRSO)
			   (<AND ,L-PRSI <NOT <LOC ,L-PRSO>>>
			    ,L-PRSI)>>
		<COND (<AND .OBJ 
			    <NOT <EQUAL? .OBJ ,PSEUDO-OBJECT ,ROOMS>>>
		       <TELL "I can't see " THE .OBJ " anymore." CR>
		       <RFATAL>)
		      (T
		       <PERFORM ,L-PRSA ,L-PRSO ,L-PRSI>)>)>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSE <>>
	 <SETG SUPER-BRIEF <>>
	 <SETG P-SPACE 1>
	 <TELL "Brief" ,DESCRIPTIONS CR>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG SUPER-BRIEF T>
	 <SETG P-SPACE 0>
	 <TELL
"Super-brief" ,DESCRIPTIONS CR>>

<ROUTINE V-VERBOSE ()
	 <SETG VERBOSE T>
	 <SETG SUPER-BRIEF <>>
	 <SETG P-SPACE 1>
	 <TELL "Verbose" ,DESCRIPTIONS CR>>

<GLOBAL DESCRIPTIONS " descriptions.">

<GLOBAL P-SPACE 1>

<ROUTINE V-SPACE ()
	 <SETG P-SPACE 1>>

<ROUTINE V-UNSPACE ()
	 <SETG P-SPACE 0>
	 <RTRUE>>

<ROUTINE V-INVENTORY ()
	 <COND (<AND <FIRST? ,WINNER> <PRINT-CONT ,WINNER>>
		<RTRUE>)
	       (T
		<TELL ,YOU-ARE "empty-handed." CR>)>>

<ROUTINE V-TIME ()
	 <TELL "It's now ">
	 <TIME-PRINT ,PRESENT-TIME>
	 <CRLF>>

<ROUTINE TIME-PRINT (NUM "OPTIONAL" (AMPM T) "AUX" HR (AM <>))
	 #DECL ((NUM HR) FIX (AM) <OR FALSE ATOM>)
	 <COND (<G? <SET HR </ .NUM 60>> 12>
		<SET HR <- .HR 12>>
		<SET AM T>)
	       (<==? .HR 12> <SET AM T>)>
	 <PRINTN .HR>
	 <TELL ":">
	 <COND (<L? <SET HR <MOD .NUM 60>> 10>
		<TELL "0">)>
	 <TELL N .HR>
	 <COND (.AMPM
		<TELL " " <COND (.AM "a.m") (T "p.m")>>)>
	 <TELL ".">>

<ROUTINE QUIT-WARNING ()
	 <COND (<NOT <EQUAL? ,L-PRSA ,V?SAVE>>
		<TELL
"If you want to continue from this point at another time, you must
\"SAVE\" first. ">)>
	 <TELL ,DO-YOU-WANT-TO "stop now?">>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T) "AUX" SCOR)
	 #DECL ((ASK?) <OR ATOM <PRIMTYPE LIST>> (SCOR) FIX)
	 <COND (<OR <AND .ASK?
			 <QUIT-WARNING>
			 <YES?>>
		    <NOT .ASK?>>
		<QUIT>)
	       (ELSE <TELL "O.K." CR>)>>

<ROUTINE V-RESTART ()
	 <TELL
"Do you wish to restart the story?">
	 <COND (<YES?>
		<RESTART>
		<TELL-STATUS "original">)>>

<ROUTINE TELL-STATUS (STR)
<TELL "Your " .STR " status couldn't be restored." ,CONSULT CR>>

<ROUTINE V-RESTORE ()
	 <COND (<RESTORE>
		<TELL "O.K." CR>
		<V-FIRST-LOOK>)
	       (T
		<TELL-STATUS "previous">)>>

<GLOBAL CONSULT " Consult your manual or Reference Card if necessary.">

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<NOT ,SUPER-BRIEF> <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-SAVE ()
	 <COND (<SAVE>
	        <TELL "O.K." CR>)
	       (T
		<TELL
"Your story couldn't be saved." ,CONSULT CR>)>>

<ROUTINE V-VERSION ("AUX" (CNT 17))
	 <TELL
"SUSPECT|
Infocom interactive fiction - a mystery story|
Copyright (c) 1984 Infocom, Inc.  All rights reserved.|
">
	 ;<COND (<NOT <==? <BAND <GETB 0 1> 8> 0>>
		<TELL "Licensed to Tandy Corporation." CR>)>
	 <TELL "SUSPECT is a registered trademark of Infocom, Inc.|
Release number ">
	 <PRINTN <BAND <GET 0 1> *3777*>>
	 <TELL " / Serial number ">
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> 23>
			<RETURN>)
		       (T
			<PRINTC <GETB 0 .CNT>>)>>
	 <CRLF>>


<GLOBAL Y-INBUF <ITABLE BYTE 12>>
<GLOBAL Y-LEXV <ITABLE BYTE 10>>

<ROUTINE YES? ("OPTIONAL" (RESTORE? <>) "AUX" W)
	 <REPEAT ()
		 <PRINTI " (Answer YES">
		 <COND (.RESTORE? <PRINTI " or RESTORE">)>
		 <TELL " or NO">
		 <PRINTI ".) >">
		 <READ ,Y-INBUF ,Y-LEXV>
		 <COND (<0? <GETB ,Y-LEXV ,P-LEXWORDS>>
			<RFALSE>)>
		 <SET W <GET ,Y-LEXV 1>>
		 <COND (<AND .RESTORE? <EQUAL? .W ,W?RESTORE>>
			<RFATAL>)
		       (<EQUAL? .W ,W?YES ,W?Y>
			<RTRUE>)
		       (<EQUAL? .W ,W?NO ,W?N>
			<RFALSE>)>>>

""

"SUBTITLE - GENERALLY USEFUL ROUTINES & CONSTANTS"

"DESCRIBE-OBJECT -- takes object and flag.  if flag is true will print a
long description (fdesc or ldesc), otherwise will print short."

<ROUTINE DESCRIBE-OBJECT (OBJ V? LEVEL "AUX" (STR <>) AV)
	 <COND (<AND <0? .LEVEL>
		     <FSET? .OBJ ,PERSON>
		     <IN-MOTION? .OBJ>>
		<RTRUE>)>
	 <COND (<AND <0? .LEVEL>
		     <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		<RTRUE>)>
	 ;<COND (<FSET? .OBJ ,PERSON> <THIS-IS-S-HE .OBJ>)
	       (T <THIS-IS-IT .OBJ>)>
	 <COND (<AND <0? .LEVEL>
		     <OR <AND <NOT <FSET? .OBJ ,TOUCHBIT>>
			      <SET STR <GETP .OBJ ,P?FDESC>>>
			 <SET STR <GETP .OBJ ,P?LDESC>>>>
		<TELL .STR>)
	       (<0? .LEVEL>
		<COND (<FSET? .OBJ ,PERSON>
		       <TELL CD .OBJ " is">)
		      (T
		       <TELL "There's " A .OBJ>)>
		<TELL " here.">)
	       (ELSE
		<TELL <GET ,INDENTS .LEVEL>>
		<COND (<OR <FSET? .OBJ ,PERSON> <EQUAL? .OBJ ,CORPSE>>
		       <TELL D .OBJ>)
		      (T
		       <TELL A .OBJ>
		       <COND (<FSET? .OBJ ,WEARBIT>
			      <TELL " (being worn)">)>)>)>
	 <COND (<AND <0? .LEVEL>
		     <SET AV <LOC ,WINNER>>
		     <FSET? .AV ,VEHBIT>
		     <NOT <FSET? .AV ,FURNITURE>>>
		<TELL " (outside " THE .AV ")">)>
	 <CRLF>
	 <COND (<AND <SEE-INSIDE? .OBJ> <FIRST? .OBJ>>
		<PRINT-CONT .OBJ .V? .LEVEL>)>>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (V? <>))
	 <COND (<FIRST? ,HERE>
		<PRINT-CONT ,HERE <SET V? <OR .V? ,VERBOSE>> -1>)>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? (F? <>) STR L)
	 <SET V? <OR .LOOK? ,VERBOSE>>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<FSET ,HERE ,TOUCHBIT>
		<SET V? T>
		<SET F? T>)>
	 <COND (<EQUAL? <GETP ,HERE ,P?LINE>
			,BALLROOM-LINE-C>
		<TELL "Ballroom, ">)>
	 <TELL D ,HERE>
	 <SET L ,PLAYER-HIDING>
	 <COND (.L
		<TELL ", hiding ">
		<COND (<EQUAL? .L ,WINDOW-SEAT> <TELL "in ">)
		      (T <TELL "behind ">)>
		<TELL THE .L>)
	       (<FSET? <SET L <LOC ,WINNER>> ,VEHBIT>
		<TELL ", ">
		<COND (<EQUAL? .L ,CHAIR ,GLOBAL-CHAIR>
		       <TELL "sitting in">)
		      (<OR <FSET? .L ,SURFACEBIT>
			   <EQUAL? .L ,GLOBAL-SOFA>>
		       <TELL "sitting on">)
		      (T <TELL "standing in">)>
		<TELL " " THE .L>)>
	 <CRLF>
	 <COND (<OR .LOOK? <NOT ,SUPER-BRIEF>>
		<COND (<AND <OUTSIDE? ,HERE>
			    <NOT <OUTSIDE? ,OHERE>>
			    <NOT <EQUAL? ,RAIN-STATE 0>>>
		       <COND (<EQUAL? ,RAIN-STATE 1>
			      <SETG SAW-RAIN-SLACK-OFF? T>
			      <TELL "Rain is falling in a light drizzle.">)
			     (ELSE <TELL "Rain falls in a downpour.">)>
		       <CRLF>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       <RTRUE>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?FDESC>>>
		       <TELL .STR CR>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
		<COND (<NOT <==? ,HERE .L>>
		       <APPLY <GETP .L ,P?ACTION> ,M-LOOK>)>)>
	 <COND (<GETP ,HERE ,P?CORRIDOR> <CORRIDOR-LOOK>)>
	 T>

"Lengths:"
<CONSTANT UEXIT 1> "Uncondl EXIT:(dir TO rm)		 = rm"
<CONSTANT NEXIT 2> "Non EXIT:	(dir string)		 = str-ing"
<CONSTANT FEXIT 3> "Fcnl EXIT:  (dir PER rtn)		 = rou-tine, 0"
<CONSTANT CEXIT 4> "Condl EXIT:	(dir TO rm IF f)	 = rm, f, str-ing"
<CONSTANT DEXIT 5> "Door EXIT: (dir TO rm IF dr IS OPEN) = rm, dr, str-ing, 0"

<CONSTANT REXIT 0>
<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG 1>	"GETB"
<CONSTANT CEXITSTR 1>	"GET"
<CONSTANT DEXITOBJ 1>	"GETB"
<CONSTANT DEXITSTR 1>	"GET"

<ROUTINE FIRSTER (OBJ LEVEL)
	 <COND (<==? .OBJ ,WINNER>
		<TELL ,YOU-ARE "carrying:" CR>)
	       (<NOT <IN? .OBJ ,ROOMS>>
		<COND (<G? .LEVEL 0>
		       <TELL <GET ,INDENTS .LEVEL>>)>
		<COND (<AND <FSET? .OBJ ,SURFACEBIT>
			    <NOT <EQUAL? .OBJ ,WINDOW-SEAT>>>
		       <TELL "Sitting on " THE .OBJ " can be seen:" CR>)
		      (<FSET? .OBJ ,PERSON>
		       <TELL CD .OBJ " is holding:" CR>)
		      (ELSE
		       <TELL CTHE .OBJ
			     " contains:" CR>)>)>>

<ROUTINE GONE-CRAZY ()
	 <TELL
"Murder or no murder, this gets you arrested for sure!" CR>
	 <FINISH>>

<GLOBAL OHERE <>>

<ROUTINE GOTO (RM "OPTIONAL" (V? T) "AUX" F WT VAL (INSIDE? <>))
	 #DECL ((RM) OBJECT)
	 <COND (,DUFFY-SNARFED
		<IRON-GRIP>
		<RTRUE>)>
	 <PLAYER-GETS-UP>
	 <COND (<AND <G? ,RAIN-STATE 0> <OUTSIDE? .RM>>
		<COND (<OUTSIDE? ,HERE>
		       <TELL
"It's">)
		      (T
		       <SET INSIDE? T>
		       <TELL
"You go outside, where it's">)>
		<TELL
" dark and cloudy, and the territory is unfamiliar." CR>
		<COND (.INSIDE? <CRLF>)
		      (<NOT <SET VAL <INT-WAIT 2>>>
		       <TELL "You stop." CR>
		       <RTRUE>)
		      (<OR <==? .VAL ,M-FATAL>
			   ,DUFFY-SNARFED>
		       <RTRUE>)
		      (ELSE
		       <TELL "You finally get there." CR CR>)>)>
	 <MOVE-PLAYER .RM>
	 <APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	 <COND (.V? <V-FIRST-LOOK>)>>

<ROUTINE MOVE-PLAYER (RM)
	 <SETG OHERE ,HERE>
	 <MOVE ,PLAYER .RM>
	 <SETG HERE .RM>
	 <WHERE-UPDATE ,PLAYER>>

<ROUTINE HACK-HACK (STR)
	 <COND (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (T
		<TELL .STR " " THE ,PRSO <PICK-ONE ,HO-HUM> CR>)>>

<GLOBAL HO-HUM
	<LTABLE 0
	 " doesn't help."
	 " has no effect.">>

<ROUTINE HELD? (OBJ "OPTIONAL" (CONT <>))
	 <COND (<NOT .CONT> <SET CONT ,WINNER>)>
	 <COND (<NOT .OBJ>
		<RFALSE>)
	       (<IN? .OBJ .CONT>
		<RTRUE>)
	       (<EQUAL? <LOC .OBJ> ,ROOMS ,GLOBAL-OBJECTS>
		<RFALSE>)
	       (T
		<HELD? <LOC .OBJ>>)>>

<ROUTINE IDROP ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL CD ,PRSO " wouldn't enjoy that." CR>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <IN? <LOC ,PRSO> ,WINNER>>>
		<TELL ,YOU-ARENT "carrying ">
		<TELL-PRSO>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL-CLOSED>
		<RFALSE>)
	       (T
		<FCLEAR ,PRSO ,WEARBIT>
		<MOVE ,PRSO ,HERE ;<LOC ,WINNER>>
		<RTRUE>)>>

<GLOBAL INDENTS
	<TABLE ""
	       "  "
	       "    "
	       "      "
	       "        "
	       "          ">>

<GLOBAL FUMBLE-NUMBER 7>
;<GLOBAL FUMBLE-PROB 8>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ)
	 #DECL ((VB) <OR ATOM FALSE> (CNT) FIX (OBJ) OBJECT)
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB
		       <TELL-YOU-CANT "take " <>>
		       <TELL-PRSO>)>
		<RFALSE>)
	       (<AND <NOT <IN? <LOC ,PRSO> ,WINNER>>
		     <G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>> ,LOAD-ALLOWED>>
		<COND (.VB
		       <COND (<G? <WEIGHT ,PRSO> ,LOAD-ALLOWED>
			      <TELL "It's too heavy to carry">)
			     (T
			      <TELL "Your load's too heavy">)>
		       <TELL "." CR>)>
		<RFATAL>)
	       (<G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
		<COND (.VB
		       <TELL-YOU-CANT "carry that many things at once">)>
		<RFATAL>)
	       (T
		<MOVE ,PRSO ,WINNER>
		<FSET ,PRSO ,TOUCHBIT>
		<FCLEAR ,PRSO ,NDESCBIT>
		<FCLEAR ,PRSO ,INVISIBLE>
		<RTRUE>)>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<COND (<NOT <FSET? .X ,WEARBIT>>
			       <SET CNT <+ .CNT 1>>)>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

<ROUTINE NOT-HERE (OBJ)
	 <SETG P-WON <>>
	 <TELL ,YOU-CANT-SEE THE .OBJ>
	 <TELL-HERE>>

<GLOBAL YOU-CANT-SEE "You can't see ">

<ROUTINE PRINT-CONT (OBJ "OPTIONAL" (V? <>) (LEVEL 0)
		     "AUX" Y 1ST? AV (STR <>) (PV? <>) (INV? <>))
	#DECL ((OBJ) OBJECT (LEVEL) FIX)
 <COND (<NOT <SET Y <FIRST? .OBJ>>> <RTRUE>)>
 <COND (<AND <SET AV <LOC ,WINNER>>
	     <FSET? .AV ,VEHBIT>
	     <OR <NOT <FSET? .AV ,FURNITURE>>
		 <FSET? .AV ,OPENBIT>>>
	T)
       (ELSE <SET AV <>>)>
 <SET 1ST? T>
 <COND (<EQUAL? ,WINNER .OBJ <LOC .OBJ>>
	<SET INV? T>)
       (ELSE
	<REPEAT ()
	 <COND (<NOT .Y> <RETURN <NOT .1ST?>>)
	       (<==? .Y .AV> <SET PV? T>)
	       (<==? .Y ,WINNER>)
	       (<AND <NOT <FSET? .Y ,INVISIBLE>>
		     <NOT <FSET? .Y ,TOUCHBIT>>
		     <OR ;<APPLY <GETP .Y ,P?DESCFCN> ,M-OBJDESC>
			 <SET STR <GETP .Y ,P?FDESC>>>>
		<COND (<NOT <FSET? .Y ,NDESCBIT>>
		       <SET 1ST? <>>
		       <SET LEVEL 0>
		       <COND (.STR
			      <TELL .STR CR>
			      <SET STR <>>
			      <COND (<FSET? .Y ,PERSON> <THIS-IS-S-HE .Y>)
				    (T <THIS-IS-IT .Y>)>)>)>
		<COND (<AND <SEE-INSIDE? .Y>
			    <NOT <GETP <LOC .Y> ,P?DESCFCN>>
			    <FIRST? .Y>>
		       <PRINT-CONT .Y .V? 0>)>)>
	 <SET Y <NEXT? .Y>>>)>
 <SET Y <FIRST? .OBJ>>
 <REPEAT ()
	 <COND (<NOT .Y>
		<COND (<AND .PV? .AV <FIRST? .AV>>
		       <PRINT-CONT .AV .V? .LEVEL>)>
		<RETURN <NOT .1ST?>>)
	       (<EQUAL? .Y .AV ,PLAYER>)
	       (<AND <NOT <FSET? .Y ,INVISIBLE>>
		     <OR .INV?
			 <FSET? .Y ,TOUCHBIT>
			 <NOT <GETP .Y ,P?FDESC>>>>
		<COND (<NOT <FSET? .Y ,NDESCBIT>>
		       <COND (.1ST?
			      <COND (<FIRSTER .OBJ .LEVEL>
				     <COND (<L? .LEVEL 0> <SET LEVEL 0>)>)>
			      <SET LEVEL <+ 1 .LEVEL>>
			      <SET 1ST? <>>)>
		       <DESCRIBE-OBJECT .Y .V? .LEVEL>)
		      (<AND <FIRST? .Y> <SEE-INSIDE? .Y>>
		       <PRINT-CONT .Y .V? .LEVEL>)>)>
	 <SET Y <NEXT? .Y>>>>

<ROUTINE PRINT-CONTENTS (OBJ "OPTIONAL" (START <>) (NOT-OBJ <>)
			 "AUX" F N (1ST? T))
	 #DECL ((OBJ) OBJECT (F N) <OR FALSE OBJECT>)
	 <COND (<SET F <FIRST? .OBJ>>
		<REPEAT ()
			<SET N <NEXT? .F>>
			<COND (<AND <NOT <FSET? .F ,INVISIBLE>>
				    <NOT <EQUAL? .F .NOT-OBJ>>>
			       <COND (.1ST?
				      <COND (.START <TELL .START>)>
				      <SET 1ST? <>>)
				     (ELSE
				      <TELL ", ">
				      <COND (<NOT .N> <TELL "and ">)>)>
			       <COND (<FSET? .F ,PERSON>
				      <TELL D .F>)
				     (T
				      <TELL A .F>)>
			       <COND (<FSET? .F ,PERSON> <THIS-IS-S-HE .F>)
				     (T <THIS-IS-IT .F>)>)>
			<SET F .N>
			<COND (<NOT .F>
			       <RETURN <NOT .1ST?>>)>>)>>

<GLOBAL QCONTEXT <>>
<GLOBAL QCONTEXT-ROOM <>>

<ROUTINE ROOM-CHECK ()
	 <COND (<IN? ,PRSO ,ROOMS>
		<COND (<EQUAL? ,PRSO ,HERE ,GLOBAL-HERE>
		       <PERFORM ,PRSA ,GLOBAL-ROOM ,PRSI>
		       <RTRUE>)
		      (T
		       <TELL ,YOU-ARENT "in that place!" CR>
		       <RTRUE>)>)
	       (<OR <EQUAL? ,PRSO ,PSEUDO-OBJECT>
		    <EQUAL? <META-LOC ,PRSO> ,HERE ,GLOBAL-OBJECTS>
		    <GLOBAL-IN? ,PRSO ,HERE>>
		<RFALSE>)
	       (T
		<NOT-HERE ,PRSO>)>>

<ROUTINE META-LOC (OBJ)
	 <COND (<AND <EQUAL? .OBJ ,PLAYER>
		     <FSET? <LOC .OBJ> ,VEHBIT>>
		,HERE)
	       (ELSE
		<REPEAT ()
			<COND (<NOT .OBJ> <RFALSE>)
			      (<EQUAL? .OBJ ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>
			       <RETURN .OBJ>)>
			<COND (<IN? .OBJ ,ROOMS>
			       <RETURN .OBJ>)
			      (ELSE
			       <SET OBJ <LOC .OBJ>>)>>)>>

<ROUTINE SEE-INSIDE? (OBJ)
	 <AND <NOT <FSET? .OBJ ,INVISIBLE>>
	      <OR <FSET? .OBJ ,TRANSBIT> <FSET? .OBJ ,OPENBIT>>>>

"WEIGHT:  Get sum of SIZEs of supplied object, recursing to the nth level."

<ROUTINE WEIGHT
	 (OBJ "AUX" CONT (WT 0))
	 #DECL ((OBJ) OBJECT (CONT) <OR FALSE OBJECT> (WT) FIX)
	 <COND (<FSET? .OBJ ,WEARBIT> 0)
	       (T
		<COND (<SET CONT <FIRST? .OBJ>>
		       <REPEAT ()
			       <SET WT <+ .WT <WEIGHT .CONT>>>
			       <COND (<NOT <SET CONT <NEXT? .CONT>>>
				      <RETURN>)>>)>
		<+ .WT <GETP .OBJ ,P?SIZE>>)>>

<GLOBAL WHO-CARES
	<LTABLE 0
		" doesn't appear interested"
		" doesn't care"
		" lets out a loud yawn"
		" seems to be getting impatient">>

<GLOBAL YUKS
	<LTABLE 0
		"That's ridiculous!"
		"Nuts!"
		"What a screwball!"
		"You're off your rocker!"
		"You can't be serious!">>
""
"SUBTITLE REAL VERBS"

<ROUTINE PRE-ACCUSE ()
	 <COND (<NOT ,PRSI>
		<SETG PRSI ,GLOBAL-MURDER>)>
	 <COND (<AND <EQUAL? ,PRSI ,GLOBAL-MURDER>
		     <FSET? ,CORPSE ,INVISIBLE>>
		<TELL "Nothing's dead here but your head!" CR>)
	       (<NOT <EQUAL? ,PRSI ,GLOBAL-MURDER ,GLOBAL-EMBEZZLEMENT>>
		<TELL "What an accusation!" CR>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "Sure! \"Quick, Sergeant! Arrest that "
		      D ,PRSO "!\"" CR>)>>

<ROUTINE V-ACCUSE ()
	 <TELL CD ,PRSO " shrugs off your accusation." CR>>

;<ROUTINE PRE-SANALYZE ()
	<PERFORM ,V?ANALYZE ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-ANALYZE ()
	 <COND (<TELL
,YOU-SHOULD "leave these tasks to those who can do them best: the police.">
		<COND (<NOT <FSET? ,WINNER ,TOLD>>
		       <TELL
" Perhaps you should call them if you wish assistance.">)>
		<CRLF>)>>

<ROUTINE V-ANSWER ()
	 <TELL "No one was waiting for your answer." CR>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-REPLY ()
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<TELL "No one's knocking at ">
		<TELL-PRSO>)
	       (T <TELL ,TOO-BAD THE ,PRSO " doesn't care." CR>)>>

<ROUTINE PRE-ARREST ()
	 <COND (<EQUAL? ,WINNER ,PLAYER>
		<TELL
"A citizen's arrest, eh? Those only happen in the movies. "
,HAVE-TO "convince " THE ,DETECTIVE " to arrest someone." CR>)>>

<ROUTINE V-ARREST ()
	 <RTRUE>> 

<ROUTINE PRE-ASK-ABOUT ()
	 <COND (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "Talking to " A ,PRSO " again, huh?" CR>)
	       (<EQUAL? ,PRSO ,ME>
		<TELL "Talking to yourself, again, huh?" CR>)
	       (<NOT <IN? ,PRSO ,HERE>>
		<TELL "You shouldn't shout: " HE/SHE ,PRSO "'s not">
		<TELL-HERE>)
	       (ELSE
		<SETG QCONTEXT ,PRSO>
		<SETG QCONTEXT-ROOM ,HERE>
		<RFALSE>)>>

<ROUTINE INTERVIEW-SELF ()
	 <TELL "Interviewing yourself again, eh?" CR>>

<ROUTINE V-ASK-ABOUT ()
	 <COND (<==? ,PRSO ,PLAYER>
		<INTERVIEW-SELF>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL
"I've known odd reporters, but none of them ever
tried to talk to " A ,PRSO "!" CR>)
	       (T
		<TELL CD ,PRSO " doesn't seem to know about that." CR>)>>

<ROUTINE PRE-ASK-CONTEXT-ABOUT ("AUX" P)
 <COND (<AND ,QCONTEXT
	     <==? ,HERE ,QCONTEXT-ROOM>
	     <==? ,HERE <META-LOC ,QCONTEXT>>>
	<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSO>
	<RTRUE>)
       ;(<SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>
	<PERFORM ,V?ASK-ABOUT .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-ASK-CONTEXT-ABOUT ()
	<TELL-ISNT-ANYONE>>

<ROUTINE TELL-ISNT-ANYONE ()
	 <TELL ,YOU-ARENT "talking to anyone." CR>>

<ROUTINE V-ASK-FOR ()
	 <COND (<AND <FSET? ,PRSO ,PERSON>
		     <NOT <==? ,PRSO ,PLAYER>>>
		<TELL CD ,PRSO>
		<COND (<NOT <IN? ,PRSO ,HERE>>
		       <TELL ,ISNT-HERE CR>)
		      (<IN? ,PRSI ,PRSO>
		       <TELL " refuses, somewhat politely." CR>)
		      (T
		       <TELL " doesn't have that." CR>)>)
	       (T <TELL <PICK-ONE ,YUKS> CR>)>>

<ROUTINE PRE-ASK-CONTEXT-FOR ("AUX" P)
 <COND (<AND <FSET? <SET P <LOC ,PRSO>> ,PERSON>
	     <IN? .P ,HERE>>
	<PERFORM ,V?ASK-FOR .P ,PRSO>
	<RTRUE>)
       (<AND ,QCONTEXT
	     <==? ,HERE ,QCONTEXT-ROOM>
	     <==? ,HERE <META-LOC ,QCONTEXT>>>
	<PERFORM ,V?ASK-FOR ,QCONTEXT ,PRSO>
	<RTRUE>)>>

<ROUTINE V-ASK-CONTEXT-FOR ()
	<TELL-ISNT-ANYONE>>

<ROUTINE V-ATTACK () <IKILL>>

<ROUTINE V-BRUSH ()
 <TELL
"\"Cleanliness is next to Godliness,\" but in this case it seems to be
next to Impossible." CR>>

<ROUTINE V-CALL-LOSE ()
	 <TELL ,YOU-MUST "use a verb." CR>>

<ROUTINE V-$CALL ("AUX" PER (MOT <>) (HERE? <>))
	 <COND (<SET PER <CHARACTERIZE? ,PRSO>>
		<COND (<IN-MOTION? .PER> <SET MOT T>)>
		<COND (<OR <SET HERE? <==? <META-LOC .PER> ,HERE>>
			   <NEARBY? .PER>>
		       <TELL CD .PER>
		       <COND (<AND ,FLEEING?
				   <EQUAL? .PER ,MICHAEL ,ALICIA>
				   <IN-MOTION? .PER>>
			      <TELL-NO-GRAB>)
			     (<GRAB-ATTENTION .PER>
			      <COND (<OR .MOT <NOT .HERE?>>
				     <COND (.MOT <TELL " stops and">)>
				     <TELL " turns toward you.">)
				    (ELSE
				     <TELL ,LISTENING>)>
			      <CRLF>)
			     (T
			      <TELL-NO-GRAB>)>)
		      (T
		       <SETG P-WON <>>
		       <TELL ,YOU-DONT "see " D .PER>
		       <TELL-HERE>)>)
	       (T <V-CALL-LOSE>)>>

<ROUTINE TELL-NO-GRAB ()
	 <TELL ,IGNORES-YOU " or doesn't hear you." CR>>

<GLOBAL LISTENING " is listening.">
<GLOBAL YOU-DONT "You don't ">
<ROUTINE THERE-DOESNT-SEEM () <TELL "There doesn't seem to be ">>

<ROUTINE PRE-PHONE ()
	 <COND (,PLAYER-HIDING
		<PLAYER-EMERGES>
		<RFALSE>)>>

<ROUTINE V-PHONE ("AUX" PER)
	 <COND (<NOT <GLOBAL-IN? ,TELEPHONE ,HERE>>
		<THERE-DOESNT-SEEM>
		<TELL A ,TELEPHONE>
		<TELL-HERE>)
	       (<AND <FSET? ,PRSO ,PERSON>
		     <SET PER <CHARACTERIZE ,PRSO>>
		     <NEARBY? .PER>>
		<PERFORM ,V?$CALL ,PRSO>
		<RTRUE>)
	       (<AND ,PRSI <NOT <==? ,PRSI ,TELEPHONE>>>
		<TELL
,TOO-BAD THE ,PRSI " isn't a telephone." CR>)
	       (<==? ,PRSO ,INTNUM>
		<DISABLE <INT I-HANG-UP>>
		<COND (<AND <EQUAL? ,P-EXCHANGE 0>
			    <EQUAL? ,P-NUMBER 0>>
		       <TELL
"You dial the operator, who suggests you dial 911." CR>)
		      (<AND <EQUAL? ,P-EXCHANGE 0>
			    <EQUAL? ,P-NUMBER 411>>
		       <TELL
"The information operator, in a honeyed voice, suggests you consult
your directory if you need a number." CR>)
		      (<AND <EQUAL? ,P-EXCHANGE 0>
			    <EQUAL? ,P-NUMBER 911>>
		       <PERFORM ,V?PHONE ,POLICE>
		       <RTRUE>)
		      (<AND <EQUAL? ,P-EXCHANGE 555>
			    <EQUAL? ,P-NUMBER 9009>>
		       <PERFORM ,V?PHONE ,COSTUME-SHOP>)
		      (<PROB 50>
		       <TELL-NO-ANSWER>)
		      (<PROB 50>
		       <TELL
"The telephone is answered. \"Hello? Hello? Hey, what is this, a crank call?\"
The telephone hangs up." CR>)
		      (T
		       <TELL "You get a busy signal." CR>)>)
	       (<IN? ,PRSO ,ROOMS>
		<TELL-YOU-CANT "call another room">)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL ,TOO-BAD THE ,PRSO " has no telephone." CR>)
	       (<IN? ,PRSO ,HERE>
		<TELL CD ,PRSO " is right here!" CR>)
	       (T
		<TELL "There's no sense in phoning ">
		<TELL-PRSO>)>>

<ROUTINE TELL-ALREADY-ARE ()
	 <TELL "You already are." CR>>

<ROUTINE V-CLIMB-ON ()
	 <COND (<AND <FSET? ,PRSO ,FURNITURE> <FSET? ,PRSO ,VEHBIT>>
		<COND (<IN? ,PLAYER ,PRSO>
		       <TELL-ALREADY-ARE>)
		      (T
		       <MOVE ,PLAYER ,PRSO>
		       <TELL
,YOU-ARE "now sitting on ">
		       <TELL-PRSO>)>)
	       (<FSET? ,PRSO ,FURNITURE>
		<TELL "This isn't the kind of thing to sit on!" CR>)
	       (T
		<TELL-YOU-CANT
"climb onto " <>>
		<TELL-PRSO>)>>

<ROUTINE V-CLIMB-UP (DIR "OPTIONAL" (OBJ <>) "AUX" X)
	 #DECL ((DIR) FIX (OBJ) <OR ATOM FALSE> (X) TABLE)
	 <COND (<GETPT ,HERE .DIR>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<NOT .OBJ>
		<TELL-YOU-CANT ,GO-THAT-WAY>)
	       (ELSE <TELL <PICK-ONE ,YUKS> CR>)>>

<GLOBAL GO-THAT-WAY "go that way">

<ROUTINE TELL-YOU-CANT (STR "OPTIONAL" (DONE T))
	 <TELL "You can't " .STR>
	 <COND (.DONE <TELL "." CR>)>>

<ROUTINE V-CLIMB-DOWN ()
	 <COND (<AND <FSET? ,PRSO ,FURNITURE> <FSET? ,PRSO ,VEHBIT>>
		<V-CLIMB-ON>
		<RTRUE>)
	       (T <V-CLIMB-UP ,P?DOWN>)>>

<ROUTINE V-CLIMB-FOO () <V-CLIMB-UP ,P?UP T>>

<ROUTINE V-CLOSE ()
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <FSET? ,PRSO ,WINDOWBIT>>>
		<TELL-MORE-CLEVER>)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,WINDOWBIT>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <COND (<FSET? ,PRSO ,RMUNGBIT>
			      <TELL
"It won't stay closed. The latch is broken." CR>)
			     (T
			      <FCLEAR ,PRSO ,OPENBIT>
			      <TELL
"Okay, " THE ,PRSO " is now closed." CR>)>)
		      (T <TELL ,ITS-ALREADY "closed." CR>)>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<OPEN-CLOSE>)
	       (ELSE
		<TELL-YOU-CANT "close " <>>
		<TELL-PRSO>)>>

<ROUTINE TELL-UNLOCK-IT (OBJ)
	 <THIS-IS-IT .OBJ>
	 <TELL ,HAVE-TO "unlock " THE .OBJ " first." CR>>

<ROUTINE OPEN-CLOSE ()
	 <COND (<VERB? CLOSE>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <FCLEAR ,PRSO ,OPENBIT>
		       <TELL "Closed." CR>)
		      (T <TELL ,ITS-ALREADY "closed." CR>)>)
	       (ELSE
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL ,ITS-ALREADY "open." CR>)
		      (<FSET? ,PRSO ,LOCKED>
		       <TELL-UNLOCK-IT ,PRSO>)
		      (<FSET? ,PRSO ,RMUNGBIT>
		       <TELL-YOU-CANT "open it. The latch is broken">)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<OR <FSET? ,PRSO ,DOORBIT>
				  <FSET? ,PRSO ,WINDOWBIT>
				  <IN? ,WINNER ,PRSO>>
			      <TELL
"Okay, " THE ,PRSO " is now open." CR>)
			     (<OR <NOT <FIRST? ,PRSO>><FSET? ,PRSO ,TRANSBIT>>
			      <TELL "Opened." CR>)
			     (T
			      <TELL "You open " THE ,PRSO " and see ">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL "." CR>)>)>)>>

<ROUTINE PRE-COMPARE ()
 <COND (<AND <NOT ,PRSI>
	     <==? 1 <GET ,P-PRSO 0>>>
	<TELL "Oops! Try typing \"Compare it to (something).\"" CR>
	<RTRUE>)
       (<==? 2 <GET ,P-PRSO 0>>
	<PUT ,P-PRSO 0 1>
	<PERFORM ,PRSA <GET ,P-PRSO 1> <GET ,P-PRSO 2>>
	<RTRUE>)>>

<ROUTINE V-COMPARE ()
 <COND (<==? ,PRSO ,PRSI> <TELL "They're the same thing!" CR>)
       (T <TELL "They're not a bit alike." CR>)>>

<ROUTINE V-CURSES ()
	 <COND (,PRSO
		<COND (<FSET? ,PRSO ,PERSON>
		       <TELL
"Insults like that won't help you solve the case." CR>)
		      (T
		       <TELL <PICK-ONE ,YUKS> CR>)>)
	       (T
		<TELL <PICK-ONE ,OFFENDED> CR>)>>

<GLOBAL OFFENDED
	<LTABLE 0
		"You ought to be ashamed of yourself!"
		"Hey, save that talk for the locker room!"
		"Step outside and say that!"
		"So's your old man!">>

<ROUTINE V-MUNG ()
	 <COND (<AND <FSET? ,PRSO ,DOORBIT> <NOT ,PRSI>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL
"You'd fly through the open door if you tried." CR>)
		      (<FSET? ,PRSO ,LOCKED>
		       <TELL "Oof! All you get is a sore shoulder." CR>)
		      (T <TELL "Why don't you just open it instead?" CR>)>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<HACK-HACK ,TRYING-DESTROY>)
	       (<OR <NOT ,PRSI>
		    <NOT <FSET? ,PRSI ,WEAPONBIT>>>
		<TELL ,TRYING-DESTROY THE ,PRSO " with ">
		<COND (<NOT ,PRSO>
		       <TELL "your bare hands is suicidal.">)
		      (T
		       <TELL A ,PRSI " is silly.">)>
		<CRLF>)
	       (T <TELL-YOU-CANT "do that">)>>

<GLOBAL TRYING-DESTROY "Trying to destroy">

<ROUTINE V-DROP ()
	 <COND (<IDROP>
		<TELL "Okay, " THE ,PRSO " is now on the ">
		<COND (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		       <TELL "ground">)
		      (T <TELL "floor">)>
		<TELL "." CR>)>>

<ROUTINE V-DRINK ()
	 <V-EAT>>

<ROUTINE V-EAT ("AUX" (EAT? <>) (DRINK? <>))
	 #DECL ((NOBJ) <OR OBJECT FALSE> (EAT? DRINK?) <OR ATOM FALSE>)
	 <COND (<SET EAT? <FSET? ,PRSO ,FOODBIT>>
		<COND (<IN? ,PRSO ,WINNER>
		       <COND (<AND <VERB? DRINK> <G? ,DRINK-COUNT 2>>
			      <TELL
"Seems that you've had too much to drink already!" CR>)
			     (ELSE
			      <TELL
"Mmm. That really hit the spot." CR>)>)
		      (ELSE
		       <TELL ,YOU-DONT-HAVE "that." CR>)>)
	       (<SET DRINK? <FSET? ,PRSO ,DRINKBIT>>
		<PERFORM ,V?DRINK ,PRSO>
		<RTRUE>)
	       (ELSE
		<TELL
"Weren't the hors d'oeuvres enough for you?" CR>)>>

<ROUTINE V-ENTER ()
	<DO-WALK ,P?IN>
	<RTRUE>>

%<COND (<NOT <GASSIGNED? PREDGEN>>
	'<ROUTINE V-ESCAPE () <QUITTER <ASCII 7> ,INCHAN>>)>

;<ROUTINE PRE-THROUGH ()		;"WALK WITH => FOLLOW"
	 <COND (<FSET? ,PRSO ,PERSON> <PERFORM ,V?FOLLOW ,PRSO> <RTRUE>)>>

<ROUTINE V-THROUGH ("AUX" RM DIR)
	<COND (<IN? ,PRSO ,ROOMS>
	       <COND (<==? ,PRSO <META-LOC ,PLAYER>>
		      <TELL-ALREADY-ARE>)
		     (<SET DIR <DIR-FROM ,HERE ,PRSO>>
		      <DO-WALK .DIR>
		      <RTRUE>)
		     (<OUTSIDE? ,HERE>
		      <TELL
"It's dark and confusing out here, you'll have to use directions." CR>)
		     (ELSE
		      <PLAYER-GETS-UP>
		      <ESTABLISH-GOAL ,PLAYER ,PRSO>
		      <V-CONTINUE>
		      <RTRUE>)>)
	      (<FSET? ,PRSO ,DOORBIT>
	       <COND (<FSET? ,PRSO ,LOCKED>
		      <TELL-LOCKED>)
		     (<SET RM <DOOR-ROOM ,HERE ,PRSO>>
		      <OPEN-DOOR ,PRSO>
		      <GOTO .RM>)
		     (T <TELL
"Sorry, but the \"" D ,PRSO "\" must be somewhere else." CR>)>)
	      (<FSET? ,PRSO ,VEHBIT>
	       <TELL ,YOU-ARE>
	       <COND (<IN? ,PLAYER ,PRSO>
		      <TELL "already">)
		     (T
		      <SETG PLAYER-HIDING <>>
		      <MOVE ,PLAYER ,PRSO>
		      <TELL "now">)>
	       <TELL " in ">
	       <TELL-PRSO>)
	      (<FSET? ,PRSO ,PERSON>
	       <TELL "A revolting idea." CR>)
	      (<NOT <FSET? ,PRSO ,TAKEBIT>>
	       <TELL "You hit your head against " THE ,PRSO
		     " as you try it." CR>)
	      (<IN? ,PRSO ,WINNER>
	       <TELL ,YOU-MUST "think you're a contortionist!" CR>)
	      (ELSE <TELL <PICK-ONE ,YUKS> CR>)>>

<GLOBAL YOU-MUST "You must ">

<ROUTINE V-CONTINUE ("AUX" GT OL WHERE OS OI GF DIR)
	 <SET GT <GET ,GOAL-TABLES ,PLAYER-C>>
	 <COND (<GET .GT ,GOAL-S>
		<SET GF <GET .GT ,GOAL-F>>
		<TELL
"(On your way to " THE .GF ".)" CR>
		<SET OL ,HERE>
		<SET OI <GET .GT ,GOAL-I>>
		<FOLLOW-GOAL ,PLAYER>
		<SET WHERE ,HERE>
		<COND (<NOT <EQUAL? .OL .WHERE>>
		       <SET DIR <DIR-FROM .OL .WHERE>>
		       <MOVE ,PLAYER .OL>
		       <SETG HERE .OL>
		       <SET OS <GET .GT ,GOAL-S>>
		       <DO-WALK .DIR>
		       <PUT .GT ,GOAL-S .OS>
		       <COND (<EQUAL? ,HERE .OL>
			      <PUT .GT ,GOAL-I .OI>)>
		       <COND (<EQUAL? ,HERE .GF>
			      <PUT .GT ,GOAL-S <>>)>)>
		<RTRUE>)
	       (ELSE
		<TELL
"I suppose you have a destination in mind, but I'm not sure what it is." CR>)>>

<ROUTINE PRE-EXAMINE ("AUX" OW)
	 <COND (<ROOM-CHECK> <RTRUE>)
	       (<NOT <EQUAL? ,WINNER ,PLAYER>>
		<SET OW ,WINNER>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?SHOW ,PRSO .OW>
		<SETG WINNER .OW>
		<RTRUE>)>>

<ROUTINE V-EXAMINE ("AUX" T)
	 <COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <NOT <EQUAL? <META-LOC ,PRSO> ,HERE ,LOCAL-GLOBALS>>>
		<COND (<NEARBY? ,PRSO>
		       <TELL
"You ought to get closer, you'd get a better look." CR>)
		      (T
		       <NOT-HERE ,PRSO>
		       <RTRUE>)>)
	       (<SET T <GETP ,PRSO ,P?TEXT>>
		<TELL .T CR>)
	       (<FSET? ,PRSO ,CONTBIT>
		<V-LOOK-INSIDE ,P?IN>)
	       (ELSE
		<TELL
"There's nothing special about ">
		<TELL-PRSO>)>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" T)
	 #DECL ((OBJ1 OBJ2) OBJECT (T) <OR FALSE TABLE>)
	 <COND (<SET T <GETPT .OBJ2 ,P?GLOBAL>>
		<ZMEMQB .OBJ1 .T <- <PTSIZE .T> 1>>)>>

<ROUTINE PRE-FIND ("AUX" CHR NUM)
	 <COND (<AND <FSET? ,PRSO ,PERSON>
		     <SET CHR <GETP ,PRSO ,P?CHARACTER>>>
		<SET NUM <GET <GET ,WHERE-TABLES <GETP ,WINNER ,P?CHARACTER>>
			      .CHR>>
		<COND (<IN? ,PRSO ,GLOBAL-OBJECTS>
		       <SETG PRSO <GET ,CHARACTER-TABLE .CHR>>)>
		<COND (<AND <EQUAL? .CHR ,VERONICA-C>
			    <NOT <LOC ,CORPSE>>>
		       <COND (<==? ,WINNER ,PLAYER>
			      <TELL ,WHAT-DO-YOU-MEAN CR>
			      <RTRUE>)
			     (<OR <AND <==? ,WINNER ,MICHAEL>
				       ,MICHAEL-SEEN-CORPSE?>
				  <AND <==? ,WINNER ,RICHARD>
				       ,RICHARD-SEEN-CORPSE?>>
			      <TELL "\"" ,WHAT-DO-YOU-MEAN"\"" CR>
			      <RTRUE>)
			     (T <RFALSE>)>)>
		<COND (<AND <NOT <==? ,WINNER ,PLAYER>>
			    <NOT <GRAB-ATTENTION ,WINNER>>>
		       <RTRUE>)>
		<COND (<==? <META-LOC ,WINNER> <META-LOC ,PRSO>>
		       <COND (<==? ,WINNER ,PLAYER>
			      <TELL
		"It sounds as though you need your vision checked." CR>)
			     (T
			      <TELL "\"Ahem...\"" CR>)>)
		      (<0? .NUM>
		       <COND (<==? ,WINNER ,PLAYER>
			      <TELL
"You haven't seen " HIM/HER ,PRSO " yet." CR>)
			     (T
			      <TELL
"\"I haven't seen " HIM/HER ,PRSO " tonight.\"" CR>)>)
		      (T
		       <SET NUM <- ,PRESENT-TIME .NUM>>
		       <COND (<==? ,WINNER ,PLAYER>
			      <TELL
"You last saw " HIM/HER ,PRSO " ">)
			     (T
			      <TELL
"\"I last saw " HIM/HER ,PRSO " ">)>
		       <COND (<AND <EQUAL? ,PRSO ,VERONICA>
				   <FSET? ,WINNER ,TOLD>>
			      <TELL "alive ">)>
		       <COND (<G? .NUM 120>
			      <TELL "a few hours">)
			     (<G? .NUM 80>
			      <TELL "an hour or two">)
			     (<G? .NUM 45>
			      <TELL "about an hour">)
			     (<G? .NUM 20>
			      <TELL "about half an hour">)
			     (<G? .NUM 10>
			      <TELL "about 15 minutes">)
			     (<G? .NUM 5>
			      <TELL "less than 10 minutes">)
			     (T
			      <TELL "just a few minutes">)>
		       <TELL " ago.">
		       <COND (<NOT <==? ,WINNER ,PLAYER>>
			      <TELL " I don't know where ">
			      <TELL HE/SHE ,PRSO " is now.\"">)>
		       <CRLF>)>
		<RTRUE>)
	       (<AND <EQUAL? ,PRSO ,YOU>
		     <NOT <EQUAL? ,PRSI ,INTNUM>>>
		<PERFORM ,PRSA ,PRSI>
		<RTRUE>)
	       (<EQUAL? ,PRSO ,POLICE> <RFALSE>)
	       (<FSET? ,PRSO ,PERSON>
		<COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
		       <TELL "\"">)>
		<TELL "I don't remember where ">
		<COND (<EQUAL? ,PRSO ,ME ,PLAYER>
		       <TELL "you are">)
		      (T <TELL THE ,PRSO " is">)>
		<TELL ".">
		<COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
		       <TELL "\"">)>
		<CRLF>
		<RTRUE>)
	       (<NOT <EQUAL? ,PLAYER ,WINNER>> <RFALSE>)
	       (<IN? ,PRSO ,ROOMS>
		<COND (<==? ,PRSO ,HERE>
		       <TELL-ALREADY-ARE>)
		      (<FSET? ,PRSO ,TOUCHBIT>
		       <TELL ,YOU-SHOULD "remember!" CR>)
		      (T <TELL
"I thought reporters always knew their way around!" CR>)>)
	       (<AND <EQUAL? <META-LOC ,PRSO> ,HERE>
		     <NOT <EQUAL? ,PRSO ,PULSE>>
		     <NOT <SEE-INSIDE? <LOC ,PRSO>>>>
		<NOT-HERE ,PRSO>)>>

<GLOBAL WHAT-DO-YOU-MEAN "What do you mean? She's dead!">

<GLOBAL RICHARD-SEEN-CORPSE? <>>
<GLOBAL MICHAEL-SEEN-CORPSE? <>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<==? ,PRSO ,PLAYER>
		<COND (<NOT <==? ,PLAYER ,WINNER>> <TELL "\"">)>
		<TELL "You're right here, ">
		<COND (<FSET? .L ,SURFACEBIT> <TELL "on">)
		      (T <TELL "in">)>
		<TELL " " THE .L ".">
		<COND (<NOT <==? ,PLAYER ,WINNER>> <TELL "\"">)>
		<CRLF>)
	       (<NOT <EQUAL? ,PLAYER ,WINNER>>
		<COND (<AND <EQUAL? ,PRSO ,YOU>
			    <EQUAL? ,PRSI ,INTNUM>>
		       <COND (<G? ,P-NUMBER ,PRESENT-TIME>
			      <TELL "\"I don't understand">)
			     (ELSE
			      <TELL
"\"I was ">
			      <COND (<OR <G? ,P-NUMBER 555>
					 <AND <G? ,P-NUMBER 480>
					      <NOT <EQUAL? ,WINNER ,ALICIA>>>>
				     <TELL "here at the party">)
				    (<AND <G? ,P-NUMBER 540>
					  <EQUAL? ,WINNER ,ALICIA>>
				     <TELL "on my way here">)
				    (ELSE
				     <TELL "at home">)>)>
		       <TELL ".\"" CR>)
		      (T
		       <TELL
"\"I thought reporters were resourceful.\"" CR>)>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<TELL
"You're the reporter, can't you find something as simple as that?" CR>)
	       (<IN? ,PRSO ,WINNER>
		<TELL "You have it." CR>)
	       (<OR <IN? ,PRSO ,HERE>
		    <==? ,PRSO ,PSEUDO-OBJECT>
		    <GLOBAL-IN? ,PRSO ,HERE>>
		<TELL "It's right">
		<TELL-HERE>)
	       (<OR <FSET? ,PRSO ,INVISIBLE>
		    <NOT <EQUAL? <META-LOC ,PRSO> ,HERE>>>
		<TELL "Well, it's not here, anyway." CR>)
	       (<FSET? .L ,PERSON>
		<TELL CD .L " has it." CR>)
	       (<FSET? .L ,SURFACEBIT>
		<TELL "It's on " THE .L "." CR>)
	       (<FSET? .L ,CONTBIT>
		<TELL "It's in " THE .L "." CR>)
	       (ELSE
		<TELL "You're certainly no investigative reporter!" CR>)>>

<ROUTINE V-FINGERPRINT ()
 <COND (<OR <FSET? ,PRSO ,PERSON> <EQUAL? ,PRSO ,YOU ,ME>>
	<COND (<EQUAL? ,WINNER ,DETECTIVE ,DUFFY>
	       <TELL "\"Everyone will be fingerprinted in due time.\"" CR>)
	      (ELSE
	       <TELL "Leave that to the police." CR>)>)
       (T
	<PERFORM ,V?ANALYZE ,PRSO ,GLOBAL-FINGERPRINTS>
	<RTRUE>)>>

<ROUTINE V-FOLLOW ("AUX" CN CHR COR PCOR (L <>))
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL "It's not clear who you're talking to." CR>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL
"How tragic to see a respected news writer stalking "
A ,PRSO "!" CR>)
	       (<AND <SET CHR <CHARACTERIZE? ,PRSO>>
		     <==? ,HERE <SET L <META-LOC .CHR>>>>
		<TELL "You're in the same place as " D ,PRSO "!" CR>)
	       (<NOT .L>
		<TELL "You seem to have lost track of " D ,PRSO "." CR>)
	       (<AND <IN-BALLROOM? .CHR>
		     <IN-BALLROOM? ,WINNER>>
		<COND (<SET CN <DIR-FROM ,HERE .L>>
		       <DO-WALK .CN>)
		      (<SET CN <DIR-FROM ,HERE ,BALLROOM-5>>
		       <DO-WALK .CN>)
		      (ELSE
		       <TELL ,HAVE-TO "give a direction." CR>)>)
	       (<SET CN <DIR-FROM ,HERE .L>>
		<DO-WALK .CN>)
	       (<AND <SET COR <GETP ,HERE ,P?CORRIDOR>>
		     <SET PCOR <GETP .L ,P?CORRIDOR>>
		     <NOT <==? <BAND .COR .PCOR> 0>>>
		<SETG PRSO <COR-DIR ,HERE .L>>
		<DO-WALK ,PRSO>)
	       (T
		<TELL "You seem to have lost track of " D ,PRSO "." CR>)>>

<GLOBAL HAVE-TO "You'll have to ">

<ROUTINE OUTSIDE? (L)
	 <OR <EQUAL? <GETP .L ,P?LINE> ,OUTSIDE-LINE-C>
	     <EQUAL? .L ,WALKWAY ,BACK-PORCH>>>

<ROUTINE PRE-GIVE ()
	 <COND (<NOT <HELD? ,PRSO>>
		<TELL 
"That's easy for you to say, since you don't even have it." CR>)>>

<ROUTINE V-GIVE ()
	 <COND (<NOT <FSET? ,PRSI ,PERSON>>
		<TELL-YOU-CANT "give " <>>
		<TELL A ,PRSO " to " A ,PRSI "!" CR>)
	       (T <TELL CD ,PRSI " refuses your offer." CR>)>>

<ROUTINE PRE-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-SGIVE ()
	 <RTRUE>>

<ROUTINE V-GOODBYE () <V-HELLO <>>>

<ROUTINE V-HANDCUFF ()
	<COND (<IN? ,HANDCUFFS ,PLAYER>
	       <PERFORM ,V?TIE-WITH ,PRSO ,HANDCUFFS>
	       <RTRUE>)
	      (T <TELL ,YOU-DONT-HAVE THE ,HANDCUFFS "." CR>)>>

<ROUTINE V-HELLO ("OPTIONAL" (HELL T) "AUX" P)
	 <COND (<SET P <OR ,PRSO ,QCONTEXT ;<FIND-FLAG ,HERE ,PERSON ,WINNER>>>
		<COND (<NOT <IN? .P ,HERE>>
		       <TELL-ISNT-HERE .P>)
		      (<FSET? .P ,PERSON>
		       <COND (.HELL
			      <TELL CD .P " nods at you." CR>)
			     (ELSE
			      <TELL
"\"Don't tell me you're leaving already!\"" CR>)>)
		      (ELSE
		       <TELL "Only nuts say \""
			     <COND (.HELL "Hello") (T "Good-bye")>
			     "\" to " A .P "." CR>)>)
	       (T <TELL "It's not clear who you're talking to." CR>)>>

<ROUTINE V-HELP ()
	 <COND (<NOT ,PRSO>
		<TELL
"You'll find help in your manual." CR>)
	       (T
		<TELL-SPECIFIC>)>>

<ROUTINE TELL-SPECIFIC ()
	 <TELL ,HAVE-TO "be more specific." CR>>

<ROUTINE PRE-HIDE ()
	 <COND (,PLAYER-HIDING <TELL-HIDING>)
	       (<INHABITED? ,HERE>
		<TELL-YOU-CANT "hide when someone is watching you">)>>

<ROUTINE V-HIDE ()
	 <COND (,PRSO
		<TELL "That's not a">)
	       (T
		<TELL ,HAVE-TO "suggest a specific">)>
	 <TELL-HIDING-PLACE>>

<ROUTINE TELL-HIDING-PLACE ()
	 <TELL " hiding place." CR>>

<ROUTINE V-HIDE-INSIDE ()
 	 <COND (,PLAYER-HIDING
		<TELL-HIDING>)
	       (ELSE
		<TELL-YOU-CANT "hide in " <>>
		<TELL-PRSO>)>>

<ROUTINE TELL-PRSO () <TELL THE ,PRSO "." CR>>

<ROUTINE V-HIDE-BEHIND ()
 	 <COND (,PLAYER-HIDING
		<TELL-HIDING>)
	       (T
		<TELL-YOU-CANT "hide behind " <>>
		<TELL-PRSO>)>>

<ROUTINE TELL-HIDING ()
	 <TELL "You're already hiding. Are you getting scared?" CR>>

<ROUTINE V-KICK ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "What terrible manners!" CR>)
	       (T <HACK-HACK "Kicking">)>>

<ROUTINE V-CUT ()
	 <COND (<NOT ,PRSI> <TELL "With your cutting wit, I suppose?" CR>)
	       (<AND <NOT <EQUAL? <META-LOC ,PRSO> ,HERE>>
		     <NOT <HELD? ,PRSO>>>
		<TELL-ISNT-HERE ,PRSO>)
	       (<GETP ,PRSO ,P?CHARACTER>
		<GONE-CRAZY>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL
"You think better of it and don't slice ">
		<TELL-PRSO>)
	       (ELSE
		<TELL "The result is unexciting." CR>)>>

<ROUTINE V-KILL ()
	 <IKILL>>

<ROUTINE IKILL ()
	 <COND (<NOT ,PRSO> <TELL "There's nothing here to kill." CR>)
	       (<AND <NOT ,PRSI> <FSET? ,PRSO ,WEAPONBIT>>
		<TELL "You didn't say what to kill." CR>)
	       (<FSET? ,PRSO ,DOORBIT>
		<FSET ,PRSO ,RMUNGBIT>
		<TELL
"Hey, this isn't a TV crime show! You just broke the lock
beyond repair." CR>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL
"Sure, destroy " THE ,PRSO ". Your manners are atrocious! I doubt you'll
ever be invited back." CR>)
	       (<NOT ,PRSI>
		<COND (<EQUAL? ,PRSO ,DUFFY ,DETECTIVE>
		       <TELL
"That was a bad move. These officers are trained to defend themselves.
They do. You lose, and quickly." CR>
		       <GONE-CRAZY>)
		      (<PROB 50>
		       <TELL-WISE-UP>)
		      (T <TELL
"With all your ability (which is to say, nearly none), you kill " D ,PRSO
" with one lucky blow." CR>
		       <GONE-CRAZY>)>)
	       (<EQUAL? ,PRSO ,DUFFY ,DETECTIVE>
		<TELL
"You've had better ideas tonight. With practiced ease, " D ,PRSO " wrests "
THE ,PRSI " from your grasp, slaps on the cuffs, and reads you your
rights." CR>
		<GONE-CRAZY>)
	       (<PROB 50>
		<TELL-WISE-UP>)
	       (T
		<TELL
"With lethal facility, you use " THE ,PRSI " on " D ,PRSO ", who dies." CR>
		<GONE-CRAZY>)>>

<ROUTINE TELL-WISE-UP ()
	 <TELL
"You think it over and think better of it." CR>>

<ROUTINE V-KISS ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL
"This isn't Hollywood; you can't go around kissing at random." CR>)
	       (T <TELL "What a (ahem!) strange idea!" CR>)>>

<ROUTINE TELL-NO-ANSWER ()
	 <TELL "There's no answer." CR>>

<ROUTINE V-KNOCK ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<INHABITED? <DOOR-ROOM ,HERE ,PRSO>>
		       <TELL "Someone shouts \"Go away!\"" CR>)
		      (T <TELL-NO-ANSWER>)>)
	       (<FSET? ,PRSO ,WINDOWBIT>
		<TELL-NO-ANSWER>)
	       (ELSE
		<TELL "Why knock on " A ,PRSO "?" CR>)>>

<ROUTINE DOOR-ROOM (HERE OBJ "AUX" (P 0) L T O)
	 #DECL ((HERE OBJ O) OBJECT (P L) FIX)
	 <REPEAT ()
		 <COND (<0? <SET P <NEXTP .HERE .P>>>
			<RFALSE>)
		       (<NOT <L? .P ,LOW-DIRECTION>>
			<SET T <GETPT .HERE .P>>
			<SET L <PTSIZE .T>>
			<COND (<AND <EQUAL? .L ,DEXIT>
				    <EQUAL? <GETB .T ,DEXITOBJ> .OBJ>>
			       <RETURN <GETB .T ,REXIT>>)>)>>>

;<ROUTINE V-LEAN ()
	 <TELL-YOU-CANT "do that">>

<ROUTINE V-STAND ("AUX" P)
	 <COND (,PLAYER-HIDING
		<PLAYER-GETS-UP>
		<RTRUE>)
	       (<OR <FSET? <LOC ,WINNER> ,SURFACEBIT>
		    <FSET? <LOC ,WINNER> ,FURNITURE>>
		<MOVE ,WINNER ,HERE>
		<SETG PLAYER-HIDING <>>
		<TELL ,YOU-ARE "on your own feet again." CR>)
	       (T
		<TELL-ALREADY-ARE>)>>

<ROUTINE PRE-LEAVE ()
	 <COND (,PRSO
		<COND (<EQUAL? ,PRSO ,PARTY> <RFALSE>)
		      (<AND <FSET? ,PRSO ,PERSON>
			    <NOT <EQUAL? ,PRSO ,CORPSE>>>
		       <DO-WALK ,P?OUT>
		       <RTRUE>)
		      (<EQUAL? ,PRSO <META-LOC ,WINNER> ,GLOBAL-ROOM>
		       <DO-WALK ,P?OUT>
		       <RTRUE>)
		      (ELSE
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)>)>>

<ROUTINE V-LEAVE ()
	 <DO-WALK ,P?OUT>>

<ROUTINE V-LISTEN ()
	 <COND (<OR <NOT ,PRSO> <EQUAL? ,PRSO ,DISCUSSION>>
		<COND (<AND <G? ,ARGUMENT-COUNT 0>
			    <EQUAL? ,HERE ,BALLROOM-9>>
		       <TELL
CTHE ,DISCUSSION " intensifies." CR>)
		      (ELSE
		       <TELL
"It's pretty one-sided." CR>)>)
	       (<FSET? ,PRSO ,PERSON>
		<COND (<EQUAL? ,PRSO ,VERONICA>
		       <COND (<IN-MOTION? ,VERONICA>
			      <TELL-YOU-CANT
"quite catch what she's saying, but it sounds like it would blister paint">)
			     (ELSE
			      <TELL
"She is talking, as usual, about horses." CR>)>)
		      (<AND <G? ,ARGUMENT-COUNT 0>
			    <EQUAL? ,HERE ,BALLROOM-9>
			    <EQUAL? ,PRSO ,MICHAEL ,COL-MARSTON ,COCHRANE>>
		       <TELL
CD ,PRSO " is taking part in " A ,DISCUSSION "." CR>)
		      (ELSE
		       <TELL
"This conversation doesn't appear to be going anywhere, does it?" CR>)>)
	       (ELSE
		<TELL ,TOO-BAD THE ,PRSO " makes no sound." CR>)>>

<ROUTINE TELL-MORE-CLEVER ()
	 <TELL
"You'd have to be more clever to do that to ">
	 <TELL-PRSO>>

<ROUTINE V-LOCK ()
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>>>
		<TELL-MORE-CLEVER>)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    ;<FSET? ,PRSO ,WINDOWBIT>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL ,HAVE-TO "close it first." CR>)
		      (<FSET? ,PRSO ,LOCKED>
		       <TELL ,ITS-ALREADY "locked." CR>)
		      (<FSET? ,PRSO ,RMUNGBIT>
		       <TELL-YOU-CANT "lock it. The lock is broken">)
		      (<EQUAL? <GETP ,PRSO ,P?UNLOCK> ,ROOMS>
		       <TELL
"This door doesn't have a lock." CR>)
		      (<NOT <EQUAL? <GETP ,PRSO ,P?UNLOCK> ,HERE>>
		       <TELL-YOU-CANT "lock it from this side without a key">)
		      (T
		       <FSET ,PRSO ,LOCKED>
		       <TELL
"Okay, " THE ,PRSO " is now locked." CR>)>)
	       (T
		<TELL-YOU-CANT "lock " <>>
		<TELL-PRSO>)>>

<GLOBAL ITS-ALREADY "It's already ">

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS T>)>>

<ROUTINE V-LOOK-BEHIND ()
	 <TELL "There's nothing behind ">
	 <TELL-PRSO>>

<ROUTINE V-LOOK-DOWN ()
 <COND (<==? ,PRSO ,ROOMS>
	<COND (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
	       <TELL "There's mud and grass there, mostly." CR>)
	      (T
	       <TELL-BORING>)>)
       (<==? ,PRSO ,HALLWAY>
	<COND (<NOT <CORRIDOR-LOOK>>
	       <TELL "There's no one there." CR>)>)
       (T <TELL-LONG-WEEK>)>>

<ROUTINE TELL-LONG-WEEK ()
	 <TELL "It has been a long week, hasn't it?" CR>>

<ROUTINE TELL-CLOSED ()
	 <TELL
,TOO-BAD THE ,PRSO " is closed." CR>>

<ROUTINE PRE-LOOK-INSIDE () <ROOM-CHECK>>

<ROUTINE V-LOOK-INSIDE (DIR "AUX" RM)
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <COND (<SET RM <DOOR-ROOM ,HERE ,PRSO>>
			      <ROOM-PEEK .RM>)
			     (T <TELL
CTHE ,PRSO " is open, but you can't tell what's beyond it." CR>)>)
		      (ELSE
		       <TELL-CLOSED>)>)
	       (<FSET? ,PRSO ,WINDOWBIT>
		<TELL-YOU-CANT "tell what's beyond " <>>
		<TELL-PRSO>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<SEE-INSIDE? ,PRSO>
		       <COND (<AND <FIRST? ,PRSO> <PRINT-CONT ,PRSO>>
			      <RTRUE>)
			     (<FSET? ,PRSO ,SURFACEBIT>
			      <TELL
"There's nothing on ">
			      <TELL-PRSO>)
			     (T
			      <TELL
CTHE ,PRSO " is empty." CR>)>)
		      (ELSE
		       <TELL-CLOSED>)>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL "You forgot to bring your X-ray glasses." CR>)
	       (ELSE
		<TELL-YOU-CANT "look " <>>
		<COND (<==? .DIR ,P?IN>
		       <TELL "inside ">
		       <TELL-PRSO>)
	       	      (<==? .DIR ,P?OUT>
		       <TELL "outside ">
		       <TELL-PRSO>)
	       	      (ELSE
		       <TELL "inside that." CR>)>)>>

<ROUTINE ROOM-PEEK (RM "AUX" OHERE)
	 <SET OHERE ,HERE>
	 <COND (<SEE-INTO? .RM>
		<SETG HERE .RM>
		<TELL "You take a quick peek into " THE .RM ":" CR>
		<COND (<NOT <DESCRIBE-OBJECTS T>>
		       <TELL-BORING>)>
		<SETG HERE .OHERE>)>>

<ROUTINE SEE-INTO? (THERE "AUX" P L T O)
	 #DECL ((THERE O) OBJECT (P L) FIX)
	 <SET P 0>
	 <REPEAT ()
		 <COND (<0? <SET P <NEXTP ,HERE .P>>>
			<TELL-CANT-FIND>
			<RFALSE>)
		       (<EQUAL? .P ,P?IN ,P?OUT> T)
		       (<NOT <L? .P ,LOW-DIRECTION>>
			<SET T <GETPT ,HERE .P>>
			<SET L <PTSIZE .T>>
			<COND (<AND <==? .L ,UEXIT>
				    <==? <GETB .T ,REXIT> .THERE>>
			       <RTRUE>)
			      (<AND <==? .L ,DEXIT>
				    <==? <GETB .T ,REXIT> .THERE>>
			       <COND (<FSET? <GETB .T ,DEXITOBJ> ,OPENBIT>
				      <RTRUE>)
				     (T
				      <TELL
"The door to that room is closed." CR>
				      <RFALSE>)>)
			      (<AND <==? .L ,CEXIT>
				    <==? <GETB .T ,REXIT> .THERE>>
			       <COND (<VALUE <GETB .T ,CEXITFLAG>>
				      <RTRUE>)
				     (T
				      <TELL-CANT-FIND>
				      <RFALSE>)>)>)>>>

<ROUTINE TELL-CANT-FIND ()
	 <TELL-YOU-CANT "seem to find that room">>

<ROUTINE V-LOOK-ON ()
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<V-LOOK-INSIDE ,P?IN>)
	       (T
		<TELL "There's no good surface on ">
		<TELL-PRSO>)>>

<ROUTINE V-LOOK-OUTSIDE () <V-LOOK-INSIDE ,P?OUT>>

<ROUTINE V-LOOK-UNDER ()
	 <COND (<FSET? ,PRSO ,FURNITURE>
		<TELL
"You twist your head to look under " THE ,PRSO " but find nothing." CR>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL "Nope. Nothing hiding under " D ,PRSO "." CR>)
	       (<EQUAL? <LOC ,PRSO> ,HERE ,LOCAL-GLOBALS ,GLOBAL-OBJECTS>
		<TELL "There's nothing there but dust." CR>)
	       (T
		<TELL "That's not a bit useful." CR>)>>

<ROUTINE V-LOOK-UP ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL <PICK-ONE ,YUKS> CR>)
	       (<NOT <==? ,PRSO ,ROOMS>>
		<TELL-LONG-WEEK>)
	       (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		<PERFORM ,V?EXAMINE ,WEATHER>
		<RTRUE>)
	       (T
		<TELL
"You see the ceiling. It's a nice ceiling. It's smoothly plastered, but
if you don't stop looking at it, people will think you're just
plastered." CR>)>>

<ROUTINE V-MAKE ()
	<COND (<NOT ,PRSI>
	       <PERFORM ,V?MAKE ,PLAYER ,PRSO>)
	      (T
	       <TELL
"\"Eat, drink, and be merry,\" eh?" CR>)>>

<ROUTINE PRE-MOVE ()
	 <COND (<HELD? ,PRSO>
		<TELL "Juggling isn't one of your talents." CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL
"Moving " THE ,PRSO " reveals nothing." CR>)
	       (T
		<TELL-YOU-CANT "move " <>>
		<TELL-PRSO>)>>

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <FSET? ,PRSO ,WINDOWBIT>>>
		<TELL-MORE-CLEVER>)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,WINDOWBIT>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<OPEN-CLOSE>)
	       (T
		<TELL-YOU-CANT "open " <>>
		<TELL-PRSO>)>>

<ROUTINE V-PICK () <TELL-YOU-CANT "pick that">>

;<ROUTINE V-PLAY ()
	 <TELL
"(Speaking of playing, you ought to try Infocom's other products.)" CR>>

<ROUTINE V-PUSH () <HACK-HACK "Pushing">>

<ROUTINE V-PUT-UNDER ()
         <TELL "There's not enough room." CR>>

<ROUTINE PRE-PUT ()
	 <COND (<EQUAL? ,PRSO ,HANDCUFFS>
		<PERFORM ,V?TIE-WITH ,PRSI ,HANDCUFFS>
		<RTRUE>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<TELL "You can't do that." CR>)>>

<ROUTINE V-PUT ()
	 <COND (<OR <FSET? ,PRSI ,OPENBIT>
		    <OPENABLE? ,PRSI>
		    <FSET? ,PRSI ,VEHBIT>> T)
	       (T
		<TELL-YOU-CANT "do that">
		<RTRUE>)>
	 <COND (<FSET? ,PRSI ,PERSON>
		<TELL CD ,PRSI " won't let you." CR>)
	       (<AND <NOT <FSET? ,PRSI ,FURNITURE>>
		     <NOT <FSET? ,PRSI ,OPENBIT>>>
		<TELL ,TOO-BAD THE ,PRSI " isn't open." CR>)
	       (<==? ,PRSI ,PRSO>
		<TELL <PICK-ONE ,YUKS> CR>)
	       (<IN? ,PRSO ,PRSI>
		<TELL
,TOO-BAD THE ,PRSO " is already in " THE ,PRSI "." CR>)
	       (<G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
		       <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL "There's no room." CR>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <ITAKE>>>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<FCLEAR ,PRSO ,WEARBIT>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL "Okay." CR>)>>

<ROUTINE V-RAISE () <HACK-HACK "Playing in this way with">>

<ROUTINE V-RAPE ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<COND (<PROB 75>
		       <TELL
"Section 29A of the United States Criminal Code, whose provisions
come to your unhealthy mind, forbids it." CR>)
		      (T <GONE-CRAZY>)>)
	       (T <TELL "What a (ahem!) strange idea!" CR>)>>

<ROUTINE PRE-READ ("AUX" VAL)
	 <COND (<OUTSIDE? ,HERE>
		<TELL "It's impossible to read in the dark." CR>)
	       (<AND ,PRSI
		     <NOT <FSET? ,PRSI ,TRANSBIT>>
		     <NOT <==? ,PRSI ,INTNUM>>>	;"? INTNUM?"
		<TELL
,YOU-MUST "have a swell method of looking through " THE ,PRSI "." CR>)
	       (<EQUAL? <LOC ,PRSO> ,WINNER ,ROOMS> <>)
	       (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <NOT <SEE-INSIDE? <LOC ,PRSO>>>>
		<NOT-HERE ,PRSO>)>>

<ROUTINE V-READ ()
	 <COND (<NOT <FSET? ,PRSO ,READBIT>>
		<TELL-YOU-CANT "read " <>>
		<TELL-PRSO>)
	       (<AND <NOT <IN? ,PRSO ,PLAYER>>
		     <FSET? <LOC ,PRSO> ,PERSON>>
		<TELL "Trying to read over " D <LOC ,PRSO> "'s shoulder?" CR>)
	       (ELSE
		<TELL <GETP ,PRSO ,P?TEXT> CR>)>>

<ROUTINE V-REVIVE ()
 <COND (<FSET? ,PRSO ,PERSON>
	<TELL CD ,PRSO " doesn't need reviving." CR>)
       (T <HACK-HACK "Trying to revive">)>>

<ROUTINE V-RING ()
	 <HACK-HACK "Ringing">>

<ROUTINE V-RUB () <HACK-HACK "Fiddling with">>

;<ROUTINE PRE-RUB-OVER ()
	 <PERFORM ,V?RUB ,PRSI ,PRSO>
	 <RTRUE>>

;<ROUTINE V-RUB-OVER ()
	 <TELL "You really can't expect that to help." CR>>

<ROUTINE V-SAY ("AUX" V)
	 <SETG QUOTE-FLAG <>>
	 <SETG P-CONT <>>
	 <TELL "Try instead: Michael, Tell me about Veronica." CR>>

<ROUTINE PRE-SEARCH () <ROOM-CHECK>>

<ROUTINE V-SEARCH ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL-REFUSES>)
	       (<AND <FSET? ,PRSO ,CONTBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
		<TELL ,HAVE-TO "open it first." CR>)
	       (T <TELL "You find nothing unusual." CR>)>>

<ROUTINE PRE-SEARCH-OBJECT-FOR ("AUX" OBJ)
	 <COND (<ROOM-CHECK> <RTRUE>)>
	 <COND (<EQUAL? ,PRSO ,GLOBAL-ROOM ,GLOBAL-HERE>
		<SETG PRSO ,HERE>)>
	 <RFALSE>>

<ROUTINE TELL-REFUSES ()
	 <TELL CD ,PRSO
	       " refuses to let you search " HIM/HER ,PRSO "." CR>>

<ROUTINE V-SEARCH-OBJECT-FOR ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL-REFUSES>)
	       (<AND <FSET? ,PRSO ,CONTBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
		<TELL ,HAVE-TO "open " THE ,PRSO " first." CR>)
	       (<IN? ,PRSI ,PRSO>
		<TELL "How observant you are! There "
			<COND (<FSET? ,PRSI ,FEMALE> "she")
			      (<FSET? ,PRSI ,PERSON> "he")
			      (T "it")>
			" is!" CR>)
	       (T <TELL ,YOU-DONT "find " THE ,PRSI " there." CR>)>>

<ROUTINE PRE-SHOW ()
	 <COND (<EQUAL? ,PRSO ,PRSI>
		<TELL "Using a mirror, no doubt?" CR>)
	       (<AND <IN? ,PRSO ,DETECTIVE>
		     <NOT <EQUAL? ,PRSI ,DETECTIVE>>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (ELSE
		<THIS-IS-S-HE ,PRSO>
		<RFALSE>)>>

<ROUTINE V-SHOW ()
	 <COND (<==? ,PRSI ,PLAYER>
		<TELL "Do you often talk to yourself?" CR>)
	       (<NOT <FSET? ,PRSI ,PERSON>>
		<TELL "Don't wait for " THE ,PRSI " to applaud." CR>)
	       (T
		<TELL CD ,PRSI <PICK-ONE ,WHO-CARES> "." CR>)>>

<ROUTINE PRE-SSHOW ()
	 <SETG P-MERGED T>
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SSHOW () <RTRUE>>

<ROUTINE V-SIT ("AUX" F)
	 <COND (<AND <FSET? ,PRSO ,FURNITURE> <FSET? ,PRSO ,VEHBIT>>
		<COND (<IN? ,PLAYER ,PRSO>
		       <TELL-ALREADY-ARE>)
		      (<SET F <FIRST? ,PRSO>>
		       <TELL "You might crush " THE .F "." CR>)
		      (T
		       <MOVE ,PLAYER ,PRSO>
		       <SETG PLAYER-HIDING <>>
		       <TELL
,YOU-ARE "now sitting on ">
		       <TELL-PRSO>)>)
	       (T
		<TELL "That isn't something to sit on!" CR>)>>

<ROUTINE V-SLAP ()
	 <COND (<NOT <IN? ,PRSO ,HERE>>
		<TELL "What " ,PRSO "?" CR>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL
CD ,PRSO " slaps you right back. It hurts, too." CR>)
	       (T
		<TELL
"Your hand stings something fierce now!" CR>)>>

<ROUTINE V-SMELL ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<COND (<FSET? ,PRSO ,FEMALE> <TELL "She">)
		      (T <TELL "He">)>)
	       (T <TELL "It">)>
	 <TELL " smells just like " A ,PRSO "." CR>>

<ROUTINE PRE-TAKE ("AUX" (P <LOC ,PRSO>))
	 <COND (<OR <EQUAL? ,PRSO ,PULSE ,FAIRY-COSTUME ,NOT-ROPE>
		    <EQUAL? ,PRSO ,NOTEBOOK ,SALE-AGREEMENT ,TRUST-DOCUMENTS>>
		<RFALSE>)
	       (<IN? ,PRSO ,WINNER> <TELL "You already have it." CR>)
	       (<AND <NOT ,PRSI>
		     <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>
		     <FSET? .P ,PERSON>
		     <NOT <EQUAL? .P ,CORPSE>>>
		<PERFORM ,V?TAKE ,PRSO .P>
		<RTRUE>)
	       (<AND <FSET? .P ,CONTBIT>
		     <NOT <FSET? .P ,OPENBIT>>
		     <NOT <FSET? .P ,PERSON>>>
		<TELL-YOU-CANT "reach that">
		<RTRUE>)
	       (,PRSI
		<COND (<NOT <EQUAL? <META-LOC ,PRSI> ,HERE>>
		       <TELL-ISNT-HERE ,PRSI>)
		      (<NOT <==? ,PRSI .P>>
		       <TELL CTHE ,PRSI " doesn't have ">
		       <TELL-PRSO>)
		      (<AND <FSET? ,PRSI ,PERSON>
			    <NOT <EQUAL? ,PRSI ,CORPSE ,VERONICA>>>
		       <TELL
"Politeness dictates that you ask " D ,PRSI " for it." CR>)
		      (T
		       <SETG PRSI <>>
		       <RFALSE>)>)
	       (<==? ,PRSO <LOC ,WINNER>>
		<TELL "You're in it, nitwit!" CR>)>>

<ROUTINE V-TAKE ()
	 <COND (<==? <ITAKE> T>
		<TELL
,YOU-ARE "now carrying ">
		<TELL-PRSO>)>>

<ROUTINE PRE-TAKEOUT ()
  <TELL ,SORRY-I-DONT CR>>

<ROUTINE V-TAKEOUT ()
	 <RTRUE>>

<ROUTINE V-DISEMBARK ()
	 <COND (<==? <LOC ,PRSO> ,WINNER>
		<TELL
,YOU-DONT "need to take out " THE ,PRSO " to use it." CR>)
	       (<NOT <==? <LOC ,WINNER> ,PRSO>>
		<TELL ,YOU-ARENT "in that!" CR>
		<RFATAL>)
	       (T
		<TELL ,YOU-ARE "on your own feet again." CR>
		<MOVE ,WINNER ,HERE>)>>

;<ROUTINE V-HOLD-UP ()
	 <TELL "That doesn't seem to help at all." CR>>

<ROUTINE V-TELL ()
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL
"Talking to yourself is a sign of impending looniness." CR>
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)
	       (<AND <EQUAL? ,PRSO ,VERONICA>
		     <IN-MOTION? ,VERONICA>
		     <NOT <IN? ,VERONICA ,BALLROOM-8>>>
		<TELL-IGNORES>
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)
	       (<FSET? ,PRSO ,PERSON>
		<COND (<NOT <EQUAL? <META-LOC ,PRSO> ,HERE>>
		       <TELL-ISNT-HERE ,PRSO>
		       <SETG P-CONT <>>
		       <SETG QUOTE-FLAG <>>
		       <RFATAL>)
		      (,P-CONT
		       <SETG WINNER ,PRSO>)
		      (ELSE
		       <TELL CD ,PRSO ,LISTENING CR>)>
		<SETG QCONTEXT ,PRSO>
		<SETG QCONTEXT-ROOM ,HERE>)
	       (T
		<TELL-YOU-CANT "talk to " <>>
		<TELL-PRSO>
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)>>

<ROUTINE PRE-TELL-ME ("AUX" P OW)
	 <SET OW ,WINNER>
	 <COND (<AND ,QCONTEXT
		     <==? ,HERE ,QCONTEXT-ROOM>
		     <==? ,HERE <META-LOC ,QCONTEXT>>
		     <EQUAL? ,PRSO ,PLAYER>>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSI>
		<SETG WINNER .OW>
		<RTRUE>)
	       ;(<AND <EQUAL? ,PRSO ,PLAYER>
		      <SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>>
		 <PERFORM ,V?ASK-ABOUT .P ,PRSI>
		 <RTRUE>)>>

<ROUTINE V-TELL-ME ()
	 <COND (<NOT <EQUAL? ,PLAYER ,WINNER>>
		<COND (<NOT <EQUAL? ,PRSO ,PLAYER>>
		       <TELL
"\"Tell " HIM/HER ,PRSO " yourself." CR>)
		      (ELSE
		       <TELL
"\"I haven't any thing to say about " THE ,PRSI "." CR>)>)
	       (<EQUAL? ,PRSO ,PLAYER>
		<TELL-ISNT-ANYONE>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL
CTHE ,PRSO " is certainly unlikely to spread the story." CR>)
	       (T <TELL CD ,PRSO <PICK-ONE ,WHO-CARES> "." CR>)>>

<ROUTINE PRE-TELL-ME-ABOUT ("AUX" P)
	 <COND (<AND ,QCONTEXT
		     <==? ,HERE ,QCONTEXT-ROOM>
		     <==? ,HERE <META-LOC ,QCONTEXT>>>
		<PERFORM <COND (<EQUAL? ,WINNER ,PLAYER> ,V?TELL-ME)
			       (T ,V?ASK-ABOUT)>
			 ,QCONTEXT
			 ,PRSO>
		<RTRUE>)
	       ;(<SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>
		 <PERFORM ,V?ASK-ABOUT .P ,PRSO>
		 <RTRUE>)>>

<ROUTINE V-TELL-ME-ABOUT ()
	 <TELL-ISNT-ANYONE>>

<ROUTINE V-THANKS ("AUX" P)
	 <COND ;(<OR <AND ,PRSO <FSET? ,PRSO ,PERSON>>
		    <AND ,QCONTEXT
			 <==? ,HERE ,QCONTEXT-ROOM>
			 <==? ,HERE <META-LOC ,QCONTEXT>>>
		    <SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>>
		<TELL CD <OR ,PRSO ,QCONTEXT .P>
			" acknowledges your thanks."CR>)
	       (T <TELL "You're more than welcome." CR>)>>

<ROUTINE V-THROW () <COND (<IDROP> <TELL "Thrown." CR>)>>

<ROUTINE V-THROW-AT ()
	 <COND (<NOT <IDROP>> <RTRUE>)
	       (<FSET? ,PRSI ,PERSON>
		<TELL CD ,PRSI
		      ", puzzled by your unusual methods, ducks as "
		      THE ,PRSO " flies by." CR>)
	       (T <TELL "Maybe you aren't feeling well." CR>)>>

<ROUTINE V-THROW-THROUGH ()
	 <COND (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "Let's not resort to violence, please." CR>)
	       (T <V-THROW>)>>

<ROUTINE PRE-TIE-TO ()
	 <COND (<OR <NOT <FSET? ,PRSO ,PERSON>>
		    <NOT <FSET? ,PRSI ,FURNITURE>>>
		<TELL "That won't do any good." CR>)>>

<ROUTINE V-TIE-TO ()
	<TELL-YOU-CANT "tie " <>>
	<TELL D ,PRSO " to that." CR>>

<ROUTINE PRE-TIE-WITH ()
	 <COND (<OR <NOT <FSET? ,PRSO ,PERSON>>
		    <NOT <FSET? ,PRSI ,TOOLBIT>>>
		<TELL "That won't do any good." CR>)>>

<ROUTINE V-TIE-WITH ()
	<COND (<FSET? ,PRSO ,PERSON>
	       <TELL
"\"I'll sue!\"" CR>)
	      (T
	       <TELL-YOU-CANT <COND (<EQUAL? ,PRSI ,HANDCUFFS> "handcuff ")
				    (T "tie " ;V)>
			      <>>
	       <TELL D ,PRSO " with that." CR>)>>

<ROUTINE V-TURN () <TELL "This has no effect." CR>>

<ROUTINE V-LAMP-ON ()
	 <COND (<EQUAL? ,PRSO ,SINK ,WATER>
		<TELL
"You turn the handle and lo! The water starts to run. Impressed
with yourself, you turn the handle once again, and the water stops
running! You try it once more, just to make sure. Bravo!" CR>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL <PICK-ONE ,YUKS> CR>)
	       (T
		<TELL-YOU-CANT "turn on " <>>
		<TELL-PRSO>)>>

<ROUTINE V-LAMP-OFF ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "Your vulgar ways would turn anyone off." CR>)
	       (T
		<TELL-YOU-CANT "turn off " <>>
		<TELL-PRSO>)>>

;<ROUTINE V-TURN-UP ()
	 <TELL "That's silly." CR>>

;<ROUTINE V-TURN-DOWN ()
	 <TELL "That's silly." CR>>

<ROUTINE PRE-UNLOCK ()
	 <COND (<AND <OUTSIDE? ,HERE>
		     <FSET? ,PRSO ,DOORBIT>
		     <NOT ,PRSI>>
		<TELL ,YOU-DONT-HAVE "the right key." CR>)>>

<GLOBAL YOU-DONT-HAVE "You don't have ">

<ROUTINE V-UNLOCK ()
	 <COND (,PRSI
		<TELL-YOU-CANT "unlock " <>>
		<TELL A ,PRSO " with " A ,PRSI "." CR>)
	       (<NOT <OR <FSET? ,PRSO ,CONTBIT> <FSET? ,PRSO ,DOORBIT>>>
		<TELL-MORE-CLEVER>)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<NOT <FSET? ,PRSO ,LOCKED>>
		       <TELL ,ITS-ALREADY "unlocked." CR>)
		      (<FSET? ,PRSO ,OPENBIT>
		       <TELL ,ITS-ALREADY "open." CR>)
		      (<EQUAL? <GETP ,PRSO ,P?UNLOCK> ,ROOMS>
		       <TELL
"This door doesn't have a lock." CR>)
		      (<FSET? ,PRSO ,RMUNGBIT>
		       <TELL-YOU-CANT "unlock it. The lock is broken">)
		      (<NOT <GETP ,PRSO ,P?UNLOCK>>
		       <TELL-YOU-CANT "unlock it" <>>
		       <UNLESS-HAVE-KEY>)
		      (<NOT <EQUAL? <GETP ,PRSO ,P?UNLOCK> ,HERE>>
		       <TELL
,HAVE-TO "unlock it from the other side">
		       <UNLESS-HAVE-KEY>)
		      (T
		       <FCLEAR ,PRSO ,LOCKED>
		       <TELL
"Okay, " THE ,PRSO " is now unlocked." CR>)>)
	       (T
		<TELL-YOU-CANT "unlock " <>>
		<TELL-PRSO>)>>

<ROUTINE UNLESS-HAVE-KEY ()
	 <TELL " unless you have the key." CR>>

<ROUTINE V-UNTIE ()
	 <TELL-YOU-CANT "untie it">>

<GLOBAL YOU-SHOULD "You should ">

<ROUTINE V-USE ()
	 <TELL-SPECIFIC>>

"V-WAIT has three modes, depending on the arguments:
1) If only one argument is given, it will wait for that many moves.
2) If a second argument is given, it will wait the least of the first
   argument number of moves and the time at which the second argument
   (an object) is in the room with the player.
3) If the third argument is given, the second should be FALSE.  It will
   wait <first argument> number of moves (or at least try to).  The
   third argument means that an 'internal wait' is happening (e.g. for
   a 'careful' search)."

<GLOBAL WHO-WAIT 0>

<ROUTINE V-WAIT ("OPTIONAL" (NUM 10) (WHO <>) (INT <>)
		 "AUX" VAL HR (RESULT T))
	 #DECL ((NUM) FIX)
	 <SET HR ,HERE>
	 <SETG WHO-WAIT 0>
	 <COND (<NOT .INT> <TELL "Time passes..." CR>)>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0> <RETURN>)
		       (<SET VAL <CLOCKER>>
			<COND (<OR <==? .VAL ,M-FATAL>
				   <NOT <==? .HR ,HERE>>>
			       <SET RESULT ,M-FATAL>
			       <RETURN>)
			      (<AND .WHO <IN? .WHO ,HERE>>
			       <TELL CD .WHO
", for whom you are waiting, has arrived." CR>
			       <RETURN>)
			      (T
			       <SETG WHO-WAIT <+ ,WHO-WAIT 1>>
			       <COND (<NOT <==? <BAND <GETB 0 1> 16> 0>>
				      <TELL "(">
				      <TIME-PRINT ,PRESENT-TIME>
				      <TELL ") ">)>
			       <TELL ,DO-YOU-WANT-TO>
			       <COND (.INT <TELL
"continue what you were doing?">)
				     (T <TELL
"keep waiting?">)>
			       <COND (<NOT <YES?>>
				      <SET RESULT <>>
				      <RETURN>)
				     (T <USL>)>)>)
		       (<AND .WHO <IN? .WHO ,HERE>>
			<TELL CD .WHO
", for whom you are waiting, has arrived." CR>
			<RETURN>)
		       (<AND .WHO <G? <SETG WHO-WAIT <+ ,WHO-WAIT 1>> 40>>
			<TELL CD .WHO
" still hasn't arrived.  " ,DO-YOU-WANT-TO "keep waiting?">
			<COND (<NOT <YES?>>
			       <SET RESULT <>>
			       <RETURN>)>
			<SETG WHO-WAIT 0>
			<USL>)
		       (T <USL>)>>
	 <SETG CLOCK-WAIT T>
	 <COND (<NOT .INT> <V-TIME>)>
	 .RESULT>

<GLOBAL DO-YOU-WANT-TO "Do you want to ">

<ROUTINE INT-WAIT (N)
	 <V-WAIT <* .N 2> <> T>>

;<COND (<==? ,M-FATAL <SET VAL <V-WAIT <SET REQ <* .N 2>> <> T>>>
	<RFATAL>)
       (<NOT <L? <- ,PRESENT-TIME .TIM> .REQ>>
	<RTRUE>)
       (T <RFALSE>)>

<ROUTINE V-WAIT-FOR ("AUX" WHO)
	 <COND (<==? ,PRSO ,INTNUM>
		<COND (<G? ,P-NUMBER ,PRESENT-TIME> <V-WAIT-UNTIL> <RTRUE>)
		      (<G? ,P-NUMBER 180>
		       <TELL "That's too long to wait." CR>)
		      (T <V-WAIT ,P-NUMBER>)>)
	       (<==? ,PRSO ,GLOBAL-HERE> <V-WAIT> <RTRUE>)
	       (<==? ,PRSO ,MIDNIGHT> <V-WAIT-UNTIL> <RTRUE>)
	       (<FSET? ,PRSO ,PERSON>
		<COND (<SET WHO <CHARACTERIZE? ,PRSO>>
		       <COND (<IN? .WHO ,HERE>
			      <TELL "That person's" ,ALREADY-HERE CR>)
			     (T <V-WAIT 10000 .WHO>)>)
		      (ELSE <TELL "You would be better off not waiting." CR>)>)
	       (<EQUAL? ,PRSO ,PLAYER>
		<TELL "You're" ,ALREADY-HERE CR>)
	       (T <TELL "Not a good idea. You might wait all night." CR>)>>

<GLOBAL ALREADY-HERE " already here!">

<ROUTINE V-WAIT-UNTIL ()	;"?? time?"
	 <COND (<==? ,PRSO ,MIDNIGHT>
		<SETG P-NUMBER 720>
		<SETG PRSO ,INTNUM>)
	       (<L? ,P-NUMBER 8>
		<SETG P-NUMBER <* <+ ,P-NUMBER 12> 60>>)
	       (<L? ,P-NUMBER 13>
		<SETG P-NUMBER <* ,P-NUMBER 60>>)>
	 <COND (<==? ,PRSO ,INTNUM>
		<COND (<G? ,P-NUMBER ,PRESENT-TIME>
		       <V-WAIT <- ,P-NUMBER ,PRESENT-TIME>>)
		      (T <TELL
,YOU-ARE "clearly ahead of your time." CR>)>)
	       (T <TELL "It has been a long week, hasn't it?" CR>)>>

<ROUTINE V-ALARM ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "He's wide awake, or haven't you noticed?" CR>)
	       (ELSE
		<TELL
,TOO-BAD THE ,PRSO " isn't asleep." CR>)>>

<GLOBAL TOO-BAD "Too bad, but ">

<ROUTINE V-WALK ("AUX" PT PTS STR OBJ RM)
	 #DECL ((PT) <OR FALSE TABLE> (PTS) FIX
		(OBJ) OBJECT (RM) <OR FALSE OBJECT>)
	 <COND (<EQUAL? ,WINNER ,PLAYER>
		<PUT <GET ,GOAL-TABLES ,PLAYER-C> ,GOAL-S <>>)>
	 <COND (<NOT ,PRSO> <TELL-YOU-CANT ,GO-THAT-WAY>)
	       (<SET PT <GETPT ,HERE ,PRSO>>
		<SETG P-WALK-DIR ,PRSO>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <SET RM <GETB .PT ,REXIT>>
		       <GOTO .RM>)
		      (<==? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<==? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <GOTO .RM>)
			     (T
			      <RFATAL>)>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL-YOU-CANT ,GO-THAT-WAY>
			      <RFATAL>)>)
		      (<==? .PTS ,DEXIT>
		       <SET OBJ <GETB .PT ,DEXITOBJ>>
		       <COND (<FSET? .OBJ ,OPENBIT>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<NOT <FSET? .OBJ ,LOCKED>>
			      <OPEN-DOOR .OBJ>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<EQUAL? <GETP .OBJ ,P?UNLOCK> ,HERE>
			      <TELL-UNLOCK-IT .OBJ>)
			     (<FSET? .OBJ ,INVISIBLE>
			      <TELL-YOU-CANT ,GO-THAT-WAY>)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL ,TOO-BAD THE .OBJ " is locked." CR>
			      <THIS-IS-IT .OBJ>
			      <RFATAL>)>)>)
	       (<==? ,PRSO ,P?IN>
		<TELL "What compass direction do you want to go in?" CR>
		<RFATAL>)
	       (T
		<TELL-YOU-CANT ,GO-THAT-WAY>
		<RFATAL>)>>

<ROUTINE PLAYER-EMERGES ()
	 <TELL
"You emerge from the concealment of " THE ,PLAYER-HIDING "." CR>
	 <SETG PLAYER-HIDING <>>>

<ROUTINE PLAYER-GETS-UP ()
	 <COND (,PLAYER-HIDING
		<PLAYER-EMERGES>
		<MOVE ,PLAYER ,HERE>)
	       (<FSET? <LOC ,PLAYER> ,VEHBIT>
		<TELL
"You get out of " THE <LOC ,PLAYER> "." CR>
		<MOVE ,PLAYER ,HERE>)>>

<ROUTINE OPEN-DOOR (OBJ)
	 <PLAYER-GETS-UP>
	 <FSET .OBJ ,OPENBIT>
	 <COND (<==? ,WINNER ,PLAYER>
		<TELL "You open">)
	       (T
		<FCLEAR .OBJ ,LOCKED>
		<TELL CD ,WINNER " opens">)>
	 <TELL " " THE .OBJ "." CR>>

;<ROUTINE V-WALK-AROUND ()
	 <TELL "(Use compass directions to move around here.)" CR>>

<ROUTINE DO-WALK (DIR)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>>

<GLOBAL P-WALK-DIR <>>

<ROUTINE IRON-GRIP ()
	 <TELL
'DUFFY " holds you in a grip of iron. You cannot escape!" CR>>

<ROUTINE V-WALK-TO ("AUX" WHO RM)
	 <COND (,DUFFY-SNARFED
		<IRON-GRIP>
		<RTRUE>)
	       (<AND <FSET? ,PRSO ,DOORBIT>
		     <SET RM <GETP ,PRSO ,P?UNLOCK>>
		     <NOT <EQUAL? .RM ,ROOMS>>>
		<SETG PRSO .RM>
		<V-THROUGH>)
	       (<OR <EQUAL? <META-LOC ,PRSO> ,HERE>
		    <GLOBAL-IN? ,PRSO ,HERE>>
		<TELL-CLOSE-ENOUGH>)
	       (<AND <IN? ,PRSO ,GLOBAL-OBJECTS>
		     <FSET? ,PRSO ,PERSON>>
		<SET WHO <CHARACTERIZE ,PRSO>>
		<COND (<NEARBY? .WHO> 
		       <SETG PRSO <META-LOC .WHO>>
		       <V-THROUGH>)
		      (ELSE
		       <TELL-YOU-CANT "even see " <>>
		       <TELL D ,PRSO "!" CR>)>)
	       (<EQUAL? ,PRSO ,HALLWAY>
		<SETG PRSO ,HALL>
		<V-THROUGH>)
	       (<IN? <META-LOC ,PRSO> ,ROOMS>
		<SETG PRSO <META-LOC ,PRSO>>
		<V-THROUGH>)
	       (T
		<TELL-YOU-CANT
"go from here to there, at least not directly">)>>

<ROUTINE V-RUN-OVER ()
	 <TELL "That doesn't make much sense." CR>>

<ROUTINE V-WHAT ("AUX" OW OBJ)
	 <SET OW ,WINNER>
	 <COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
		<COND (<EQUAL? ,PRSO ,YOU> <SET OBJ ,WINNER>)
		      (ELSE <SET OBJ ,PRSO>)>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?ASK-ABOUT .OW .OBJ>
		<SETG WINNER .OW>
		<RTRUE>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL "Try asking that person." CR>)
	       (T <TELL "Are you talking to yourself again?" CR>)>>

<ROUTINE V-YN ()
	 <COND (<AND ,QCONTEXT
		     <==? ,HERE ,QCONTEXT-ROOM>
		     <==? ,HERE <META-LOC ,QCONTEXT>>>
		<TELL CD ,QCONTEXT ,IGNORES-YOU " completely." CR>)
	       (T <TELL "That deserves to be ignored." CR>)>>

<ROUTINE V-UNMASK ()
	 <COND (<NOT ,PRSO>
		<PERFORM ,V?TAKE ,MASK>
		<RTRUE>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL
CD ,PRSO " isn't wearing a mask! (Well, that's what they always say in
horror movies)." CR>)
	       (ELSE
		<TELL
"You have an odd idea of what constitutes a costume." CR>)>>

<ROUTINE V-HANG-UP ()
	 <COND (<EQUAL? ,PRSO ,ALICIA-COAT ,YOUR-COAT ,GUNBELT>
		<COND (<EQUAL? ,HERE ,EAST-COAT-CLOSET ,WEST-COAT-CLOSET>
		       <COND (<IN? ,PRSO ,HERE>
			      <TELL "It already is." CR>)
			     (T
			      <MOVE ,PRSO ,HERE>
			      <TELL "Hung." CR>)>)
		      (ELSE
		       <TELL "This isn't a closet." CR>)>)
	       (ELSE
		<TELL
"It's not a picture, and it's not a telephone, so how can you?" CR>)>>

<ROUTINE V-SCORE ()
	 <TELL
"It's not so much a question of your score, but of whether or not you
get the story." CR>>

<ROUTINE V-DANCE ("AUX" OW)
	 <COND (<AND <NOT <EQUAL? ,WINNER ,PLAYER>>
		     <EQUAL? ,PRSO <> ,ME ,PLAYER>>
		<SET OW ,WINNER>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?DANCE .OW>
		<SETG WINNER .OW>
		<RTRUE>)
	       (<NOT <IN-BALLROOM? ,WINNER>>
		<TELL ,YOU-ARENT "even in the Ballroom." CR>)
	       (<NOT ,PRSO>
		<TELL
"You dance by yourself for a while." CR>)
	       (<FSET? ,PRSO ,PERSON>
		<COND (<IN-MOTION? ,PERSON>
		       <TELL
CD ,PRSO " seems to be too busy to dance right now." CR>)
		      (<OR <AND <NOT ,DANCE-WITH-FEMALE?>
				<NOT ,DANCE-WITH-MALE?>>
			   <AND ,DANCE-WITH-FEMALE? <FSET? ,PRSO ,FEMALE>>
			   <AND ,DANCE-WITH-MALE? <NOT <FSET? ,PRSO ,FEMALE>>>>
		       <COND (<FSET? ,PRSO ,FEMALE>
			      <SETG DANCE-WITH-FEMALE? T>)
			     (ELSE
			      <SETG DANCE-WITH-MALE? T>)>
		       <TELL
"You and " D ,PRSO " dance for a while." CR>)
		      (ELSE
		       <TELL
CD ,PRSO " doesn't want to dance with you." CR>)>)
	       (ELSE
		<TELL
"Dancing with " A ,PRSO ", eh? Some see that as a sign of impending mental
collapse." CR>)>>

<GLOBAL DANCE-WITH-FEMALE? <>>
<GLOBAL DANCE-WITH-MALE? <>>

<ROUTINE V-WAVE ()
	 <COND (<AND <EQUAL? ,HERE ,BALLROOM-9>
		     <IN? ,VERONICA ,BALLROOM-8>
		     <EQUAL? ,PRSO <> ,GLOBAL-MICHAEL ,GLOBAL-VERONICA>>
		<THIS-IS-S-HE ,MICHAEL>
		<TELL
'MICHAEL " waves you over again." CR>)
	       (<NOT ,PRSO>
		<TELL "Calling a taxi, eh?" CR>)
	       (<FSET? ,PRSO ,PERSON>
		<COND (<NOT <NEARBY? ,PRSO>>
		       <TELL-ISNT-HERE ,PRSO>)
		      (<PROB 50>
		       <TELL
CD ,PRSO " waves back, puzzled." CR>)
		      (T
		       <TELL
CD ,PRSO " doesn't seem overly interested." CR>)>)
	       (ELSE
		<TELL "Waving at " A ,PRSO " again, eh?" CR>)>>

<ROUTINE NEARBY? (PER)
	 <COND (<IN? .PER ,HERE> <RTRUE>)
	       (<AND <IN-BALLROOM? .PER>
		     <IN-BALLROOM? ,PLAYER>>
		<RTRUE>)
	       (<CORRIDOR-LOOK .PER> <RTRUE>)>>

<ROUTINE V-WHAT-IS-WAS ()
	 <TELL-DONT-KNOW>
	 <CRLF>>

<ROUTINE V-DIAGNOSE ()
	 <COND (<EQUAL? ,DRINK-COUNT 0>
		<TELL ,YOU-ARE "healthy and sober.">)
	       (<EQUAL? ,DRINK-COUNT 1>
		<TELL "You've had one drink. The effect has been minimal.">)
	       (ELSE
		<TELL
"You've had " <GET ,NUMBERS <COND (<G? ,DRINK-COUNT 3> 4) (T ,DRINK-COUNT)>>
" drinks. I would think twice
about driving home if I were you. You might call a taxi instead.">)>
	 <COND (<FSET? ,DOG ,RMUNGBIT>
		<TELL " You've been bitten by a dog, but I think he had
a rabies tag, so you're safe.">)>
	 <CRLF>>

<ROUTINE V-REVEAL ()
	 <COND (<FSET? ,PRSI ,PERSON>
		<TELL
"Your revelation of " D ,PRSO " does not seem to interest " D ,PRSI "." CR>)
	       (ELSE
		<TELL
,YOU-MUST "be pretty anxious to talk about it, if you're telling "
THE ,PRSI "." CR>)>>

<ROUTINE V-$REVEAL ()
	 <RTRUE>>

<ROUTINE V-$DISCOVER ()
	 <COND (<IN? ,CORPSE ,PLAYER>
		<SETG PLAYER-SEEN-WITH-BODY? T>)>
	 <COND (<EQUAL? ,PRSI ,PLAYER ,VERONICA> <RTRUE>)
	       (<NOT <FSET? ,PRSI ,TOLD>>
		<REVEAL-MURDER ,PRSI>
		<COND (<IN? ,PRSI ,HERE>
		       <TELL
CD ,PRSI " sees the body and recoils in horror. \"That's " 'VERONICA "!\" "
HE/SHE ,PRSI " exclaims in shock and surprise." CR>)>
		<RTRUE>)
	       (<AND <IN? ,PRSI ,HERE>
		     <NOT <EQUAL? ,PRSI ,DETECTIVE ,DUFFY>>>
		<TELL
CD ,PRSI " stares, horrified, at the body." CR>)>>

<ROUTINE V-ORDER ()
	 <COND (<IN? ,BARTENDER ,HERE>
		<PERFORM ,V?ASK-FOR ,BARTENDER ,PRSO>
		<RTRUE>)
	       (ELSE
		<TELL
,THERE-IS "no one here to give you " A ,PRSO "." CR>)>>

<ROUTINE V-POUR-ON ()
	 <COND (<FSET? ,PRSO ,DRINKBIT>
		<COND (<FSET? ,PRSI ,PERSON>
		       <TELL
CTHE ,PRSI " gets away from you and " THE ,PRSO " pours on the ground." CR>)
		      (T
		       <TELL
CTHE ,PRSI " is now wet with some of ">
		       <TELL-PRSO>)>)
	       (T
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)>>

<ROUTINE PRE-WEAR ()
	 <COND (<EQUAL? ,PRSO ,GUNBELT ,YOUR-COAT ,MASK>
		<RFALSE>)
	       (<EQUAL? ,PRSO ,ALICIA-COAT ,FAIRY-MASK>
		<IT-DOESNT-FIT>)
	       (ELSE
		<TELL-YOU-CANT "wear that">)>>

<ROUTINE IT-DOESNT-FIT () <TELL "It doesn't fit." CR>>

<ROUTINE V-WEAR ()
	 <COND (<FSET? ,PRSO ,WEARBIT>
		<TELL "You already are wearing the " D ,PRSO "." CR>)
	       (T
		<FSET ,PRSO ,WEARBIT>
		<TELL "Okay." CR>)>>

<ROUTINE V-TAKE-OFF ()
	 <COND (<FSET? ,PRSO ,WEARBIT>
		<FCLEAR ,PRSO ,WEARBIT>
		<TELL "Okay, you're no longer wearing the " D ,PRSO "." CR>)
	       (<EQUAL? <META-LOC ,PRSO> ,PLAYER>
		<TELL ,YOU-ARENT "wearing that." CR>)
	       (ELSE
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-COUNT ()
	 <TELL
"I don't think it's important, and as I recall, you failed \"Math for
Journalists.\" Certainly your expense accounts reveal little mathematical
ability (but a lot of creativity)." CR>>

<ROUTINE V-FLUSH ()
	 <TELL-YOU-CANT "flush that">>

<ROUTINE V-TIP ()
	 <TELL "How gauche." CR>>

<ROUTINE V-WRITE ()
	 <TELL "Trying to deface " THE ,PRSO ", huh?" CR>>

<ROUTINE V-LEAP ()
	 <TELL "Jumping for joy, eh?" CR>>

<ROUTINE V-BURN ()
	 <COND (<NOT ,PRSI>
		<COND (<EQUAL? ,HERE ,BALLROOM-8>
		       <PERFORM ,V?PUT ,PRSO ,FIREPLACE>)
		      (ELSE
		       <TELL ,THERE-IS "no fire">
		       <TELL-HERE>)>
		<RTRUE>)
	       (<NOT <FSET? ,PRSO ,BURNBIT>>
		<TELL "That won't burn." CR>)>>

<ROUTINE V-IS ()
	 <TELL "Oh?" CR>>


<GLOBAL YOU-ARE "You are ">
<GLOBAL YOU-ARENT "You aren't ">

<ROUTINE V-INTERVIEW ()
	 <PERFORM ,V?ASK-ABOUT ,PRSO ,PRSO>
	 <RTRUE>>